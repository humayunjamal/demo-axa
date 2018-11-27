FROM python:3-alpine

ENV TERRAFORM_VERSION=0.11.4

RUN apk add --update git curl openssh build-base libffi-dev openssl-dev && \
	pip install awscli boto3 ansible && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

VOLUME ["/root/.terraform.d"]
ENTRYPOINT ["/bin/sh"]
