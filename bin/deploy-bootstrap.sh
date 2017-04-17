#!/bin/bash

set -e

secrets_repo=$1

# TODO: refactor to avoid duplication. Make sed parsing robust to varying whitespace in yaml.
concourse_protocol=$(grep "protocol" $secrets_repo/ansible_hosts/concourse/host_vars/powertrip.yml | sed "s/protocol: //g")
concourse_external_host=$(grep "external_host" $secrets_repo/ansible_hosts/concourse/host_vars/powertrip.yml | sed "s/external_host: //g")
concourse_host="$concourse_protocol://$concourse_external_host"

concourse_user=$(grep "auth_user" $secrets_repo/ansible_hosts/concourse/host_vars/powertrip.yml | sed "s/auth_user: //g")
concourse_pass=$(grep "auth_pass" $secrets_repo/ansible_hosts/concourse/host_vars/powertrip.yml | sed "s/auth_pass: //g")

ftp_uri="ftp://"$(grep "ftp_host" $secrets_repo/ansible_hosts/concourse/host_vars/toast.yml | sed "s/ftp_host: //g")
ftp_user=$(grep "ftp_user" $secrets_repo/ansible_hosts/concourse/host_vars/toast.yml | sed "s/ftp_user: //g")
ftp_pass=$(grep "ftp_pass" $secrets_repo/ansible_hosts/concourse/host_vars/toast.yml | sed "s/ftp_pass: //g")

github_user=$(head -n1 $secrets_repo/keys/q2d2/github.csv | cut -f2 -d',')
github_pass=$(head -n1 $secrets_repo/keys/q2d2/github.csv | cut -f3 -d',')
github_token=$(head -n1 $secrets_repo/keys/q2d2/github.csv | cut -f4 -d',')

anaconda_user=$(head -n1 $secrets_repo/keys/q2d2/anaconda.csv | cut -f2 -d',')
anaconda_pass=$(head -n1 $secrets_repo/keys/q2d2/anaconda.csv | cut -f3 -d',')

fly -t qiime2 set-pipeline -p bootstrap -c bootstrap/pipelines/deploy.yaml \
    --var "concourse_host=$concourse_host" \
    --var "concourse_user=$concourse_user" \
    --var "concourse_pass=$concourse_pass" \
    --var "ftp_uri=$ftp_uri" \
    --var "ftp_user=$ftp_user" \
    --var "ftp_pass=$ftp_pass" \
    --var "github_user=$github_user" \
    --var "github_pass=$github_pass" \
    --var "github_token=$github_token" \
    --var "anaconda_user=$anaconda_user" \
    --var "anaconda_pass=$anaconda_pass"
