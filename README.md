# DK Infrastructure as code
## Prerequisites (Local Run)
### install AWS CLI
install `awscli2` then run this command and follow the instructions
```shell
aws configure --region us-east-1
```
### get the repository locally
run this command
```shell
git clone git@github.com:56kcloud/dk-infra-as-code.git
```
### install terraform CLI
if you're in mac with homebrew use this command
```shell
brew install hashicorp/tap/terraform
```
if you have another OS
refer to the official documentation [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### test your terraform installation

run these command to validate that evrything is ok
```shell
$ terraform init
$ terraform validate
$ terraform plan
```

## use github actions 
you have two worfklows :

- the `PR workflow validation` used to validate the syntax and the lint of your files run only on pull requests triggred on every push.
- the `apply workflow` apply modification on environement or create a new one default main branch but can be changed.


