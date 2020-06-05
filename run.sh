#!/usr/bin/env bash
#
# Builds container images and deploys to K8s.

CONTAINER_IMAGE_LIST='nginx:nginx'   # <CONTAINER_NAME>:<IMAGE>
export $(egrep -v '^#' .env | xargs) # export vars from .env

build_container() {
  for SUBDIR in ${SUBDIR_LIST}; do
    # Build the container image
    docker build -f ${SUBDIR}/Dockerfile -t ${SUBDIR}:${IMAGE_TAG} .

    # Push image to registry
    sudo podman login https://${IMAGE_REGISTRY}
    sudo podman push ${SUBDIR}:${IMAGE_TAG} ${IMAGE_REGISTRY}/${ORG_NAME}/${SUBDIR}:${IMAGE_TAG}
  done
}

run_locally() {
  echo -e "Starting containers..."
  for CONTAINER_IMAGE in ${CONTAINER_IMAGE_LIST}; do

    # Parse list into container name and assocaited container image.
    CONTAINER_NAME=$(echo ${CONTAINER_IMAGE} | cut -d: -f1)
    IMAGE=$(echo ${CONTAINER_IMAGE} | cut -d: -f2)

    # Remove the container
    sudo podman rm -f ${CONTAINER_NAME}

    # Run the container in detached mode on podman network.
    sudo podman run -d --rm \
      --net podman \
      --name ${CONTAINER_NAME} \
      ${IMAGE}:${IMAGE_TAG}

  done
}

run_k8s() {
  # Assumes authenticated and correct namespace selected

  for CONTAINER_IMAGE in ${CONTAINER_IMAGE_LIST}; do

    # Parse list into container name.
    CONTAINER_NAME=$(echo ${CONTAINER_IMAGE} | cut -d: -f1)

    for YAML_FILE in $( ls ${CONTAINER_NAME}/*.yaml ); do
      envsubst < ${YAML_FILE} | oc apply -f -
    done

  done
}

############################
# Main
############################

#run_locally
build_container
run_k8s
