defmodule Microblog.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :following_user_id, references(:users, on_delete: :delete_all)
      add :followed_user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:follows, [:following_user_id])
    create index(:follows, [:followed_user_id])
  end
end
