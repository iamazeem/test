FROM debian:stable-20230904-slim

RUN apt update && apt install -y jq

RUN \
    --mount=type=secret,id=secrets,dst=/etc/secrets.json \
    cat /etc/secrets.json | jq -r '.key1' > secret.txt
