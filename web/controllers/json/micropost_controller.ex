defmodule PhMicroblog.Json.MicropostController do
  use PhMicroblog.Web, :controller

  import Ecto.Query
  alias PhMicroblog.Micropost
  alias PhMicroblog.Json.ChangesetView

  plug PhMicroblog.RequireLogin, mode: :json
  plug :scrub_params, "micropost" when action == :create
  plug :set_micropost when action == :delete
  plug PhMicroblog.CorrectUser, [accessor: [:micropost, :user], mode: :json] when action == :delete

  def create(conn, %{"micropost" => micropost_params}) do
    changeset = conn.assigns.current_user
      |> build_assoc(:microposts)
      |> Micropost.changeset(micropost_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn |> put_status(201) |> render("show.json", micropost: post)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn.assigns.micropost |> Repo.delete!

    conn |> put_status(204) |> json(%{})
  end

  defp set_micropost(conn, _opts) do
    id = conn.params["id"] |> String.to_integer
    post = conn.assigns.current_user
      |> assoc(:microposts)
      |> where([m], m.id == ^id)
      |> preload([m], :user)
      |> Repo.one

    conn |> assign(:micropost, post)
  end
end
