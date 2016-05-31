defmodule PhMicroblog.UserController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.{User, Repo}

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    conn
    |> assign(:title, user.name)
    |> render(user: user)
  end
end
