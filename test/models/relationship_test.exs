defmodule PhMicroblog.RelationshipTest do
  use PhMicroblog.ModelCase, async: true

  alias PhMicroblog.{Relationship, Factory, Repo}

  setup do
    michael = Factory.create(:michael)
    archer  = Factory.create(:archer)

    {:ok, [michael: michael, archer: archer]}
  end

  test "pair of follower_id and followed_id should be unique", %{michael: michael, archer: archer} do
    Factory.create(:relationship, follower: michael, followed: archer)

    changeset = Factory.build(:relationship, follower: michael, followed: archer)
      |> Relationship.changeset

    assert {:error, _} = Repo.insert(changeset)
  end
end
