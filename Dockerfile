# Stage 1: compile mbtileserver
FROM golang:1.23-alpine3.20 AS build

WORKDIR /
RUN apk add git build-base
COPY . .

# Static Link required libraries 
RUN CGO_ENABLED=1 go build -ldflags='-linkmode external -extldflags "-static"' -o /mbtileserver


# Stage 2: start from non-root image
FROM gcr.io/distroless/static-debian13:nonroot

WORKDIR /

COPY --from=build /mbtileserver /mbtileserver

# Set the command as the entrypoint, so that it captures any
# command-line arguments passed in
ENTRYPOINT ["/mbtileserver"]
