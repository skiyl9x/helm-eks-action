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

#response=$( bash -c "$INPUT_COMMAND" 2>&1 )
commandExitCode=${?}

response=`cat output.log`
#fix multiline output
response="${response//'%'/'%25'}"
response="${response//$'\n'/'%0A'}"
response="${response//$'\r'/'%0D'}"
echo "::set-output name=response::${response}"
exit ${commandExitCode}
