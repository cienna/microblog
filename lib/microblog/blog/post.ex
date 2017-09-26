defmodule Microblog.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Blog.Post


  schema "posts" do
    field :body, :string
    field :created_timestamp, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :created_timestamp])
    |> validate_required([:body, :created_timestamp])
  end
end
