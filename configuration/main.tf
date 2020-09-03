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

terraform {
  required_providers {
    panos = {
      version = "1.6.3"
    }
  }
}

module "networking" {
  source = "./modules/networking"

  template = var.template
  stack    = var.stack
}

module "policies" {
  source = "./modules/policies"

  device_group = var.device_group

  zone_untrust = module.networking.zone_untrust
  zone_web     = module.networking.zone_web
  zone_db      = module.networking.zone_db

  interface_untrust = module.networking.interface_untrust
  interface_web     = module.networking.interface_web
  interface_db      = module.networking.interface_db

}

# ** Not supported on Terraform Cloud **
# resource "null_resource" "commit_panorama" {
#     provisioner "local-exec" {
#         command = "./commit"
#     }
#     depends_on = [
#         module.policies.security_rule_group,
#         module.policies.nat_rule_group
#     ]
# }
