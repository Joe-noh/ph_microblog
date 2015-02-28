defmodule UserPageTest do
  use ExUnit.Case
  use Plug.Test
  import TestHelper

  alias PhMicroblog.User
  alias PhMicroblog.Repo

  @opts PhMicroblog.Router.init []

  setup_all do
    mary = %User{
      name: "mary",
      email: "MARY@doe.com",
      password: "12345678",
      password_confirmation: "12345678"
    } |> Repo.insert

    on_exit fn -> Repo.delete_all(User) end

    {:ok, [user: mary]}
  end

  test "new" do
    conn = conn(:get, "/signup", %{})
      |> with_session
      |> PhMicroblog.Router.call(@opts)

    assert conn.state  == :sent
    assert conn.status == 200

    assert have_content?(conn, "Sign up")
    assert have_title?(conn, "Sample App | Sign up")
  end

  test "show", context do
    user = context.user

    conn = conn(:get, "/users/#{user.id}")
      |> with_session
      |> PhMicroblog.Router.call(@opts)

    assert conn.state  == :sent
    assert conn.status == 200

    assert have_content?(conn, "mary")
    assert have_title?(conn, "Sample App | mary")
  end
end
