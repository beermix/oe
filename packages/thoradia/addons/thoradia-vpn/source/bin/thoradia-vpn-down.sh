#!/bin/sh

ip rule del from "$ifconfig_local" table 1
ip rule del to "$ifconfig_local" table 1
