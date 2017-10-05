defmodule Microblog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Accounts.User


  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    has_many :follows, Microblog.Social.Follow

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username, :email])
    |> validate_required([:first_name, :last_name, :username, :email])
  end
end
