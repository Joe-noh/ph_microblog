defmodule PhMicroblog.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", PhMicroblog do
    pipe_through :browser # Use the default browser stack

    get "/static_page/home",    StaticPageController, :home
    get "/static_page/help",    StaticPageController, :help
    get "/static_page/about",   StaticPageController, :about
    get "/static_page/contact", StaticPageController, :contact
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhMicroblog do
  #   pipe_through :api
  # end
end
