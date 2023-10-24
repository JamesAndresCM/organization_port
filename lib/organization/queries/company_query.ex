defmodule Organization.Queries.CompanyQuery do
  import Ecto.Query

  def apply_filter(query, params) do
    filter = %{
      name: Map.get(params, "name"),
      business_name: Map.get(params, "business_name")
    }

    query
    |> filter_by_name(filter.name)
    |> filter_by_business_name(filter.business_name)
  end

  defp filter_by_name(query, nil), do: query
  defp filter_by_name(query, name) when is_binary(name) do
    from(c in query, where: ilike(c.name, ^"%#{name}%"))
  end

  defp filter_by_business_name(query, nil), do: query
  defp filter_by_business_name(query, business_name) when is_binary(business_name) do
    from(c in query,
      distinct: c.id,
      join: b in assoc(c, :business_name),
      where: ilike(b.name, ^"%#{business_name}%") and is_nil(b.deleted_at),
      group_by: [c.id]
    )
  end
end
