defmodule OrganizationWeb.CompanyView do
  use JaSerializer.PhoenixView

  attributes [
    :name, :domain, :note, :uuid, :total_persons
  ]

  def type do
    "company"
  end

  def total_persons(company, args) do
    Map.get(args.assigns.total_persons, company.id, 0)
  end
end
