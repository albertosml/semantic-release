FROM golang:1.22 as builder
ARG CGO_ENABLED=0
WORKDIR /app

COPY go.mod go.sum main.go ./
RUN go mod download

RUN go build -o server

FROM scratch
COPY --from=builder /app/server /server
ENTRYPOINT ["/server"]
