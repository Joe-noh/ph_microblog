defmodule PhMicroblog.UserView do
  use PhMicroblog.Web, :view

  alias PhMicroblog.User

  def gravatar_url(user) do
    User.gravatar_for(user)
  end
end
