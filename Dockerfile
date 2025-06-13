# Use lightweight nginx base image
FROM nginx:alpine

# Copy custom nginx config
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy frontend build folder
COPY dist/ /usr/share/nginx/html

# Expose default HTTP port
EXPOSE 3000

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
