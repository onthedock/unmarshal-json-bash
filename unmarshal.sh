#!/usr/bin/env bash

ERROR_UNSUPPORTED_DOCUMENT_TYPE=1
ERROR_UNSUPPORTED_PROPERTY_TYPE=2

unmarshal() {
    local document="$1"

    # If it's not a JSON object, exit
    document_type=$(jq -r '. | type' "$document")
    if [[ $document_type != "object" ]]; then
        echo "'$document' is of an unsupported type: '$document_type' (only 'object' is supported)"
        exit $ERROR_UNSUPPORTED_DOCUMENT_TYPE
    fi

    # Save document keys in a Bash array
    declare -a keys
    mapfile -t keys < <(jq -r 'keys[]' "$document")

    for k in "${keys[@]}"; do
        # Declare reference variable
        declare -n ref="$k"
        type="$(jq -r --arg k "$k" '.[$k] | type' "$document")"
        case $type in
            "string" | "boolean" | "number" | "null")
                # echo "type: $type"
                ref=$(jq -r --arg key "$k" '.[$key]' "$document")
            ;;
            "array")
                mapfile -t "${!ref}" < <(jq -r -c --arg key "$k" '.[$key][]' "$document")
            ;;
            "object")
                mapfile -t "$k" < <(jq -r -c --arg key "$k" '.[$key]' "$document")
            ;;
            *)
               echo "'$k' is of an unsupported type: '$type' (only 'string', 'bool', 'number', 'array', 'object' and 'null' are supported)"
               exit $ERROR_UNSUPPORTED_PROPERTY_TYPE
            ;;
        esac
    done
}