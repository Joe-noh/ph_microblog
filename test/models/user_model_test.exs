defmodule UserModelTest do
  use ExUnit.Case
  alias PhMicroblog.Repo
  alias PhMicroblog.User
  import Ecto.Query

  setup_all do
    john = %User{
      name: "john",
      email: "john@doe.com",
      password: "abcdefgh",
      password_confirmation: "abcdefgh"
    }
    mary = User.changeset(%{
      name: "mary",
      email: "MARY@doe.com",
      password: "12345678",
      password_confirmation: "12345678"
    }) |> Repo.insert

    on_exit fn -> Repo.delete_all(User) end

    {:ok, [saved: mary, unsaved: john]}
  end

  test "valid user", context do
    assert User.changeset(context.unsaved, %{}).valid?
    assert User.changeset(context.saved,   %{}).valid?
  end

  test "name is not present", context do
    user = User.changeset(context.unsaved, %{name: " "})
    refute user.valid?
  end

  test "name is too long", context do
    user = User.changeset(context.unsaved, %{name: String.duplicate("a", 50)})
    assert user.valid?

    user = User.changeset(context.unsaved, %{name: String.duplicate("a", 51)})
    refute user.valid?
  end

  test "name is not unique", context do
    user = User.changeset(context.unsaved, %{name: context.saved.name})
    refute user.valid?
  end

  test "email is not present", context do
    user = User.changeset(context.unsaved, %{email: " "})
    refute user.valid?
  end

  test "email format is valid", context do
    ~w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    |> Enum.each fn email ->
      user = User.changeset(context.unsaved, %{email: email})
      assert user.valid?
    end
  end

  test "email format is invalid", context do
    ~w[user@foo,com user_at_foo.org exam.user@foo. foo@b_b.com foo@b+b.com]
    |> Enum.each fn email ->
      user = User.changeset(context.unsaved, %{email: email})
      refute user.valid?
    end
  end

  test "email is not unique", context do
    user = User.changeset(context.unsaved, %{email: context.saved.email})
    refute user.valid?
  end

  test "email should be downcased", context do
    email = Repo.one(from u in User, where: u.name == "mary").email
    assert email == String.downcase(context.saved.email)
  end

  test "password is too short", context do
    user = User.changeset(context.unsaved, %{password: "a", password_confirmation: "a"})
    refute user.valid?
  end

  test "password and confirmation don't match", context do
    user = User.changeset(context.unsaved, %{password: "password"})
    refute user.valid?
  end

  test "authenticate", context do
    assert User.authenticate(context.saved.email, "12345678").name == "mary"
    assert User.authenticate(context.saved.email, "01234567") == nil
  end
end
