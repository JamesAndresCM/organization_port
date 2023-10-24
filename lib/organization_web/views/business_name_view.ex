defmodule OrganizationWeb.BusinessNameView do
  use JaSerializer.PhoenixView

  attributes [
    :name
  ]

  def type do
    "business_name"
  end

  has_one :identification,
    serializer: OrganizationWeb.IdentificationView,
    include: true
end