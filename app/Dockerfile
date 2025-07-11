FROM node:23-alpine AS builder

WORKDIR /app

COPY package*.json ./

# installs the dependencies
RUN npm install

COPY . .

# makes the application production-ready and stores fils in the /dist directory
RUN npm run build


# Stage 2. Verified provider docker image that is more secure than the original as it runs as non-root
FROM nginxinc/nginx-unprivileged:1.27-alpine-slim

# allows to run the image as a non-root user
RUN sed -i '/^pid/d' /etc/nginx/nginx.conf
RUN echo "pid /tmp/nginx.pid;" >> /etc/nginx/nginx.conf

# copies the production-ready files to the nginx directory
COPY --from=builder /app/dist /usr/share/nginx/html