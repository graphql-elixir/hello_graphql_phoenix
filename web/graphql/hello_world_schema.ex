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

  def greeting(_, %{name: name}, _), do: "Hello, #{name}!"
  def greeting(_, _, _), do: "Hello, world!"
end
