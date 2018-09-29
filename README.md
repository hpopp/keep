# Keep
> Persistent key-value store. A work in progress.

## What's This?
A Phoenix JSON API wrapper on top of an Erlang dets table. Perfect for stateful microservices when Postgres is overkill.

## Usage
Not really packaged for production, but `mix phx.server` to run locally.

```bash
$ curl -X PUT -H "Content-Type: text/plain" --data "some data" localhost:4000/data/some_key
(empty, 201)

$ curl localhost:4000/data/some_key
"some data"

$ curl -X DELETE localhost:4000/data/some_key
(empty, 204)

$ curl localhost:4000/data/some_key
(empty, 404)
```
