#!/bin/bash

# Global Settings
SPINE1=spine1
LEAF1=leaf1
LEAF2=leaf2

IP_CTRL=172.17.0.3
IP_PORT=6633

OF_VER=OpenFlow13
FAIL_MODE=secure

echo Create switches
ovs-vsctl --may-exist add-br $SPINE1
ovs-vsctl --may-exist add-br $LEAF1
ovs-vsctl --may-exist add-br $LEAF2

echo Set MAC address
ovs-vsctl set bridge $SPINE1 other-config:hwaddr=00:00:00:00:00:0B
ovs-vsctl set bridge $LEAF1 other-config:hwaddr=00:00:00:00:00:15
ovs-vsctl set bridge $LEAF2 other-config:hwaddr=00:00:00:00:00:16

echo Connect switches
ovs-vsctl --may-exist add-port $SPINE1 sl1 -- set interface sl1 type=patch options:peer=ls1
ovs-vsctl --may-exist add-port $SPINE1 sl2 -- set interface sl2 type=patch options:peer=ls2

ovs-vsctl --may-exist add-port $LEAF1 ls1 -- set interface ls1 type=patch options:peer=sl1
ovs-vsctl --may-exist add-port $LEAF2 ls2 -- set interface ls2 type=patch options:peer=sl2

echo Set switch options
for BR in $SPINE1 $LEAF1 $LEAF2
do
  ovs-vsctl set bridge $BR fail_mode=$FAIL_MODE
  ovs-vsctl set bridge $BR protocols=$OF_VER
  ovs-vsctl set-controller $BR tcp:$IP_CTRL:$IP_PORT
done 