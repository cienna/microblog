defmodule MicroblogWeb.Router do
  use MicroblogWeb, :router
  import Microblog.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_user
  end

  scope "/", MicroblogWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/feed", PageController, :feed
    resources "/posts", PostController, except: [:index]
    resources "/users", UserController, except: [:new]
    resources "/follows", FollowController, except: [:new, :show, :edit]
    # following two lines from NuMart Code.
    post "/sessions", SessionController, :login
    delete "/sessions", SessionController, :logout
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", MicroblogWeb do
    pipe_through :api

    resources "/likes", LikeController, except: [:new, :edit]
  end
end
