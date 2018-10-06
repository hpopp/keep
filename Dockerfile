FROM elixir:1.7-alpine as builder

WORKDIR /keep

ENV MIX_ENV prod
ENV PORT 4040

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get
RUN mix deps.compile

COPY . .

RUN mix release --env=prod --verbose

FROM alpine:3.6

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl
    # Phoenix needs these

EXPOSE 4040

WORKDIR /keep
COPY --from=builder /keep/_build/prod/rel/keep/releases/0.1.1/keep.tar.gz .

RUN tar zxf keep.tar.gz && rm keep.tar.gz

RUN chown -R root ./releases

USER root

CMD ["/keep/bin/keep", "foreground"]
