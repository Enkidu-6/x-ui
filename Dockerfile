FROM golang:1.23-alpine AS builder
WORKDIR /app
ARG TARGETARCH 
RUN apk --no-cache --update add build-base gcc wget unzip
COPY . .
ENV CGO_ENABLED=1
ENV CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
RUN go build -o build/x-ui main.go
RUN ./DockerInitFiles.sh "$TARGETARCH"

FROM alpine
LABEL org.opencontainers.image.authors="Enkidu-6"
ENV TZ=etc/UTC
WORKDIR /app

RUN apk add ca-certificates tzdata

COPY --from=builder  /app/build/ /app/
VOLUME [ "/etc/x-ui" ]
CMD [ "./x-ui" ]
