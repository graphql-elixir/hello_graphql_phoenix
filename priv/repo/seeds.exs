# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HelloGraphQL.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
HelloGraphQL.Repo.delete_all(HelloGraphQL.User)

Enum.map 1..10, fn (x) ->
  params = %{name: "Garrett - #{x}"}

  HelloGraphQL.User.changeset(%HelloGraphQL.User{}, params)
  |> HelloGraphQL.Repo.insert!
end
