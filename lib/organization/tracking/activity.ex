defmodule Organization.Tracking.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}

  schema "activities" do
    field :trackable_type, :string
    field :trackable_id, :integer
    field :owner_type, :string
    field :owner_id, :integer
    field :customer_id, :integer
    field :key, :string
    field :parameters, :string
    field :action, :string
    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, updated_at: :updated_at)
  end

  def changeset(activity, params \\ %{}) do
    activity
    |> cast(params, [:owner_type, :owner_id, :trackable_type, :trackable_id, :parameters, :customer_id, :action, :key])
    |> validate_required([:owner_id])
  end
end
