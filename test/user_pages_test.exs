defmodule UserPagesTest do
  use ExUnit.Case
  use Hound.Helpers
  import TestHelper

  hound_session

  setup_all do
    PhMicroblog.Router.start

    on_exit fn ->
      PhMicroblog.Router.stop
    end
  end

  test "root" do
    navigate_to url("/static_pages/home")

    assert Regex.match?(~r/app/, page_source)
  end
end
