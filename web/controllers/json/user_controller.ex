defmodule PhMicroblog.Json.UserController do
  use PhMicroblog.Web, :json_controller

  import Ecto.Query

  alias PhMicroblog.{User, Repo, Pager}
  alias PhMicroblog.{RequireLogin, CorrectUser}
  alias PhMicroblog.Json.ChangesetView

  plug RequireLogin, [mode: :json] when action in [:index, :update]
  plug :scrub_params, "user" when action in [:create, :update]
  plug :set_user when action in [:show, :update]
  plug CorrectUser, [accessor: [:user], mode: :json] when action in [:update]

  def index(conn, params) do
    page = User |> Pager.paginate(page_number: params["p"])

    render(conn, page: page)
  end

  def show(conn, _params) do
    render(conn)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"user" => user_params}) do
    changeset = User.changeset(conn.assigns.user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_status(204)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp set_user(conn, _opts) do
    user = User |> Repo.get!(conn.params["id"])

    conn |> assign(:user, user)
  end
end
