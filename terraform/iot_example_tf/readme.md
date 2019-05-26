# prepare

1. install terraform  

    download archive from terraform.io/downloads
    cp /usr/bin/terraform ; chmod a+x /usr/bin/terraform

    terraform -install-autocomplete #for bash or zsh shells

2. install and configure aws cli  

    install pip3
    pip3 install awscli --upgrade --user
> upgrade all required packages and install for current user
    aws configure --profile terraform
> supply access key id (associated with terraform user in IAM)  
 supply secret access key (shown only during creation, so copy it from similar place)

3. terraform init  

    enter s3 bucket name for Bucket to store tfstate

4. set credentials file location. configured during aws cli install  

    export TF_VAR_shared_credentials_file="~/.aws/credentials"
