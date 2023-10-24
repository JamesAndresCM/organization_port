defmodule Organization.Accounts.Customer do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  
  schema "customers" do
    field :name, :string 
    field :email, :string 
    field :phone, :string 
    has_many :users, Organization.Accounts.User, foreign_key: :customer_id
    has_many :companies, Organization.Directory.Company
  end
end