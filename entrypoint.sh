#!/bin/sh

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

bash -c "$INPUT_COMMAND" 2>&1 | tee -a response.txt

# response=$(sh -c " $INPUT_COMMAND 2>&1")
response=`cat response.txt`

# exit_code=$?
#output result
echo -e "$response"

#fix multiline output
response="${response//'%'/'%25'}"
response="${response//$'\n'/'%0A'}"
response="${response//$'\r'/'%0D'}"

echo "::set-output name=response::$response"

# exit $exit_code
