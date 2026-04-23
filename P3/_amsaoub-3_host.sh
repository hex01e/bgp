#!/bin/sh
# Bring host interface up.
ip link set eth0 up
# Assign host IP address
ip addr add 20.1.1.3/24 dev eth0