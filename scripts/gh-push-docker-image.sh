#!/bin/bash

if [[ -z $GITHUB_ACTOR || -z $GITHUB_TOKEN || -z $GITHUB_REPOSITORY ]]; then
  echo "[ERR] Run $0 under GitHub Actions context!"
  exit 1
fi

IMAGE_NAME=${1:-''}
IMAGE_TAG=${2:-''}
if [[ -z $IMAGE_NAME || -z $IMAGE_TAG ]]; then
  echo "[ERR] Usage: $0 [IMAGE_NAME] [IMAGE_TAG]"
  exit 1
fi

USERNAME="$GITHUB_ACTOR"
PASSWORD="$GITHUB_TOKEN"
REPOSITORY="$(echo -n "$GITHUB_REPOSITORY" | tr '[:upper:]' '[:lower:]')"
IMAGE="$IMAGE_NAME:$IMAGE_TAG"
GHCR_IMAGE="ghcr.io/$REPOSITORY/$IMAGE"

echo "Logging in to GitHub Container Registry"
echo "$PASSWORD" | docker login ghcr.io -u "$USERNAME" --password-stdin

echo "Retagging [$IMAGE => $GHCR_IMAGE]"
docker tag "$IMAGE" "$GHCR_IMAGE"
docker images

echo "Pushing [$GHCR_IMAGE]"
docker push "$GHCR_IMAGE"

echo "Image pushed successfully! [$GHCR_IMAGE]"
