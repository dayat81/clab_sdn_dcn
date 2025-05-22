# Simple SDN Topology

This repository contains a simple Software-Defined Networking (SDN) topology using Containerlab and Ryu controller. The topology consists of two hosts connected through a leaf-spine network architecture.

## Topology Overview

```
                    [spine1]
                      /   \
                     /     \
                    /       \
              [leaf1]     [leaf2]
                 |          |
                 |          |
                [h1]       [h2]
```

- **Hosts**: Two hosts (h1, h2) with IP addresses 192.168.1.1 and 192.168.1.2 respectively
- **Switches**: 
  - Two leaf switches (leaf1, leaf2)
  - One spine switch (spine1)
- **Controller**: Ryu SDN controller with FlowManager application

## Prerequisites

- Python 3.9
- Docker
- Containerlab
- Open vSwitch

## Setup Instructions

1. Create and activate Python virtual environment:
   ```bash
   python3.9 -m venv venv39
   source venv39/bin/activate
   ```

2. Install Ryu and required dependencies:
   ```bash
   pip install ryu eventlet==0.30.2
   ```

3. Deploy the topology using Containerlab:
   ```bash
   sudo containerlab deploy -t simple_topology.yaml
   ```

4. Start the Ryu controller with FlowManager:
   ```bash
   source venv39/bin/activate
   ryu-manager --observe-links --ofp-listen-host 0.0.0.0 flowmanager/flowmanager.py ryu.app.simple_switch_13
   ```

## Accessing the Web GUI

The FlowManager web interface is available at:
```
http://localhost:8080/home/topology.html
```

The web GUI provides:
- Network topology visualization
- Flow monitoring
- Switch statistics
- Port statistics

## Testing Connectivity

To test connectivity between hosts:
```bash
# Ping from h1 to h2
docker exec clab-simple-sdn-h1 ping -c 4 192.168.1.2

# Ping from h2 to h1
docker exec clab-simple-sdn-h2 ping -c 4 192.168.1.1
```

## Network Configuration

### Host IP Addresses
- h1: 192.168.1.1/24
- h2: 192.168.1.2/24

### Switch Controller Connection
All switches are configured to connect to the Ryu controller at:
```
tcp:127.0.0.1:6633
```

## Troubleshooting

If hosts cannot communicate:
1. Verify controller is running:
   ```bash
   ps aux | grep ryu-manager
   ```

2. Check switch-controller connections:
   ```bash
   sudo ovs-vsctl show
   ```

3. Reset controller connections if needed:
   ```bash
   sudo ovs-vsctl del-controller leaf1
   sudo ovs-vsctl del-controller leaf2
   sudo ovs-vsctl del-controller spine1
   sudo ovs-vsctl set-controller leaf1 tcp:127.0.0.1:6633
   sudo ovs-vsctl set-controller leaf2 tcp:127.0.0.1:6633
   sudo ovs-vsctl set-controller spine1 tcp:127.0.0.1:6633
   ```

## Cleanup

To destroy the topology:
```bash
sudo containerlab destroy -t simple_topology.yaml
```
