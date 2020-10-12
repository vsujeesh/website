# build stage
FROM node:12.18-alpine as build-stage

WORKDIR /app

COPY package*.json ./

RUN yarn

COPY . .

RUN yarn build

# production stage
FROM nginx:stable-alpine as production-stage

COPY --from=build-stage /app/public /usr/share/nginx/html
COPY --from=build-stage /app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
