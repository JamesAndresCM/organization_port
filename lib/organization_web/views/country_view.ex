defmodule OrganizationWeb.CountryView do
  use JaSerializer.PhoenixView

  attributes [
    :country_name,
    :country_code_two,
    :country_code_three,
    :main_language,
    :phone_number_prefix
  ]

  def type do
    "country"
  end
end