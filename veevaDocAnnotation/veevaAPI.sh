vault_domain="https://vvtechpartner-welocalize-clinical.veevavault.com"
version="v24.3"
username="gregor.faurobert@vvtechpartner-welocalize.com"
password="aBuuN2NTVxLdV7b"
documentId="5301"
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
        $vault_domain/api/$version/objects/documents/$documentId/versions/$majorVersion/$minorVersion/annotations > documentId_${documentId}_${majorVersion}_${minorVersion}_annotations_$(date +%Y%m%d).json
        ;;
    # Retrieve all Docs from a Workflow at a certain step
    "retrieveAllWorkflows")
        # Get session ID from auth call
        sessionId=$(curl -X POST $vault_domain/api/$version/auth \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Accept: application/json" \
        -d "username=$username&password=$password" | jq -r '.sessionId')
        curl -X GET -H "Authorization: $sessionId" \
        $vault_domain/api/v24.3/objects/documents/actions/Objectworkflow.mdw_review__c > allDocsWorkflows_$(date +%Y%m%d).json
        ;;
    # Retrieve Commented Doc PDF
    "retrieveCommentedDocPDF")
        # Get session ID from auth call
        sessionId=$(curl -X POST $vault_domain/api/$version/auth \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Accept: application/json" \
        -d "username=$username&password=$password" | jq -r '.sessionId')
        # Start the Export Job
        curl -X POST -H "Authorization: $sessionId" \
        -H "Content-Type: application/json" \
        --data-binary @"documentIds.json" \
        $vault_domain/api/v24.3/objects/documents/batch/actions/fileextract > jobId_$(date +%Y%m%d).json
        # Get the Job ID
        jobId=$(jq -r '.job_id' jobId_$(date +%Y%m%d).json)
        # Get the Results
        curl -X GET -H "Authorization: $sessionId" \
        $vault_domain/api/$version/objects/documents/batch/actions/fileextract/$jobId/results > results_$(date +%Y%m%d).json
        file=$(jq -r '.data[0].file' results_$(date +%Y%m%d).json)
        # Download the File
        curl -L -X GET -H "Authorization: $sessionId" \
        $vault_domain/api/v24.3/services/file_staging/items/content/$file
        ;;
esac

