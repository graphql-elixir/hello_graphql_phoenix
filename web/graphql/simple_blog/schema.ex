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
            resolve: fn(o, %{width: w, height: h}, _) -> o.pic.(w, h) end
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
              _, %{id: id}, _ -> [GraphQL.Schema.SimpleBlog.make_article(id)]
              _, _, _         -> for id <- 1..2, do: GraphQL.Schema.SimpleBlog.make_article(id)
            end
          },
          feed: %{
            type: %List{ofType: Article.type},
            resolve: fn(_, _, _) -> for id <- 1..2, do: GraphQL.Schema.SimpleBlog.make_article(id) end
          }
        }
      }
    end
  end

  def schema do
    %Schema{query: Query.type}
  end

  def make_article(id) do
    %{
      id: "#{id}",
      isPublished: true,
      author: %{
        id: "123",
        name: "John Smith",
        pic: fn(width, height) -> get_pic("123", width, height) end
        # recentArticle: 1
      },
      title: "My Article #{id}",
      body: "This is a post",
      hidden: "This data is not exposed in the schema",
      keywords: ["foo", "bar", 1, true, nil]
    }
  end

  def get_pic(uid, width, height) do
    %{
      url: "cdn://#{uid}",
      width: "#{width}",
      height: "#{height}"
    }
  end
end
