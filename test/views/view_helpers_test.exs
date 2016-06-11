defmodule PhMicroblog.ViewHelpersTest do
  use PhMicroblog.ConnCase, async: true

  alias PhMicroblog.ViewHelpers, as: V

  test "full_title/1" do
    assert V.full_title(nil) == "Sample App"
    assert V.full_title("a") == "a | Sample App"
  end

  test "logged_in?/1" do
    conn = conn |> assign(:current_user, nil)
    refute V.logged_in?(conn)

    conn = conn |> assign(:current_user, :something)
    assert V.logged_in?(conn)
  end

  test "current_user?/2" do
    conn = conn |> assign(:current_user, %{id: 1})

    assert V.current_user?(conn, %{id: 1})
    refute V.current_user?(conn, %{id: 2})
  end
end
