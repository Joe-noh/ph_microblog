defmodule PhMicroblog.RelationshipTest do
  use PhMicroblog.ModelCase, async: true

  alias PhMicroblog.{Relationship, Factory, Repo}

  setup do
    michael = Factory.insert(:michael)
    archer  = Factory.insert(:archer)

    {:ok, [michael: michael, archer: archer]}
  end

  describe "validations" do
    test "pair of follower_id and followed_id should be unique", %{michael: michael, archer: archer} do
      Factory.insert(:relationship, follower: michael, followed: archer)

      changeset = Factory.build(:relationship, follower: michael, followed: archer)
        |> Relationship.changeset

      assert {:error, _} = Repo.insert(changeset)
    end
  end
end
