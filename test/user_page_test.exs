defmodule UserPageTest do
  use ExUnit.Case
  use Plug.Test
  import TestHelper

  @opts PhMicroblog.Router.init []

  test "new" do
    conn = conn(:get, "/users/new", %{})
      |> with_session
      |> PhMicroblog.Router.call(@opts)

    assert conn.state  == :sent
    assert conn.status == 200

    assert have_content?(conn, "Sign up")
    assert have_title?(conn, "Sample App | Sign up")
  end
end
