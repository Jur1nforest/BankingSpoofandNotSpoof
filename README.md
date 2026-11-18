# DemoBank

Two offline pages show how a familiar banking screen can lead to different outcomes in a classroom simulation.

- `legitimate-bank/index.html` shows a successful sign-in.
- `spoofed-bank/index.html` shows a warning and explains how rogue DHCP settings can affect DNS.

# To Host on VM

Choose the specific cd to setup everything. The ip's of the dns server's in the test example should be preconfigured to forward to those addresses.

- `cd dhcp-spoofing-websites/spoofed-bank` or `cd dhcp-spoofing-websites/legitimate-bank`
- `sudo python3 -m http.server 80 --bind 0.0.0.0`

# To Sign in

Password for the legitimate is Username: student123 and Password: DemoPass123!