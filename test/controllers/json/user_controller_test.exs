defmodule PhMicroblog.Json.UserControllerTest do
  use PhMicroblog.ConnCase, async: true

  alias PhMicroblog.{Jwt, Factory}

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

    test "can't get users list without login", %{conn: conn} do
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

  describe "POST create" do
    test "creates and returns a user", %{conn: conn} do
      params = %{
        name: "Mary Doe",
        email: "example@example.com",
        password: "password",
        password_confirmation: "password"
      }

      json = conn
        |> post(api_user_path(conn, :create), user: params)
        |> json_response(201)

      assert json["user"]["name"] == "Mary Doe"
    end

    test "returns error when params are invalid", %{conn: conn} do
      json = conn
        |> post(api_user_path(conn, :create), user: %{})
        |> json_response(422)

      assert json["errors"]["name"] == ["can't be blank"]
    end
  end

  describe "PUT update" do
    test "updates and returns a user", %{conn: conn, user: user} do
      json = conn
        |> put_req_header("authorization", Jwt.encode(user))
        |> put(api_user_path(conn, :update, user), user: %{name: "Jack Johnson"})
        |> json_response(200)

      assert json["user"]["name"] == "Jack Johnson"
    end

    test "returns error when params are invalid", %{conn: conn, user: user} do
      json = conn
        |> put_req_header("authorization", Jwt.encode(user))
        |> put(api_user_path(conn, :update, user), user: %{name: ""})
        |> json_response(422)

      assert json["errors"]["name"] == ["can't be blank"]
    end

    test "can't update other users", %{conn: conn, user: user, another_user: another} do
      json = conn
        |> put_req_header("authorization", Jwt.encode(another))
        |> put(api_user_path(conn, :update, user), user: %{name: "Jack Johnson"})
        |> json_response(401)

      assert json["error"] == "Unauthorized"
    end
  end

  describe "DELETE destroy" do
    test "deletes a user", %{conn: conn, user: user, another_user: another} do
      json = conn
        |> put_req_header("authorization", Jwt.encode(user))
        |> delete(api_user_path(conn, :delete, another))
        |> json_response(204)

      assert json == %{}
    end

    test "non-admin can't delete", %{conn: conn, another_user: another} do
      json = conn
        |> put_req_header("authorization", Jwt.encode(another))
        |> delete(api_user_path(conn, :delete, another))
        |> json_response(401)

      assert json["error"] == "Unauthorized"
    end
  end
end
