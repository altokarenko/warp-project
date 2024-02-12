# Use the official Nginx image
FROM nginx

# Copy the Nginx configuration file into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
