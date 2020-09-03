#!/usr/bin/env bash

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

# For use on Debian 9 (Stretch) servers

# Check for Internet connectivity
while true
    do 
        resp=$(curl -s -S "http://captive.apple.com")
	echo $resp
        if [[ $resp == *"Success"* ]] ; then
            break
        fi
        sleep 10s
    done

# Install and configure web server
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq apache2 wordpress
sudo ln -sf /usr/share/wordpress /var/www/html/wordpress
sudo cat > /etc/wordpress/config-default.php << EOF
<?php
# Created by /usr/share/doc/wordpress/examples/setup-mysql 
define('DB_NAME', 'Demo');
define('DB_USER', 'demouser');
define('DB_PASSWORD', 'paloalto@123');
define('DB_HOST', '10.5.3.5');
define('SECRET_KEY', 'UtqouIbh65q92QYevFJzth5Kuya3GKozJzmOq4Mv0mevSmgtlW');
define('WP_CONTENT_DIR', '/var/lib/wordpress/wp-content');
?>
EOF
sudo chown root:www-data /etc/wordpress/config-default.php
sudo systemctl restart apache2
