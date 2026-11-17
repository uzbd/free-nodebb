
FROM ghcr.io/nodebb/nodebb:latest

ENV UV_THREADPOOL_SIZE=1
ENV NODE_OPTIONS="--v8-pool-size=1"
