#! /bin/sh

mix local.hex --force && mix local.rebar --force
npm install -g coffee-script
npm install -g brunch
mix do deps.get, deps.compile
npm install
