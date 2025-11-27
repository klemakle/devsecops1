FROM node:22-alpine
WORKDIR /app
COPY src/package*.json ./

RUN npm ci --only=production && npm cache clean --force
COPY src/ ./

EXPOSE 3000
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app


HEALTHCHECK --interval=30s --timeout=3s \
    CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

USER nodejs
CMD ["node", "server.js"]
