defmodule PhMicroblog.UserController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.{User, Repo}

  def new(conn, _params) do
    changeset = User.changeset(%User{})

    conn
    |> assign(:title, "Sign up")
    |> render(changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to Sample App!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render conn, "new.html", title: "Sign up", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    conn
    |> assign(:title, user.name)
    |> render(user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)

    conn
    |> assign(:title, "Edit user")
    |> render(user: user, changeset: changeset)
  end
end
