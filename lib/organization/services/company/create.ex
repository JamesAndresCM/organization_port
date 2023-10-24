defmodule Organization.Services.Company.Create do
  alias Organization.Repo
  alias Organization.Tracking.Activity
  alias Organization.Directory.{Company, EntityPosition, CompanyPerson}
  @keys_to_drop ["entity_positions", "customer_id"]

  defstruct company: nil, entity_positions: nil, user: nil, params: nil

  def new(params, user) do
    %__MODULE__{
      user: user,
      entity_positions: Map.get(params["company"], "entity_positions"),
      company: build_company(params, user),
      params: params
    }
  end

  def save(%__MODULE__{company: company} = _context) when is_nil(company), do: nil
  def save(%__MODULE__{} = context) do
    if context.company.valid? do
      result = 
      try do
        Repo.transaction(fn ->
          company = Repo.insert!(context.company)
          create_activity(company, context.params)
          Company.initialize_default_company_positions(company.id)
          unless Enum.empty?(context.entity_positions), do: create_positions(company, context.entity_positions)
          company
        end)
      rescue e ->
        {:error, e}
      end
  
      case result do
        {:ok, company} -> {:ok, company}
        {:error, e} -> {:error, format_errors(e.changeset)}
      end
    else
      {:error, format_errors(context.company)}
    end
  end

  defp build_company(params, user) do    
    changes = 
    params["company"]
    |> Map.drop(@keys_to_drop)
    |> Map.put("user_id", user.id)
    |> Map.put("customer_id", user.customer.id)

    addresses = Map.get(params["company"], "addresses", [])
    updated_changes = build_addresses(changes, addresses)
    final_changes = put_identificable_type(updated_changes)

    %Company{}
    |> Company.changeset(final_changes)
  end

  defp build_addresses(changes, addresses) do
    if !Enum.empty?(addresses) do
      addresses_with_type = Enum.map(addresses, fn address -> 
        Map.put(address, "addresable_type", "Organization::Company")
      end)
      Map.put(changes, "addresses", addresses_with_type)
    else
      changes
    end
  end

  defp put_identificable_type(changes) do
    case get_in(changes, ["business_name", "identification"]) do
      nil -> changes
      _ -> put_in(changes, ["business_name", "identification", "identificable_type"], "Organization::BusinessName")
    end
  end

  defp create_positions(company, entity_positions) do
    Enum.each(entity_positions, fn entity_position ->
      position = Map.get(entity_position, "position_type")
      person_id = Map.get(entity_position, "person_id")
      position_id = 
      case position do
        "contact" -> Company.contact_position_id(company.id)
        "legal_representative" -> Company.legal_representative_position_id(company.id)
        _ -> nil
      end

      if position_id do
        changes = %{position_id: position_id, person_id: person_id, entity_type: "Organization::Company", entity_id: company.id}
        %EntityPosition{}
        |> EntityPosition.changeset(changes)
        |> Repo.insert!()

        Repo.insert!(Map.merge(%CompanyPerson{}, %{person_id: person_id, company_id: company.id}))
      end
    end)
  end

  defp create_activity(company, params) do
    if company do
      activity_keys = %{
        owner_type: "User",
        owner_id: company.user_id,
        trackable_type: "Organization::Company",
        trackable_id: company.id,
        parameters: Jason.encode!(params),
        customer_id: company.customer_id,
        action: "create",
        key: "Organization::Company.create"
      }
      %Activity{}
      |> Activity.changeset(activity_keys)
      |> Repo.insert!
    end
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
      msg
    end)
  end
end