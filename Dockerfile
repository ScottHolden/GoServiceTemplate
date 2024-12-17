ARG OUTPUT_BIN_PATH="/go/bin/[[PROJECT_NAME]]"

FROM golang:alpine AS builder
ARG OUTPUT_BIN_PATH
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/
COPY . .
RUN go get -v
RUN go build -o ${OUTPUT_BIN_PATH}

FROM scratch
COPY --from=builder ${OUTPUT_BIN_PATH} ${OUTPUT_BIN_PATH}
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT [ "/go/bin/[[PROJECT_NAME]]" ]