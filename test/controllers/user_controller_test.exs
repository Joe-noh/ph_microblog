defmodule PhMicroblog.UserControllerTest do
  use PhMicroblog.ConnCase, async: true

  alias PhMicroblog.{Factory, User}

  setup do
    context = %{
      user: Factory.create(:michael),
      another_user: Factory.create(:archer)
    }

    {:ok, context}
  end

  describe "GET index" do
    test "shows paginated users", %{user: user} do
      html = build_conn()
        |> assign(:current_user, user)
        |> get(user_path(build_conn(), :index))
        |> html_response(200)

      assert html |> Floki.find("title") |> Floki.text == "All users | Sample App"
      assert html |> Floki.find(".previous") |> Enum.count == 2
      assert html |> Floki.find(".next.disabled") |> Enum.count == 2
    end

    test "redirects to login page without login" do
      conn = build_conn()
        |> assign(:current_user, nil)
        |> get(user_path(build_conn(), :index))

      assert redirected_to(conn) == session_path(conn, :new)
    end
  end

  describe "GET show" do
    test "listed microposts are sorted", %{user: user} do
      p1 = Factory.create(:lorem, user: user, inserted_at: Ecto.DateTime.cast!("2014-04-01T12:00:00Z"))
      p2 = Factory.create(:lorem, user: user, inserted_at: Ecto.DateTime.cast!("2014-04-04T12:00:00Z"))
      p3 = Factory.create(:lorem, user: user, inserted_at: Ecto.DateTime.cast!("2014-04-08T12:00:00Z"))

      conn = build_conn()
        |> assign(:current_user, user)
        |> get(user_path(build_conn(), :show, user))

      assert conn.assigns.page.entries == [p3, p2, p1]
    end
  end

  describe "GET new" do
    test "shows signup page" do
      html = build_conn()
        |> get(user_path(build_conn(), :new))
        |> html_response(200)

      assert html |> Floki.find("title") |> Floki.text == "Sign up | Sample App"
    end
  end

  describe "POST create" do
    test "creates a user with valid params" do
      params = %{
        name: "Mary Doe",
        email: "example@example.com",
        password: "password",
        password_confirmation: "password"
      }

      conn = post(build_conn(), user_path(build_conn(), :create), user: params)
      user = Repo.get_by!(User, name: params.name)

      assert redirected_to(conn) == user_path(conn, :show, user)
    end

    test "shows errors with invalid params" do
      params = Factory.fields_for(:michael)
        |> Map.take([:name, :email])
        |> Map.merge(%{
          password: "pass",
          password_confirmation: "pass"
        })

      html = build_conn()
        |> post(user_path(build_conn(), :create), user: params)
        |> html_response(200)

      assert html |> Floki.find(".has-error") |> Enum.count != 0
    end
  end

  describe "GET edit" do
    test "shows edit page", %{user: user} do
      html = build_conn()
        |> assign(:current_user, user)
        |> get(user_path(build_conn(), :edit, user))
        |> html_response(200)

      assert html |> Floki.find("h1") |> Floki.text == "Update your profile"
    end

    test "needs login", %{user: user} do
      conn = build_conn()
        |> assign(:current_user, nil)
        |> get(user_path(build_conn(), :edit, user))

      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "redirects to home if it is others edit page", %{user: user, another_user: another} do
      conn = build_conn()
        |> assign(:current_user, another)
        |> get(user_path(build_conn(), :edit, user))

      assert redirected_to(conn) == static_page_path(conn, :home)
    end
  end

  describe "PUT update" do
    test "updates a user with valid params", %{user: user} do
      build_conn()
      |> assign(:current_user, user)
      |> put(user_path(build_conn(), :update, user), %{user: %{name: "a"}})

      assert Repo.get!(User, user.id).name == "a"
    end

    test "doesn't update a user with invalid params", %{user: user} do
      build_conn()
      |> assign(:current_user, user)
      |> put(user_path(build_conn(), :update, user), %{user: %{name: ""}})

      assert Repo.get!(User, user.id).name == user.name
    end

    test "needs login", %{user: user} do
      build_conn()
      |> assign(:current_user, nil)
      |> put(user_path(build_conn(), :update, user), %{user: %{name: "a"}})

      assert Repo.get!(User, user.id).name == user.name
    end

    test "cannot update another user", %{user: user, another_user: another} do
      conn = build_conn()
        |> assign(:current_user, another)
        |> put(user_path(build_conn(), :update, user), %{user: %{name: "a"}})

      assert redirected_to(conn) == static_page_path(conn, :home)
    end
  end

  describe "DELETE delete" do
    test "deletes a user", %{user: user, another_user: another} do
      conn = build_conn()
        |> assign(:current_user, user)
        |> delete(user_path(build_conn(), :delete, another))

      assert redirected_to(conn) == user_path(conn, :index)
      assert Repo.get(User, another.id) == nil
    end

    test "cannot delete when the user is not admin", %{user: user, another_user: another} do
      conn = build_conn()
        |> assign(:current_user, another)
        |> delete(user_path(build_conn(), :delete, user))

      assert redirected_to(conn) == static_page_path(conn, :home)
      assert Repo.get(User, user.id) != nil
    end
  end

  describe "GET following" do
    test "shows paginated following users", %{user: user} do
      html = build_conn()
        |> assign(:current_user, user)
        |> get(user_relationship_path(build_conn(), :following, user))
        |> html_response(200)

      assert html |> Floki.find("title") |> Floki.text == "Following | Sample App"
    end

    test "needs login", %{user: user} do
      conn = build_conn()
        |> assign(:current_user, nil)
        |> get(user_relationship_path(build_conn(), :following, user))

      assert redirected_to(conn) == session_path(conn, :new)
    end
  end

  describe "GET followers" do
    test "shows paginated followers", %{user: user} do
      html = build_conn()
        |> assign(:current_user, user)
        |> get(user_relationship_path(build_conn(), :followers, user))
        |> html_response(200)

      assert html |> Floki.find("title") |> Floki.text == "Followers | Sample App"
    end

    test "needs login", %{user: user} do
      conn = build_conn()
        |> assign(:current_user, nil)
        |> get(user_relationship_path(build_conn(), :followers, user))

      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
