defmodule Organization.Directory.Person do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}

  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string
    field :email, :string
    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    field :uuid, Ecto.UUID
    belongs_to :customer, Organization.Accounts.Customer
    belongs_to :user, Organization.Accounts.User
    has_many :company_persons, Organization.Directory.CompanyPerson
    has_many :entity_positions, Organization.Directory.EntityPosition
  end
end
