# DemoBank

Two offline pages show how a familiar banking screen can lead to different outcomes in a DHCP Spoof simulation.

- `legitimate-bank/index.html` shows a successful sign-in.
- `spoofed-bank/index.html` shows a warning and explains how rogue DHCP settings can affect DNS.

# To Host on VM

Choose the specific cd to setup everything. The ip's of the dns server's in the test example should be preconfigured to forward to their own address since the real DHCP/DNS server and Spoof DHCP/DNS server will just be hosting their respected real/spoofed web server.

Configure each DNS server to have the relationship of DemoBank.test with their own IP. This way our spoof works no matter the DNS server or address.

- `cd dhcp-spoofing-websites/spoofed-bank` or `cd dhcp-spoofing-websites/legitimate-bank`
- `sudo python3 server.py --host 10.0.0.2` but replace 10.0.0.2 with the actual address

# To Sign in

Password for the legitimate is Username: student123 and Password: DemoPass123!
