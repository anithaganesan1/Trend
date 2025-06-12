# Stage: Production web server for Vite app
FROM nginx:alpine

# Clear the default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy the Vite build output into the nginx web folder
COPY dist/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
