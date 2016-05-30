defmodule PhMicroblog.UserTest do
  use PhMicroblog.ModelCase

  alias PhMicroblog.{Factory, User}

  setup do
    user = Factory.build(:user)

    {:ok, [user: user]}
  end

  test "name can't be blank", %{user: user} do
    assert errors_on(user, %{name: ""})[:name]
  end

  test "name shouldn't be too long", %{user: user} do
    name = String.duplicate("a", 50)
    refute errors_on(user, %{name: name})[:name]

    name = String.duplicate("a", 51)
    assert errors_on(user, %{name: name})[:name]
  end

  test "email can't be blank", %{user: user} do
    assert errors_on(user, %{email: ""})[:email]
  end

  test "email shouldn't be too long", %{user: user} do
    email = String.duplicate("a", 243) <> "@example.com"
    refute errors_on(user, %{email: email})[:email]

    email = String.duplicate("a", 244) <> "@example.com"
    assert errors_on(user, %{email: email})[:email]
  end

  test "email validation should accept valid addresses", %{user: user} do
    ~w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    |> Enum.each(fn email ->
      refute errors_on(user, %{email: email})[:email]
    end)
  end

  test "email validation should reject invalid addresses", %{user: user} do
    ~w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    |> Enum.each(fn email ->
      assert errors_on(user, %{email: email})[:email]
    end)
  end

  test "email addresses should be unique", %{user: user} do
    Factory.create(:user, email: user.email)

    assert {:error, _} = user |> User.changeset() |> Repo.insert()
  end

  test "email always will be saved in downcase", %{user: user} do
    changeset = User.changeset(user, %{email: "HOGE@EXAMPLE.COM"})

    assert changeset |> Ecto.Changeset.get_field(:email) == "hoge@example.com"
  end

  test "password and its confirmation have to be same when there's password", %{user: user} do
    params = %{password: "aaaaa", password_confirmation: "bbbbb"}

    assert errors_on(user, params)[:password_confirmation]
  end

  test "update without password should succeed", %{user: user} do
    user = Factory.create(:user, email: user.email)

    assert errors_on(user, %{name: "alex"}) == []
  end
end
