defmodule PhMicroblog.SessionControllerTest do
  use PhMicroblog.ConnCase

  alias PhMicroblog.Factory

  setup do
    user = Factory.create(:michael)

    {:ok, user: user}
  end

  test "GET new" do
    html = build_conn()
      |> get(session_path(build_conn(), :new))
      |> html_response(200)

    assert html |> Floki.find("h1") |> Floki.text == "Log in"
  end

  test "POST create with correct email/pass", %{user: user} do
    params = %{email: user.email, password: "password"}
    conn = build_conn() |> post(session_path(build_conn(), :create), %{session: params})

    assert redirected_to(conn) == user_path(conn, :show, user)
  end

  test "POST create with incorrect email/pass", %{user: user} do
    params = %{email: user.email, password: "hogehoge"}

    html = build_conn()
      |> post(session_path(build_conn(), :create), %{session: params})
      |> html_response(200)

     assert html |> Floki.find(".alert-danger") |> Floki.text =~ ~r/Invalid/
  end

  test "DELETE destroy" do
    conn = build_conn()
      |> with_session
      |> put_session(:current_user_id, 3)
      |> delete(session_path(build_conn(), :destroy))

    assert get_session(conn, :current_user_id) == nil
  end
end
