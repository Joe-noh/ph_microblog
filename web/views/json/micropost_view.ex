defmodule PhMicroblog.Json.MicropostView do
  use PhMicroblog.Web, :view

  def render("index.json", %{page: page}) do
    %{microposts: render_many(page.entries, __MODULE__, "micropost.json")}
  end

  def render("show.json", %{micropost: micropost}) do
    %{micropost: render_one(micropost, __MODULE__, "micropost.json")}
  end

  def render("micropost.json", %{micropost: micropost}) do
    %{
      id: micropost.id,
      content: micropost.content,
      inserted_at: micropost.inserted_at,
      user: render_one(micropost.user, PhMicroblog.Json.UserView, "user.json")
    }
  end
end
