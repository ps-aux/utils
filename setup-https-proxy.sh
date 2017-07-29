#/bin/env bash
set -e
if=w-ap
iptables -t nat -A PREROUTING -i ${if} -p tcp --dport 443 -j REDIRECT --to 8443



