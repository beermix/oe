#!/bin/sh

. /etc/profile
oe_setup_addon service.thoradia-vpn

if [ ! -f "$vpn_conf" -o -z "$vpn_pass" -o -z "$vpn_user" ]; then
  exit 0
fi

path_work="/tmp/thoradia-vpn"
path_auth="$path_work/auth"
path_conf="$path_work/conf"

rm -fr "$path_work"
mkdir -p "$path_work"

cat > "$path_auth" << EOF
$vpn_user
$vpn_pass
EOF

sed '/^ *auth-user-pass/d; /^ *dev /d' "$vpn_conf" > "$path_conf"

# Prevents VPN Manager for OpenVPN from stopping this service
cp /bin/openvpn "$ADDON_DIR/bin/thoradia-vpn"

nice -n "$vpn_nice" \
thoradia-vpn --auth-user-pass "$path_auth" \
             --config "$path_conf" \
             --dev thoradia-vpn \
             --dev-type tun \
             --down "$ADDON_DIR/bin/thoradia-vpn-down.sh" \
             --route-noexec \
             --script-security 2 \
             --up "$ADDON_DIR/bin/thoradia-vpn-up.sh"
