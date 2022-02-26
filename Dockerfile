FROM registry.saschaschwarze.de/build-system/node-nonroot:16 AS modules

ENV NODE_ENV production

WORKDIR /app

COPY package.json package-lock.json /app/

RUN npm install --production || true
WORKDIR /home/nonroot/.npm/_logs
#RUN ls | xargs cat
RUN for FILE in *; do cat "$FILE"; done
RUN false
#RUN npm ci && npm prune --production

FROM registry.saschaschwarze.de/build-system/node-nonroot:16

WORKDIR /app

COPY main.js package.json server.js ./
COPY lib ./lib
COPY --from=modules /app/node_modules /app/node_modules

ENV DEBUG localtunnel*

ENTRYPOINT ["node", "main.js"]
