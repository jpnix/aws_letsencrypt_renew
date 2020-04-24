# Lets encrypt auto renew on EC2

Small script that handles the automatic renewal of certificates that are about to expire

## Requirements

Its understood that you have certbot-auto installed on your ec2 instance.
The policy in this repo will need to be added to a role that is attached to the instance. This is to allow the security group directives to be modified with port 80 temporarily open to world so LE can successfully pass the ACME challenge and then remove the port 80 access.

## EC2 Policy
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/security_group_id"
        }
    ]
}

```


## Usage
Run as cronjob to run before your cert expires

```
./script security_group_id aws_region
```
