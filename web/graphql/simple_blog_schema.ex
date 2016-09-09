defmodule GraphQL.Schema.SimpleBlog do
  alias GraphQL.Type.{ObjectType, List, NonNull, ID, String, Int, Boolean}
  alias GraphQL.Schema.SimpleBlog
  alias GraphQL.Schema.SimpleBlog.{Article, Author, Image}

  defmodule Image do
    def type do
      %ObjectType{
        name: "Image",
        description: "Images for an article or a profile picture",
        fields: %{
          url: %{type: %String{}, description: "URL where the image of the appropriate size can be fetched"},
          width: %{type: %Int{}, description: "Width in pixels"},
          height: %{type: %Int{}, description: "Height in pixels"}
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
          id: %{type: %String{}, description: "Author ID"},
          name: %{type: %String{}, description: "Author's name"},
          pic: %{
            args: %{
              width: %{type: %Int{}, description: "Width in pixels"},
              height: %{type: %Int{}, description: "Height in pixels"}
            },
            type: Image,
            description: "Picture of the author",
            resolve: fn(o, %{width: w, height: h}, _info) -> o.pic.(w, h) end
          },
          recentArticle: %{
            type: Article,
            description: "The most recent article published by the author",
            resolve: fn(_source, _args, _info) -> SimpleBlog.make_article(100) end
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
          isPublished: %{type: %Boolean{}, description: "Is the article published yet?"},
          author: %{type: Author, description: "Author of the article"},
          title: %{type: %String{}, description: "Title of the article"},
          body: %{type: %String{}, description: "Content of the article"},
          keywords: %{type: %List{ofType: %String{}}, description: "Keywords describing the article contents"}
        }
      }
    end
  end

  defmodule Query do
    def type do
      %ObjectType{
        name: "Query",
        description: "All the queries available to the client",
        fields: %{
          article: %{
            type: %List{ofType: Article},
            description: "An Article or blog post written by an Author",
            args: %{id: %{type: %ID{}, description: "ID of the article"}},
            resolve: fn
              _source, %{id: id}, _info -> [SimpleBlog.make_article(id)]
              _source, _args, _info     -> for id <- 1..2, do: SimpleBlog.make_article(id)
            end
          },
          feed: %{
            type: %List{ofType: Article},
            description: "A feed of the latest articles",
            resolve: fn(_source, _args, _info) -> for id <- 1..2, do: SimpleBlog.make_article(id) end
          }
        }
      }
    end
  end

  def schema do
    %GraphQL.Schema{query: Query.type}
  end

  def make_article(id) do
    %{
      id: "#{id}",
      isPublished: true,
      author: %{
        id: "123",
        name: "John Smith",
        pic: fn(width, height) -> get_pic("123", width, height) end
      },
      title: "My Article #{id}",
      body: "This is the article content...",
      hidden: "This data is not exposed in the schema",
      keywords: ["elixir", "graphql", "technology", "api", "rest"]
    }
  end

  def get_pic(uid, width, height) do
    %{
      url: "cdn://example.com/images/#{uid}",
      width: "#{width}",
      height: "#{height}"
    }
  end
end
