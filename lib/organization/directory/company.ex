defmodule Organization.Directory.Company do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Organization.Repo
  alias Organization.Tracking.Activity
  alias Organization.Directory.{Address, BusinessName, Person, Company, CompanyPerson, EntityPosition, Position, Identification}


  @default_company_positions [:legal_representative, :contact]
  @primary_key {:id, :id, autogenerate: true}

  schema "companies" do
    field :name, :string
    field :domain, :string
    field :note, :string
    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    field :uuid, Ecto.UUID
    field :contact, :map, virtual: true
    field :legal_representatives, :map, virtual: true
    belongs_to :customer, Organization.Accounts.Customer
    belongs_to :user, Organization.Accounts.User
    has_many :company_persons, CompanyPerson
    has_many :activities, Activity, foreign_key: :trackable_id, where: [trackable_type: "Organization::Company"]
    has_one :business_name, BusinessName
    has_many :addresses, Address, foreign_key: :addresable_id, where: [addresable_type: "Organization::Company"]
    has_many :entity_positions, EntityPosition, foreign_key: :entity_id, where: [entity_type: "Organization::Company"]
    has_many :positions, Position, foreign_key: :positionable_id, where: [positionable_type: "Organization::Company"]
    has_many :persons, through: [:company_persons, :person]
  end

  def changeset(company, params \\ %{}) do
    company
    |> cast(params, [:name, :domain, :note, :user_id, :customer_id])
    |> validate_required([:name, :user_id, :customer_id])
    |> downcase_company_name
    |> validate_uniqueness_name_by_customer
    |> cast_assoc(:addresses, with: &Address.changeset/2)
    |> cast_assoc(:business_name, with: &BusinessName.changeset/2)
  end

  defp validate_uniqueness_name_by_customer(changeset) do
    name = get_field(changeset, :name)
    customer_id = get_field(changeset, :customer_id)
    exist_record = Company |> where([c], c.name == ^name and c.customer_id == ^customer_id and is_nil(c.deleted_at)) |> Repo.one
    if exist_record do
      add_error(changeset, :name, "Error #{name} already exists")
    else
      changeset
    end
  end

  defp downcase_company_name(changeset) do
    name = get_field(changeset, :name)
    put_change(changeset, :name, String.downcase(name))
  end

  def get_by_id(id) do
    Company
    |> where([c], is_nil(c.deleted_at))
    |> Repo.get(id)
  end

  def load_associations(id) do
    get_by_id(id)
    |> Repo.preload([
      :user,
      :customer,
      {:addresses, from(a in Address, where: is_nil(a.deleted_at))},
      {:persons, from(p in Person, where: is_nil(p.deleted_at))},
      {:business_name, from(b in BusinessName, where: is_nil(b.deleted_at))}
    ])
  end

  def contact_position_id(company_id) do
    from(c in Company,
      join: p in assoc(c, :positions),
      where: c.id == ^company_id and is_nil(p.deleted_at) and p.name == "contact",
      select: p.id
    ) |> Repo.one
  end

  def legal_representative_position_id(company_id) do
    from(c in Company,
      join: p in assoc(c, :positions),
      where: c.id == ^company_id and is_nil(p.deleted_at) and p.name == "legal_representative",
      select: p.id
    ) |> Repo.one
  end

  def initialize_default_company_positions(company_id) do
    current_timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    values = Enum.map(@default_company_positions, fn name ->
      %{
        name: Atom.to_string(name),
        positionable_type: "Organization::Company",
        positionable_id: company_id,
        created_at: current_timestamp,
        updated_at: current_timestamp
      }
    end)

    Repo.insert_all(Position, values)
  end

  def get_contact_for_company(company_id) do
    case Company.contact_position_id(company_id) do
      nil -> 
        nil
    position_id ->
      contact = Repo.one(
        from ep in EntityPosition,
        join: p in assoc(ep, :person),
        where: ep.entity_id == ^company_id and ep.entity_type == "Organization::Company" and ep.position_id == ^position_id,
        select: p
      )
      entity_positions_query = from ep in EntityPosition,
        where: ep.entity_type == "Organization::Company" and ep.entity_id == ^company_id
    
      company_persons_query = from cp in CompanyPerson,
        where: cp.company_id == ^company_id
      contact
        |> Repo.preload(entity_positions: entity_positions_query)
        |> Repo.preload(company_persons: company_persons_query)
    end
  end

  def with_contact(company) do
    contact = get_contact_for_company(company.id)
    Map.put(company, :contact, contact)
  end

  def get_legal_representatives_for_company(company_id) do
    case Company.legal_representative_position_id(company_id) do
      nil ->
        nil
      rep_id ->
        legal_representative = Repo.all(from ep in EntityPosition, 
                                        join: p in assoc(ep, :person),
                                        where: ep.entity_id == ^company_id and ep.entity_type == "Organization::Company" 
                                        and ep.position_id == ^rep_id, select: p)
        entity_positions_query = from ep in EntityPosition,
          where: ep.entity_type == "Organization::Company" and ep.entity_id == ^company_id
      
        company_persons_query = from cp in CompanyPerson,
          where: cp.company_id == ^company_id
        legal_representative
        |> Repo.preload(entity_positions: entity_positions_query)
        |> Repo.preload(company_persons: company_persons_query)
    end
  end

  def with_legal_representatives(company) do
    legal_representatives = get_legal_representatives_for_company(company.id)
    Map.put(company, :legal_representatives, legal_representatives)
  end

  def get_company_with_preloads(company_id) when is_binary(company_id), do: nil
  def get_company_with_preloads(company_id) when is_integer(company_id) do
    case get_by_id(company_id) do
      nil ->
        nil
      company ->   
      identification_query = from(i in Identification, where: is_nil(i.deleted_at), preload: :country)
      preloads = [
        {:addresses, from(a in Address, where: is_nil(a.deleted_at))},
        {:business_name, from(bn in BusinessName, where: is_nil(bn.deleted_at), preload: [identification: ^identification_query])},
        addresses: :country
      ]
      company
      |> Repo.preload(preloads)
      |> with_contact
      |> with_legal_representatives
    end
  end
end
