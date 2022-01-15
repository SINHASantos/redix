FROM golang:1.17.3-alpine As builder

WORKDIR /redix/

RUN apk update && apk add musl-dev git gcc upx

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o /usr/bin/redix

RUN upx -9 /usr/bin/redix

FROM alpine

WORKDIR /redix/

COPY --from=builder /usr/bin/redix /usr/bin/redix

CMD ["/usr/bin/redix"]