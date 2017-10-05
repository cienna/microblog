defmodule MicroblogWeb.FollowController do
  use MicroblogWeb, :controller

  alias Microblog.Social
  alias Microblog.Social.Follow

  def index(conn, _params) do
    follows = Social.list_follows()
    render(conn, "index.html", follows: follows)
  end

  def new(conn, _params) do
    changeset = Social.change_follow(%Follow{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"follow" => follow_params}) do
    current_user = get_session(conn, :current_user)
    followed_user = get_session(conn, :user)
    Map.put(follow_params, "following_user_id", current_user)
    Map.put(follow_params, "followed_user_id", followed_user)
    case Social.create_follow(follow_params) do
      {:ok, follow} ->
        conn
        |> put_flash(:info, "Follow created successfully.")
        |> redirect(to: follow_path(conn, :show, follow))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    follow = Social.get_follow!(id)
    render(conn, "show.html", follow: follow)
  end

  def edit(conn, %{"id" => id}) do
    follow = Social.get_follow!(id)
    changeset = Social.change_follow(follow)
    render(conn, "edit.html", follow: follow, changeset: changeset)
  end

  def update(conn, %{"id" => id, "follow" => follow_params}) do
    follow = Social.get_follow!(id)

    case Social.update_follow(follow, follow_params) do
      {:ok, follow} ->
        conn
        |> put_flash(:info, "Follow updated successfully.")
        |> redirect(to: follow_path(conn, :show, follow))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", follow: follow, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    follow = Social.get_follow!(id)
    {:ok, _follow} = Social.delete_follow(follow)

    conn
    |> put_flash(:info, "Follow deleted successfully.")
    |> redirect(to: follow_path(conn, :index))
  end
end
