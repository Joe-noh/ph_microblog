defmodule PhMicroblog.Json.ErrorView do
  use PhMicroblog.Web, :view

  def render("401.json", _assigns) do
    %{error: "Unauthorized"}
  end

  def render("404.json", _assigns) do
    %{error: "Page not found"}
  end

  def render("500.json", _assigns) do
    %{error: "Server internal error"}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
