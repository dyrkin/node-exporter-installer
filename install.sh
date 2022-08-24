#!/bin/bash

[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

VERSION=1.3.1

ARCH=""

if [[ "$(uname -m)" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$(uname -m)" == "aarch64" ]]; then
  ARCH="arm64"
else
  echo "unsupported system $(uname -m)" && exit 1
fi


wget -O node_exporter.tar.gz https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-$VERSION.linux-$ARCH.tar.gz
tar xvf node_exporter.tar.gz
mv node_exporter-*/node_exporter /usr/local/bin/node-exporter

useradd -rs /bin/false node-exporter

echo '[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node-exporter
Group=node-exporter
Type=simple
ExecStart=/usr/local/bin/node-exporter

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/node-exporter.service


systemctl daemon-reload
systemctl restart node-exporter

sudo rm -rf node_exporter*
