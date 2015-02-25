defmodule PhMicroblog.User do
  use Ecto.Model

  alias PhMicroblog.Repo
  alias PhMicroblog.User

  schema "users" do
    field :name, :string
    field :email, :string

    field :digest, :string
    field :password,              :string, virtual: true
    field :password_confirmation, :string, virtual: true

    field :inserted_at, Ecto.DateTime, default: Ecto.DateTime.local
    field :updated_at,  Ecto.DateTime, default: Ecto.DateTime.local
  end

  before_insert :downcase_email
  before_update :downcase_email
  before_insert :make_digest
  before_update :make_digest

  def changeset(user, params \\ %{}) do
    set = params
      |> cast(user, ~w(name email password password_confirmation), [])
      |> validate_unique(:name, on: PhMicroblog.Repo)
      |> validate_length(:name, max: 50)
      |> validate_unique(:email, on: PhMicroblog.Repo, downcase: true)
      |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
      |> validate_length(:password, min: 8)
      |> validate_length(:password_confirmation, min: 8)

    pass = get_field(set, :password)
    conf = get_field(set, :password_confirmation)
    case pass do
      ^conf  -> set
      _other -> add_error(set, :password, "password and confirmation don't match")
    end
  end

  def authenticate(email, password) do
    case Repo.one(from u in User, where: u.email == ^email) do
      nil  -> nil
      user -> check_password(user, password)
    end
  end

  defp check_password(user, password) do
    case Comeonin.Bcrypt.checkpw(password, user.digest) do
      true  -> user
      false -> nil
    end
  end

  defp downcase_email(changeset) do
    case get_change(changeset, :email) do
      nil   -> changeset
      email -> put_change(changeset, :email, String.downcase(email))
    end
  end

  defp make_digest(changeset) do
    case get_field(changeset, :password) do
      nil  -> changeset
      pass -> put_change(changeset, :digest, Comeonin.Bcrypt.hashpwsalt(pass))
    end
  end
end
