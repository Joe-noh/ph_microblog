defmodule PhMicroblog.UserController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.{User, Repo}

  def new(conn, _params) do
    changeset = User.changeset(%User{})

    conn
    |> assign(:title, "Sign up")
    |> render(changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    conn
    |> assign(:title, user.name)
    |> render(user: user)
  end
end
