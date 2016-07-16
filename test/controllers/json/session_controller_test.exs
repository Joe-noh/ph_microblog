defmodule PhMicroblog.Json.SessionControllerTest do
  use PhMicroblog.ConnCase, async: true
  @moduletag :json_controller

  alias PhMicroblog.Factory

  setup do
    user = Factory.insert(:michael)

    {:ok, user: user}
  end

  describe "POST create" do
    test "redirects to user page with correct email/pass", %{user: user} do
      params = %{email: user.email, password: "password"}

      json = build_conn()
        |> post(api_session_path(build_conn(), :create), %{session: params})
        |> json_response(200)

      assert json["token"] |> is_binary
    end

    test "renders error with incorrect email/pass", %{user: user} do
      params = %{email: user.email, password: "hogehoge"}

      json = build_conn()
        |> post(api_session_path(build_conn(), :create), %{session: params})
        |> json_response(401)

       assert json["error"] == "Unauthorized"
    end
  end
end
