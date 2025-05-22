#!/bin/bash

# Remove all switches
ovs-vsctl --if-exists del-br spine1
ovs-vsctl --if-exists del-br leaf1
ovs-vsctl --if-exists del-br leaf2 