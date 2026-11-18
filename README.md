# DemoBank

Two offline pages show how a familiar banking screen can lead to different outcomes in a DHCP Spoof simulation.

- `legitimate-bank/index.html` shows a successful sign-in.
- `spoofed-bank/index.html` shows a warning and explains how rogue DHCP settings can affect DNS.

# To Host on VM

Choose the specific cd to setup everything. The ip's of the dns server's in the test example should be preconfigured to forward to their own address since the real DHCP/DNS server and Spoof DHCP/DNS server will just be hosting their respected real/spoofed web server.

Configure each DNS server to have the relationship of DemoBank.test with their own IP. This way our spoof works no matter the DNS server or address.

- For "real" bank: `(cd legitimate-bank && sudo python3 -u server.py --host 192.168.9.84)` but change the ip with the vm's ifconfig ip
- For "Spoof" bank: `(cd spoofed-bank && sudo python3 -u server.py --host 192.168.9.84)` but change the ip with the vm's ifconfig ip

also make sure you do not have `` in your terminal command. This will allow python print to buffer failing to show the server logs.

# To Sign in

Password for the legitimate is Username: student123 and Password: DemoPass123!
