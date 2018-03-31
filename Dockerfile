FROM       golang:alpine as builder

RUN apk --no-cache --update add git curl make libc-dev gcc libgcc
RUN curl -s https://glide.sh/get | sh
RUN mkdir -p  /go/src/github.com/percona/mongodb_exporter \
    && cd /go/src/github.com/percona/mongodb_exporter \
    &&  git clone https://github.com/percona/mongodb_exporter.git .
RUN cd /go/src/github.com/percona/mongodb_exporter && make build

FROM       alpine:3.7
EXPOSE     9216
RUN apk add --update ca-certificates
COPY --from=builder /go/src/github.com/percona/mongodb_exporter/mongodb_exporter /usr/local/bin/mongodb_exporter

ENTRYPOINT [ "mongodb_exporter", "-collect.database" ]
