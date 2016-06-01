defmodule PhMicroblog.UserControllerTest do
  use PhMicroblog.ConnCase

  alias PhMicroblog.{Factory, User}

  setup do
    {:ok, %{user: Factory.create(:user)}}
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
    params = Factory.fields_for(:user)
      |> Map.take([:name, :email])
      |> Map.merge(%{
        password: "pass",
        password_confirmation: "pass"
      })

    html = conn
      |> post(user_path(conn, :create), user: params)
      |> html_response(200)

    assert html |> Floki.find(".form-group.has-error") |> Enum.count != 0
  end

  test "PUT update with valid params", %{user: user} do
    conn |> put(user_path(conn, :update, user), %{user: %{name: "a"}})

    assert Repo.get!(User, user.id).name == "a"
  end

  test "PUT update with invalid params", %{user: user} do
    conn |> put(user_path(conn, :update, user), %{user: %{name: ""}})

    assert Repo.get!(User, user.id).name == user.name
  end
end
