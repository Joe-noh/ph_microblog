defmodule PhMicroblog.CurrentUserTest do
  use PhMicroblog.ConnCase, aysnc: true

  alias PhMicroblog.{Jwt, Factory}
  alias PhMicroblog.CurrentUser

  describe "mode :json" do
    setup %{conn: conn} do
      conn = conn |> put_req_header("accept", "application/json")
      opts = CurrentUser.init(mode: :json)
      user = Factory.create(:michael)

      {:ok, [conn: conn, opts: opts, user: user]}
    end

    test "assigns user if the token is valid", %{conn: conn, opts: opts, user: user} do
      conn = conn
        |> put_req_header("authorization", Jwt.encode(user))
        |> CurrentUser.call(opts)

      assert conn.assigns.current_user
    end

    test "assigns nothing if the token is invalid", %{conn: conn, opts: opts} do
      conn = conn
        |> put_req_header("authorization", "aaaaaaaaaaaaaaa")
        |> CurrentUser.call(opts)

      refute conn.assigns |> Dict.has_key?(:current_user)
    end

    test "assigns nothing if token is missing", %{conn: conn, opts: opts} do
      conn = conn |> CurrentUser.call(opts)

      refute conn.assigns |> Dict.has_key?(:current_user)
    end
  end
end
