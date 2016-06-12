defmodule PhMicroblog.Json.SessionController do
  use PhMicroblog.Web, :json_controller

  alias PhMicroblog.{User, Jwt, Repo}

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Repo.get_by(User, email: email) do
      nil ->
        unauthorized(conn)
      user ->
        case User.authenticate(user, password) do
          {:ok, user} ->
            conn |> render("token.json", token: Jwt.encode(user))
          :error ->
            unauthorized(conn)
        end
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(401)
    |> render(ErrorView, "401.json")
  end
end
