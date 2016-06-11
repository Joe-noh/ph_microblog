alias PhMicroblog.{User, Micropost, Relationship, Repo}

import Ecto
import Ecto.Query

defmodule Helper do
  def insert_user!(name, email, password, admin \\ false) do
    params = %{
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    }

    %User{admin: admin} |> User.changeset(params) |> Repo.insert!
  end
end

Faker.start

example_user = Helper.insert_user!("Example User", "example@railstutorial.org", "foobar", true)

1..99
|> Enum.map(&Task.async(Helper, :insert_user!, [Faker.Name.name, "example-#{&1}@railstutorial.org", "password"]))
|> Enum.map(&Task.await/1)

users = from(u in User, order_by: :inserted_at, limit: 6) |> Repo.all

(for _ <- 1..50, user <- users, do: user)
|> Enum.map(fn user ->
  Task.async fn ->
    content = Faker.Lorem.sentence(5)
    user |> build_assoc(:microposts) |> Micropost.changeset(%{content: content}) |> Repo.insert!
  end
end)
|> Enum.map(&Task.await/1)

from(u in User, offset: 2, limit: 48)
|> Repo.all
|> Enum.map(&Task.async fn ->
  example_user
  |> build_assoc(:active_relationships)
  |> Relationship.changeset(%{followed_id: &1.id})
  |> Repo.insert!
end)
|> Enum.map(&Task.await/1)

from(u in User, offset: 3, limit: 37)
|> Repo.all
|> Enum.map(&Task.async fn ->
  example_user
  |> build_assoc(:passive_relationships)
  |> Relationship.changeset(%{follower_id: &1.id})
  |> Repo.insert!
end)
|> Enum.map(&Task.await/1)
