defmodule PhMicroblog.StaticPageController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.{User, Micropost, Pager}

  def home(conn, params) do
    case conn.assigns[:current_user] do
      nil ->
        render conn, "home.html"
      current_user ->
        changeset = Micropost.changeset(%Micropost{})
        page = current_user
          |> User.feed
          |> Pager.paginate(page: params["p"])

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
end
