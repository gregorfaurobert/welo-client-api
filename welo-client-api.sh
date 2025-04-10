#!/bin/sh
#baseCMD="/bin/curl" #Linux
baseCMD="curl" #macOS

baseURL="hypnos-client-api.welocalize.io:5999" # Client API FS
#baseURL="hypnos.welocalize.tools" # Production
# baseURL="junction-clien-701.welocalize.io:5999" #clien-701 stack
#baseURL="junction.welocalize.com"

userToken="575e107e-d860-433d-9998-a18c7e49e5df" #Test Veeva 183341
#userToken="9462bc2b-2ff0-4129-bf8b-074380e428c9" # Roche prod
#userToken="f79851cb-308e-4529-9749-b171bec5a55a" #Roche

# payload="createNewProjectNoDueDate.json"
payload="RochePayloadSimple.json"

projectID="$2"
deliverableID="$3"
assetReference="$4"

#file="assets/Future_of_Corporate_Diversity_and_Inclusion.docx"
fileToUpload="fileToUpload.json"
file=$(jq -r '.file' $fileToUpload)
asset=$(jq -c '.asset' $fileToUpload)
# file="margin_slides.pdf"
# file="Team_Work.txt"

if [ "$1" = "--help" ]; then
    echo "Usage: ./welo-client-api.sh [command] [options]"
    echo ""
    echo "Commands:"
    echo "  create [payload]      Create a new project using JSON payload file"
    echo "  upload [projectId] [file]   Upload a file to specified project"
    echo "  start [projectId]     Start a specific project"
    echo "  refresh              Refresh authentication token"
    echo "  project-list         Get list of all projects"
    echo "  project-status [projectId]  Get status of specific project"
    echo "  deliverables [projectId]    Get list of deliverables for project"
    echo "  get-file [projectId] [deliverableId]  Download specific deliverable"
    echo ""
    echo "Options:"
    echo "  status:[value]       Filter project list by status"
    echo "                       Valid statuses: processing, created, in scoping,"
    echo "                       in progress, delivery in progress, completed,"
    echo "                       error, cancelled, hold, lost, ignored"
    echo ""
    echo "Examples:"
    echo "  ./welo-client-api.sh project-list"
    echo "  ./welo-client-api.sh project-list status:completed"
    echo "  ./welo-client-api.sh project-status 123456"
    echo "  ./welo-client-api.sh upload 123456 myfile.txt"
    exit 0
else
    case $1 in
        "authTokenInfo")
            $baseCMD -X GET "https://"$baseURL"/v1/authentication-token/info" \
            --header "x-pantheon-auth-key:$userToken" > api_result.json
            ;;
        "services")
            $baseCMD -X GET "https://"$baseURL"/v1/client-api/services" \
            --header "x-pantheon-auth-key:$userToken" > api_result.json
            ;;
        "create")
            $baseCMD -X POST "https://"$baseURL"/v1/client-api/project" \
            --header "x-pantheon-auth-key:$userToken" \
            --header "Content-Type: application/json" \
            --data @$payload > api_result.json
            ;;
        "upload")
            $baseCMD -X POST 'https://'$baseURL'/v1/client-api/project/'$projectID'/file' \
            --header 'x-pantheon-auth-key: '$userToken'' \
            --form 'file=@'$file \
            --form 'asset='"$asset" > api_result.json
            ;;
        "start")
            $baseCMD -X PUT 'https://'$baseURL'/v1/client-api/project/'$projectID'/start' \
            --header 'x-pantheon-auth-key: '$userToken'' > api_result.json  
            ;;
        "refresh")
            $baseCMD --location --request PUT 'https://'$baseURL'/v1/authentication-token/refresh/{{refId}}' \
            --header 'x-pantheon-auth-key: '$userToken'' > api_result.json
            ;;
        "project-list")
            $baseCMD -X GET "https://"$baseURL"/v1/client-api/projects" \
            --header "x-pantheon-auth-key:$userToken" > api_result.json
            ;;
        "project-status")
            $baseCMD -X GET "https://"$baseURL"/v1/client-api/project/"$projectID"/status" \
            --header "x-pantheon-auth-key:$userToken" > api_result.json
            ;;
        "deliverables")
            $baseCMD -X GET "https://"$baseURL"/v1/client-api/project/"$projectID"/deliverables" \
            --header "x-pantheon-auth-key:$userToken" > api_result.json
            ;;
        "get-file")
            $baseCMD -X GET "https://"$baseURL"/v1/client-api/project/"$projectID"/deliverable/"$deliverableID"" \
            --header "x-pantheon-auth-key:$userToken" \
            --output "$assetReference"
            ;;
        "get-assets-list")
            $baseCMD -X GET "https://"$baseURL"/v1/client-api/project/"$projectID"/files" \
            --header "x-pantheon-auth-key:$userToken" | jq '.' > api_result.json
            ;;
        *)
            :
            ;;
    esac

    if [[ "$2" == status:* ]]; then
        status="${2#status:}"
        jq --arg status "$status" '.data[] | select(.status == $status)' api_result.json
    elif [[ "$1" == get-list ]]; then
        exit 0
    else
        jq '.' api_result.json
    fi
fi


# curl -X GET https://hypnos-client-api.welocalize.io:5999/v1/client-api/project/3378248857/deliverables --header x-pantheon-auth-key:f79851cb-308e-4529-9749-b171bec5a55a
# curl -X GET https://hypnos-client-api.welocalize.io:5999/v1/client-api/project/3378248857/deliverables --header x-pantheon-auth-key:575e107e-d860-433d-9998-a18c7e49e5df

