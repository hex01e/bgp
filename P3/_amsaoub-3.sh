#!/bin/sh
# Ensure loopback interface is administratively up.
ip link set lo up
# Assign VTEP loopback /32 used for router-id and VXLAN source.
ip addr add 1.1.1.3/32 dev lo
# Bring underlay uplink toward RR up.
ip link set eth0 up
# Set p2p underlay IP toward RR.
ip addr add 10.0.13.2/30 dev eth0

# Configure OSPF: set router-id and advertise loopback plus underlay uplink.
# OSPF cmd: enter global configuration mode.
# OSPF cmd: enter OSPF configuration context.
# OSPF cmd: set OSPF router-id to loopback IP.
# OSPF cmd: advertise loopback /32 in area 0.
# OSPF cmd: advertise underlay uplink subnet in area 0.
vtysh \
	-c "configure terminal" \
	-c "router ospf" \
	-c "ospf router-id 1.1.1.3" \
	-c "network 1.1.1.3/32 area 0" \
	-c "network 10.0.13.0/30 area 0"

# Configure BGP EVPN: RR neighbor, loopback source, activate EVPN, advertise VNIs.
# BGP cmd: enter global configuration mode.
# BGP cmd: enter BGP process for AS 100.
# BGP cmd: set BGP router-id to loopback IP.
# BGP cmd: define RR as iBGP neighbor.
# BGP cmd: source BGP session from loopback interface.
# BGP cmd: enter EVPN address-family.
# BGP cmd: activate EVPN for RR neighbor.
# BGP cmd: advertise all local VNIs in EVPN.
# BGP cmd: exit EVPN address-family.
vtysh \
	-c "configure terminal" \
	-c "router bgp 100" \
	-c "bgp router-id 1.1.1.3" \
	-c "neighbor 1.1.1.1 remote-as 100" \
	-c "neighbor 1.1.1.1 update-source lo" \
	-c "address-family l2vpn evpn" \
	-c "neighbor 1.1.1.1 activate" \
	-c "advertise-all-vni" \
	-c "exit-address-family"
# Create VXLAN interface vxlan10 (VNI 10, UDP 4789, local loopback source).
ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.3 nolearning
# Bring VXLAN interface up.
ip link set vxlan10 up
# Create Linux bridge br0.
ip link add br0 type bridge
# Bring bridge interface up.
ip link set br0 up
# Add VXLAN interface to bridge.
ip link set vxlan10 master br0
# Add host-facing access port eth1 to bridge.
ip link set eth1 master br0
# Bring host-facing access port up.
ip link set eth1 up