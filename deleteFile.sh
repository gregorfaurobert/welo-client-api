#!/bin/bash

baseCMD="curl" #macOS

baseURL="hypnos-client-api.welocalize.io:5999"
#baseURL="junction-clien-701.welocalize.io:5999" #clien-701 stack

#userToken="575e107e-d860-433d-9998-a18c7e49e5df" #Test Veeva 183341
userToken="f79851cb-308e-4529-9749-b171bec5a55a" #Roche
# userToken="73bb8231-cfbf-4bc1-86e9-6d5a73a6bc9f" #Roche User Test ID 183342
#userToken="cca122aa-2496-4e17-9a2a-613dfc2ebdf4" #Gregor Faurobert Agent


projectID="$1"
fileID="$2"

$baseCMD -X DELETE "https://"$baseURL"/v1/client-api/project/"$projectID"/file/"$fileID \
--header "x-pantheon-auth-key:$userToken" \
--header "Content-Type: application/json" \