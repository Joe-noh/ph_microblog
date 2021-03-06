defmodule PhMicroblog.User do
  use PhMicroblog.Web, :model

  import Ecto.Query
  alias PhMicroblog.{Micropost, Relationship, Repo}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_digest, :string
    field :admin, :boolean, default: false

    field :password, :string, virtual: true

    has_many :microposts, Micropost, on_delete: :delete_all

    has_many :active_relationships, Relationship,
      foreign_key: :follower_id,
      on_delete: :delete_all
    has_many :following, through: [:active_relationships, :followed]

    has_many :passive_relationships, Relationship,
      foreign_key: :followed_id,
      on_delete: :delete_all
    has_many :followers, through: [:passive_relationships, :follower]

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
    |> update_change(:email, &downcase_email/1)
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
    following_ids = user |> assoc(:following) |> Repo.all |> Enum.map(& &1.id)
    targets = [user.id | following_ids]

    Micropost
    |> where([m], m.user_id in ^targets)
    |> preload([m], :user)
    |> order_by([m], desc: m.inserted_at)
  end

  def following?(user, other) do
    user |> assoc(:following) |> Repo.get(other.id) != nil
  end

  def following_count(user) do
    user
    |> assoc(:following)
    |> select([f], count(f.id))
    |> Repo.one
  end

  def followers_count(user) do
    user
    |> assoc(:followers)
    |> select([f], count(f.id))
    |> Repo.one
  end

  defp generate_digest(changeset) do
    password = get_field(changeset, :password, nil)
    if password != nil do
      put_change(changeset, :password_digest, Comeonin.Bcrypt.hashpwsalt(password))
    else
      changeset
    end
  end

  defp downcase_email(nil),   do: nil
  defp downcase_email(email), do: String.downcase(email)
end
