defmodule PhMicroblog.Repo.Migrations.AddDigestToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :digest, :string
    end
  end

  def down do
    alter table(:users) do
      remove :digest
    end
  end
end
