#! /bin/sh

export MIX_ENV=prod

mix do compile
brunch build --production
mix do phoenix.digest, release
