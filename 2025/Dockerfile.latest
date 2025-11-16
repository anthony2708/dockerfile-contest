# --------------- STEP 1: Build the image-------------------

# Intro: Chainguard is a distroless Docker image registry. All Chainguard images are being used 
# to securely remove all unneccessary tools and reduce surface for malicious factors
# Tradeoffs: Stricter configs, needs to setup NPM/PNPM manually

# https://images.chainguard.dev/directory/image/node/versions
FROM cgr.dev/chainguard/node:latest AS builder 

# Secure by default: Do not use root, use Node user and identify the working dirs
USER node
WORKDIR /app

# Install PNPM by:
# a. Force the npm-global inside user's home folder, not root
# b. Add a new ENV to PATH
# c. Run the command (also cleanup the cache)
RUN npm config set prefix '~/.npm-global'
ENV PATH="/home/node/.npm-global/bin:$PATH"
RUN npm install -g pnpm && npm cache clean --force

# Only copy the needed file to /app:
COPY --chown=node:node package.json pnpm-lock.yaml .npmrc index.html tsconfig.json tsconfig.node.json vite.config.ts postcss.config.js tailwind.config.ts ./

# Install dependencies
RUN pnpm install --frozen-lockfile --prefer-offline

# Selective copies to /app/src and /app/public:
COPY --chown=node:node src ./src
COPY --chown=node:node public ./public

# ENV: Production
ENV CI=true NODE_ENV=production

# Build command and clean up artefacts
RUN pnpm run build && find dist -type f \( -name "*.map" -o -name ".*" \) -delete


# --------- STEP 2: Minimal filesystem -------------

# https://images.chainguard.dev/directory/image/wolfi-base/versions
FROM cgr.dev/chainguard/wolfi-base:latest AS compressor

# Add some tools to zip the files, choose the working directory and non-root user
RUN apk add --no-cache gzip brotli findutils 
WORKDIR /app
USER 65534

# Copy
COPY --from=builder --chown=65534:65534 /app/dist ./dist

# Parallel compression: gzip + brotli
RUN find dist -type f \
    \( -name "*.html" -o -name "*.css" -o -name "*.js" -o \
       -name "*.json" -o -name "*.svg" -o -name "*.xml" \) \
    -print0 | xargs -0 -P"$(nproc)" -I {} sh -c 'gzip -9 -k -f "{}" && brotli -q 11 -f "{}"'

# --------- STEP 3: Run the app -------------
FROM cgr.dev/chainguard/nginx:latest

# Copy Nginx config
COPY --chown=nginx:nginx nginx.conf /etc/nginx/conf.d/default.conf

# Copy compressed files
COPY --from=compressor --chown=nginx:nginx /app/dist /usr/share/nginx/html

# Labels
LABEL org.opencontainers.image.title="Nginx Chainguard Minimal" 
LABEL org.opencontainers.image.description="Nginx sourced from Chainguard with Pre-compressed Assets"
LABEL org.opencontainers.image.base.name="cgr.dev/chainguard/nginx"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.authors="Bui Le Tuan Anh"

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD ["/usr/sbin/nginx", "-t", "-q"]

# Expose and run
EXPOSE 3000
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]