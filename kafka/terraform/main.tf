variable "api_key" {}
variable "secret_key" {}
variable "private_key_file" {}
variable "public_key_file" {}
variable "installer_ip" {}

variable "domain" {}
variable "domain_ttl" {
  default = 600
}

variable "zone" {
  default = "at-vie-1"
}

#
# Kafka settings
#
variable "node_count" {
  default = 3
}
variable "node_size" {
  default = "Extra-large"
}
variable "node_disk" {
  default = 800
}

#
# Provider settings
#
provider "exoscale" {
  token = "${var.api_key}"
  secret = "${var.secret_key}"
}
provider "template" {}


#
# Modules
#
module "ssh" {
  source = "./ssh"
  public_key_file = "${var.public_key_file}"
}
module "dns" {
  source = "./dns"
  domain = "${var.domain}"
}
module "kafka" {
  source = "./kafka"
  private_key_file = "${var.private_key_file}"
  installer_ip = "${var.installer_ip}"
  zone = "${var.zone}"
  domain = "${module.dns.domain_name}"
  domain_ttl = "${var.domain_ttl}"
  node_count = "${var.node_count}"
  node_size = "${var.node_size}"
  node_disk = "${var.node_disk}"
}
