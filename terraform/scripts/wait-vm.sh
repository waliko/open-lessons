#!/bin/bash

while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
	echo "Waiting for vm accessible"
	sleep 1
done
