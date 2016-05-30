defmodule PhMicroblog.UserService do
  alias Ecto.Multi

  def insert(name, email, password, confirmation) do
    params = %{name: name, email: email, password: password, password_confirmation: confirmation}

    Multi.new
    |> Multi.insert(:user, PhMicroblog.User.insert_changeset(%PhMicroblog.User{}, params))
  end
end
