defmodule Microblog.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Blog.Post
  alias Microblog.Accounts.User
  alias Microblog.Reactions.Like


  schema "posts" do
    field :body, :string
    belongs_to :user, Microblog.Accounts.User

    many_to_many :users, User, join_through: Like

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body])
  end
end
