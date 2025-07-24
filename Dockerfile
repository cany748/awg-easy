FROM docker.io/library/node:lts-slim AS build
WORKDIR /app

# update corepack
RUN npm install --global corepack@latest
# Install pnpm
RUN corepack enable pnpm

# Copy Web UI
COPY src/package.json src/pnpm-lock.yaml ./
RUN pnpm install

# Build UI
COPY src ./
RUN pnpm build

# Copy build result to a new image.
# This saves a lot of disk space.
FROM docker.io/library/node:lts-slim
WORKDIR /app

HEALTHCHECK --interval=1m --timeout=5s --retries=3 CMD /usr/bin/timeout 5s /bin/sh -c "/usr/bin/wg show | /bin/grep -q interface || exit 1"

# Copy build
COPY --from=build /app/.output /app
# Copy migrations
COPY --from=build /app/server/database/migrations /app/server/database/migrations
# libsql (https://github.com/nitrojs/nitro/issues/3328)
RUN cd /app/server && \
    npm install --no-save libsql && \
    npm cache clean --force
# cli
COPY --from=build /app/cli/cli.sh /usr/local/bin/cli
RUN chmod +x /usr/local/bin/cli

RUN mkdir -p /etc/wireguard
RUN mkdir -p /etc/amnezia
RUN ln -s /etc/wireguard /etc/amnezia/amneziawg

# Install Linux packages
RUN apt update && apt install -y dumb-init ca-certificates iproute2 iptables
RUN echo "deb [allow-insecure=yes] https://ppa.launchpadcontent.net/amnezia/ppa/ubuntu focal main" | tee -a /etc/apt/sources.list
RUN echo "deb-src [allow-insecure=yes] https://ppa.launchpadcontent.net/amnezia/ppa/ubuntu focal main" | tee -a /etc/apt/sources.list
RUN apt update --allow-unauthenticated && apt install -y --allow-unauthenticated --no-install-recommends amneziawg-tools

# Set Environment
ENV DEBUG=Server,WireGuard,Database,CMD
ENV PORT=51821
ENV HOST=0.0.0.0
ENV INSECURE=false
ENV INIT_ENABLED=false
ENV DISABLE_IPV6=false

LABEL org.opencontainers.image.source=https://github.com/cany748/awg-easy

# Run Web UI
CMD ["/usr/bin/dumb-init", "node", "server/index.mjs"]
