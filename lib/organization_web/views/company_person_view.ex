defmodule OrganizationWeb.CompanyPersonView do
  use JaSerializer.PhoenixView

  attributes [
    :person_id, :company_id
  ]

  def type do
    "company_person"
  end
end