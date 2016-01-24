defmodule HelloGraphQL.Repo do
  use Ecto.Repo, otp_app: :hello_graphql, adapter: Ecto.Adapters.Postgres
end
