ExUnit.start
Amrita.start

defmodule TestHelper do
  use Hound.Helpers

  alias PhMicroblog.Router.Helpers, as: Router
  alias PhMicroblog.User
  alias PhMicroblog.Repo

  @port 4001

  def url(path) do
    "http://localhost:#{@port}#{path}"
  end

  def valid_user_params do
    %{"name"  => "joe",
      "email" => "joe@example.com",
      "password"     => "abcdefgh",
      "confirmation" => "abcdefgh"}
  end

  def signin_via_form do
    params = valid_user_params
    {:ok, user} = User.create(valid_user_params)

    navigate_to url(Router.session_path :new)

    find_element(:id, "email")    |> fill_field(params["email"])
    find_element(:id, "password") |> fill_field(params["password"])

    find_element(:id, "submit-button") |> click
    Repo.delete(user)
  end
end
