defmodule Microblog.Repo.Migrations.ModifyPosts do
  use Ecto.Migration

  def change do
    alter table("posts") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

  end
end
