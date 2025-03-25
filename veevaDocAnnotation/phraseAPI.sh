#!/bin/bash
baseURL=https://cloud.memsource.com/web
#userName=pantheon_uat
#password=wlP@ntheon08!
userName=uat.humberto.acea
password='bu8aDBHEV$BmhFD'
projectId="H641RhV33Zn46a1thvskP1"
jobId="YwOT1IwaKnj3rWLwpmjwb7"

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
        curl -X GET -H "Authorization: $token" https://cloud.memsource.com/web/api2/v1/auth/whoAmI
    ;;
    "addComment")
        curl -X POST $baseURL/api2/v3/jobs/$jobId/conversations/plains \
        -H "Authorization: $token" \
        -H "Content-Type: application/json" \
        -d '{
            "comment": {
                "text": "Testing From Api call"
            },
            "references": {
                "transGroupId": 0,
                "segmentId": "Vom0CA8kW7SG1qSD1_dc7:1", 
                "commentedText": "iaculis dolor"
            }
        }'
    ;;
    "getJobSegments")
        beginIndex=0
        endIndex=100
        # Get and store the token first
        token=$(curl -X POST $baseURL/api2/v3/auth/login -H "Content-Type: application/json" -d '{
        "userName": "'$userName'",
        "password": "'$password'"
        }' | jq -r '.token')
        
        # Make the API call with the token
        curl -X GET -H "Authorization: $token" \
        $baseURL/api2/v1/projects/$projectId/jobs/$jobId/segments?beginIndex=0&endIndex=100
    ;;
esac
