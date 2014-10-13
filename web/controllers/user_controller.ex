defmodule PhMicroblog.UserController do
  use Phoenix.Controller

  alias Phoenix.Controller.Flash
  alias PhMicroblog.User
  alias PhMicroblog.Router.Helpers, as: Router

  plug :action

  def index(conn, _params) do
    users = User.all
    render conn, "index", users: users
  end

  def edit(conn, %{"id" => id}) do
    user = User.find_by(:id, id)
    render conn, "edit", user: user
  end

  def new(conn, _params) do
    render conn, "new", user: User.new
  end

  def show(conn, %{"id" => id}) do
    user = User.find_by(:id, id)
    render conn, "show", user: user
  end

  def create(conn, %{"user" => params}) do
    case User.create(params) do
      {:ok, user} ->
        conn
        |> Flash.put(:success, "Signed up successfully")
        |> redirect(Router.user_path(:show, user.id))
      {:error, messages} ->
        conn
        |> Flash.put(:warning, messages)
        |> redirect(Router.user_path :new)
    end
  end

  def update(conn, %{"id" => id, "user" => params}) do
    case User.update(id, params) do
      {:ok, user} ->
        conn
        |> Flash.put(:success, "Updated successfully")
        |> redirect(Router.user_path(:show, user.id))
      {:error, messages} ->
        conn
        |> Flash.put(:warning, messages)
        |> redirect(Router.user_path(:edit, id))
    end
  end

  def destroy(conn, params) do
    User.destroy(Dict.get(params, "id"))
    conn |> redirect("/")
  end
end
