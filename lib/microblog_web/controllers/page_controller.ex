defmodule MicroblogWeb.PageController do
  use MicroblogWeb, :controller

  def index(conn, _params) do
#    render conn, "index.html"
    redirect conn, to: user_path(conn, :new)
  end
end
