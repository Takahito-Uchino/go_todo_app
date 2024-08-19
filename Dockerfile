FROM golang:1.23.0-bookworm as deploy-builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -trimpath -ldflags "-w -s" -o app

FROM debian:bookworm-slim as deploy

COPY --from=deploy-builder /app/app .

CMD [ "./app" ]

FROM golang:1.23.0 as dev

WORKDIR /app

RUN go install github.com/air-verse/air@latest
CMD [ "air" ]
