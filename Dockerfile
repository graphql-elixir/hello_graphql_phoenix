FROM bitwalker/alpine-elixir-phoenix:2.0

# Set exposed ports
EXPOSE 5000
ENV PORT=5000 MIX_ENV=prod

# Set your project's working directory
WORKDIR /app

# Cache npm deps
ADD package.json package.json
RUN npm install

# Same with elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

# Run frontend build, compile, and digest assets
RUN brunch build --production && \
    mix do compile, phoenix.digest

CMD ["mix", "phoenix.server"]