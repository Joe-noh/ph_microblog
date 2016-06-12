defmodule PhMicroblog.MicropostTest do
  use PhMicroblog.ModelCase, async: true

  alias PhMicroblog.{Factory, Micropost}

  setup do
    micropost = Factory.create(:lorem)

    {:ok, [micropost: micropost]}
  end

  test "content can't be blank", %{micropost: micropost} do
    assert errors_on(micropost, %{content: ""})[:content]
  end

  test "content length can't be longer than 140", %{micropost: micropost} do
    content = String.duplicate("a", 140)
    refute errors_on(micropost, %{content: content})[:content]

    content = String.duplicate("a", 141)
    assert errors_on(micropost, %{content: content})[:content]
  end

  test "user_id can't be blank" do
    params = Factory.fields_for(:lorem)

    assert errors_on(%Micropost{user_id: nil}, params)[:user_id]
  end

  test "user should exist" do
    params = Factory.fields_for(:lorem)
    changeset = %Micropost{user_id: -1} |> Micropost.changeset(params)

    assert_raise Ecto.InvalidChangesetError, fn ->
      Repo.insert! changeset
    end
  end
end
