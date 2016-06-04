defmodule PhMicroblog.UserController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.{User, Repo}
  alias PhMicroblog.{RequireLogin, CorrectUser}

  plug RequireLogin when action in [:edit, :update]
  plug :scrub_params, "user" when action in [:create, :update]
  plug :set_user when action in [:show, :edit, :update]
  plug CorrectUser, [get_in: [:user]] when action in [:edit, :update]

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
        |> redirect_back_or(user_path(conn, :show, user))
      {:error, changeset} ->
        render conn, "new.html", title: "Sign up", changeset: changeset
    end
  end

  def show(conn, _params) do
    user = conn.assigns.user

    conn
    |> assign(:title, user.name)
    |> render(user: user)
  end

  def edit(conn, _params) do
    user = conn.assigns.user
    changeset = User.changeset(user)

    conn
    |> assign(:title, "Edit user")
    |> render(user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.user
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile updated")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        conn
        |> assign(:title, "Edit user")
        |> render("edit.html", changeset: changeset, user: user)
    end
  end

  defp set_user(conn, _opts) do
    user = Repo.get!(User, conn.params["id"])

    conn |> assign(:user, user)
  end

  defp redirect_back_or(conn, default) do
    path = RequireLogin.forwarding_path(conn) || default

    conn
    |> RequireLogin.delete_forwarding_path
    |> redirect(to: path)
  end
end
