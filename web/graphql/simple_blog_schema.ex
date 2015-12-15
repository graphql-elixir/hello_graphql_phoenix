defmodule GraphQL.Schema.SimpleBlog do
  alias GraphQL.Schema
  alias GraphQL.ObjectType
  alias GraphQL.List
  alias GraphQL.Type.NonNull

  def schema do
    image = %ObjectType{
      name: "Image",
      description: "Images for an article or a profile picture",
      fields: %{
        url: %{type: "String"},
        width: %{type: "Int"},
        height: %{type: "Int"}
      }
    }

    author = %ObjectType{
      name: "Author",
      description: "Author of the blog, with their profile picture and latest article",
      fields: %{
        id: %{type: "String"},
        name: %{type: "String"},
        pic: %{
          args: %{
            width: %{type: "Int"},
            height: %{type: "Int"}
          },
          type: image,
          resolve: fn(o, %{width: w, height: h}, _) -> o.pic(w, h) end
        }
      }
    }

    article = %ObjectType{
      name: "Article",
      description: "A blog post",
      fields: %{
        id: %{type: %NonNull{of_type: "String"}},
        isPublished: %{type: "Boolean"},
        author: %{type: author},
        title: %{type: "String"},
        body: %{type: "String"},
        keywords: %{type: %List{of_type: "String"}}
      }
    }

    blog_query = %ObjectType{
      name: "Query",
      fields: %{
        article: %{
          type: article,
          args: %{id: %{type: "ID"}},
          resolve: fn(_, %{id: id}, _) -> make_article(id) end
        },
        feed: %{
          type: %List{of_type: article},
          resolve: fn(_, _, _) -> for id <- 1..2, do: make_article(id) end
        }
      }
    }

    %Schema{query: blog_query}
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
