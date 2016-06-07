alias PhMicroblog.{User, Repo}

defmodule Helper do
  def insert_user!(name, email, password) do
    params = %{
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    }

    %User{} |> User.changeset(params) |> Repo.insert!
  end
end

Faker.start

Helper.insert_user!("Example User", "example@railstutorial.org", "foobar")

Enum.each 1..99, fn i ->
  spawn fn ->
    Helper.insert_user!(Faker.Name.name, "example-#{i}@railstutorial.org", "password")
  end
end
