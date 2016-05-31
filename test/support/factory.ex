defmodule PhMicroblog.Factory do
  use ExMachina.Ecto, repo: PhMicroblog.Repo

  alias PhMicroblog.{User}

  def factory(:user) do
    %User{
      name: "John Doe",
      email: sequence(:email, &"user#{&1}@example.com"),
      password_digest: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    }
  end
end
