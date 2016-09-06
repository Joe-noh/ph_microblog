defmodule PhMicroblog.Json.UserView do
  use PhMicroblog.Web, :view

  def render("index.json", %{page: page}) do
    %{users: render_many(page.entries, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      avatar_url: gravatar_url(user)
     }
  end
end
