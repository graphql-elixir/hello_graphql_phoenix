# Hello GraphQL Phoenix

[![Build Status](https://travis-ci.org/joshprice/hello_graphql_phoenix.svg)](https://travis-ci.org/joshprice/hello_graphql_phoenix)
[![Public Slack Discussion](https://graphql-slack.herokuapp.com/badge.svg)](https://graphql-slack.herokuapp.com/)

This is a Phoenix app containing examples of how to use [plug_graphql](https://github.com/joshprice/plug_graphql) which in turn uses the [GraphQL Elixir Core](https://github.com/joshprice/graphql-elixir)

## Installation

Clone this repo and start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Setup your DB for the Ecto example with `mix ecto.migrate` and `mix run priv/repo/seeds.exs`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Examples

Using [plug_graphql](https://github.com/joshprice/plug_graphql) with Phoenix is very simple.

Simply mount your GraphQL endpoint like so:

1. Define your schema in `web/graphql` (see https://github.com/joshprice/hello_graphql_phoenix/tree/master/web/graphql)
2. [Mount your endpoint](https://github.com/joshprice/hello_graphql_phoenix/blob/master/web/router.ex#L22-L26)

-

## Resources

* GraphQL Plug https://github.com/joshprice/plug_graphql
* GraphQL Elixir Core https://github.com/joshprice/graphql-elixir
* GraphQL Spec http://facebook.github.io/graphql
