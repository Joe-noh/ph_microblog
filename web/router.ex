defmodule PhMicroblog.Router do
  use PhMicroblog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug PhMicroblog.Plug.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhMicroblog do
    pipe_through :browser # Use the default browser stack

    get "/",                    StaticPageController, :home
    get "static_pages/help",    StaticPageController, :help
    get "static_pages/about",   StaticPageController, :about
    get "static_pages/contact", StaticPageController, :contact

    get "signup", UserController, :new
    resources "/users", UserController, except: [:new]

    get    "login",  SessionController, :new
    post   "login",  SessionController, :create
    delete "logout", SessionController, :destroy
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhMicroblog do
  #   pipe_through :api
  # end
end
