## Following instructions are for local setup. Jenkinsfile automates this process

__setup the AWS session using CLI__
```
$saml2aws login -a lunar2-non-production-admin
```
__export the environment variables__
```
$export AWS_PROFILE=lunar2-non-production-admin AWS_DEFAULT_REGION=us-west-2  AWS_SDK_LOAD_CONFIG=1
```
__Below example targets the dev environment__
```
$terraform init -backend-config=environments/dev/remote-backend.properties
$terraform validate
$terraform plan -out tfplan.out -var-file=environments/dev/terraform.tfvars
$terraform apply tfplan.out
```