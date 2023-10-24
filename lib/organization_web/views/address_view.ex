defmodule OrganizationWeb.AddressView do
  use JaSerializer.PhoenixView

  attributes [
    :name, :district, :city, :region, :postal_code, :default
  ]

  def type do
    "address"
  end

  has_one :country,
    serializer: OrganizationWeb.CountryView,
    include: true
end