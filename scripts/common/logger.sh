#!/bin/bash

# Initialize logger (can be extended for different log targets)
init_logger() {
    export LOG_LEVEL="${LOG_LEVEL:-INFO}"
}

# Log message function
log_message() {
    local message="$1"
    local level="${2:-INFO}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case "$level" in
        "ERROR")
            echo "::error::[$timestamp] $message"
            ;;
        "WARNING"|"WARN")
            echo "::warning::[$timestamp] $message"
            ;;
        "DEBUG")
            if [[ "$LOG_LEVEL" == "DEBUG" ]]; then
                echo "::debug::[$timestamp] $message"
            fi
            ;;
        "INFO"|*)
            echo "[$timestamp] $message"
            ;;
    esac
}

# Export the function so it can be used in other scripts
export -f log_message
