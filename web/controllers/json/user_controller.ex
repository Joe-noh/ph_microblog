defmodule PhMicroblog.Json.UserController do
  use PhMicroblog.Web, :json_controller

  alias PhMicroblog.{User, Repo, Pager}
  alias PhMicroblog.{RequireLogin, CorrectUser}
  alias PhMicroblog.Json.{MicropostView, ChangesetView, ErrorView}

  plug RequireLogin, [mode: :json] when action in [:index, :update, :delete, :feed]
  plug :scrub_params, "user" when action in [:create, :update]
  plug :set_user when action in [:show, :update, :delete]
  plug CorrectUser, [accessor: [:user], mode: :json] when action in [:update]
  plug :admin_only when action in [:delete]

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
        |> put_status(200)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn.assigns.user |> Repo.delete!

    conn |> put_status(204) |> json(%{})
  end

  def feed(conn, params) do
    page = conn.assigns.current_user
      |> User.feed()
      |> Pager.paginate(page_number: params["p"])

    render(conn, MicropostView, "index.json", page: page)
  end

  defp set_user(conn, _opts) do
    user = User |> Repo.get!(conn.params["id"] || conn.params["user_id"])

    conn |> assign(:user, user)
  end

  defp admin_only(conn, _opts) do
    if conn.assigns.current_user.admin do
      conn
    else
      conn |> put_status(401) |> render(ErrorView, "401.json") |> halt
    end
  end
end
