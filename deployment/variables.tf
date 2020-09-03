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

############################################################################################
# PROJECT VARIABLES
############################################################################################
variable "project" {
  description = "Your GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region in which to deploy"
  type        = string
}

variable "zone" {
  description = "The GCP zone in which to deploy"
  type        = string
}

variable "gcp_credentials" {
  description = "Full path to the JSON credentials file"
  type        = string
}

variable "ssh_key" {
  description = "Full path to the SSH public key file"
  type        = string
}

variable "allowed_mgmt_cidr" {
  description = "The source address that will be allowed to access the lab environment"
  type        = string
  default     = "0.0.0.0/0"
}

variable "fw_name" {
  description = "Name for the firewall"
  type        = string
}

variable "panorama" {
  description = "Panorama hostname for bootstrap config"
  type        = string
}

variable "panorama2" {
  description = "Panorama hostname for bootstrap config"
  type        = string
  default     = ""
}

variable "template_stack" {
  description = "Panorama template stack for bootstrap config"
  type        = string
}

variable "device_group" {
  description = "Panorama device group for bootstrap config"
  type        = string
}

variable "vm_auth_key" {
  description = "Panorama VM auth key for bootstrap config"
  type        = string
}
