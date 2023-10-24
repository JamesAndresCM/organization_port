defmodule OrganizationWeb.ContactView do
  use JaSerializer.PhoenixView

  attributes [
    :first_name, :last_name, :email, :uuid, :phone
  ]

  def type do
    "person"
  end

  has_many :entity_positions,
    serializer: OrganizationWeb.EntityPositionView,
    include: true

  has_many :company_persons,
    serializer: OrganizationWeb.CompanyPersonView,
    include: true
end