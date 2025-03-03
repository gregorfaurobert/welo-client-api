#!/bin/sh
# userToken="a623074a-66aa-4225-affa-9e436dbd4faa" #Anil Key
#userToken="575e107e-d860-433d-9998-a18c7e49e5df" #Test Veeva 183341
#userToken="cca122aa-2496-4e17-9a2a-613dfc2ebdf4" #Gregor Faurobert Agent
userToken="f79851cb-308e-4529-9749-b171bec5a55a" #Roche
#userToken="73bb8231-cfbf-4bc1-86e9-6d5a73a6bc9f" #Roche User Test ID 183342

# Gregor Faurobert Agent - clien-701 - ID = 821291
#     "plainTextAuthToken": "cca122aa-2496-4e17-9a2a-613dfc2ebdf4",
#     "plainTextRefreshToken": "f39f16fd-2d34-4b7c-99e3-27417a56d088"

baseCMD="curl" #macOS
#baseCMD="/bin/curl" #Linux
baseURL="hypnos-client-api.welocalize.io:5999" #client-api stack
#baseURL="junction-clien-701.welocalize.io:5999" #clien-701 stack

$baseCMD -X GET 'https://'$baseURL'/v1/client-api/services' \
--header 'x-pantheon-auth-key:'$userToken''