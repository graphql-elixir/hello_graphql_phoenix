defmodule HelloGraphQL.Router do
  use HelloGraphQL.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloGraphQL do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/graphql" do
    pipe_through :api

    forward "/hello", GraphQL.Plug.Endpoint, schema: {GraphQL.Schema.HelloWorld, :schema}
  end
end
