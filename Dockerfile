FROM golang:1.16 as build
WORKDIR /app
COPY . .

ARG VERSION
ARG COMMIT
ARG DATE

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-X main.commit=$COMMIT -X main.version=$VERSION -X main.date=$DATE" -o pscale-proxy github.com/planetscale/sql-proxy/cmd/sql-proxy-client

FROM alpine:latest
LABEL org.opencontainers.image.source https://github.com/almostprod/sql-proxy
RUN apk --no-cache add ca-certificates
EXPOSE 3306

WORKDIR /app
COPY --from=build /app/pscale-proxy /usr/bin
ENTRYPOINT ["/usr/bin/pscale-proxy"] 
