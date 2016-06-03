defmodule PhMicroblog.Factory do
  use ExMachina.Ecto, repo: PhMicroblog.Repo

  alias PhMicroblog.{User}

  def factory(:michael) do
    %User{
      name: "John Doe",
      email: sequence(:email, &"user#{&1}@example.com"),
      password_digest: Comeonin.Bcrypt.hashpwsalt("password")
    }
  end

  def factory(:archer) do
    %User{
      name: "Sterling Archer",
      email: sequence(:email, &"user#{&1}@example.com"),
      password_digest: Comeonin.Bcrypt.hashpwsalt("password")
    }
  end
end
