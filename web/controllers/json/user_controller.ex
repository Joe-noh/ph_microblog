defmodule PhMicroblog.Json.UserController do
  use PhMicroblog.Web, :json_controller

  import Ecto.Query

  alias PhMicroblog.{User, Repo, Pager}
  alias PhMicroblog.{RequireLogin, CorrectUser}

  plug RequireLogin, [mode: :json] when action in [:index]

  def index(conn, params) do
    page = User |> Pager.paginate(page_number: params["p"])

    render(conn, "index.json", page: page)
  end
end
