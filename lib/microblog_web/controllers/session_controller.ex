# code taken from NuMart (https://github.com/NatTuck/nu_mart/blob/master/lib/nu_mart_web/controllers/session_controller.ex) and modified slightly

defmodule MicroblogWeb.SessionController do
  use MicroblogWeb, :controller

  alias Microblog.Accounts

  # TODO: move?
  def update_tries(throttle, prev) do
    if throttle do
      prev + 1
    else
      1
    end
  end

  def throttle_attempts(user) do
    y2k = DateTime.from_naive!(~N[2000-01-01 00:00:00], "Etc/UTC")
    prv = DateTime.to_unix(user.pw_last_try || y2k)
    now = DateTime.to_unix(DateTime.utc_now())
    thr = (now - prv) < 3600

    if (thr && user.pw_tries > 5) do
      nil
    else
      changes = %{
        pw_tries: update_tries(thr, user.pw_tries),
        pw_last_try: DateTime.utc_now(),
      }
      {:ok, user} = Ecto.Changeset.cast(user, changes, [:pw_tries, :pw_last_try])
      |> Microblog.Repo.update
      user
    end
  end

  # TODO: move?
  def get_and_auth_user(username, password) do
    user = Accounts.get_user_by_username(username)
    user = throttle_attempts(user)
    case Comeonin.Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end



  def login(conn, %{"username" => username, "password" => password}) do
    user = get_and_auth_user(username, password)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.username}")
      |> redirect(to: page_path(conn, :feed))
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "Username or password incorrect.")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end
