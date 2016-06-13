defmodule PhMicroblog.Json.UserControllerTest do
  use PhMicroblog.ConnCase, async: true

  alias PhMicroblog.Factory

  setup %{conn: conn} do
    context = %{
      user: Factory.create(:michael),
      another_user: Factory.create(:archer),
      conn: put_req_header(conn, "accept", "application/json")
    }

    {:ok, context}
  end

  describe "GET index" do
    test "shows paginated users", %{user: user, conn: conn} do
      json = conn
        |> assign(:current_user, user)
        |> get(api_user_path(conn, :index))
        |> json_response(200)

      assert json["users"] |> is_list
    end

    test "redirects to login page without login", %{conn: conn} do
      json = conn
        |> assign(:current_user, nil)
        |> get(api_user_path(conn, :index))
        |> json_response(401)

      assert json["error"] == "Unauthorized"
    end
  end

  describe "GET show" do
    test "returns a user", %{user: user, conn: conn} do
      json = conn
        |> get(api_user_path(conn, :show, user))
        |> json_response(200)

      assert json["user"]["id"]   == user.id
      assert json["user"]["name"] == user.name
    end
  end
end
