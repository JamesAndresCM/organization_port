defmodule OrganizationWeb.CompanyCreateView do
  use JaSerializer.PhoenixView

  attributes [
    :name, :domain, :note, :uuid, :created_at, :updated_at
  ]

  def type do
    "company"
  end

  has_one :contact,
    serializer: OrganizationWeb.ContactView,
    include: true

  has_many :legal_representatives,
    serializer: OrganizationWeb.LegalRepresentativeView,
    include: true

  has_one :addresses, 
    serializer: OrganizationWeb.AddressView,
    include: true

  has_one :business_name, 
    serializer: OrganizationWeb.BusinessNameView,
    include: true
end