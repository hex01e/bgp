# BGP Network Lab

This repository contains a collection of GNS3-based networking lab exercises focused on BGP, OSPF, VXLAN, and EVPN concepts. The project is structured as separate lab scenarios under the folders `P1`, `P2`, and `P3`, each representing a different network topology or learning objective.

## Overview

The labs demonstrate several routing and overlay networking patterns using FRR (Free Range Routing) and Linux networking primitives:

- BGP and OSPF configuration inside containerized routers
- VXLAN tunnel setup for Layer 2 extension
- EVPN with BGP route reflection
- Linux bridge and VXLAN integration for overlay networks

## Repository structure

```text
bgp/
├── P1/
│   ├── _houmanso-1_host
│   ├── _houmanso-2
│   └── P1.gns3project
├── P2/
│   ├── _ilasrarf-1_g
│   ├── _ilasrarf-1_host
│   ├── _ilasrarf-1_s
│   ├── _ilasrarf-2_g
│   ├── _ilasrarf-2_host
│   ├── _ilasrarf-2_s
│   └── P2.gns3project
├── P3/
│   ├── _amsaoub-1
│   ├── _amsaoub-1_host
│   ├── _amsaoub-2
│   ├── _amsaoub-2_host
│   ├── _amsaoub-3
│   ├── _amsaoub-3_host
│   ├── _amsaoub-4
│   └── P3.gns3project
└── README.md
```

## Scenario descriptions

### P1: Routing and BGP basics

This lab uses FRR-enabled Alpine containers and configures router interfaces, OSPF, and BGP. The scripts set up loopback addresses, advertise networks into OSPF, and build IBGP sessions using loopback-based peers.

Key characteristics:

- OSPF Area 0 configuration
- BGP AS 100
- Neighbor peering using loopback addresses
- EVPN activation in the BGP address-family

### P2: VXLAN overlay lab

This lab focuses on VXLAN tunnels and Linux bridges. There are two router variants:

- Dynamic multicast VXLAN (`*_g` files)
- Static VXLAN configuration (`*_s` files)

Both examples create a VXLAN interface (`vxlan10`), attach it to a bridge (`br0`), and connect host-facing interfaces to the same bridge. This provides a simple example of extending Layer 2 connectivity across nodes.

Key characteristics:

- `vxlan10` interface with VNI 10
- Bridge integration with `eth1`
- Multicast group `239.1.1.1` in the dynamic setup
- Static remote peer configuration in the static setup

### P3: EVPN and route-reflector topology

This scenario represents an EVPN-style design with a route-reflector architecture. The routers are configured with OSPF to establish connectivity, and then BGP is used to advertise EVPN routes with loopback-based peering.

Key characteristics:

- Loopback addresses per router (`1.1.1.1`, `2.2.2.2`, `3.3.3.3`, `4.4.4.4`)
- OSPF Area 0
- BGP AS 100
- EVPN address family enabled on all peers
- `advertise-all-vni` used to share VXLAN VNI information
- Route reflector behavior on the central router

## Prerequisites

To run or adapt these labs, you will typically need:

- GNS3 installed and configured
- Docker support for the FRR containerized routers
- Linux environment with bridge and VXLAN support
- Basic familiarity with OSPF, BGP, and overlay networking

## How to use the labs

1. Open the relevant `.gns3project` file in GNS3.
2. Start the topology for the scenario you want to study.
3. Inspect the startup scripts inside each generated node file (`_amsaoub-*`, `_ilasrarf-*`, etc.).
4. Verify neighbor relationships and routing information using FRR commands such as:

```bash
vtysh
show ip ospf neighbor
show ip bgp summary
show bgp l2vpn evpn
show evpn vni
```

## Useful verification commands

For a router running FRR, common checks include:

```bash
show ip route
show ip bgp summary
show ip ospf neighbor
show bgp l2vpn evpn
show running-config
```

These commands help confirm that:

- OSPF neighbors are up
- BGP sessions are established
- EVPN routes are exchanged correctly
- VXLAN endpoints are bridged as expected

## Notes

- These files are lab-oriented configuration examples and are designed for learning and experimentation.
- They are not intended as production-ready network baselines.
- The topologies can be used as references for building more advanced BGP/EVPN labs.

## Suggested next steps

- Compare the dynamic and static VXLAN examples in `P2`
- Trace how route reflection is implemented in `P3`
- Extend the topology with additional routers or hosts for multi-AS testing
- Validate end-to-end reachability between devices on connected bridges

This project is best used as a practical lab reference for understanding how modern routing and overlay technologies fit together in a Linux and FRR environment.
