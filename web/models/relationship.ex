defmodule PhMicroblog.Relationship do
  use PhMicroblog.Web, :model

  alias PhMicroblog.User

  schema "relationships" do
    belongs_to :follower, User
    belongs_to :followed, User

    timestamps
  end

  @allowed ~w[follower_id followed_id]

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed)
    |> foreign_key_constraint(:follower_id)
    |> foreign_key_constraint(:followed_id)
    |> unique_constraint(:follower_id, name: :relationships_index)
  end
end
