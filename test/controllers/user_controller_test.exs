defmodule PhMicroblog.UserControllerTest do
  use PhMicroblog.ConnCase

  alias PhMicroblog.{Factory, User}

  setup do
    context = %{
      user: Factory.create(:michael),
      another_user: Factory.create(:archer)
    }

    {:ok, context}
  end

  test "GET index", %{user: user} do
    html = conn
      |> assign(:current_user, user)
      |> get(user_path(conn, :index))
      |> html_response(200)

    assert html |> Floki.find("title") |> Floki.text == "All users | Sample App"
    assert html |> Floki.find(".previous") |> Enum.count == 2
    assert html |> Floki.find(".next.disabled") |> Enum.count == 2
  end

  test "GET index without login" do
    conn = conn
      |> assign(:current_user, nil)
      |> get(user_path(conn, :index))

    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "GET show microposts are sorted", %{user: user} do
    p1 = Factory.create(:lorem, user: user, inserted_at: Ecto.DateTime.cast!("2014-04-01T12:00:00Z"))
    p2 = Factory.create(:lorem, user: user, inserted_at: Ecto.DateTime.cast!("2014-04-04T12:00:00Z"))
    p3 = Factory.create(:lorem, user: user, inserted_at: Ecto.DateTime.cast!("2014-04-08T12:00:00Z"))

    conn = conn
      |> assign(:current_user, user)
      |> get(user_path(conn, :show, user))

    assert conn.assigns.page.entries == [p3, p2, p1]
  end

  test "GET new" do
    html = conn
      |> get(user_path(conn, :new))
      |> html_response(200)

    assert html |> Floki.find("title") |> Floki.text == "Sign up | Sample App"
  end

  test "POST create with valid params" do
    params = %{
      name: "Mary Doe",
      email: "example@example.com",
      password: "password",
      password_confirmation: "password"
    }

    conn = post(conn, user_path(conn, :create), user: params)
    user = Repo.get_by!(User, name: params.name)

    assert redirected_to(conn) == user_path(conn, :show, user)
  end

  test "POST create with invalid params" do
    params = Factory.fields_for(:michael)
      |> Map.take([:name, :email])
      |> Map.merge(%{
        password: "pass",
        password_confirmation: "pass"
      })

    html = conn
      |> post(user_path(conn, :create), user: params)
      |> html_response(200)

    assert html |> Floki.find(".has-error") |> Enum.count != 0
  end

  test "GET edit", %{user: user} do
    html = conn
      |> assign(:current_user, user)
      |> get(user_path(conn, :edit, user))
      |> html_response(200)

    assert html |> Floki.find("h1") |> Floki.text == "Update your profile"
  end

  test "GET edit without login", %{user: user} do
    conn = conn
      |> assign(:current_user, nil)
      |> get(user_path(conn, :edit, user))

    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "GET edit by another user", %{user: user, another_user: another} do
    conn = conn
      |> assign(:current_user, another)
      |> get(user_path(conn, :edit, user))

    assert redirected_to(conn) == static_page_path(conn, :home)
  end

  test "PUT update with valid params", %{user: user} do
    conn
    |> assign(:current_user, user)
    |> put(user_path(conn, :update, user), %{user: %{name: "a"}})

    assert Repo.get!(User, user.id).name == "a"
  end

  test "PUT update with invalid params", %{user: user} do
    conn
    |> assign(:current_user, user)
    |> put(user_path(conn, :update, user), %{user: %{name: ""}})

    assert Repo.get!(User, user.id).name == user.name
  end

  test "PUT update without login", %{user: user} do
    conn
    |> assign(:current_user, nil)
    |> put(user_path(conn, :update, user), %{user: %{name: "a"}})

    assert Repo.get!(User, user.id).name == user.name
  end

  test "PUT update by another user", %{user: user, another_user: another} do
    conn = conn
      |> assign(:current_user, another)
      |> put(user_path(conn, :update, user), %{user: %{name: "a"}})

    assert redirected_to(conn) == static_page_path(conn, :home)
  end

  test "DELETE delete", %{user: user, another_user: another} do
    conn = conn
      |> assign(:current_user, user)
      |> delete(user_path(conn, :delete, another))

    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get(User, another.id) == nil
  end

  test "DELETE delete by non-admin user", %{user: user, another_user: another} do
    conn = conn
      |> assign(:current_user, another)
      |> delete(user_path(conn, :delete, user))

    assert redirected_to(conn) == static_page_path(conn, :home)
    assert Repo.get(User, user.id) != nil
  end
end
