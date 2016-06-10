defmodule PhMicroblog.StaticPageController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.Micropost

  def home(conn, _params) do
    changeset = Micropost.changeset(%Micropost{})
    render conn, "home.html", micropost_changeset: changeset
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
