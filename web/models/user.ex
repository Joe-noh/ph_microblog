defmodule PhMicroblog.User do
  use PhMicroblog.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_digest, :string
    field :admin, :boolean, default: false

    field :password, :string, virtual: true

    timestamps
  end

  @allowed ~w[name email password]

  @email_format ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> generate_digest
    |> validate_required(:name)
    |> validate_required(:email)
    |> validate_required(:password_digest)
    |> validate_length(:name, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, @email_format)
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
  end

  def authenticate(nil, _password) do
    Comeonin.Bcrypt.dummy_checkpw()
  end

  def authenticate(user, password) do
    if Comeonin.Bcrypt.checkpw(password, user.password_digest) do
      {:ok, user}
    else
      :error
    end
  end

  def gravatar_for(%{email: email}, size) do
    "https://secure.gravatar.com/avatar/#{md5_digest(email)}?s=#{size}"
  end

  defp md5_digest(email) do
    email
    |> String.downcase
    |> :erlang.md5
    |> stringify_digest
  end

  defp stringify_digest(md5) do
    parts = for <<c <- md5>>, do: c |> Integer.to_string(16) |> String.rjust(2, ?0)
    parts |> List.flatten |> Enum.join |> String.downcase
  end

  defp generate_digest(changeset) do
    password = get_field(changeset, :password, nil)
    if password != nil do
      put_change(changeset, :password_digest, Comeonin.Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end
end
