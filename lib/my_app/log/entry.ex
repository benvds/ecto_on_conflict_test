defmodule MyApp.Log.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :note, :string
    field :subject, :string
    field :update_allowed, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:note, :subject, :update_allowed])
    |> validate_required([:note, :subject, :update_allowed])
    |> unique_constraint([:subject, :update_allowed])
  end
end
