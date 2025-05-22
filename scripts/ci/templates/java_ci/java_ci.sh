#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../../common/logger.sh"
source "$(dirname "$0")/../../../common/build_dockerfile.sh"

run_java_ci() {
    log_message "🚀 Starting Java CI Pipeline" "INFO"
    log_message "📦 Repo URL: ${STEP_REPO_URL}" "INFO"
    log_message "🌿 Branch: ${STEP_REPO_BRANCH}" "INFO"
    
    
    
    if [[ "${STEP_DOCKER_BUILD}" == "true" ]]; then
        log_message "🐳 Docker build is enabled" "INFO"
        build_dockerfile
    else
        log_message "⏭️ Skipping Docker build as it is disabled" "INFO"
    fi
    
    log_message "✅ Java CI Pipeline completed successfully" "INFO"
}

# Execute the function
run_java_ci || {
    log_message "❌ Java CI Pipeline failed" "ERROR"
    exit 1
}
