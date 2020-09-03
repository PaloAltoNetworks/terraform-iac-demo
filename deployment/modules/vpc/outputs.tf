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


output "mgmt_network" {
  value = google_compute_network.management-net.self_link
}

output "mgmt_subnet" {
  value = google_compute_subnetwork.management-sub.self_link
}

output "mgmt_subnet_cidr_block" {
  value = google_compute_subnetwork.management-sub.ip_cidr_range
}

output "untrust_network" {
  value = google_compute_network.untrust-net.self_link
}

output "untrust_subnet" {
  value = google_compute_subnetwork.untrust-sub.self_link
}

output "untrust_subnet_cidr_block" {
  value = google_compute_subnetwork.untrust-sub.ip_cidr_range
}

output "web_network" {
  value = google_compute_network.web-net.self_link
}

output "web_subnet" {
  value = google_compute_subnetwork.web-sub.self_link
}

output "web_subnet_cidr_block" {
  value = google_compute_subnetwork.web-sub.ip_cidr_range
}

output "db_network" {
  value = google_compute_network.db-net.self_link
}

output "db_subnet" {
  value = google_compute_subnetwork.db-sub.self_link
}

output "db_subnet_cidr_block" {
  value = google_compute_subnetwork.db-sub.ip_cidr_range
}

output "mgmt-allow-inbound-rule" {
  value = google_compute_firewall.mgmt-allow-inbound.self_link
}

output "untrust-allow-inbound-rule" {
  value = google_compute_firewall.untrust-allow-inbound.self_link
}

output "web-allow-outbound-rule" {
  value = google_compute_firewall.web-allow-outbound.self_link
}

output "db-allow-outbound-rule" {
  value = google_compute_firewall.db-allow-outbound.self_link
}
