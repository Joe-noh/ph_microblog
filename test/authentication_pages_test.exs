defmodule AuthenticationPagesTest do
  use Amrita.Sweet
  use Hound.Helpers

  import TestHelper

  alias PhMicroblog.Router.Helpers, as: Router
  alias PhMicroblog.User
  alias PhMicroblog.Repo

  hound_session

  setup_all do
    PhMicroblog.Router.start

    on_exit fn ->
      Repo.delete_all(User)
      PhMicroblog.Router.stop
    end
  end

  facts "signin page" do
    fact "contains 'Sign in'" do
      navigate_to url(Router.session_path :new)

      page_source |> contains "Sign in"
    end
  end

  facts "signin" do
    fact "profile page contains the user's name" do
      {:ok, user} = User.create(valid_user_params)
      navigate_to url(Router.user_path(:show, user.id))
      Repo.delete(user)

      page_source |> contains user.name
    end

    fact "success with valid information" do
      signin_via_form
      page_source |> contains "successfully"
    end

    fact "fail with invalid information" do
      navigate_to url(Router.session_path :new)
      find_element(:id, "submit-button") |> click

      element_displayed?({:css, ".alert"}) |> truthy
    end

    fact "followed by sign out" do
      signin_via_form
      find_element(:link_text, "Sign out") |> click

      element_displayed?({:link_text, "Sign in"}) |> truthy
    end
  end
end
