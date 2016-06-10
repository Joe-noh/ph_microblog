defmodule PhMicroblog.StaticPageView do
  use PhMicroblog.Web, :view

  def logged_in?(conn) do
    !is_nil(conn.assigns[:current_user])
  end

  def gravatar_url(user, size \\ 80) do
    PhMicroblog.User.gravatar_for(user, size)
  end
end
