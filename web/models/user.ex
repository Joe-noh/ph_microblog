defmodule PhMicroblog.User do
  use Ecto.Model

  import Ecto.Query
  alias PhMicroblog.Repo
  alias PhMicroblog.User
  alias PhMicroblog.Util

  schema "users" do
    field :name
    field :email
    field :digest
    field :salt

    field :created_at, :datetime
    field :updated_at, :datetime

    field :password,     :virtual
    field :confirmation, :virtual
  end

  validate user,
    name:   present,
    email:  present,
    digest: present,
    salt:   present,
    password: has_length(min: 8),
    also: validate_confirmation

  defp validate_confirmation(user) do
    case user.password == user.confirmation do
      true   -> []
      _other -> [password: "does not match the confirmation"]
    end
  end

  def authenticate(email, pass) do
    case User.find_by(:email, email) do
      nil  -> nil
      user ->
        {:ok, digest} = :bcrypt.hashpw(pass, String.to_char_list(user.digest))

        if user.digest == List.to_string(digest), do: user, else: nil
    end
  end

  def new, do: %User{}

  def find_by(:id, id) when is_integer(id) do
    Repo.get(User, id)
  end

  def find_by(:id, id) when is_binary(id) do
    Repo.get(User, String.to_integer(id))
  end

  def find_by(:name, name) when is_binary(name) do
    Repo.one(from(u in User, where: u.name == ^name))
  end

  def find_by(:email, email) when is_binary(email) do
    Repo.one(from(u in User, where: u.email == ^email))
  end

  def all, do: Repo.all(User)

  def create(%{"name" => name, "email" => email, "password" => pass, "confirmation" => conf}) do
    user = new_user(name, email, pass, conf)

    case validate(user) do
      []     -> {:ok, Repo.insert(user)}
      errors -> {:error, Util.errors_to_strings(errors)}
    end
  end

  def update(%{"name" => name, "email" => email, "password" => pass, "confirmation" => conf}) do
    user = new_user(name, email, pass, conf)

    case validate(user) do
      []     -> {:ok, Repo.insert(user)}
      errors -> {:error, Util.errors_to_strings(errors)}
    end
  end

  defp new_user(name, email, pass, conf) do
    {:ok, salt}   = :bcrypt.gen_salt
    {:ok, digest} = :bcrypt.hashpw(pass, salt)

    %User{
      name:   name,
      email:  email,
      password: pass,
      confirmation: conf,
      digest: List.to_string(digest),
      salt:   List.to_string(salt),
      created_at: Ecto.DateTime.from_erl(:calendar.local_time)
    }
  end
end
