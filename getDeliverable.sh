#!/bin/sh
userToken="575e107e-d860-433d-9998-a18c7e49e5df" #Test Veeva 183341
#userToken="a623074a-66aa-4225-affa-9e436dbd4faa" #Veeva POC
# userToken="f79851cb-308e-4529-9749-b171bec5a55a" #Roche
# userToken="73bb8231-cfbf-4bc1-86e9-6d5a73a6bc9f" #Roche User Test ID 183342
#userToken="cca122aa-2496-4e17-9a2a-613dfc2ebdf4" #Gregor Faurobert AgentuserToken="cca122aa-2496-4e17-9a2a-613dfc2ebdf4" #Gregor Faurobert Agent

# baseURL="junction-clien-701.welocalize.io:5999" # clien-701 stack
baseURL="hypnos-client-api.welocalize.io:5999" # client stack

projectID="$2"
fileID="$3"
fileName="$4"

baseCMD="curl" #macOS
#baseCMD="/bin/curl" #Linux

case $1 in
    list)
            $baseCMD -X GET 'https://'$baseURL'/v1/client-api/project/'$projectID'/deliverables' \
            --header 'x-pantheon-auth-key:'$userToken''
            ;;
    file)
            $baseCMD -X GET 'https://'$baseURL'/v1/client-api/project/'$projectID'/deliverable/'$fileID'' \
            --header 'x-pantheon-auth-key:'$userToken'' \
            --output $4
            ;;
esac
            
#> api_result.json

# jq '.data[] | select(.id == "'$projectID'")' api_result.json

