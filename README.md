# Keep
> Persistent key-value store. A work in progress.

## What's This?
A Plug API wrapper on top of an Erlang dets table. Perfect for stateful microservices when Postgres is overkill.

## Getting Started
Easiest to run with Docker:

```bash
$ docker run -p 4040:4040 hpopp/keep:0.2.0
```

## Usage
```bash
$ curl -X PUT -H "Content-Type: text/plain" --data "some data" localhost:4040/data/some_key
(empty, 201)

$ curl localhost:4040/data/some_key
some data

$ curl -X DELETE localhost:4040/data/some_key
(empty, 204)

$ curl localhost:4040/data/some_key
(empty, 404)
```
