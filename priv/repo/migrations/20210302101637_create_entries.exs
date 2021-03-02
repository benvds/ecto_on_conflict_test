defmodule MyApp.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :note, :string
      add :subject, :string
      add :update_allowed, :boolean, default: true, null: false

      timestamps()
    end

    create index("entries", [:subject, :update_allowed], unique: true)
  end
end
