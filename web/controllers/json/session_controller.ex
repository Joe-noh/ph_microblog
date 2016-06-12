defmodule PhMicroblog.Json.SessionController do
  use PhMicroblog.Web, :json_controller

  alias PhMicroblog.{User, Repo, Plug.CurrentUser}

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Repo.get_by(User, email: email) do
      nil ->
        unauthorized(conn)
      user ->
        case User.authenticate(user, password) do
          {:ok, user} ->
            conn |> render("token.json", token: "hogehoge")
          :error ->
            unauthorized conn
        end
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(401)
    |> render(ErrorView, "401.json")
  end
end
