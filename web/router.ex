defmodule PhMicroblog.Router do
  use Phoenix.Router

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/static_pages/home",  PhMicroblog.StaticPageController, :home,  as: :home
    get "/static_pages/help",  PhMicroblog.StaticPageController, :help,  as: :help
    get "/static_pages/about", PhMicroblog.StaticPageController, :about, as: :about
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
