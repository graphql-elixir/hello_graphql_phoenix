use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hello_graphql, HelloGraphQL.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :hello_graphql, HelloGraphQL.Repo,
  adapter: Sqlite.Ecto,
  database: "hello_graphql_tests.sqlite3"
