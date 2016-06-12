defmodule PhMicroblog.Json.SessionView do
  use PhMicroblog.Web, :view

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
