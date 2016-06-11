defmodule PhMicroblog.Factory do
  use ExMachina.Ecto, repo: PhMicroblog.Repo

  alias PhMicroblog.{User, Micropost}

  def factory(:michael) do
    %User{
      name: "John Doe",
      email: sequence(:email, &"user#{&1}@example.com"),
      password_digest: Comeonin.Bcrypt.hashpwsalt("password"),
      admin: true
    }
  end

  def factory(:archer) do
    %User{
      name: "Sterling Archer",
      email: sequence(:email, &"user#{&1}@example.com"),
      password_digest: Comeonin.Bcrypt.hashpwsalt("password"),
      admin: false
    }
  end

  def factory(:lorem) do
    %Micropost{
      content: "Lorem ipsum",
      user: build(:michael)
    }
  end
end
