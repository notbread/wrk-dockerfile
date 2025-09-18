# Build stage
FROM alpine:latest AS builder

RUN apk add --update build-base \
  openssl-dev \
  libgcrypt-static \
  openssl-libs-static \
  libstdc++ \
  libffi-dev \
  g++ \
  zlib-dev \
  musl-dev \
  git
RUN git clone https://github.com/giltene/wrk2.git \
  && cd wrk2 \
  && CFLAGS="-O2 -static" LDFLAGS="-static"  make
#RUN CFLAGS="-O2 -static" LDFLAGS="-static" make
RUN mv /wrk2/wrk /bin/

# Runtime stage
FROM alpine:latest

# Copy the built binary from builder stage
COPY --from=builder /bin/wrk /usr/local/bin/wrk

# Set permissions
RUN chmod +x /usr/local/bin/wrk

# Default command
CMD ["wrk"]
