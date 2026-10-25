#!/usr/bin/env bash
# Run this script INSIDE the bastion SSH session.
# Update the target IPs if your EC2 private IP addresses have changed.
set -u

APP_A_IP="${APP_A_IP:-28.0.2.184}"
APP_B_IP="${APP_B_IP:-28.200.1.177}"
PORT="${PORT:-22}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-5}"

test_tcp() {
  local target_ip="$1"
  local label="$2"

  printf '\nTesting TCP %s to %s (%s)...\n' "$PORT" "$label" "$target_ip"
  if timeout "$TIMEOUT_SECONDS" bash -c "cat < /dev/null > /dev/tcp/${target_ip}/${PORT}"; then
    echo "PASS: TCP connection succeeded."
  else
    echo "FAIL: TCP connection failed or timed out."
  fi
}

test_tcp "$APP_A_IP" "App-A"
test_tcp "$APP_B_IP" "App-B"

echo
echo "Note: TCP success confirms port reachability, not SSH authentication."
echo "If ping fails, check ICMP rules separately; ping alone does not prove peering is broken."
