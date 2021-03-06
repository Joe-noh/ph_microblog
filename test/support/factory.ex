defmodule PhMicroblog.Factory do
  use ExMachina.Ecto, repo: PhMicroblog.Repo

  alias PhMicroblog.{User, Micropost, Relationship}

  def michael_factory do
    %User{
      name: "John Doe",
      email: sequence(:email, &"user#{&1}@example.com"),
      password_digest: Comeonin.Bcrypt.hashpwsalt("password"),
      admin: true
    }
  end

  def archer_factory do
    %User{
      name: "Sterling Archer",
      email: sequence(:email, &"user#{&1}@example.com"),
      password_digest: Comeonin.Bcrypt.hashpwsalt("password"),
      admin: false
    }
  end

  def lorem_factory do
    %Micropost{
      content: "Lorem ipsum",
      user: build(:michael)
    }
  end

  def relationship_factory do
    %Relationship{
      follower: build(:michael),
      followed: build(:archer)
    }
  end
end
