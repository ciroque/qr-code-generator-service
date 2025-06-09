# ---------------------
# ---- Build Stage ----
FROM elixir:1.16.2-alpine AS build

ARG APP_NAME=qr_code_gen_svc
ENV MIX_ENV=prod \
    LANG=C.UTF-8 \
    HOME=/root

# Install build tools and dependencies
RUN apk add --no-cache build-base git openssl curl && \
    mix local.hex --force && \
    mix local.rebar --force

# Create working directory
WORKDIR /app

# Copy only mix files + config first (to cache deps)
COPY mix.exs mix.lock ./
COPY config config

# Install and compile deps
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy app source
COPY lib lib

# Compile application
RUN mix compile

# Generate release
RUN mix release #qr_code_gen_svc

# ---------------------
# ---- Release Stage ----

FROM alpine:3.18.5 AS app

# Build arguments
ARG MAINTAINER="your-email@example.com"
ARG VERSION="1.0.0"

# Port configuration and validation
ARG PORT=7117
ENV PORT=${PORT}

# Validate port is within valid range
RUN if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then \
    echo "Error: PORT must be between 1 and 65535" && exit 1; \
fi

ARG SECRET_KEY_BASE
ARG APP_NAME=qr_code_gen_svc
ENV LANG=C.UTF-8 \
    MIX_ENV=prod \
    SECRET_KEY_BASE=$SECRET_KEY_BASE \
    PORT=${PORT} \
    APP_NAME=${APP_NAME}

# Expose the configured port
EXPOSE ${PORT}

# Add non-root user
RUN addgroup --system --gid 1001 app && \
    adduser --system --uid 1001 app

# Install runtime dependencies
RUN apk add --no-cache openssl ncurses-libs libstdc++ libgcc bash

# Create app directory and set ownership
RUN mkdir -p /app && \
    chown -R app:app /app

# Copy release from build
COPY --from=build /app/_build/prod/rel/qr_code_gen_svc /app/

# Switch to non-root user
USER app

WORKDIR /app

# Health check configuration
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:${PORT}/health || exit 1

# Default command with fallback
ENTRYPOINT ["./bin/qr_code_gen_svc"]
CMD ["start"]

# Add debug information
LABEL maintainer="$MAINTAINER" \
    version="$VERSION" \
    description="QR Code Generation Service" \
    build-date="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
