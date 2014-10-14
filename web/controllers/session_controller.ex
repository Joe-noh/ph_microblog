defmodule PhMicroblog.SessionController do
  use Phoenix.Controller

  alias Phoenix.Controller.Flash
  alias PhMicroblog.User
  alias PhMicroblog.Router.Helpers, as: Router

  plug :action

  def new(conn, _params) do
    case get_session(conn, :email) do
      nil   -> render conn, "new"
      ""    -> render conn, "new"
      email ->
        case User.find_by(:email, email) do
          nil  -> render conn, "new"
          user -> redirect(conn, Router.user_path(:show, user.id))
        end
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case User.find_by(:email, email) do
      nil  -> fail_to_signin(conn)
      user ->
        case User.authenticate(email, pass) do
          nil  -> fail_to_signin(conn)
          user ->
            conn
            |> put_session(:email, email)
            |> Flash.put(:success, "Signed in successfully")
            |> redirect(Router.user_path(:show, user.id))
        end
    end
  end

  def destroy(conn, _params) do
    conn
    |> put_session(:email, "")
    |> Flash.put(:success, "Signed out successfully")
    |> redirect(Router.static_page_path(:home))
  end

  defp fail_to_signin(conn) do
    conn
    |> Flash.put(:warning, ["invalid email/password"])
    |> render("new")
  end
end
