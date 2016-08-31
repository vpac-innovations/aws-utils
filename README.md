# AWS Utils
This repository contains utilities for managing VPAC Innovations infrastructure

## SSH Key Management

When creating a new EC2 instance:

1. Cut and paste [`user_data.sh`](user_data.sh) into the _User Data_ text box.
1. Set `s3Key` and `s3Secret` to an access key for the `keys` user. This user has access to a special bucket in s3.
1. Set the name of `public_key_file` to match the project your machine will be used for.
1. Configure the security group such that there is no public SSH access. Instead, incoming connections should only be accepted from the private network (e.g. `172.31.0.0/16`). Connections will be made via the bastion server.
1. When you are asked for a key pair, choose any one with the intention of not using it. You could even create a new pair, download it and then delete it.
1. Otherwise configure the machine as normal.

### Accessing Machines

To gain access to machines that have this script installed, simply add the contents of your `~/.ssh/id_rsa.pub` to the appropriate `authorized_keys` file in the `vpac-innovations-keys` bucket. You might need to ask an administrator to do that.

If you add this line to your `~/.bashrc`, you can avoid specifying the bastion machine's IP address every time. You'll need to replace `BASTION_PUBLIC_IP` with the actual IP address of the bastion server.

```
alias ssh-vpac='ssh -o ProxyCommand="ssh -W %h:%p -l ubuntu <BASTION_PUBLIC_IP>" -l ubuntu'
```

Then to connect to a server:
```
ssh-vpac <INTERNAL_SERVER_IP>
```

### The Keys IAM User

If the `keys` user doesn't exist, create it with this policy:

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

There is no need to add a special bucket policy.
