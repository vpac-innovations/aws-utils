###
### This script is used for user data when AWS instance is created
### Need to be changed S3key, S3Secret, bucket and key file location
### for your s3 and AMI user settings.
### 
### Author : forjin@vpac-innovations.com.au
###
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

curl \
     -H "Host: \${bucket}.s3.amazonaws.com" \
     -H "Date: \${dateValue}" \
     -H "Content-Type: \${contentType}" \
     -H "Authorization: AWS \${s3Key}:\${signature}" \
     https://\${bucket}.s3.amazonaws.com/\${public_key_file}

EOF

chmod +x /etc/ssh/keys.sh
if grep -q AuthorizedKeysCommand "/etc/ssh/sshd_config"; then
    echo "AuthorizedKeysCommand found"
else
    echo "AuthorizedKeysCommand /etc/ssh/keys.sh" >> /etc/ssh/sshd_config
    echo "AuthorizedKeysCommandUser root" >> /etc/ssh/sshd_config
fi
service ssh restart
