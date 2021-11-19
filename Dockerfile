FROM alpine:latest

RUN apk --no-cache add jq bash curl

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
