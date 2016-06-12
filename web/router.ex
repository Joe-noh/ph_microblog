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

    get "/",                     StaticPageController, :home
    get "/static_pages/help",    StaticPageController, :help
    get "/static_pages/about",   StaticPageController, :about
    get "/static_pages/contact", StaticPageController, :contact

    get "/signup", UserController, :new
    resources "/users", UserController, except: [:new] do
      get "/following", UserController, :following, as: :relationship
      get "/followers", UserController, :followers, as: :relationship
    end

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :destroy

    resources "/microposts", MicropostController, only: [:create, :delete]
    resources "/relationships", RelationshipController, only: [:create, :delete]
  end

  scope "/api", PhMicroblog.Json, as: :api do
    pipe_through :api

    post   "/login",  SessionController, :create
  end
end
