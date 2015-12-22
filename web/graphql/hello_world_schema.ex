defmodule GraphQL.Schema.HelloWorld do
  alias GraphQL.Schema
  alias GraphQL.ObjectType

  def schema do
    %Schema{
      query: %ObjectType{
        name: "HelloWorld",
        fields: %{
          greeting: %{
            type: "String",
            args: %{name: %{type: "String"}},
            resolve: {Schema.HelloWorld, :greeting}
          }
        }
      }
    }
  end

  def greeting(_, %{name: user_id}, _) do
    user = HelloGraphQL.User.find(user_id)
    "Hello, #{user.name}!"
  end
  def greeting(_, _, _), do: "Hello, world!"
end
