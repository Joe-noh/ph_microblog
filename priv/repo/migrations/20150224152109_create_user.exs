defmodule PhMicroblog.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :name
      add :email
      timestamps
    end
  end

  def down do
    drop table(:users)
  end
end
