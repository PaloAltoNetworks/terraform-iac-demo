############################################################################################
# Copyright 2019 Palo Alto Networks.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
############################################################################################

terraform {
  required_version = ">= 0.12"
}

############################################################################################
# CONFIGURE THE PROVIDER AND SET AUTHENTICATION TO GCE API
############################################################################################

provider "google" {
  # credentials = base64decode(var.gcp_credentials)
  credentials = var.gcp_credentials
  project     = var.project
  region      = var.region
}

############################################################################################
# PROCESS EACH MODULE IN ORDER
############################################################################################

module "bootstrap" {
  source  = "PaloAltoNetworks/panos-bootstrap/google"
  version = "1.0.0"

  bootstrap_project = var.project
  bootstrap_region  = var.region

  hostname         = var.fw_name
  panorama-server  = var.panorama
  panorama-server2 = var.panorama2
  tplname          = var.template_stack
  dgname           = var.device_group
  vm-auth-key      = var.vm_auth_key
}

module "vpc" {
  source = "./modules/vpc"

  vpc_region = var.region

  vpc_mgmt_network_name = "management-network"
  vpc_mgmt_subnet_cidr  = "10.5.0.0/24"
  vpc_mgmt_subnet_name  = "management-subnet"

  vpc_untrust_network_name = "untrust-network"
  vpc_untrust_subnet_cidr  = "10.5.1.0/24"
  vpc_untrust_subnet_name  = "untrust-subnet"

  vpc_web_network_name = "web-network"
  vpc_web_subnet_cidr  = "10.5.2.0/24"
  vpc_web_subnet_name  = "web-subnet"

  vpc_db_network_name = "database-network"
  vpc_db_subnet_cidr  = "10.5.3.0/24"
  vpc_db_subnet_name  = "database-subnet"

  allowed_mgmt_cidr = var.allowed_mgmt_cidr
}

module "web" {
  source = "./modules/web"

  web_name         = "web-vm"
  web_zone         = var.zone
  web_machine_type = "n1-standard-1"
  web_ssh_key      = "admin:${var.ssh_key}"
  web_subnet_id    = module.vpc.web_subnet
  web_ip           = "10.5.2.5"
  web_image        = "debian-9"
}

module "db" {
  source = "./modules/db"

  db_name         = "db-vm"
  db_zone         = var.zone
  db_machine_type = "n1-standard-1"
  db_ssh_key      = "admin:${var.ssh_key}"
  db_subnet_id    = module.vpc.db_subnet
  db_ip           = "10.5.3.5"
  db_image        = "debian-9"
}

module "firewall" {
  source = "./modules/firewall"

  fw_name             = var.fw_name
  fw_zone             = var.zone
  fw_image            = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-flex-bundle2-1000"
  fw_machine_type     = "n1-standard-4"
  fw_machine_cpu      = "Intel Skylake"
  fw_bootstrap_bucket = module.bootstrap.bootstrap_name

  fw_ssh_key = "admin:${var.ssh_key}"

  fw_mgmt_subnet = module.vpc.mgmt_subnet
  fw_mgmt_ip     = "10.5.0.4"
  fw_mgmt_rule   = module.vpc.mgmt-allow-inbound-rule

  fw_untrust_subnet = module.vpc.untrust_subnet
  fw_untrust_ip     = "10.5.1.4"
  fw_untrust_rule   = module.vpc.untrust-allow-inbound-rule

  fw_web_subnet = module.vpc.web_subnet
  fw_web_ip     = "10.5.2.4"
  fw_web_rule   = module.vpc.web-allow-outbound-rule

  fw_db_subnet = module.vpc.db_subnet
  fw_db_ip     = "10.5.3.4"
  fw_db_rule   = module.vpc.db-allow-outbound-rule
}

############################################################################################
# CREATE ROUTES FOR WEB AND DB NETWORKS
############################################################################################

resource "google_compute_route" "web-route" {
  name                   = "web-route"
  dest_range             = "0.0.0.0/0"
  network                = module.vpc.web_network
  next_hop_instance      = module.firewall.firewall-instance
  next_hop_instance_zone = var.zone
  priority               = 100
}

resource "google_compute_route" "db-route" {
  name                   = "db-route"
  dest_range             = "0.0.0.0/0"
  network                = module.vpc.db_network
  next_hop_instance      = module.firewall.firewall-instance
  next_hop_instance_zone = var.zone
  priority               = 100
}

