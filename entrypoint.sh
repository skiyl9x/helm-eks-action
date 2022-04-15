#!/bin/bash

set -e

echo ${KUBE_CONFIG_DATA} | base64 -d > kubeconfig
export KUBECONFIG="${PWD}/kubeconfig"
chmod 600 ${PWD}/kubeconfig

if [[ -n "${INPUT_PLUGINS// /}" ]]
then
    plugins=$(echo $INPUT_PLUGINS | tr ",")

    for plugin in $plugins
    do
        echo "installing helm plugin: [$plugin]"
        helm plugin install $plugin
    done
fi

echo "running entrypoint command(s)"

bash -c "$INPUT_COMMAND" > >(tee -a output.log) 2> >(tee -a output.log >&2)


#if [ -s stderr.log ]; then
#  errors=`cat stderr.log`
#  echo "errors<<EOF" >> $GITHUB_ENV
#  echo "$errors" >> $GITHUB_ENV
#  echo "EOF" >> $GITHUB_ENV
#  exit 2
#fi

#if [ -s stdout.log ]; then
#  response=`cat stdout.log`
#  echo "response<<EOF" >> $GITHUB_ENV
#  echo "$response" >> $GITHUB_ENV
#  echo "EOF" >> $GITHUB_ENV
#fi

export response=`cat output.log`
#fix multiline output
response="${response//'%'/'%25'}"
response="${response//$'\n'/'%0A'}"
response="${response//$'\r'/'%0D'}"

echo "::set-output name=response::$(echo "$response")"
