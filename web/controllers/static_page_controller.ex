defmodule PhMicroblog.StaticPageController do
  use Phoenix.Controller

  plug :action

  def home(conn, _params) do
    render conn, "home", title: "Home"
  end

  def help(conn, _params) do
    render conn, "help", title: "Help"
  end

  def about(conn, _params) do
    render conn, "about", title: "About"
  end

  def contact(conn, _params) do
    render conn, "contact", title: "Contact"
  end

  def not_found(conn, _params) do
    render conn, "not_found"
  end

  def error(conn, _params) do
    render conn, "error"
  end
end
