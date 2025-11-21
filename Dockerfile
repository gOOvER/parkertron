# ----------------------------------
# parkertron dockerfile
# ----------------------------------

FROM golang:1.22-bookworm as builder

COPY . /parkertron

WORKDIR /parkertron

RUN apt update -y \
 && apt install -y tesseract-ocr tesseract-ocr-eng libtesseract-dev \
 && go mod tidy \
 && go build -o parkertron

FROM debian:bookworm-slim

RUN apt update -y \
    && apt install -y --no-install-recommends ca-certificates libtesseract-dev tesseract-ocr-eng \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/

COPY --from=builder /parkertron/parkertron /app/

VOLUME /app/configs
VOLUME /app/logs

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD [ -f /app/parkertron ] && echo "OK" || exit 1

CMD ["./parkertron"]