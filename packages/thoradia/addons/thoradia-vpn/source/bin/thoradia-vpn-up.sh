#!/bin/sh

ip addr flush dev "$dev"
ip addr add "$ifconfig_local/$ifconfig_netmask" dev "$dev"

ip route flush dev "$dev"
ip route add default dev "$dev" src "$ifconfig_local" table 1

ip rule add from "$ifconfig_local" table 1
ip rule add to "$ifconfig_local" table 1

echo "Rules:"
ip rule list
echo "Main Routing Table:"
ip route list
echo "Routing Table 1:"
ip route list table 1
