defmodule PhMicroblog.MicropostController do
  use PhMicroblog.Web, :controller

  import Ecto.Query
  alias PhMicroblog.Micropost

  plug PhMicroblog.RequireLogin
  plug :scrub_params, "micropost" when action == :create
  plug :set_micropost when action == :delete
  plug PhMicroblog.CorrectUser, [accessor: [:micropost, :user]] when action == :delete

  def create(conn, %{"micropost" => micropost_params}) do
    changeset = conn.assigns.current_user
      |> build_assoc(:microposts)
      |> Micropost.changeset(micropost_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn |> redirect(to: static_page_path(conn, :home))
      {:error, changeset} ->
        conn
        |> assign(:micropost_changeset, changeset)
        |> render PhMicroblog.StaticPageView, "home.html"
    end
  end

  def delete(conn, params) do
    conn.assigns.micropost |> Repo.delete!

    conn |> redirect(to: static_page_path(conn, :home))
  end

  defp set_micropost(conn, _opts) do
    id = conn.params["id"] |> String.to_integer
    post = conn.assigns.current_user
      |> assoc(:microposts)
      |> preload([m], :user)
      |> where([m], m.id == ^id)
      |> Repo.one

    conn |> assign(:micropost, post)
  end
end
