defmodule OrganizationWeb.PositionView do
  use JaSerializer.PhoenixView

  attributes [
    :positionable_type, :positionable_id, :name, :uuid
  ]

  def type do
    "position"
  end
end