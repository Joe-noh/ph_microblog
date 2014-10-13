defmodule UserFacts do
  use Amrita.Sweet

  alias PhMicroblog.User
  alias PhMicroblog.Repo

  @valid_params TestHelper.valid_user_params

  setup_all do
    Repo.delete_all(User)
    :ok
  end

  setup do
    on_exit fn -> Repo.delete_all(User) end
  end

  facts "creation" do
    fact "success with valid parameters" do
      Repo.delete_all(User)
      {:ok, user} = User.create(@valid_params)

      %User{user | password: nil, confirmation: nil} |> equals User.find_by(:id, user.id)
    end

    fact "fail with blank name" do
      {:error, messages} = User.create(%{@valid_params | "name" => ""})
      messages |> contains "name can't be blank"
    end

    fact "fail with blank email" do
      {:error, messages} = User.create(%{@valid_params | "email" => ""})
      messages |> contains "email can't be blank"
    end

    fact "fail with too short password" do
      {:error, messages} =
        %{@valid_params | "password" => "abc", "confirmation" => "abc"}
        |> User.create
      messages |> contains "password is too short (minimum is 8 characters)"
    end

    fact "fail with pass and confirmation which do not match" do
      {:error, messages} = User.create(%{@valid_params | "password" => "12345678"})
      messages |> contains "password does not match the confirmation"
    end
  end

  facts "authentication" do
    fact "success with correct parameters" do
      {:ok, user} = User.create(@valid_params)

      User.authenticate(user.name, user.password) |> matches %User{}
    end

    fact "fail with incorrect parameters" do
      {:ok, user} = User.create(@valid_params)

      User.authenticate(user.name, "hogehoge") |> equals nil
    end
  end
end

