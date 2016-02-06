FROM aweiker/alpine-elixir:1.2.1
ENV PORT=4000 MIX_ENV=prod

ENV APP_NAME=hello_graphql APP_VERSION="0.0.1"

WORKDIR /$APP_NAME
ADD rel/$APP_NAME .
EXPOSE $PORT
CMD trap exit TERM; /$APP_NAME/bin/$APP_NAME foreground & wait
