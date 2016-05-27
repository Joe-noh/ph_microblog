defmodule PhMicroblog.User do
  use PhMicroblog.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string

    timestamps
  end

  @allowed ~w[name email]

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:name)
    |> validate_required(:email)
  end
end
