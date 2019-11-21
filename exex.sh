#!/usr/bin/env bash

set -xeu


usage() {
  cat <<'EOT'
exec.sh {-g|-h}

  -g get outputs only
  -h show help
EOT
}

get_only_flag=false
stack_name=bookmarks-prepare

while getopts ':h:g' args; do
    case ${args} in
        g)
            get_only_flag=true
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

[[ ${get_only_flag} == false ]] && \
    pipenv run aws cloudformation deploy \
        --template-file template.yml \
        --stack-name ${stack_name} \
        --no-fail-on-empty-changeset

pipenv run aws cloudformation describe-stacks \
    --stack-name ${stack_name} \
    --query 'Stacks[0].Outputs'