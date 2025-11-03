#!/bin/bash
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "<h1 style='color:green;'>Green Environment</h1>" > /var/www/html/index.html
