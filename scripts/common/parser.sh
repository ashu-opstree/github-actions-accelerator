if ! declare -f log_message > /dev/null; then
    source "$(dirname "$0")/logger.sh"
fi

# Parse configuration files (YAML, JSON, etc.)
parse_config() {
    local config_file="$1"
    local config_type="${2:-auto}"
    
    if [[ ! -f "$config_file" ]]; then
        log_message "Configuration file not found: $config_file" "ERROR"
        return 1
    fi
    
    log_message "Parsing configuration file: $config_file" "INFO"
    
    case "$config_type" in
        "yaml"|"yml")
            # Parse YAML (requires yq or similar tool)
            if command -v yq > /dev/null; then
                yq eval "$config_file"
            else
                log_message "yq not available for YAML parsing" "WARNING"
                cat "$config_file"
            fi
            ;;
        "json")
            # Parse JSON
            if command -v jq > /dev/null; then
                jq . "$config_file"
            else
                log_message "jq not available for JSON parsing" "WARNING"
                cat "$config_file"
            fi
            ;;
        "auto"|*)
            # Auto-detect based on file extension
            case "$config_file" in
                *.yml|*.yaml)
                    parse_config "$config_file" "yaml"
                    ;;
                *.json)
                    parse_config "$config_file" "json"
                    ;;
                *)
                    log_message "Unknown configuration format, displaying raw content" "INFO"
                    cat "$config_file"
                    ;;
            esac
            ;;
    esac
}

# Parse key-value pairs from a file
parse_properties() {
    local props_file="$1"
    
    if [[ ! -f "$props_file" ]]; then
        log_message "Properties file not found: $props_file" "ERROR"
        return 1
    fi
    
    log_message "Parsing properties file: $props_file" "INFO"
    
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        if [[ "$key" =~ ^[[:space:]]*# ]] || [[ -z "$key" ]]; then
            continue
        fi
        
        # Trim whitespace
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        
        echo "${key}=${value}"
    done < "$props_file"
}

# Export functions
export -f parse_config
export -f parse_properties
