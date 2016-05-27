defmodule PhMicroblog.UserTest do
  use PhMicroblog.ModelCase

  alias PhMicroblog.User

  @valid_attrs %{name: "John", email: "john@email.com"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
