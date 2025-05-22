#!/bin/bash

# Source logger if not already available
if ! declare -f log_message > /dev/null; then
    source "$(dirname "$0")/logger.sh"
fi

build_dockerfile() {
    local repo_url="${STEP_REPO_URL}"
    local image_name="${STEP_IMAGE_NAME}"

    log_message "🛠️  Starting Docker Build" "INFO"
    log_message "📦 Repo URL: ${repo_url}" "INFO"
    log_message "🐳 Image Name: ${image_name}" "INFO"

    # Get commit hash (GitHub Actions provides GITHUB_SHA)
    local commit_hash="${GITHUB_SHA:0:7}"
    if [[ -z "$commit_hash" ]]; then
        commit_hash=$(git rev-parse --short HEAD)
    fi
    
    log_message "📌 Using commit hash: ${commit_hash}" "INFO"
    
    # Build Docker image
    local build_cmd="docker build -f ${dockerfile_location} -t ${image_name}:${commit_hash} ${dockerfile_context}"
    log_message "🚀 Running Docker command: ${build_cmd}" "INFO"
    
    if ! eval "$build_cmd"; then
        log_message "❌ Docker build failed." "ERROR"
        return 1
    fi
    
    # Tag as latest
    local tag_cmd="docker tag ${image_name}:${commit_hash} ${image_name}:latest"
    log_message "🏷️  Tagging image as latest: ${tag_cmd}" "INFO"
    
    if ! eval "$tag_cmd"; then
        log_message "❌ Docker tag failed." "ERROR"
        return 1
    fi
    
    log_message "✅ Docker image built successfully: ${image_name}:${commit_hash}" "INFO"
    
    # Set GitHub Actions output for downstream jobs
    if [[ -n "$GITHUB_OUTPUT" ]]; then
        echo "image_name=${image_name}" >> "$GITHUB_OUTPUT"
        echo "image_tag=${commit_hash}" >> "$GITHUB_OUTPUT"
        echo "full_image_name=${image_name}:${commit_hash}" >> "$GITHUB_OUTPUT"
    fi
}

# Export the function
export -f build_dockerfile
