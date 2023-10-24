defmodule Organization.Directory.CompanyPerson do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}

  schema "company_people" do
    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    belongs_to :company, Organization.Directory.Company
    belongs_to :person, Organization.Directory.Person
  end
end
