defmodule MicroblogWeb.PageController do
  use MicroblogWeb, :controller

  import Ecto.Query, warn: false
  alias Microblog.Repo
  alias Microblog.Blog
  alias Microblog.Blog.Post
  alias Microblog.Accounts
  alias Microblog.Accounts.User

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect conn, to: page_path(conn, :feed)
    else
      changeset = Accounts.change_user(%User{})
      render(conn, "index.html", changeset: changeset)
    end
  end

  def feed(conn, _params) do
    posts = list_posts(conn, "garbage") |> Repo.preload(:user)
    post = Blog.change_post(%Post{})
    render(conn, "feed.html", posts: posts, post: post)
  end

  defp list_posts(conn, _params) do
    Repo.all(Post)
  end

end
