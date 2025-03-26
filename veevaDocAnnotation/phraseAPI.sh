#!/bin/bash
baseURL=https://cloud.memsource.com/web
#userName=pantheon_uat
#password=wlP@ntheon08!
userName=uat.humberto.acea
password='bu8aDBHEV$BmhFD'
projectId="H641RhV33Zn46a1thvskP1"
jobId="YwOT1IwaKnj3rWLwpmjwb7"

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

case $1 in
    "login")
        # Get the access token
        curl -X POST $baseURL/api2/v3/auth/login -H "Content-Type: application/json" -d '{
        "userName": "'$userName'",
        "password": "'$password'"
        }' | jq -r '.token'
    ;;
    "wai")
        token=$(curl -X POST $baseURL/api2/v3/auth/login -H "Content-Type: application/json" -d '{
        "userName": "'$userName'",
        "password": "'$password'"
        }' | jq -r '.token')
        curl -X GET -H "Authorization: ApiToken $token" $baseURL/api2/v1/auth/whoAmI
    ;;
    "addComments")
        token=$(curl -X POST $baseURL/api2/v3/auth/login -H "Content-Type: application/json" -d '{
        "userName": "'$userName'",
        "password": "'$password'"
        }' | jq -r '.token')
        
        # Read and process each comment from comments.json
        while IFS= read -r comment; do
            curl -X POST $baseURL/api2/v3/jobs/$jobId/conversations/plains \
            -H "Authorization: ApiToken $token" \
            -H "Content-Type: application/json" \
            -d "$comment"
        done < <(jq -c '.comments[]' "$SCRIPT_DIR/comments.json")
    ;;
    "getSegmentCount")
        token=$(curl -X POST $baseURL/api2/v3/auth/login -H "Content-Type: application/json" -d '{
        "userName": "'$userName'",
        "password": "'$password'"
        }' | jq -r '.token')
        curl -X POST -H "Authorization: ApiToken $token" \
        $baseURL/api2/v1/projects/$projectId/jobs/segmentsCount \
        -H "Content-Type: application/json" \
        -d '{
            "jobs": [
                {
                    "uid": "'$jobId'"
                }
            ]
        }' | jq '.segmentsCountsResults[0].counts.segmentsCount'
    ;;
    "getJobSegments")
        beginIndex=0
        endIndex=$(token=$(curl -X POST $baseURL/api2/v3/auth/login -H "Content-Type: application/json" -d '{
        "userName": "'$userName'",
        "password": "'$password'"
        }' | jq -r '.token')
        curl -X POST -H "Authorization: ApiToken $token" \
        $baseURL/api2/v1/projects/$projectId/jobs/segmentsCount \
        -H "Content-Type: application/json" \
        -d '{
            "jobs": [
                {
                    "uid": "'$jobId'"
                }
            ]
        }' | jq '.segmentsCountsResults[0].counts.segmentsCount')
        # Get and store the token first
        token=$(curl -X POST $baseURL/api2/v3/auth/login -H "Content-Type: application/json" -d '{
        "userName": "'$userName'",
        "password": "'$password'"
        }' | jq -r '.token')
        
        # Make the API call with the token and format with jq
        curl -X GET -H "Authorization: ApiToken $token" \
        "$baseURL/api2/v1/projects/$projectId/jobs/$jobId/segments?beginIndex=$beginIndex&endIndex=$endIndex" | jq '.' > $projectId"_"$jobId"_segments_"$(date +%Y%m%d_%H%M%S).json
    ;;
esac
