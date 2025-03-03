#!/bin/sh
#baseCMD="/bin/curl" #Linux
baseCMD="curl" #macOS

#url="https://hypnos-client-api.welocalize.io:5999"
baseURL="junction-clien-701.welocalize.io:5999" #clien-701 stack

#userToken="575e107e-d860-433d-9998-a18c7e49e5df" #Test Veeva 183341
# userToken="f79851cb-308e-4529-9749-b171bec5a55a" #Roche
# userToken="73bb8231-cfbf-4bc1-86e9-6d5a73a6bc9f" #Roche User Test ID 183342
userToken="cca122aa-2496-4e17-9a2a-613dfc2ebdf4" #Gregor Faurobert Agent

# payload="createNewProjectNoDueDate.json"
payload="RochePayloadSimple.json"

projectID="$2"

file="Future_of_Corporate_Diversity_and_Inclusion.docx"
# file="margin_slides.pdf"
# file="Team_Work.txt"

if [[ $1 == "create" ]]; then
    $baseCMD -X POST "https://"$baseURL"/v1/client-api/project" \
    --header "x-pantheon-auth-key:$userToken" \
    --header "Content-Type: application/json" \
    --data @$payload
elif [[ $1 == "upload" ]]; then
    $baseCMD -X POST 'https://'$baseURL'/v1/client-api/project/'$projectID'/file' \
    --header 'x-pantheon-auth-key: '$userToken'' \
    --form 'file=@"assets/'$file'"' \
    --form 'asset="{
    \"name\": \"'$file'\",
    \"type\":\"work\"
    }"'
elif [[ $1 == "start" ]]; then
    $baseCMD -X PUT 'https://'$baseURL'/v1/client-api/project/'$projectID'/start' \
    --header 'x-pantheon-auth-key: '$userToken''
elif [[ $1 == "refresh" ]]; then
    $baseCMD --location --request PUT 'https://'$baseURL'/v1/authentication-token/refresh/{{refId}}' \
    --header 'x-pantheon-auth-key: '$userToken''
else
    :
fi