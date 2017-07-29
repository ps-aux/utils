#/bin/env bash

# Splis WLAN NIC to two interfaces and uses one as access point another one as regular WLAN adapter
# WARNING: Contains harcoded values as NIC names and IP ranges. NIC must support this 'dual' mode.

set -e
physical_nic=wlp4s0

sta=w-sta
ap=w-ap

ssid="Lidl pokladna #2"
passwd="pomarance"

iw dev ${physical_nic} interface add ${sta} type managed addr 12:34:56:78:ab:cd
iw dev ${physical_nic} interface add ${ap}  type managed addr 12:34:56:78:ab:ce

# Turn off the original one
ip link set dev ${physical_nic} down

# Manually setup sta
echo "Setting up sta interface ${sta}"
ip link set dev ${sta} up
wpa_supplicant -i  ${sta} -c <(wpa_passphrase "${ssid}" "${passwd}")
dhcpd ${sta}

echo "Setting up ap interface ${ap}"
# TODO why this is not necessary and why is it already up ??
#ip link set dev ${ap} up
ip addr add 10.0.0.1/24 broadcast 10.0.0.255 dev ${ap}

echo "Starting up hostapd"
systemctl start hostapd

echo "Starting up dnsmasq"
systemctl start dnsmasq

#Setup NAT
echo "Setting up forwarind from ${ap} -> ${sta}"
sysctl net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o w-sta -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i w-ap -o w-sta -j ACCEPT



