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
# CREATE VM-SERIES INSTANCE
############################################################################################

resource "google_compute_instance" "firewall" {
  name                      = var.fw_name
  zone                      = var.fw_zone
  machine_type              = var.fw_machine_type
  min_cpu_platform          = var.fw_machine_cpu
  can_ip_forward            = true
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.fw_image
    }
  }

  metadata = {
    vmseries-bootstrap-gce-storagebucket = var.fw_bootstrap_bucket
    serial-port-enable                   = true
    block-project-ssh-keys               = true
    ssh-keys                             = var.fw_ssh_key
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = var.fw_mgmt_subnet
    network_ip = var.fw_mgmt_ip
    access_config {
      // Needed to get a public IP address
    }
  }

  network_interface {
    subnetwork = var.fw_untrust_subnet
    network_ip = var.fw_untrust_ip
    access_config {
      // Needed to get a public IP address
    }
  }

  network_interface {
    subnetwork = var.fw_web_subnet
    network_ip = var.fw_web_ip
  }

  network_interface {
    subnetwork = var.fw_db_subnet
    network_ip = var.fw_db_ip
  }
}
