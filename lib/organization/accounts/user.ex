defmodule Organization.Accounts.User do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  
  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    belongs_to :customer, Organization.Accounts.Customer
    has_many :companies, Organization.Directory.Company
  end
end