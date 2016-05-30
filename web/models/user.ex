defmodule PhMicroblog.User do
  use PhMicroblog.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_digest, :string

    field :password, :string, virtual: true

    timestamps
  end

  @allowed ~w[name email password]

  @email_format ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:name)
    |> validate_required(:email)
    |> validate_required(:password_digest)
    |> validate_length(:name, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @email_format)
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> generate_digest
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
