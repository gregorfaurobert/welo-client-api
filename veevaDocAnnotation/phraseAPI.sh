#!/bin/bash
baseURL=https://cloud.memsource.com/web
#userName=pantheon_uat
#password=wlP@ntheon08!
userName=uat.humberto.acea
password='bu8aDBHEV$BmhFD'
token=$(cat phraseToken)
jobId="H641RhV33Zn46a1thvskP1"

case $1 in
    "login")
        # Get the access token
        curl -X POST $baseURL/api2/v3/auth/login -H "Content-Type: application/json" -d '{
        "userName": "'$userName'",
        "password": "'$password'"
        }' | jq -r '.token' > phraseToken
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
esac
