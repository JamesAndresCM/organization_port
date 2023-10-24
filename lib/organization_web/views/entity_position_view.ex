defmodule OrganizationWeb.EntityPositionView do
  use JaSerializer.PhoenixView

  attributes [
    :entity_type, :entity_id, :position_id
  ]

  def type do
    "entity_position"
  end
end