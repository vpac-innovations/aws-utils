# AWS Utils
This repository is AWS utils for vpac-innovations specialized.

Here are the steps to add an AWS EC2 instance.
1. Add IAM user policy (if doesn't exists)
    - AWS console > IAM > Users > "keys" user.
    - Permissions > Create Policy > Custom User Policy > Custom policy.
    - Create policy named "keys-ro" with following.
    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "Stmt1472608112000",
                "Effect": "Allow",
                "Action": [
                    "s3:GetObject"
                ],
                "Resource": [
                    "arn:aws:s3:::vpac-innovations-keys/*"
                ]
            }
        ]
    }
    ```
    - Security Credential > Create Access Key > Create key for the user which is used for EC2 instance to access S3 bucket

1. Add your key to the `authorized_keys` file
    - Access to S3 `vpac-innovations-keys` bucket
    - add your key to `Bastion's authorized_keys` file.
    - add your key to your project `authorized_keys` file
    - Download, fix and upload

1. Create EC2 instance
    - On EC2 instance creation, Step 3 `Configure instance`
    - `Advanced` tab > `User data`
    - Cut and paste `user_data.sh` file which is properly modified.
    - Finish your creation


If you add these lines to your `~/.bashrc`, you can SSH in to our hosts easily:
```
alias ssh-wsaa='ssh -o ProxyCommand="ssh -W %h:%p -l ubuntu <<wsaa bastion public ip>>" -l ubuntu'
alias ssh-vpac='ssh -o ProxyCommand="ssh -W %h:%p -l ubuntu <<rsa bastion public ip>>" -l ubuntu'
```

Then to connect to an RSA server, for example:
```
ssh-vpac <<internal or publi ip for the server>>
```