defmodule PhMicroblog.Router do
  use Phoenix.Router

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/static_pages/home",    PhMicroblog.StaticPageController, :home,    as: :static_page
    get "/static_pages/help",    PhMicroblog.StaticPageController, :help,    as: :static_page
    get "/static_pages/about",   PhMicroblog.StaticPageController, :about,   as: :static_page
    get "/static_pages/contact", PhMicroblog.StaticPageController, :contact, as: :static_page

    resources "/users", PhMicroblog.UserController

    resources "/sessions", PhMicroblog.SessionController, only: [:new, :create]
    delete "/sessions", PhMicroblog.SessionController, :destroy, as: :signout
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
