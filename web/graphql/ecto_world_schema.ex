defmodule GraphQL.Schema.EctoWorld do
  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Type.String
  alias GraphQL.Type.ID
  alias HelloGraphQL.User

  def schema do
    %Schema{
      query: %ObjectType{
        name: "Queries",
        fields: %{
          greeting: %{
            type: %String{},
            args: %{
              id: %{type: %ID{}},
              name: %{type: %String{}},
            },
            resolve: {Schema.EctoWorld, :greeting}
          }
        }
      },
      mutation: %ObjectType{
        name: "Mutations",
        fields: %{
          addUser: %{
            type: %ObjectType{
              name: "User",
              fields: %{
                id: %{type: %String{}},
                name: %{type: %String{}}
              }
            },
            args: %{
              name: %{type: %String{}},
            },
            resolve: {Schema.EctoWorld, :add_user}
          }
        }
      }
    }
  end

  def greeting(_, %{name: name}, _) do
    user = User.find_by_name(name)
    "Hello, #{user.name}!"
  end
  def greeting(_, %{id: id}, _) do
    user = User.find_by_id(id)
    "Hello, #{user.name}!"
  end
  def greeting(_, _, _), do: "Hello, world!"

  def add_user(_, %{name: name}, _) do
    result = HelloGraphQL.Repo.insert %User{name: name}
    IO.inspect result
    case result do
      {:ok, user} -> user
      {:error, user} -> :error
    end
  end

end
