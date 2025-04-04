key="amgen-sftp-private-key.pem"
username="ath-welocalize-sftp-user-gregor-dev"
host="s-db11845b6b18414f8.server.transfer.us-west-2.amazonaws.com"

sftp -i $key $username@$host

#sftp -i amgen-sftp-private-key.pem ath-welocalize-sftp-user-dev@s-db11845b6b18414f8.server.transfer.us-west-2.amazonaws.com