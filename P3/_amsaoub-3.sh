#!/bin/sh
# ip set loopback interface up.
ip link set lo up
# ip add loopback /32 for router id and vxlan source.
ip addr add 1.1.1.3/32 dev lo
# ip set link to rr up.
ip link set eth0 up
# ip add p2p address to rr link.
ip addr add 10.0.13.2/30 dev eth0

# ip ospf enter global config mode.
# ip ospf enter router ospf mode.
# ip ospf set router id.
# ip ospf advertise loopback /32 in area 0.
# ip ospf advertise rr link subnet in area 0.
vtysh \
	-c "configure terminal" \
	-c "router ospf" \
	-c "ospf router-id 1.1.1.3" \
	-c "network 1.1.1.3/32 area 0" \
	-c "network 10.0.13.0/30 area 0"

# ip bgp enter global config mode.
# ip bgp enter router bgp 100 mode.
# ip bgp set router id.
# ip bgp add rr neighbor.
# ip bgp use loopback as source.
# ip bgp enter evpn address family.
# ip bgp activate evpn for rr neighbor.
# ip bgp advertise all vni.
# ip bgp exit evpn address family.
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
# ip create vxlan interface vni 10.
ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.3 nolearning
# ip set vxlan interface up.
ip link set vxlan10 up
# ip create bridge br0.
ip link add br0 type bridge
# ip set bridge br0 up.
ip link set br0 up
# ip add vxlan interface to bridge.
ip link set vxlan10 master br0
# ip add host port eth1 to bridge.
ip link set eth1 master br0
# ip set host port eth1 up.
ip link set eth1 up