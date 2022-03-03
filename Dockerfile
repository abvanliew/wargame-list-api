### Builder image to compile code ###
FROM golang:1.17-alpine as compiler

# create execution user id
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    runapp

# copy source code
WORKDIR /go/src
COPY go.mod go.sum *.go .

# install dependancies
RUN go mod download

# set build values
ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

# compile binary
RUN go build -ldflags "-s -w" -o /go/bin/wargame-list-api


### final build image ###
FROM scratch

# copy user data and binaries
COPY --from=compiler /etc/passwd /etc/passwd
COPY --from=compiler /etc/group /etc/group
COPY --from=compiler --chown=runapp:runapp /go/bin/wargame-list-api /bin/wargame-list-api

# switch to non-root user, set runtime environment variables and start app
USER runapp
ENV GIN_MODE=release
ENTRYPOINT [ "wargame-list-api" ]