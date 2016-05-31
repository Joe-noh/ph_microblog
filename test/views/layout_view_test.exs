defmodule PhMicroblog.LayoutViewTest do
  use PhMicroblog.ConnCase, async: true

  alias PhMicroblog.LayoutView, as: V

  test "full_title/1" do
    assert V.full_title(nil) == "Sample App"
    assert V.full_title("a") == "a | Sample App"
  end
end
