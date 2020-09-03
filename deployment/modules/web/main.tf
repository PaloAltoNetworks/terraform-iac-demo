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
# CREATE WEB SERVER INSTANCE
############################################################################################

resource "google_compute_instance" "webserver" {
  name                      = var.web_name
  zone                      = var.web_zone
  machine_type              = var.web_machine_type
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1

  // Adding METADATA Key Value pairs to WEB SERVER 
  metadata = {
    serial-port-enable     = true
    block-project-ssh-keys = false
    ssh-keys               = var.web_ssh_key
  }

  labels = {
    server-type = "web"
  }

  metadata_startup_script = file("${path.module}/../../scripts/webserver-startup.sh")

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  network_interface {
    subnetwork = var.web_subnet_id
    network_ip = var.web_ip
  }

  boot_disk {
    initialize_params {
      image = var.web_image
    }
  }
}
