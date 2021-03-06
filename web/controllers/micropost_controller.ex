defmodule PhMicroblog.MicropostController do
  use PhMicroblog.Web, :controller

  import Ecto.Query
  alias PhMicroblog.{Micropost, User, Pager}

  plug PhMicroblog.RequireLogin
  plug :scrub_params, "micropost" when action == :create
  plug :set_micropost when action == :delete
  plug PhMicroblog.CorrectUser, [accessor: [:micropost, :user]] when action == :delete

  def create(conn, params = %{"micropost" => micropost_params}) do
    changeset = conn.assigns.current_user
      |> build_assoc(:microposts)
      |> Micropost.changeset(micropost_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn |> redirect(to: static_page_path(conn, :home))
      {:error, changeset} ->
        page = conn.assigns.current_user
          |> User.feed
          |> Pager.paginate(page_number: params["p"])

        conn
        |> assign(:micropost_changeset, changeset)
        |> assign(:page, page)
        |> render(PhMicroblog.StaticPageView, "home.html")
    end
  end

  def delete(conn, _params) do
    conn.assigns.micropost |> Repo.delete!

    conn
    |> put_flash(:info, "Micropost deleted")
    |> redirect_to_referer_or(static_page_path(conn, :home))
  end

  defp redirect_to_referer_or(conn, default) do
    case List.keyfind(conn.req_headers, "referer", 0) do
      {"referer", referer} ->
        redirect(conn, to: URI.parse(referer).path)
      _ ->
        redirect(conn, to: default)
    end
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
