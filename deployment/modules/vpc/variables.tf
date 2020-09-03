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


variable "vpc_region" {
  description = "GCP region in which to deploy the network resources"
}

variable "vpc_mgmt_network_name" {
  description = "Management network name"
}

variable "vpc_mgmt_subnet_cidr" {
  description = "Management subnet netblock"
}

variable "vpc_mgmt_subnet_name" {
  description = "Management subnet name"
}

variable "vpc_untrust_network_name" {
  description = "Untrust network name"
}
variable "vpc_untrust_subnet_cidr" {
  description = "Untrust subnet netblock"
}

variable "vpc_untrust_subnet_name" {
  description = "Untrust subnet name"
}

variable "vpc_web_network_name" {
  description = "Web network name"
}

variable "vpc_web_subnet_cidr" {
  description = "Web subnet netblock"
}

variable "vpc_web_subnet_name" {
  description = "Web subnet name"
}

variable "vpc_db_network_name" {
  description = "Database network name"
}

variable "vpc_db_subnet_cidr" {
  description = "Database subnet netblock"
}

variable "vpc_db_subnet_name" {
  description = "Database subnet name"
}

variable "allowed_mgmt_cidr" {
  description = "The source address that will be allowed to access the lab environment"
  type        = string
  default     = "0.0.0.0/0"
}
