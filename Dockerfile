# Build stage
FROM alpine:latest AS builder

RUN apk add --update alpine-sdk openssl-dev && apk add --no-cache git && git clone https://github.com/giltene/wrk2.git && cd wrk2 && make && mv wrk /bin/

# Runtime stage
FROM alpine:latest

# Copy the built binary from builder stage
COPY --from=builder /bin/wrk /usr/local/bin/wrk

# Set permissions
RUN chmod +x /usr/local/bin/wrk

# Default command
CMD ["wrk"]
