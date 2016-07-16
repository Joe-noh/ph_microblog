defmodule PhMicroblog.UserTest do
  use PhMicroblog.ModelCase, async: true

  alias PhMicroblog.{Factory, User, Micropost}

  describe "validations" do
    setup do
      user = Factory.build(:michael)

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
      Factory.insert(:michael, email: user.email)

      assert {:error, _} = user |> User.changeset() |> Repo.insert()
    end

    test "email always will be saved in downcase", %{user: user} do
      changeset = User.changeset(user, %{email: "HOGE@EXAMPLE.COM"})

      assert changeset |> Ecto.Changeset.get_field(:email) == "hoge@example.com"
    end

    test "password shouldn't be too short", %{user: user} do
      params = %{password: "aaaaa", password_confirmation: "aaaaa"}

      assert errors_on(user, params)[:password]
    end

    test "password and its confirmation have to be same when there's password", %{user: user} do
      params = %{password: "aaaaaa", password_confirmation: "bbbbbb"}

      assert errors_on(user, params)[:password_confirmation]
    end

    test "update without password should succeed", %{user: user} do
      user = Factory.insert(:michael, email: user.email)

      assert errors_on(user, %{name: "alex"}) == []
    end

    test "associated microposts should be destroyed", %{user: user} do
      user = Repo.insert!(user)
      micropost = Factory.insert(:lorem, user: user)

      Repo.delete(user)

      assert Repo.get(Micropost, micropost.id) == nil
    end
  end

  describe "feed/1" do
    setup do
      michael = Factory.insert(:michael)
      archer  = Factory.insert(:archer)

      m_post = Factory.insert(:lorem, user: michael)
      a_post = Factory.insert(:lorem, user: archer)

      {:ok, [michael: michael, archer: archer, michael_post: m_post, archer_post: a_post]}
    end

    test "following user's posts are included", context do
      Factory.insert(:relationship, follower: context.michael, followed: context.archer)

      refute context.michael_post in Repo.all(User.feed context.archer)
      assert context.archer_post  in Repo.all(User.feed context.michael)
    end

    test "own posts are included", context do
      assert context.michael_post in Repo.all(User.feed context.michael)
      assert context.archer_post  in Repo.all(User.feed context.archer)
    end
  end
end
