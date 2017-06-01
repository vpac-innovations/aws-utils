#!/bin/bash

cat << EOF > /etc/ssh/keys.sh
#!/bin/bash

public_key_file="landblade/authorized_keys"
bucket="vpac-innovations-keys"
s3Key="<<AWS_S3_KEY>>"
s3Secret="<<AWS_S3_SECRET>>"
contentType="plain/text"

dateValue=\`date -R\`
resource="/\${bucket}/\${public_key_file}"
stringToSign="GET\n\n\${contentType}\n\${dateValue}\n\${resource}"
signature=\`echo -en \${stringToSign} | openssl sha1 -hmac \${s3Secret} -binary | base64\`

keys=$(curl \\
     -H "Host: \${bucket}.s3.amazonaws.com" \\
     -H "Date: \${dateValue}" \\
     -H "Content-Type: \${contentType}" \\
     -H "Authorization: AWS \${s3Key}:\${signature}" \\
     https://\${bucket}.s3.amazonaws.com/\${public_key_file})

if echo "$keys" | grep -Eq '^ssh-rsa'; then
        echo "$keys"
else
        logger -p auth.warn -t "$0" -- "Failed to fetch keys from S3: $keys"
fi

EOF

chmod +x /etc/ssh/keys.sh
if grep -q AuthorizedKeysCommand "/etc/ssh/sshd_config"; then
    echo "AuthorizedKeysCommand found"
else
    echo "AuthorizedKeysCommand /etc/ssh/keys.sh" >> /etc/ssh/sshd_config
    echo "AuthorizedKeysCommandUser root" >> /etc/ssh/sshd_config
fi
service ssh restart

apt-get update && apt-get install -y ntp
