source "$(dirname "$0")/../common/logger.sh"

# Initialize logger
init_logger

log_message "Starting GitHub Actions wrapper with the following parameters:" "INFO"
log_message "dockerBuild: ${DOCKER_BUILD}" "DEBUG"
log_message "repo_url: ${REPO_URL}" "DEBUG"
log_message "image_name: ${IMAGE_NAME}" "DEBUG"

# Set step parameters as environment variables for the CI template
export STEP_DOCKER_BUILD="${DOCKER_BUILD}"
export STEP_REPO_URL="${REPO_URL}"
export STEP_IMAGE_NAME="${IMAGE_NAME}"

# Call the Java CI template
"$(dirname "$0")/../ci/templates/java_ci/java_ci.sh"
