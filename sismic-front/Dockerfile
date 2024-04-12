ARG NODE_VERSION=20.9

FROM node:${NODE_VERSION}-alpine as base

ARG PORT=4000

ENV NODE_ENV=production

RUN mkdir /app
ADD ./sismic-front /app
WORKDIR /app

# Build
FROM base as build

# update and install dependency
RUN apk update && apk upgrade
RUN apk add git

RUN npm install --production=false

RUN npm run build
RUN npm prune

# Run
FROM base

WORKDIR /app

ENV PORT=$PORT

COPY --from=build /app/.output /app/.output
# Optional, only needed if you rely on unbundled dependencies
# COPY --from=build /src/node_modules /src/node_modules

CMD [ "node", ".output/server/index.mjs" ]