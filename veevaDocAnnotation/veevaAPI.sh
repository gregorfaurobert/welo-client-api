#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed but is required for this script."
    echo "To install jq:"
    echo "  - On macOS: Run 'brew install jq' (requires Homebrew) or 'port install jq' (requires MacPorts)"
    echo "  - On Ubuntu/Debian: Run 'sudo apt install jq'"
    echo "  - On CentOS/RHEL/Fedora: Run 'sudo dnf install jq' or 'sudo yum install jq'"
    echo "  - On Arch Linux: Run 'sudo pacman -S jq'"
    echo "Please install jq and try again."
    exit 1
fi

vault_domain="https://vvtechpartner-welocalize-clinical.veevavault.com"
version="v24.3"
username="gregor.faurobert@vvtechpartner-welocalize.com"
password="aBuuN2NTVxLdV7b"
#documentId="5301"
documentId="5401"
majorVersion="0"
minorVersion="1"

case $1 in
    # Auth Verification
    "auth")
        curl -X POST $vault_domain/api/$version/auth \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Accept: application/json" \
        -d "username=$username&password=$password"
        ;;
    # Get Document Annotation
    "getDocAnnot")
        # Get session ID from auth call
        sessionId=$(curl -X POST $vault_domain/api/$version/auth \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Accept: application/json" \
        -d "username=$username&password=$password" | jq -r '.sessionId')
        curl -X GET -H "Authorization: $sessionId" \
        $vault_domain/api/$version/objects/documents/$documentId/versions/$majorVersion/$minorVersion/annotations | jq '.' > documentId_${documentId}_${majorVersion}_${minorVersion}_annotations_$(date +%Y%m%d).json
        ;;
    # Retrieve Commented Doc PDF
    "retrieveCommentedDocPDF")
        # Get session ID from auth call
        sessionId=$(curl -X POST $vault_domain/api/$version/auth \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Accept: application/json" \
        -d "username=$username&password=$password" | jq -r '.sessionId')
        # Start the Export Job
        curl -X GET -H "Authorization: $sessionId" \
        --output documentId_${documentId}_annotated_$(date +%Y%m%d).pdf \
        $vault_domain/api/v24.3/objects/documents/$documentId/annotations/file
        ;;
    # VQL Query
    "vqlQuery")
        # Check if query name was provided
        if [ -z "$2" ]; then
            echo "Error: Please provide a query name as the second argument."
            echo "Usage: ./veevaAPI.sh vqlQuery <query_name>"
            exit 1
        fi
        
        # Get session ID from auth call
        sessionId=$(curl -X POST $vault_domain/api/$version/auth \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Accept: application/json" \
        -d "username=$username&password=$password" | jq -r '.sessionId')
        
        # Extract the specific query from vqlQueries.json based on the provided query name
        queryValue=$(jq -r --arg qname "$2" '.queries[] | select(has($qname)) | .[$qname]' vqlQueries.json)
        
        # Check if the query was found
        if [ -z "$queryValue" ] || [ "$queryValue" = "null" ]; then
            echo "Error: Query '$2' not found in vqlQueries.json"
            exit 1
        fi
        
        # Use the extracted query
        curl -X POST -H "Authorization: $sessionId" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "q=$queryValue" \
        $vault_domain/api/v24.3/query | jq '.' > vqlQuery_${2}_$(date +%Y%m%d%H%M).json
        ;;
esac

