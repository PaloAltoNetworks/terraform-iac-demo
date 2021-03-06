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


// DB-SERVER Variables
variable "db_name" {
  description = "The name of the database server instance"
  type        = string
}

variable "db_zone" {
  description = "The GCP zone in which the database server instance will be deployed"
  type        = string
}
variable "db_machine_type" {
  description = "The GCP machine type for the database server instance"
  type        = string
}

variable "db_ssh_key" {
  description = "The SSH key of the database server instance admin user"
  type        = string
}

variable "db_subnet_id" {
  description = "The subnet in which the database server instance will be deployed"
  type        = string
}

variable "db_image" {
  description = "The GCP image used to deploy the database server instance"
  type        = string
}
