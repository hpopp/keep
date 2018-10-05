FROM elixir:1.7-alpine

ENV HOME /opt/keep
WORKDIR $HOME

ENV MIX_ENV prod

ENV PORT ${PORT:-4040}
EXPOSE $PORT

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get --only prod
RUN mix deps.compile

COPY . .

RUN mix compile

CMD mix do phx.server
