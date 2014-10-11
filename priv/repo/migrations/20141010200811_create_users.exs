defmodule PhMicroblog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    [
      """
      CREATE TABLE IF NOT EXISTS users(
        id serial primary key,
        name text,
        email text,
        digest text,
        salt text,
        created_at timestamp,
        updated_at timestamp
      );
      """,
      "CREATE UNIQUE INDEX unique_name  ON users(name);",
      "CREATE UNIQUE INDEX unique_email ON users(email);"
    ]
  end

  def down do
    "DROP TABLE users"
  end
end
