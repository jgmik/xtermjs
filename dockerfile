FROM node:18.13.0-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install
RUN npm i sass-loader
RUN npm i node-sass
COPY . .

COPY ./src/keycloak/keycloak_dev.json ./src/keycloak/keycloak.json

RUN npm run build

FROM nginx:stable-alpine
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/nginx/default.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8080
ENTRYPOINT ["nginx", "-g", "daemon off;"]