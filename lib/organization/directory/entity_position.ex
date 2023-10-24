defmodule Organization.Directory.EntityPosition do
  use Ecto.Schema
  import Ecto.Changeset
  alias Organization.Directory.{Position, Person}

  @primary_key {:id, :id, autogenerate: true}

  schema "entity_positions" do
    field :entity_type, :string
    field :entity_id, :integer
    field :effective_from, :utc_datetime
    field :effective_to, :utc_datetime
    field :deleted_at, :utc_datetime
    belongs_to :position, Position
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    belongs_to :person, Person
    field :entity, :map, virtual: true
  end

  @entity_position_fields [:entity_type, :entity_id, :effective_from, :effective_to, :person_id, :position_id]

  def changeset(entity_position, params \\ %{}) do
    entity_position
    |> cast(params, @entity_position_fields)
    |> validate_required([:entity_type, :entity_id])
    |> cast_assoc(:position, with: &Position.changeset/2)
  end
end