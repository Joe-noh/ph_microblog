defmodule PhMicroblog.SessionController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.{User, Repo, CurrentUser}

  def new(conn, _params) do
    conn
    |> assign(:title, "Log in")
    |> render("new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Repo.get_by(User, email: email) do
      nil ->
        unauthorized conn
      user ->
        case User.authenticate(user, password) do
          {:ok, user} ->
            conn
            |> put_session(CurrentUser.session_key, user.id)
            |> redirect(to: user_path(conn, :show, user))
          :error ->
            unauthorized conn
        end
    end
  end

  def destroy(conn, _params) do
    conn
    |> delete_session(CurrentUser.session_key)
    |> assign(:current_user, nil)
    |> redirect(to: static_page_path(conn, :home))
  end

  defp unauthorized(conn) do
    conn
    |> assign(:title, "Log in")
    |> put_flash(:error, "Invalid email/password combination")
    |> render("new.html")
  end
end
