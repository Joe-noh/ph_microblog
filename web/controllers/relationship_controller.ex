defmodule PhMicroblog.RelationshipController do
  use PhMicroblog.Web, :controller

  alias PhMicroblog.{Relationship, User}

  plug :scrub_params, "relationship"when action == :create

  def create(conn, %{"relationship" => %{"followed_id" => followed_id}}) do
    conn.assigns.current_user
    |> build_assoc(:active_relationships)
    |> Relationship.changeset(%{followed_id: followed_id})
    |> Repo.insert!

    user = Repo.get!(User, followed_id)
    redirect(conn, to: user_path(conn, :show, user))
  end

  def delete(conn, %{"id" => followed_id}) do
    conn.assigns.current_user
    |> assoc(:active_relationships)
    |> where(followed_id: ^followed_id)
    |> Repo.one
    |> Repo.delete!

    user = Repo.get!(User, followed_id)
    redirect(conn, to: user_path(conn, :show, user))
  end
end
