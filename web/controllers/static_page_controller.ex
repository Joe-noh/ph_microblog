defmodule PhMicroblog.StaticPageController do
  use PhMicroblog.Web, :controller

  def home(conn, _params) do
    render conn, "home.html"
  end

  def help(conn, _params) do
    render conn, "help.html"
  end

  def about(conn, _params) do
    render conn, "about.html"
  end
end
