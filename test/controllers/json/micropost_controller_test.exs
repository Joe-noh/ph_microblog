defmodule PhMicroblog.Json.MicropostControllerTest do
  use PhMicroblog.ConnCase, async: true

  alias PhMicroblog.{Factory, Jwt, Micropost}

  setup %{conn: conn} do
    user = Factory.create(:michael)
    micropost = Factory.create(:lorem, user: user)
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, [user: user, micropost: micropost, conn: conn]}
  end

  describe "POST create" do
    test "with valid params", %{user: user, conn: conn} do
      params = Factory.fields_for(:lorem)

      json = conn
        |> put_req_header("authorization", Jwt.encode(user))
        |> post(api_micropost_path(conn, :create), micropost: params)
        |> json_response(201)

      assert json["micropost"]["content"] == params.content
    end

    test "with invalid params", %{user: user, conn: conn} do
      params = Factory.fields_for(:lorem, content: "")

      json = conn
        |> put_req_header("authorization", Jwt.encode(user))
        |> post(api_micropost_path(conn, :create), micropost: params)
        |> json_response(422)

      assert json["errors"]["content"] == ["can't be blank"]
    end
  end

  describe "DELETE delete" do
    test "can delete a micropost", %{user: user, micropost: micropost, conn: conn} do
      json = conn
        |> put_req_header("authorization", Jwt.encode(user))
        |> delete(api_micropost_path(conn, :delete, micropost))
        |> json_response(204)

      assert json == %{}
      assert Repo.get(Micropost, micropost.id) == nil
    end

    test "can't delete a micropost without login", %{micropost: micropost, conn: conn} do
      json = conn
        |> delete(api_micropost_path(conn, :delete, micropost))
        |> json_response(401)

      assert json["error"] == "Unauthorized"
      assert Repo.get(Micropost, micropost.id) != nil
    end

    test "can't delete others' microposts", %{micropost: micropost, conn: conn} do
      another_user = Factory.create(:archer)

      json = conn
        |> put_req_header("authorization", Jwt.encode(another_user))
        |> delete(api_micropost_path(conn, :delete, micropost))
        |> json_response(401)

      assert json["error"] == "Unauthorized"
      assert Repo.get(Micropost, micropost.id) != nil
    end
  end
end
