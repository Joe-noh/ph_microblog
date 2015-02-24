defmodule StaticPageTest do
  use ExUnit.Case
  use Plug.Test
  import TestHelper

  @opts PhMicroblog.Router.init []

  test "home" do
    conn = conn(:get, "/static_page/home", %{})
      |> with_session
      |> PhMicroblog.Router.call(@opts)

    assert conn.state  == :sent
    assert conn.status == 200

    assert have_content?(conn, "Sample App")
    assert have_title?(conn, "Sample App | Home")
  end

  test "help" do
    conn = conn(:get, "/static_page/help", %{})
      |> with_session
      |> PhMicroblog.Router.call(@opts)

    assert conn.state  == :sent
    assert conn.status == 200

    assert have_content?(conn, "Help")
    assert have_title?(conn, "Sample App | Help")
  end

  test "about" do
    conn = conn(:get, "/static_page/about", %{})
      |> with_session
      |> PhMicroblog.Router.call(@opts)

    assert conn.state  == :sent
    assert conn.status == 200

    assert have_content?(conn, "About")
    assert have_title?(conn, "Sample App | About Us")
  end
end
