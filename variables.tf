variable "user_name" {}
variable "password" {}

variable "tenant_name" {
  default = "osic-engineering"
}

variable "auth_url" {
  default = "https://cloud1.osic.org:5000/v2.0"
}

variable "domain_name" {
  default = "Default"
}

variable "region" {
  default = "RegionOne"
}

variable "image" {
  default = "ubuntu-14.04-cloud"
}

variable "flavor" {
  default = "m2.large"
}

variable "ssh_key_file" {
  default = "~/.ssh/osic_rsa"
}

variable "external_gateway" {
  default  = "7004a83a-13d3-4dcd-8cf5-52af1ace4cae"
}

variable "floating_pool" {
  default = "GATEWAY_NET"
}

variable "redmine_version" {
  default = "3.3.0"
}
