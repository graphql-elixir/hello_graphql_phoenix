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

    # Option 1: Wrap
    # --------------

    # forward "/hello", HelloWorldExample
    # forward "/blog", SimpleBlogExample
    # forward "/ecto_world", EctoWorldExample

    # Option 2: get/post
    # ------------------
    get  "/hello",    GraphQL.Plug, schema: {GraphQL.Schema.HelloWorld, :schema}
    post "/hello",    GraphQL.Plug, schema: {GraphQL.Schema.HelloWorld, :schema}

    get  "/blog",     GraphQL.Plug, schema: {GraphQL.Schema.SimpleBlog, :schema}
    post "/blog",     GraphQL.Plug, schema: {GraphQL.Schema.SimpleBlog, :schema}

    get  "/ecto",     GraphQL.Plug, schema: {GraphQL.Schema.EctoWorld, :schema}
    post "/ecto",     GraphQL.Plug, schema: {GraphQL.Schema.EctoWorld, :schema}

    get  "/starwars", GraphQL.Plug, schema: {GraphQL.Schema.StarWars, :schema}
    post "/starwars", GraphQL.Plug, schema: {GraphQL.Schema.StarWars, :schema}

    # Option 3: match
    # ---------------
    # match  "/hello", GraphQL.Plug.Endpoint, schema: {GraphQL.Schema.HelloWorld, :schema}
    # match  "/blog",  GraphQL.Plug.Endpoint, schema: {GraphQL.Schema.SimpleBlog, :schema}
  end
end
