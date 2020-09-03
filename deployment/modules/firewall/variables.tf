# The MIT License (MIT)
#
# Copyright (c) 2020,  Palo Alto Networks, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


// FIREWALL Variables
variable "fw_name" {
  description = "The name of the firewall instance"
  type        = string
}

variable "fw_zone" {
  description = "The GCP zone in which the firewall instance will be deployed"
  type        = string
}

variable "fw_image" {
  description = "The GCE image for the firewall instance"
  type        = string
}

variable "fw_machine_type" {
  description = "The GCE machine type for the firewall instance"
  type        = string
}

variable "fw_machine_cpu" {
  description = "The GCE machine minumum CPU size for the firewall instance"
  type        = string
}

variable "fw_bootstrap_bucket" {
  description = "The GCP storage bucket containing the firewall bootstrap package"
  type        = string
}

variable "fw_ssh_key" {
  description = "The SSH key used for the firewall admin user"
  type        = string
}

variable "fw_mgmt_subnet" {
  description = "The management subnet of the firewall instance"
  type        = string
}

variable "fw_mgmt_ip" {
  description = "The IP address of firewall instance management interface"
  type        = string
}

variable "fw_mgmt_rule" {
  description = "The GCP firewall rule for the firewall intance management interface"
  type        = string
}

variable "fw_untrust_subnet" {
  description = "The untrust subnet of the firewall instance"
  type        = string
}

variable "fw_untrust_ip" {
  description = "The IP address of firewall instance untrust interface"
  type        = string
}

variable "fw_untrust_rule" {
  description = "The GCP firewall rule for the firewall intance untrust interface"
  type        = string
}

variable "fw_web_subnet" {
  description = "The web subnet of the firewall instance"
  type        = string
}

variable "fw_web_ip" {
  description = "The IP address of firewall instance web interface"
  type        = string
}

variable "fw_web_rule" {
  description = "The GCP firewall rule for the firewall intance web interface"
  type        = string
}

variable "fw_db_subnet" {
  description = "The database subnet of the firewall instance"
  type        = string
}

variable "fw_db_ip" {
  description = "The IP address of firewall instance database interface"
  type        = string
}

variable "fw_db_rule" {
  description = "The GCP firewall rule for the firewall intance database interface"
  type        = string
}
