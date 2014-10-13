defmodule UserPagesTest do
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

  facts "user pages", c do
    fact "signin page contains 'Sign up'" do
      navigate_to url(Router.user_path :new)

      page_source |> contains "Sign up"
    end

    fact "profile page contains the user's name" do
      {:ok, user} = User.create(valid_user_params)
      navigate_to url(Router.user_path(:show, user.id))
      Repo.delete(user)

      page_source |> contains user.name
    end
  end

  facts "sign up" do
    fact "success with valid information" do
      params = valid_user_params

      navigate_to url(Router.user_path :new)

      find_element(:id, "name") |> fill_field(params["name"])
      find_element(:id, "email") |> fill_field(params["email"])
      find_element(:id, "password") |> fill_field(params["password"])
      find_element(:id, "confirmation") |> fill_field(params["confirmation"])

      find_element(:id, "submit-button") |> click

      page_source |> contains "successfully"
    end
  end
end
