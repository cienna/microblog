defmodule Microblog.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :text, null: false
      add :created_timestamp, :utc_datetime, null: false

      timestamps()
    end

  end
end
