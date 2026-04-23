#!/bin/sh

# Ensure loopback interface is administratively up.
ip link set lo up
# Assign RR loopback /32 used for router-id and iBGP peering endpoint.
ip addr add 1.1.1.1/32 dev lo
# Bring underlay link toward leaf 2 up.
ip link set eth0 up
# Set p2p underlay IP toward leaf 2.
ip addr add 10.0.12.1/30 dev eth0
# Bring underlay link toward leaf 3 up.
ip link set eth1 up
# Set p2p underlay IP toward leaf 3.
ip addr add 10.0.13.1/30 dev eth1
# Bring underlay link toward leaf 4 up.
ip link set eth2 up
# Set p2p underlay IP toward leaf 4.
ip addr add 10.0.14.1/30 dev eth2

# Configure OSPF: set router-id and advertise loopback plus all underlay links.
# OSPF cmd: enter global configuration mode.
# OSPF cmd: enter OSPF configuration context.
# OSPF cmd: set OSPF router-id to loopback IP.
# OSPF cmd: advertise loopback /32 in area 0.
# OSPF cmd: advertise link subnet to leaf 2 in area 0.
# OSPF cmd: advertise link subnet to leaf 3 in area 0.
# OSPF cmd: advertise link subnet to leaf 4 in area 0.
vtysh \
	-c "configure terminal" \
	-c "router ospf" \
	-c "ospf router-id 1.1.1.1" \
	-c "network 1.1.1.1/32 area 0" \
	-c "network 10.0.12.0/30 area 0" \
	-c "network 10.0.13.0/30 area 0" \
	-c "network 10.0.14.0/30 area 0"

# Configure BGP EVPN RR: neighbors, loopback update-source, activate EVPN, and mark RR clients.
# BGP cmd: enter global configuration mode.
# BGP cmd: enter BGP process for AS 100.
# BGP cmd: set BGP router-id to loopback IP.
# BGP cmd: define leaf 2 as iBGP neighbor.
# BGP cmd: source sessions to leaf 2 from loopback.
# BGP cmd: define leaf 3 as iBGP neighbor.
# BGP cmd: source sessions to leaf 3 from loopback.
# BGP cmd: define leaf 4 as iBGP neighbor.
# BGP cmd: source sessions to leaf 4 from loopback.
# BGP cmd: enter EVPN address-family.
# BGP cmd: activate EVPN for leaf 2.
# BGP cmd: mark leaf 2 as route-reflector client.
# BGP cmd: activate EVPN for leaf 3.
# BGP cmd: mark leaf 3 as route-reflector client.
# BGP cmd: activate EVPN for leaf 4.
# BGP cmd: mark leaf 4 as route-reflector client.
# BGP cmd: exit EVPN address-family.
vtysh \
	-c "configure terminal" \
	-c "router bgp 100" \
	-c "bgp router-id 1.1.1.1" \
	-c "neighbor 1.1.1.2 remote-as 100" \
	-c "neighbor 1.1.1.2 update-source lo" \
	-c "neighbor 1.1.1.3 remote-as 100" \
	-c "neighbor 1.1.1.3 update-source lo" \
	-c "neighbor 1.1.1.4 remote-as 100" \
	-c "neighbor 1.1.1.4 update-source lo" \
	-c "address-family l2vpn evpn" \
	-c "neighbor 1.1.1.2 activate" \
	-c "neighbor 1.1.1.2 route-reflector-client" \
	-c "neighbor 1.1.1.3 activate" \
	-c "neighbor 1.1.1.3 route-reflector-client" \
	-c "neighbor 1.1.1.4 activate" \
	-c "neighbor 1.1.1.4 route-reflector-client" \
	-c "exit-address-family"