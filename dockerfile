FROM node:18.13.0 as builder
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    && npm install -g node-gyp
WORKDIR /app

#kubectl 설치
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN echo 'test'
RUN ls -al
COPY package*.json ./
COPY . .

RUN grep . /etc/*-release
# RUN apk add python3
# RUN apk add make
# RUN apk add gcc

RUN ls -al
RUN yarn --version
RUN npm --version
RUN python3 --version

# RUN npm config set python /usr/bin
# RUN pip3 --version
RUN yarn install
RUN yarn install-addons
RUN yarn package

# COPY . .

# COPY ./src/keycloak/keycloak_dev.json ./src/keycloak/keycloak.json

# RUN npm run build

# FROM nginx:stable-alpine
# RUN rm -rf /etc/nginx/conf.d/default.conf
# COPY --from=builder /app/nginx/default.conf /etc/nginx/conf.d/default.conf

# RUN rm -rf /usr/share/nginx/html/*
# COPY --from=builder /app/dist /usr/share/nginx/html

# EXPOSE 8080
ENTRYPOINT ["yarn", "start"]