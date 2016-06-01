defmodule PhMicroblog.SessionControllerTest do
  use PhMicroblog.ConnCase

  alias PhMicroblog.Factory

  setup do
    user = Factory.create(:user)

    {:ok, user: user}
  end

  test "GET new" do
    html = conn
      |> get(session_path(conn, :new))
      |> html_response(200)

    assert html |> Floki.find("h1") |> Floki.text == "Log in"
  end

  test "POST create with correct email/pass", %{user: user} do
    params = %{email: user.email, password: "password"}
    conn = post(conn, session_path(conn, :create), %{session: params})

    assert redirected_to(conn) == user_path(conn, :show, user)
  end

  test "POST create with incorrect email/pass", %{user: user} do
    params = %{email: user.email, password: "hogehoge"}

    html = conn
      |> post(session_path(conn, :create), %{session: params})
      |> html_response(200)

     assert html |> Floki.find(".alert-danger") |> Floki.text =~ ~r/Invalid/
  end

  test "DELETE destroy" do
    conn = conn
      |> with_session
      |> put_session(:current_user_id, 3)
      |> delete(session_path(conn, :destroy))

    assert get_session(conn, :current_user_id) == nil
  end
end
