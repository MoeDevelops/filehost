FROM ghcr.io/gleam-lang/gleam:v1.10.0-erlang-alpine AS builder

WORKDIR /build

COPY *.toml .
RUN gleam deps download

COPY . .
RUN gleam export erlang-shipment

FROM erlang:alpine

WORKDIR /app
COPY --from=builder /build/build/erlang-shipment .

EXPOSE 5001
STOPSIGNAL SIGKILL
ENTRYPOINT [ "./entrypoint.sh", "run" ]
