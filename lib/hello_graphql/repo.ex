defmodule HelloGraphQL.Repo do
  use Ecto.Repo, otp_app: :hello_graphql, adapter: Sqlite.Ecto
end
