defmodule PhMicroblog.UserView do
  use PhMicroblog.Web, :view

  alias PhMicroblog.User

  def gravatar_url(user, size \\ 80) do
    User.gravatar_for(user, size)
  end
end
