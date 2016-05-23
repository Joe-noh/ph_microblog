defmodule PhMicroblog.StaticPageControllerTest do
  use PhMicroblog.ConnCase

  test "GET home", %{conn: conn} do
    conn = get conn, static_page_path(conn, :home)

    assert html_response(conn, 200)
  end

  test "GET help", %{conn: conn} do
    conn = get conn, static_page_path(conn, :help)

    assert html_response(conn, 200)
  end

  test "GET about", %{conn: conn} do
    conn = get conn, static_page_path(conn, :about)

    assert html_response(conn, 200)
  end
end
