defmodule PhMicroblog.StaticPageController do
  use Phoenix.Controller

  plug :action

  def home(conn, _params) do
    render conn, "home.html", title: "Home"
  end

  def help(conn, _params) do
    render conn, "help.html", title: "Help"
  end

  def about(conn, _params) do
    render conn, "about.html", title: "About Us"
  end

  def contact(conn, _params) do
    render conn, "contact.html", title: "Contact"
  end
end
