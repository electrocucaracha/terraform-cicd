terraform-cicd
==============

This Terraform project offers a deployment of tools to manage applications thru CI/CD process.

# Requirements:

* [Terraform] (https://www.terraform.io/intro/getting-started/install.html)

## Steps for execution:

```bash
$ git clone https://github.com/electrocucaracha/terraform-cicd.git
$ cd  terraform-cicd
$ terraform apply /
    -var 'user_name=<OS_USERNAME>' /
    -var 'password=<OS_PASSWORD>'
```

## Destroy:

    terraform destroy
