#!/usr/bin/env bash
set -u

pass=0
fail=0

ok() {
  printf '[PASS] %s\n' "$1"
  pass=$((pass + 1))
}

bad() {
  printf '[FAIL] %s\n' "$1"
  fail=$((fail + 1))
}

echo "DNS/NTP appliance local validation"
echo "=================================="

if sudo unbound-checkconf >/dev/null 2>&1; then
  ok "Unbound configuration parses"
else
  bad "Unbound configuration failed validation"
fi

if systemctl is-active --quiet unbound; then
  ok "Unbound service is active"
else
  bad "Unbound service is not active"
fi

if command -v dig >/dev/null 2>&1 && dig @127.0.0.1 example.com A +time=3 +tries=1 >/dev/null 2>&1; then
  ok "Local recursive DNS query succeeds"
else
  bad "Local recursive DNS query failed"
fi

if sudo chronyd -p >/dev/null 2>&1; then
  ok "Chrony configuration parses"
else
  bad "Chrony configuration failed validation"
fi

if systemctl is-active --quiet chrony; then
  ok "Chrony service is active"
else
  bad "Chrony service is not active"
fi

if chronyc tracking 2>/dev/null | grep -q "Leap status.*Normal"; then
  ok "Chrony reports normal leap status"
else
  bad "Chrony does not report normal leap status"
fi

if sysctl -n net.ipv4.ip_forward 2>/dev/null | grep -qx '0'; then
  ok "IPv4 forwarding is disabled"
else
  bad "IPv4 forwarding is enabled or unreadable"
fi

if sysctl -n net.ipv6.conf.all.forwarding 2>/dev/null | grep -qx '0'; then
  ok "IPv6 forwarding is disabled"
else
  bad "IPv6 forwarding is enabled or unreadable"
fi

echo
printf 'Summary: %d passed, %d failed\n' "$pass" "$fail"

if [ "$fail" -ne 0 ]; then
  exit 1
fi
