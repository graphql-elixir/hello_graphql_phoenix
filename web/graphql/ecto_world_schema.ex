defmodule GraphQL.Schema.EctoWorld do
  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Type.String
  alias GraphQL.Type.ID

  def schema do
    %Schema{
      query: %ObjectType{
        name: "EctoWorld",
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
      }
    }
  end

  def greeting(_source, %{name: name}, _info) do
    user = HelloGraphQL.User.find_by_name(name)
    "Hello, #{user.name}!"
  end
  def greeting(_source, %{id: id}, _info) do
    user = HelloGraphQL.User.find_by_id(id)
    "Hello, #{user.name}!"
  end
  def greeting(_source, _args, _info), do: "Hello, world!"
end
