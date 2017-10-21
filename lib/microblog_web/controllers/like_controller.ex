defmodule MicroblogWeb.LikeController do
  use MicroblogWeb, :controller

  alias Microblog.Reactions
  alias Microblog.Reactions.Like

  action_fallback MicroblogWeb.FallbackController

  def index(conn, %{"post_id" => post_id}) do
    likes = Reactions.list_post_likes(%{"post_id" => post_id})
    render(conn, "index.json", likes: likes)
  end

  def index(conn, _params) do
    likes = Reactions.list_likes()
    render(conn, "index.json", likes: likes)
  end

  def create(conn, %{"like" => like_params}) do
    IO.inspect(like_params)
    with {:ok, %Like{} = like} <- Reactions.create_like(like_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", like_path(conn, :show, like))
      |> render("show.json", like: like)
    end
  end

  def show(conn, %{"post_id" => post_id, "user_id" => user_id}) do
    like = Reactions.get_user_like_for_post(%{"post_id" => post_id, "user_id" => user_id})
    render(conn, "show.json", like: like)
  end

  def show(conn, %{"id" => id}) do
    like = Reactions.get_like!(id)
    render(conn, "show.json", like: like)
  end

  def update(conn, %{"id" => id, "like" => like_params}) do
    like = Reactions.get_like!(id)

    with {:ok, %Like{} = like} <- Reactions.update_like(like, like_params) do
      render(conn, "show.json", like: like)
    end
  end

  def delete(conn, %{"id" => id}) do
    like = Reactions.get_like!(id)
    with {:ok, %Like{}} <- Reactions.delete_like(like) do
      send_resp(conn, :no_content, "")
    end
  end
end
