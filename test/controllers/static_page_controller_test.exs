defmodule PhMicroblog.StaticPageControllerTest do
  use PhMicroblog.ConnCase, async: true

  test "GET home", %{conn: conn} do
    html = build_conn()
      |> get(static_page_path conn, :home)
      |> html_response(200)

    assert html |> Floki.find("title") |> Floki.text == "Sample App"
  end

  test "GET help", %{conn: conn} do
    html = build_conn()
      |> get(static_page_path conn, :help)
      |> html_response(200)

    assert html |> Floki.find("title") |> Floki.text == "help | Sample App"
  end

  test "GET about", %{conn: conn} do
    html = build_conn()
      |> get(static_page_path conn, :about)
      |> html_response(200)

    assert html |> Floki.find("title") |> Floki.text == "about | Sample App"
  end

  test "GET contact", %{conn: conn} do
    html = build_conn()
      |> get(static_page_path conn, :contact)
      |> html_response(200)

    assert html |> Floki.find("title") |> Floki.text == "contact | Sample App"
  end
end
