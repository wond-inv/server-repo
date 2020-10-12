## This document explains how terraform variables work. 


If you're familiar with cloudformation, terraform variales area a lot like AWS Cloudformation parameters. When starting out with terraform, you can use hard coded values on your config files(.tf files), but eventually, you will want to start using variables because that way, things become sharable, modular and reusable.

Let's say that you want to create a terraform template that will deploy EC2 instances, and you don't know the exact number of instances you need to deploy.  In these cases you can define default variables within a config file and modify that file to change the number of instances you deploy. Or you can also supply a file with variable values( .tfvars) while running the terraform apply command. 


Here, we will authour three config files, variables.tf, provider.tf and instances.tf. Within provider.tf and instance.tf, we use expression that begins with Var.`<Name>.`    Let's look at come concrete examples 
  
  ### variables.tf
```HCL


variable "instance_count" {
	# default = 2
}

variable "ec2_type" {
	# default = "t2.micro"
}
```

We thus specified that we want to launch our instances in us-east-2 by default and that we want to launch two instances. 

  ### instances.tf
```HCL

resource "aws_instance" "example" {
  ami           = "ami-0c64dd618a49aeee8"
  instance_type = var.ec2_type
  count = var.instance_count

tags = {
    Name = "Terraform_demo"
  }
}


```
In the instance.tf file, we've speciifed the ami name, instance type.  However, instead of hard coding the instance count we are using the value from the variable declared in the variable.tf file. 

#### Note: we've tagged all instances as Terraform_demo, we can iteratively name them using loops. 

  ### provider.tf
```HCL

"aws" {
  # access_key = "ACCESS_KEY_HERE"
  # secret_key = "SECRET_KEY_HERE"
  region     = "us-east-2"
}

```
In my environment, I've setup AWS CLI, and my terraform builds can access my AWS account via those credentials. Like above, the region comes from the region variable from the variable.tf file. 

  
--------
There are multiple ways to pass in variables when running the terraform apply command.
In the order of preference
1) as a command line flag
```console
$ terraform apply -var 'key-name=my-key'

```

2) A seperate variable file which you reference like this while running the script.
```console
terraform apply  -var-file="vars.tfvars"
```
> For all files which match `terraform.tfvars` or `*.auto.tfvars` present in the current directory, Terraform  automatically loads them to populate variables. If the file is named something else, you can use the -var-file flag directly to specify a file. These files are the same syntax as Terraform configuration files.


3) Environment variables:
Terraform will read environment variables in the form of TF_VAR_name to find the value for a variable. For example, the TF_VAR_access_key variable can be set to set the access_key variable.

4) If none of the first 3 steps are used to set variables, you are asked for variables when you run terraform apply.
```console
$ terraform apply
var.ec2-key
  Enter a value:
```



5) Default variable values in the .tf file where the variable is defined . You could set a default value when declaring the variable.
```HCL
variable "ec2-key" { 
default = "my-key"
}
```

---


# References
https://www.terraform.io/docs/configuration/variables.html
https://www.terraform.io/docs/providers/aws/index.html


Homework: It's your turn now

Convert Instance type and EC2 instance tag into variables too.

For more Reference:https://www.terraform.io/intro/getting-started/variables.html
