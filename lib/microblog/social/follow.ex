defmodule Microblog.Social.Follow do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Social.Follow


  schema "follows" do
    field :following_user_id, :id
    field :followed_user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Follow{} = follow, attrs) do
    follow
    |> cast(attrs, [])
    |> validate_required([])
  end
end
