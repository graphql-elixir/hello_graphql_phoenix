defmodule GraphQL.Schema.HelloWorld do
  def schema do
    %GraphQL.Schema{
      query: %GraphQL.ObjectType{
        name: "RootQueryType",
        fields: %{
          greeting: %GraphQL.FieldDefinition{
            type: "String",
            args: %{ name: %{ type: "String" } },
            resolve: {GraphQL.Schema.HelloWorld, :greeting}
          }
        }
      }
    }
  end

  def greeting(_, %{name: name}, _), do: "Hello, #{name}!"
  def greeting(_, _, _), do: "Hello, world!"
end
