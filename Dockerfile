###########
# Builder #
###########
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

# Install build dependencies
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .

# Build
RUN npm run build

###############
# Production  #
###############
FROM node:20-alpine AS production

ENV NODE_ENV=production \
    PORT=3008 \
    NATS_SERVERS=nats://nats:4222 \
    NATS_QUEUE=files_queue

WORKDIR /usr/src/app

# Install only production deps
COPY package*.json ./
RUN npm ci --omit=dev

# Copy built dist and any runtime assets needed
COPY --from=builder /usr/src/app/dist ./dist

# Expose HTTP port
EXPOSE 3008

# Run
CMD ["npm", "run", "start:prod"]