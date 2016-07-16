defmodule PhMicroblog.MicropostControllerTest do
  use PhMicroblog.ConnCase, async: true

  alias PhMicroblog.{Factory, Micropost}

  setup do
    user = Factory.insert(:michael)
    micropost = Factory.insert(:lorem, user: user)

    {:ok, [user: user, micropost: micropost]}
  end

  describe "POST create" do
    test "with valid params", %{user: user} do
      params = Factory.params_for(:lorem)

      conn = build_conn()
        |> assign(:current_user, user)
        |> post(micropost_path(build_conn(), :create), micropost: params)

      assert redirected_to(conn) == static_page_path(conn, :home)
    end

    test "with invalid params", %{user: user} do
      params = Factory.params_for(:lorem, content: "")

      html = build_conn()
        |> assign(:current_user, user)
        |> post(micropost_path(build_conn(), :create), micropost: params)
        |> html_response(200)

      assert count_element(html, ".has-error") != 0
    end
  end

  describe "DELETE delete" do
    test "can delete a micropost", %{user: user, micropost: micropost} do
      conn = build_conn()
        |> assign(:current_user, user)
        |> delete(micropost_path(build_conn(), :delete, micropost))

      assert redirected_to(conn) == static_page_path(conn, :home)
      assert Repo.get(Micropost, micropost.id) == nil
    end

    test "redirected to login page without login", %{micropost: micropost} do
      conn = build_conn()
        |> assign(:current_user, nil)
        |> delete(micropost_path(build_conn(), :delete, micropost))

      assert redirected_to(conn) == session_path(conn, :new)
      assert Repo.get(Micropost, micropost.id) != nil
    end
  end
end
