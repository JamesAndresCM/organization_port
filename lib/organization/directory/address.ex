defmodule Organization.Directory.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}

  schema "addresses" do
    field :name, :string
    field :district, :string
    field :city, :string
    field :region, :string
    field :postal_code, :string
    field :addresable_type, :string
    field :addresable_id, :integer
    field :default, :boolean
    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    field :addresable, :map, virtual: true
    belongs_to :country, Organization.Directory.Country
  end

  def changeset(address, params \\ %{}) do
    address
    |> cast(params, [:name, :district, :city, :region, :postal_code, :country_id, :addresable_type, :addresable_id, :default])
    |> validate_required([:name])
  end
end