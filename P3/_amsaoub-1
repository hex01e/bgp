#!/bin/sh

# ip set loopback interface up.
ip link set lo up
# ip add loopback /32 for router id and bgp source.
ip addr add 1.1.1.1/32 dev lo
# ip set link eth0 up.
ip link set eth0 up
# ip add p2p address on eth0.
ip addr add 10.0.12.1/30 dev eth0
# ip set link eth1 up.
ip link set eth1 up
# ip add p2p address on eth1.
ip addr add 10.0.13.1/30 dev eth1
# ip set link eth2 up.
ip link set eth2 up
# ip add p2p address on eth2.
ip addr add 10.0.14.1/30 dev eth2

# ip ospf enter global config mode.
# ip ospf enter router ospf mode.
# ip ospf set router id.
# ip ospf advertise loopback /32 in area 0.
# ip ospf advertise subnet 10.0.12.0/30 in area 0.
# ip ospf advertise subnet 10.0.13.0/30 in area 0.
# ip ospf advertise subnet 10.0.14.0/30 in area 0.
vtysh \
	-c "configure terminal" \
	-c "router ospf" \
	-c "ospf router-id 1.1.1.1" \
	-c "network 1.1.1.1/32 area 0" \
	-c "network 10.0.12.0/30 area 0" \
	-c "network 10.0.13.0/30 area 0" \
	-c "network 10.0.14.0/30 area 0"

# ip bgp enter global config mode.
# ip bgp enter router bgp 100 mode.
# ip bgp set router id.
# ip bgp add neighbor 1.1.1.2.
# ip bgp use loopback as source for 1.1.1.2.
# ip bgp add neighbor 1.1.1.3.
# ip bgp use loopback as source for 1.1.1.3.
# ip bgp add neighbor 1.1.1.4.
# ip bgp use loopback as source for 1.1.1.4.
# ip bgp enter evpn address family.
# ip bgp activate evpn for 1.1.1.2.
# ip bgp set 1.1.1.2 as rr client.
# ip bgp activate evpn for 1.1.1.3.
# ip bgp set 1.1.1.3 as rr client.
# ip bgp activate evpn for 1.1.1.4.
# ip bgp set 1.1.1.4 as rr client.
# ip bgp exit evpn address family.
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