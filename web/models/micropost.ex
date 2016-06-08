defmodule PhMicroblog.Micropost do
  use PhMicroblog.Web, :model

  alias PhMicroblog.User

  schema "microposts" do
    field :content, :string
    belongs_to :user, User

    timestamps
  end

  @allowed ~w(content)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> validate_required(:content)
    |> validate_required(:user_id)
    |> validate_length(:content, max: 140)
    |> foreign_key_constraint(:user_id)
  end
end
