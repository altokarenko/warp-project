#!/bin/bash
TIMESTAMP=$(date +%Y%M%S)
WARP_IMAGE_NAME=warp.base
NGINX_IMAGE_NAME=nginx.base

cd "$(dirname "${BASH_SOURCE[0]}")"

# Build and push the first Docker image
docker build -t $WARP_IMAGE_NAME -f ../warp/Dockerfile ../warp/
WARP_IMAGE_TAG=$ECR_REPO_URI:$WARP_IMAGE_NAME.$TIMESTAMP
docker tag $WARP_IMAGE_NAME:latest $WARP_IMAGE_TAG
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URI
docker push $WARP_IMAGE_TAG

# Build and push the second Docker image
docker build -t $NGINX_IMAGE_NAME -f ../warp/res/Dockerfile ../warp/res/
NGINX_IMAGE_TAG=$ECR_REPO_URI:$NGINX_IMAGE_NAME.$TIMESTAMP
docker tag $NGINX_IMAGE_NAME:latest $NGINX_IMAGE_TAG
docker push $NGINX_IMAGE_TAG

# Write the Terraform outputs file
cat << EOF > outputs.tf
output "warp_image_id" {
  value = "$WARP_IMAGE_TAG"
}

output "nginx_image_id" {
  value = "$NGINX_IMAGE_TAG"
}
EOF

