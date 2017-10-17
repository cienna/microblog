defmodule Microblog.Reactions.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Reactions.Like
  alias Microblog.Blog.Post
  alias Microblog.Accounts.User

  schema "likes" do
    belongs_to :post, Post
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Like{} = like, attrs) do
    like
    |> cast(attrs, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
  end
end
