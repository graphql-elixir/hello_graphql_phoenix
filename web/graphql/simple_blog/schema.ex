defmodule GraphQL.Schema.SimpleBlog do
  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType
  alias GraphQL.Type.List
  alias GraphQL.Type.NonNull
  alias GraphQL.Type.ID
  alias GraphQL.Type.String
  alias GraphQL.Type.Int
  alias GraphQL.Type.Boolean

  defmodule Image do
    def type do
       %ObjectType{
        name: "Image",
        description: "Images for an article or a profile picture",
        fields: %{
          url: %{type: %String{}},
          width: %{type: %Int{}},
          height: %{type: %Int{}}
        }
      }
    end
  end

  defmodule Author do
    def type do
      %ObjectType{
        name: "Author",
        description: "Author of the blog, with their profile picture and latest article",
        fields: %{
          id: %{type: %String{}},
          name: %{type: %String{}},
          pic: %{
            args: %{
              width: %{type: %Int{}},
              height: %{type: %Int{}}
            },
            type: Image.type,
            resolve: fn(o, %{width: w, height: h}, _) ->
              GraphQL.Schema.SimpleBlog.Data.Storage.get_pic(o.id, w, h)
            end
          }
        }
      }
    end
  end

  defmodule Article do
    def type do
      %ObjectType{
        name: "Article",
        description: "A blog post",
        fields: %{
          id: %{type: %NonNull{ofType: %String{}}},
          isPublished: %{type: %Boolean{}},
          author: %{type: Author.type},
          title: %{type: %String{}},
          body: %{type: %String{}},
          keywords: %{type: %List{ofType: %String{}}}
        }
      }
    end
  end

  defmodule Query do
    def type do
      %ObjectType{
        name: "Query",
        fields: %{
          article: %{
            type: %List{ofType: Article.type},
            args: %{id: %{type: %ID{}}},
            resolve: fn
              _, %{id: id}, _ -> [GraphQL.Schema.SimpleBlog.Data.Storage.get_article(id)]
              _, _, _         -> GraphQL.Schema.SimpleBlog.Data.Storage.get_articles
            end
          },
          feed: %{
            type: %List{ofType: Article.type},
            resolve: fn(_, _, _) -> GraphQL.Schema.SimpleBlog.Data.Storage.get_articles end
          }
        }
      }
    end
  end

  def schema do
    %Schema{query: Query.type}
  end
end
