defmodule PhMicroblog.StaticPageController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.{User, Micropost}

  def home(conn, params) do
    case conn.assigns[:current_user] do
      nil ->
        render conn, "home.html"
      current_user ->
        changeset = Micropost.changeset(%Micropost{})
        page = User.feed(conn.assigns.current_user)
          |> pagination(params["p"] || 1)

        render conn, "home.html", micropost_changeset: changeset, feed: page.entries, page: page
    end
  end

  def help(conn, _params) do
    conn
    |> assign(:title, "help")
    |> render("help.html")
  end

  def about(conn, _params) do
    conn
    |> assign(:title, "about")
    |> render("about.html")
  end

  def contact(conn, _params) do
    conn
    |> assign(:title, "contact")
    |> render("contact.html")
  end

  defp pagination(queryable, page_number) do
    queryable |> Repo.paginate(page_size: 30, page: page_number)
  end
end
