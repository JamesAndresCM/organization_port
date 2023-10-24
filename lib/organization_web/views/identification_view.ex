defmodule OrganizationWeb.IdentificationView do
  use JaSerializer.PhoenixView

  attributes [
    :identification_type, :identification_number, :default
  ]

  def type do
    "identification"
  end

  has_one :country,
    serializer: OrganizationWeb.CountryView,
    include: true
end