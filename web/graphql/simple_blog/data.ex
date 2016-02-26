
defmodule GraphQL.Schema.SimpleBlog.Data.Storage do
  @default %{
    isPublished: true,
    author: %{
      id: "123",
      name: "John Smith",
      # recentArticle: 1
    },
    body: "This is a post",
    hidden: "This data is not exposed in the schema",
    keywords: ["foo", "bar", 1, true, nil]
  }

  @initial_state %{
    "12345" => %{
      id: "12345",
      title: "My Article 12345",
      isPublished: true,
      author: %{
        id: "123",
        name: "John Smith",
        # recentArticle: 1
      },
      body: "This is a post",
      hidden: "This data is not exposed in the schema",
      keywords: ["foo", "bar", 1, true, nil]
    }
  }

  def make_article(id) do
    Map.merge(@default, %{id: "#{id}", title: "My Article #{id}"})
  end

  def get_pic(uid, width, height) do
    %{
      url: "cdn://#{uid}",
      width: "#{width}",
      height: "#{height}"
    }
  end

  def start_link do
    Agent.start_link(fn -> @initial_state end, name: __MODULE__)
  end

  def get_articles do
    Agent.get(__MODULE__, &do_get_articles(&1))
  end

  def get_article(id) do
    {:ok, article} = Agent.get_and_update(__MODULE__, &do_get_article(&1, id))
    article
  end

  def set_article(id, article) do
    Agent.get_and_update(__MODULE__, &do_set_article(&1, id, article))
  end

  defp do_get_articles(map) do
    Map.values(map)
  end

  defp do_get_article(map, id) do
    new_map = Map.put_new(map, id, default_article(id))
    article = Map.fetch(new_map, id)
    { article, new_map }
  end

  defp do_set_article(map, id, article) do
    {_, new_map} = Map.get_and_update(map, id, fn(x) ->
      {x, merge_map(x, Map.merge(%{id: id}, article))}
    end)

    result = Map.fetch(new_map, id)
    {result, new_map}
  end

  defp merge_map(nil, updates) do
    merge_map(%{preferences: @default_preferences}, updates)
  end
  defp merge_map(article, updates) do
    merge(article, updates)
  end

  defp merge(old, new) do
    Map.merge(old, new, fn (key, old_val, new_val) ->
      merge(new, key, old_val, new_val)
    end)
  end

  defp merge(_updates, _key, nil, val), do: val
  defp merge(updates, key, val, nil) do
    case Map.has_key?(updates, key) do
      true -> nil
      false -> val
    end
  end
  defp merge(_updates, _key, old, new) when is_map(new) do
    merge(old, new)
  end
  defp merge(_updates, _key, _old, new) do
    new
  end

  defp default_article(id) do
    Map.merge(@default, %{id: "#{id}", title: "My Article #{id}"})
  end
end
