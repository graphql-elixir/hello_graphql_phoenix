defmodule GraphQL.Schema.HelloWorld do
  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Type.String

  def schema do
    %Schema{
      query: %ObjectType{
        name: "HelloWorld",
        fields: %{
          greeting: %{
            type: %String{},
            args: %{name: %{type: %String{}}},
            resolve: {Schema.HelloWorld, :greeting}
          }
        }
      }
    }
  end

  def greeting(_source, %{name: name}, _info), do: "Hello, #{name}!"
  def greeting(_source, _args, _info), do: "Hello, world!"
end
