# Copyright Contributors to the Open Cluster Management project

FROM registry.ci.openshift.org/stolostron/builder:go1.23-linux AS builder

WORKDIR /go/src/github.com/stolostron/search-v2-api
COPY . .
RUN CGO_ENABLED=1 GOGC=25 go build -trimpath -o main main.go

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

COPY --from=builder /go/src/github.com/stolostron/search-v2-api/main /bin/main

ENV USER_UID=1001 \
    USER_NAME=search-api

EXPOSE 4010
USER ${USER_UID}
ENTRYPOINT ["/bin/main"]
