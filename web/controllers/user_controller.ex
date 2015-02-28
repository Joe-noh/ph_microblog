defmodule PhMicroblog.UserController do
  use PhMicroblog.BaseController

  alias PhMicroblog.User
  alias PhMicroblog.Repo
  alias PhMicroblog.Router.Helpers, as: Route

  plug :action

  def new(conn, _params) do
    render conn, "new.html", title: "Sign up"
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil  -> not_found(conn)
      user -> render conn, "show.html", user: user, title: user.name
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(user_params)

    if changeset.valid? do
      user = Repo.insert(changeset)

      conn
      |> put_flash(:success, "Welcome to the Sample App!")
      |> redirect to: Route.user_path(conn, :show, user.id)
    else
      render conn, "new.html", user: changeset.params,
             errors: changeset.errors, title: "Sign up"
    end
  end
end
