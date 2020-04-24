#!/bin/bash
# jmp@linuxmail.org                     04/2017
# Renew Let's Encrypt Certificate on Web Server
# USAGE: ./script security_group_id aws_region

aws_security_group=$1
region=$2
red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'


add_port_80()
{   
    printf "%s\n" "${grn}Temporarily opening up security group $aws_security_group to port 80 for lets encrypt renewal${end}"
    aws ec2 authorize-security-group-ingress --group-id $aws_security_group --protocol tcp --port 80 --cidr 0.0.0.0/0 $region
}

remove_port_80()
{
    printf "%s\n" "${grn}Reclosing security group $aws_security_group opened to port 80 for lets encrypt renewal${end}"
    aws ec2 revoke-security-group-ingress --group-id $aws_security_group --protocol tcp --port 80 --cidr 0.0.0.0/0 $region
}

renew_cert()
{
    printf "%s\n" "${grn}Stopping NGINX service${end}"
    /usr/sbin/service nginx stop;

    printf "%s\n" "${grn}Renewing Lets Encrypt Certificate${end}"
    /usr/local/bin/certbot-auto certonly --standalone -d $(hostname) --debug
    
    printf "%s\n" "${grn}Restarting NGINX service${end}"
    /usr/sbin/service nginx start;

    printf "%s\n" "${grn}Renewal of Lets Encrypt certificate complete $date${end}"
}

main()
{   
    add_port_80
    renew_cert
    remove_port_80
    exit 0
}

main
