defmodule OrganizationWeb.PersonView do
  use JaSerializer.PhoenixView

  attributes [
    :first_name, :last_name, :email, :uuid, :phone
  ]

  def type do
    "person"
  end
end