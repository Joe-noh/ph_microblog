defmodule PhMicroblog.Json.UserController do
  use PhMicroblog.Web, :json_controller

  import Ecto.Query

  alias PhMicroblog.{User, Repo, Pager}
  alias PhMicroblog.{RequireLogin, CorrectUser}

  plug RequireLogin, [mode: :json] when action in [:index]
  plug :set_user when action in [:show]

  def index(conn, params) do
    page = User |> Pager.paginate(page_number: params["p"])

    render(conn, page: page)
  end

  def show(conn, _params) do
    render(conn)
  end

  defp set_user(conn, _opts) do
    user = User |> Repo.get!(conn.params["id"])

    conn |> assign(:user, user)
  end
end
