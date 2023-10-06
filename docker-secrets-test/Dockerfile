# syntax=docker/dockerfile:1

FROM debian:stable-20230904-slim

RUN apt update && apt install -y jq
RUN \
    --mount=type=secret,id=secrets \
    cat /run/secrets/secrets | jq -r '.key1' > secret.txt
