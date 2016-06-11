defmodule PhMicroblog.User do
  use PhMicroblog.Web, :model

  import Ecto.Query
  alias PhMicroblog.Micropost

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_digest, :string
    field :admin, :boolean, default: false

    field :password, :string, virtual: true

    has_many :microposts, Micropost, on_delete: :delete_all

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

  def feed(user) do
    user
    |> assoc(:microposts)
    |> preload([m], :user)
    |> order_by([m], desc: m.inserted_at)
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
