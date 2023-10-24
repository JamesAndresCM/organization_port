defmodule Organization.Directory.Country do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}

  schema "countries" do
    field :country_name, :string
    field :country_code_three, :string
    field :country_code_two, :string
    field :main_language, :string
    field :phone_number_prefix, :integer
    field :default_business_document_type, :string
  end
end