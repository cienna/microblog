# code taken from NuMart (https://github.com/NatTuck/nu_mart/blob/master/lib/nu_mart_web/controllers/session_controller.ex) and modified slightly

defmodule MicroblogWeb.SessionController do
  use MicroblogWeb, :controller

  alias Microblog.Accounts

  def login(conn, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.username}")
      |> redirect(to: post_path(conn, :index))
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "No such user")
      |> redirect(to: user_path(conn, :new))
    end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: user_path(conn, :new))
  end
end
