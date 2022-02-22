FROM alpine:3.13

ARG KUBECTL_VERSION="1.21.2"

RUN apk add py-pip curl wget ca-certificates git bash jq gcc alpine-sdk && \
    pip install 'awscli==1.22.26' && \
    curl -L -o /usr/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl && \
    apk add py3-pynacl && \
    curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x /usr/bin/aws-iam-authenticator && \
    wget https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    apk add terraform

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]:
