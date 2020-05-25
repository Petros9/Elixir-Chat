defmodule ChatApp.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false, size: 20
      add :description, :string
      add :topic, :string, size: 100

      timestamps()
    end
    create unique_index(:rooms, [:name])
  end
end
