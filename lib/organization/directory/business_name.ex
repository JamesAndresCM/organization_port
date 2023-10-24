defmodule Organization.Directory.BusinessName do
  use Ecto.Schema
  alias Organization.Directory.{Company, Identification}
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}

  schema "business_names" do
    field :name, :string
    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    belongs_to :company, Company
    has_one :identification, Identification, foreign_key: :identificable_id, where: [identificable_type: "Organization::BusinessName"]
  end

  @business_name_fields [:name]

  def changeset(business_name, params \\ %{}) do
    business_name
    |> cast(params, @business_name_fields)
    |> validate_required(@business_name_fields)
    |> cast_assoc(:identification, with: &Identification.changeset/2)
  end
end