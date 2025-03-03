#!/bin/sh
userToken="575e107e-d860-433d-9998-a18c7e49e5df" #Test Veeva 183341
# userToken="f79851cb-308e-4529-9749-b171bec5a55a" #Roche
# userToken="73bb8231-cfbf-4bc1-86e9-6d5a73a6bc9f" #Roche User Test ID 183342

# baseCMD="curl" #macOS
baseCMD="/bin/curl" #Linux

projectID="3378248790"

$baseCMD -X PUT 'https://hypnos-client-api.welocalize.io/v1/client-api/project/'$projectID'/start' \
--header 'x-pantheon-auth-key: '$userToken''