defmodule PhMicroblog.User do
  use Ecto.Model

  schema "users" do
    field :name, :string
    field :email, :string

    field :inserted_at, Ecto.DateTime, default: Ecto.DateTime.local
    field :updated_at,  Ecto.DateTime, default: Ecto.DateTime.local
  end

  before_insert :downcase_email
  before_update :downcase_email

  def changeset(user, params \\ %{}) do
    params
    |> cast(user, ~w(name email), [])
    |> validate_unique(:name, on: PhMicroblog.Repo)
    |> validate_length(:name, max: 50)
    |> validate_unique(:email, on: PhMicroblog.Repo, downcase: true)
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  end

  defp downcase_email(changeset) do
    email = get_change(changeset, :email) |> String.downcase
    put_change(changeset, :email, email)
  end
end
