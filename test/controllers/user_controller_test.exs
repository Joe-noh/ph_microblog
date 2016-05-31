defmodule PhMicroblog.UserControllerTest do
  use PhMicroblog.ConnCase

  alias PhMicroblog.{Factory, User}

  test "GET new" do
    html = conn
      |> get(user_path(conn, :new))
      |> html_response(200)

    assert html |> Floki.find("title") |> Floki.text == "Sign up | Sample App"
  end

  test "POST create" do
    params = Factory.fields_for(:user)
      |> Map.take([:name, :email])
      |> Map.merge(%{
        password: "password",
        password_confirmation: "password"
      })

    conn = post(conn, user_path(conn, :create), user: params)
    user = Repo.get_by!(User, name: params.name)

    assert redirected_to(conn) == user_path(conn, :show, user)
  end
end
