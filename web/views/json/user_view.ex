defmodule PhMicroblog.Json.UserView do
  use PhMicroblog.Web, :view

  def render("index.json", %{page: page}) do
    %{users: render_many(page.entries, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name}
  end
end
