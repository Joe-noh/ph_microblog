defmodule PhMicroblog.User do
  use PhMicroblog.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string

    timestamps
  end

  @allowed ~w[name email]

  @email_format ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:name)
    |> validate_required(:email)
    |> validate_length(:name, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @email_format)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
  end
end
