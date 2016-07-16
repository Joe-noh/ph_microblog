defmodule PhMicroblog.SessionControllerTest do
  use PhMicroblog.ConnCase, async: true

  alias PhMicroblog.Factory

  setup do
    user = Factory.insert(:michael)

    {:ok, user: user}
  end

  describe "GET new" do
    test "shows us login page"do
      html = build_conn()
        |> get(session_path(build_conn(), :new))
        |> html_response(200)

      assert inner_text(html, "h1") == "Log in"
    end
  end

  describe "POST create" do
    test "redirects to user page with correct email/pass", %{user: user} do
      params = %{email: user.email, password: "password"}
      conn = build_conn() |> post(session_path(build_conn(), :create), %{session: params})

      assert redirected_to(conn) == user_path(conn, :show, user)
    end

    test "renders error with incorrect email/pass", %{user: user} do
      params = %{email: user.email, password: "hogehoge"}

      html = build_conn()
        |> post(session_path(build_conn(), :create), %{session: params})
        |> html_response(200)

       assert inner_text(html, ".alert-danger") =~ ~r/Invalid/
    end
  end

  describe "DELETE destroy" do
    test "can remove current_user_id from session" do
      conn = build_conn()
        |> with_session
        |> put_session(:current_user_id, 3)
        |> delete(session_path(build_conn(), :destroy))

      assert get_session(conn, :current_user_id) == nil
    end
  end
end
