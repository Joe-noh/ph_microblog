defmodule PhMicroblog.UserController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    render conn, "index"
  end

  def edit(conn, _params) do
    render conn, "edit"
  end

  def new(conn, _params) do
    render conn, "new"
  end

  def show(conn, params) do
    render conn, "show"
  end

  def create(conn, params) do
    text conn, inspect(params)
    #conn |> redirect("/")
  end

  def update(conn, params) do
    text conn, inspect(params)
    #conn |> redirect("/")
  end

  def destroy(conn, _params) do
    conn |> redirect("/")
  end
end
