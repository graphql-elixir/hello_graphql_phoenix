defmodule GraphQL.Schema.StarWars do

  alias GraphQL.Type.{ObjectType, List, Interface, String, NonNull}
  alias GraphQL.Schema.StarWars.{Episode, Character, Droid, Human}

  defmodule Episode do
    def type do
      GraphQL.Type.Enum.new %{
        name: "Episode",
        description: "One of the films in the Star Wars Trilogy",
        values: %{
          NEWHOPE: %{value: 4, description: "Released in 1977"},
          EMPIRE: %{value: 5, description: "Released in 1980"},
          JEDI: %{value: 6, description: "Released in 1983"}
        }
      }
    end
  end

  defmodule Character do
    def type do
      Interface.new %{
        name: "Character",
        description: "A character in the Star Wars Trilogy",
        fields: %{
          id: %{type: %NonNull{ofType: %String{}}},
          name: %{type: %String{}},
          friends: %{type: %List{ofType: Character}},
          appears_in: %{type: %List{ofType: Episode}}
        },
        resolver: fn(x) ->
          if StarWars.Data.get_human(x.id), do: Human, else: Droid
        end
      }
    end
  end

  defmodule Human do
    def type do
      %ObjectType{
        name: "Human",
        description: "A humanoid creature in the Star Wars universe",
        fields: %{
          id: %{type: %NonNull{ofType: %String{}}},
          name: %{type: %String{}},
          friends: %{
            type: %List{ofType: Character},
            resolve: fn(item, _args, _info) -> StarWars.Data.get_friends(item) end
          },
          appears_in: %{type: %List{ofType: Episode}},
          home_planet: %{type: %String{}}
        },
        interfaces: [Character]
      }
    end
  end

  defmodule Droid do
    def type do
      %ObjectType{
        name: "Droid",
        description: "A mechanical creature in the Star Wars universe",
        fields: %{
          id: %{type: %NonNull{ofType: %String{}}},
          name: %{type: %String{}},
          friends: %{
            type: %List{ofType: Character},
            resolve: fn(item, _args, _info) -> StarWars.Data.get_friends(item) end
          },
          appears_in: %{type: %List{ofType: Episode}},
          primary_function: %{type: %String{}}
        },
        interfaces: [Character]
      }
    end
  end

  def query do
    %ObjectType{
      name: "Query",
      fields: %{
        hero: %{
          type: Character,
          args: %{
            # TODO this should be a type InputObject
            episode: %{
              type: Episode,
              description: "If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode"
            }
          },
          resolve: fn(_source, args, _info) ->
            StarWars.Data.get_hero(Map.get(args, :episode))
          end
        },
        human: %{
          type: Human,
          args: %{
            id: %{type: %NonNull{ofType: %String{}}, description: "id of the human"}
          },
          resolve: fn(_source, args, _info) -> StarWars.Data.get_human(args.id) end
        },
        droid: %{
          type: Droid,
          args: %{
            id: %{type: %NonNull{ofType: %String{}}, description: "id of the droid"}
          },
          resolve: fn(_source, args, _info) -> StarWars.Data.get_droid(args.id) end
        }
      }
    }
  end

  def schema do
    %GraphQL.Schema{query: query}
  end
end

defmodule StarWars.Data do
  def get_character(id) do
    get_human(id) || get_droid(id)
  end

  def get_human(nil), do: nil
  def get_human(id) do
    Map.get(human_data, String.to_atom(id), nil)
  end

  def get_droid(nil), do: nil
  def get_droid(id) do
    Map.get(droid_data, String.to_atom(id), nil)
  end

  def get_friends(character) do
    Map.get(character, :friends)
    |> Enum.map(&(get_character(&1)))
  end

  def get_hero(5), do: luke
  def get_hero(_), do: artoo
  def get_hero, do: artoo

  def luke do
    %{id: "1000",
      name: "Luke Skywalker",
      friends: ["1002", "1003", "2000", "2001"],
      appears_in: [4,5,6],
      home_planet: "Tatooine"}
  end

  def vader do
    %{id: "1001",
      name: "Darth Vader",
      friends: ["1004"],
      appears_in: [4,5,6],
      home_planet: "Tatooine"}
  end

  def han do
    %{id: "1002",
      name: "Han Solo",
      friends: ["1000", "1003", "2001"],
      appears_in: [4,5,6]}
  end

  def leia do
    %{id: "1003",
      name: "Leia Organa",
      friends: ["1000", "1002", "2000", "2001"],
      appears_in: [4,5,6],
      home_planet: "Alderaan"}
  end

  def tarkin do
    %{id: "1004",
      name: "Wilhuff Tarkin",
      friends: ["1001"],
      appears_in: [4]}
  end

  def human_data do
    %{"1000": luke, "1001": vader, "1002": han,
      "1003": leia, "1004": tarkin}
  end

  def threepio do
    %{id: "2000",
      name: "C-3PO",
      friends: ["1000", "1002", "1003", "2001"],
      appears_in: [4,5,6],
      primary_function: "Protocol"}
  end

  def artoo do
    %{id: "2001",
      name: "R2-D2",
      friends: ["1000", "1002", "1003"],
      appears_in: [4,5,6],
      primary_function: "Astromech"}
  end

  def droid_data do
    %{"2000": threepio, "2001": artoo}
  end
end
