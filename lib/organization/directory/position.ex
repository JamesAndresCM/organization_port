defmodule Organization.Directory.Position do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}

  schema "positions" do
    field :positionable_id, :integer
    field :positionable_type, :string
    field :name, :string
    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
    field :uuid, Ecto.UUID
    field :positionable, :map, virtual: true
  end

  def changeset(position, params \\ %{}) do
    position
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end