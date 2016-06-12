defmodule PhMicroblog.StaticPageControllerTest do
  use PhMicroblog.ConnCase, async: true

  test "GET home", %{conn: conn} do
    html = build_conn()
      |> get(static_page_path conn, :home)
      |> html_response(200)

    assert has_title?(html, "Sample App")
  end

  test "GET help", %{conn: conn} do
    html = build_conn()
      |> get(static_page_path conn, :help)
      |> html_response(200)

    assert has_title?(html, "help | Sample App")
  end

  test "GET about", %{conn: conn} do
    html = build_conn()
      |> get(static_page_path conn, :about)
      |> html_response(200)

    assert has_title?(html, "about | Sample App")
  end

  test "GET contact", %{conn: conn} do
    html = build_conn()
      |> get(static_page_path conn, :contact)
      |> html_response(200)

    assert has_title?(html, "contact | Sample App")
  end
end
