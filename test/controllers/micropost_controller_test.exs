defmodule PhMicroblog.MicropostControllerTest do
  use PhMicroblog.ConnCase

  alias PhMicroblog.{Factory, Micropost}

  setup do
    user = Factory.create(:michael)
    micropost = Factory.create(:lorem, user: user)

    {:ok, [user: user, micropost: micropost]}
  end

  test "POST create with valid params", %{user: user} do
    params = Factory.fields_for(:lorem)

    conn = conn
      |> assign(:current_user, user)
      |> post(micropost_path(conn, :create), micropost: params)

    assert redirected_to(conn) == static_page_path(conn, :home)
  end

  test "POST create with invalid params", %{user: user} do
    params = Factory.fields_for(:lorem, content: "")

    html = conn
      |> assign(:current_user, Repo.preload(user, :microposts))
      |> post(micropost_path(conn, :create), micropost: params)
      |> html_response(200)

    assert html |> Floki.find(".has-error") |> Enum.count != 0
  end

  test "DELETE delete", %{user: user, micropost: micropost} do
    conn = conn
      |> assign(:current_user, user)
      |> delete(micropost_path(conn, :delete, micropost))

    assert redirected_to(conn) == static_page_path(conn, :home)
    assert Repo.get(Micropost, micropost.id) == nil
  end

  test "DELETE delete without login", %{micropost: micropost} do
    conn = conn
      |> assign(:current_user, nil)
      |> delete(micropost_path(conn, :delete, micropost))

    assert redirected_to(conn) == session_path(conn, :new)
    assert Repo.get(Micropost, micropost.id) != nil
  end
end