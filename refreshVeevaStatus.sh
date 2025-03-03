#!/bin/sh

/bin/curl --location 'https://veeva-app-stage.cloudwords.com/veeva/translation/status' \
--header 'clientId: admin' \
--header 'clientSecret: admin'