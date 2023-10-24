defmodule Organization.Directory.Identification do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}

  @identification_types [rut: 0, cuit: 1, rfc: 2, cnpj: 3, nit: 4, ruc: 5, rif: 6, passport: 7, dni: 8, ci: 9, cpf: 10]

  schema "identifications" do
    field :identification_type, Ecto.Enum, values: @identification_types
    field :identification_number, :string
    field :identificable_type, :string
    field :identificable_id, :integer
    field :default, :boolean
    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    field :identificable, :map, virtual: true
    belongs_to :country, Organization.Directory.Country
  end

  def changeset(address, params \\ %{}) do
    address
    |> cast(params, [:identification_type, :identification_number, :country_id, :identificable_type, :identificable_id, :default])
    |> validate_required([:identification_number, :identification_type, :country_id])
  end
end