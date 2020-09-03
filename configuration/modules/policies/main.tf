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


// Panorama device group
resource "panos_panorama_device_group" "dg" {
  name = var.device_group
}

// Address objects
resource "panos_panorama_address_object" "web-srv" {
  name         = "web-srv"
  value        = "10.5.2.5"
  description  = "Web server"
  device_group = panos_panorama_device_group.dg.name
}

resource "panos_panorama_address_object" "db-srv" {
  name         = "db-srv"
  value        = "10.5.3.5"
  description  = "Database server"
  device_group = panos_panorama_device_group.dg.name
}

// Dynamic address groups
# resource "panos_panorama_address_group" "web-srvs-dag" {
#   name          = "web-srvs-dag"
#   description   = "Web servers DAG"
#   dynamic_match = "'gce-label.server-type.web'"
#   device_group  = panos_panorama_device_group.dg.name
# }

# resource "panos_panorama_address_group" "db-srvs-dag" {
#   name          = "db-srvs-dag"
#   description   = "Database servers DAG"
#   dynamic_match = "'gce-label.server-type.database'"
#   device_group  = panos_panorama_device_group.dg.name
# }

// Service objects
resource "panos_panorama_service_object" "service-tcp-221" {
  name             = "service-tcp-221"
  protocol         = "tcp"
  description      = "SSH on tcp/221"
  destination_port = "221"
  device_group     = panos_panorama_device_group.dg.name
}

resource "panos_panorama_service_object" "service-tcp-222" {
  name             = "service-tcp-222"
  protocol         = "tcp"
  description      = "SSH on tcp/222"
  destination_port = "222"
  device_group     = panos_panorama_device_group.dg.name
}

// Security rules
resource "panos_panorama_security_rule_group" "app-rules" {
  device_group = panos_panorama_device_group.dg.name
  rule {
    name                  = "Allow ping"
    source_zones          = ["any"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = ["any"]
    applications          = ["ping"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
  rule {
    name                  = "Allow SSH inbound"
    source_zones          = [var.zone_untrust]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [var.zone_web, var.zone_db]
    destination_addresses = ["any"]
    applications          = ["ssh"]
    services              = [panos_panorama_service_object.service-tcp-221.name, panos_panorama_service_object.service-tcp-222.name]
    categories            = ["any"]
    action                = "allow"
  }
  rule {
    name                  = "Allow web inbound"
    source_zones          = [var.zone_untrust]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [var.zone_web]
    destination_addresses = ["any"]
    applications          = ["web-browsing", "ssl", "blog-posting"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
  rule {
    name                  = "Allow web to db"
    source_zones          = [var.zone_web]
    source_addresses      = [panos_panorama_address_object.web-srv.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [var.zone_db]
    destination_addresses = [panos_panorama_address_object.db-srv.name]
    applications          = ["mysql"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
  rule {
    name                  = "Allow all outbound"
    source_zones          = [var.zone_web, var.zone_db]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [var.zone_untrust]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
}

// NAT rules
resource "panos_panorama_nat_rule_group" "app-nat" {
  device_group = panos_panorama_device_group.dg.name
  rule {
    name = "Web SSH"
    original_packet {
      source_zones          = [var.zone_untrust]
      destination_zone      = var.zone_untrust
      destination_interface = "any"
      source_addresses      = ["any"]
      destination_addresses = ["10.5.1.4"]
      service               = panos_panorama_service_object.service-tcp-221.name
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = var.interface_web
          }
        }
      }
      destination {
        static_translation {
          address = panos_panorama_address_object.web-srv.name
          port    = 22
        }
      }
    }
  }
  rule {
    name = "DB SSH"
    original_packet {
      source_zones          = [var.zone_untrust]
      destination_zone      = var.zone_untrust
      destination_interface = "any"
      source_addresses      = ["any"]
      destination_addresses = ["10.5.1.4"]
      service               = panos_panorama_service_object.service-tcp-222.name
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = var.interface_db
          }
        }
      }
      destination {
        static_translation {
          address = panos_panorama_address_object.db-srv.name
          port    = 22
        }
      }
    }
  }
  rule {
    name = "WordPress NAT"
    original_packet {
      source_zones          = [var.zone_untrust]
      destination_zone      = var.zone_untrust
      source_addresses      = ["any"]
      destination_addresses = ["10.5.1.4"]
      service               = "service-http"
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = var.interface_web
          }
        }
      }
      destination {
        static_translation {
          address = panos_panorama_address_object.web-srv.name
          port    = 80
        }
      }
    }
  }
  rule {
    name = "Outbound NAT"
    original_packet {
      source_zones          = [var.zone_web, var.zone_db]
      destination_zone      = var.zone_untrust
      source_addresses      = ["any"]
      destination_addresses = ["any"]
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = var.interface_untrust
          }
        }
      }
      destination {}
    }
  }
}
