defmodule PhMicroblog.Repo.Migrations.AddPasswordDigestToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_digest, :string, null: false
    end
  end
end
