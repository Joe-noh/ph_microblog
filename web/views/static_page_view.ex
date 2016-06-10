defmodule PhMicroblog.StaticPageView do
  use PhMicroblog.Web, :view

  def logged_in?(conn) do
    !is_nil(conn.assigns[:current_user])
  end
end
