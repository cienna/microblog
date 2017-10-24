# password code references NuMart

defmodule Microblog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Microblog.Accounts.User
  alias Microblog.Blog.Post
  alias Microblog.Reactions.Like
  alias Microblog.Social.Follow

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :password_hash, :string
    field :pw_tries, :integer
    field :pw_last_try, :utc_datetime

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    many_to_many :posts, Post, join_through: Like

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username, :email, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:first_name, :last_name, :username, :email, :password_hash])
  end

  # Password validation - from Comeonin docs
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  def put_pass_hash(changeset), do: changeset

  def valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end
  def valid_password?(_), do: {:error, "The password is too short"}
end
