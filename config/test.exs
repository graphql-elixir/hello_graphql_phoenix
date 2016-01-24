use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hello_graphql, HelloGraphQL.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :hello_graphql, HelloGraphQL.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "hello_graphql_test",
  hostname: "localhost",
  pool_size: 10
