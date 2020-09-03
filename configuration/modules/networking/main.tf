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

//  Panorama template and template stack
resource "panos_panorama_template" "demo_template" {
  name = var.template
}

resource "panos_panorama_template_stack" "demo_stack" {
  name      = var.stack
  templates = [panos_panorama_template.demo_template.name]
}

// Ethernet interfaces
resource "panos_panorama_ethernet_interface" "untrust" {
  name                      = "ethernet1/1"
  comment                   = "untrust interface"
  vsys                      = "vsys1"
  mode                      = "layer3"
  enable_dhcp               = true
  create_dhcp_default_route = true
  template                  = panos_panorama_template.demo_template.name
}

resource "panos_panorama_ethernet_interface" "web" {
  name        = "ethernet1/2"
  comment     = "web interface"
  vsys        = "vsys1"
  mode        = "layer3"
  enable_dhcp = true
  template    = panos_panorama_template.demo_template.name
}

resource "panos_panorama_ethernet_interface" "db" {
  name        = "ethernet1/3"
  comment     = "database interface"
  vsys        = "vsys1"
  mode        = "layer3"
  enable_dhcp = true
  template    = panos_panorama_template.demo_template.name
}

// Virtual router
resource "panos_panorama_virtual_router" "lab_vr" {
  name = "lab_vr"
  interfaces = [
    panos_panorama_ethernet_interface.untrust.name,
    panos_panorama_ethernet_interface.web.name,
    panos_panorama_ethernet_interface.db.name
  ]
  template = panos_panorama_template.demo_template.name
}

// Static routes for GCP
resource "panos_panorama_static_route_ipv4" "outbound" {
  name           = "outbound"
  virtual_router = panos_panorama_virtual_router.lab_vr.name
  destination    = "0.0.0.0/0"
  interface      = panos_panorama_ethernet_interface.untrust.name
  next_hop       = "10.5.1.1"
  template       = panos_panorama_template.demo_template.name
}

resource "panos_panorama_static_route_ipv4" "to-web" {
  name           = "to-web"
  virtual_router = panos_panorama_virtual_router.lab_vr.name
  destination    = "10.5.2.0/24"
  interface      = panos_panorama_ethernet_interface.web.name
  next_hop       = "10.5.2.1"
  template       = panos_panorama_template.demo_template.name
}

resource "panos_panorama_static_route_ipv4" "to-db" {
  name           = "to-db"
  virtual_router = panos_panorama_virtual_router.lab_vr.name
  destination    = "10.5.3.0/24"
  interface      = panos_panorama_ethernet_interface.db.name
  next_hop       = "10.5.3.1"
  template       = panos_panorama_template.demo_template.name
}

// Security zones
resource "panos_panorama_zone" "untrust" {
  name       = "untrust-zone"
  mode       = "layer3"
  interfaces = [panos_panorama_ethernet_interface.untrust.name]
  template   = panos_panorama_template.demo_template.name
}

resource "panos_panorama_zone" "web" {
  name       = "web-zone"
  mode       = "layer3"
  interfaces = [panos_panorama_ethernet_interface.web.name]
  template   = panos_panorama_template.demo_template.name
}

resource "panos_panorama_zone" "db" {
  name       = "db-zone"
  mode       = "layer3"
  interfaces = [panos_panorama_ethernet_interface.db.name]
  template   = panos_panorama_template.demo_template.name
}
