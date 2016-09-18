defmodule HelloGraphQL.Mixfile do
  use Mix.Project

  def project do
    [app: :hello_graphql,
     version: "0.3.0",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {HelloGraphQL, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :plug_graphql, :graphql,
                    :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, "~> 0.12"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0.5", only: :dev},
     {:cowboy, "~> 1.0"},
     {:plug_graphql, "~> 0.3.1"}]
  end
end
