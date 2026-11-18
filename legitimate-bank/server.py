
import argparse
from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import parse_qs

# Fictional test account only
DEMO_USERNAME = "student123"
DEMO_PASSWORD = "DemoPass123!"

class Handler(SimpleHTTPRequestHandler):
    def do_POST(self):
        if self.path != "/submit":
            self.send_error(404)
            return

        length = int(self.headers.get("Content-Length", 0))
        if length <= 0 or length > 2048:
            self.send_error(400, "Invalid request size")
            return

        data = self.rfile.read(length).decode("utf-8")
        form = parse_qs(data)

        username = form.get("username", [""])[0]
        password = form.get("password", [""])[0]

        # Only accept the real demo test account
        if username != DEMO_USERNAME or password != DEMO_PASSWORD:
            self.send_error(400, "Invalid demo credentials")
            return

        print("\n=== DEMO LOGIN RECEIVED ===")
        print(f"Username: {username}")
        print(f"Password: {password} (synthetic)")
        print("===========================\n", flush=True)

        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.end_headers()
        self.wfile.write(b"OK")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=80)
    args = parser.parse_args()

    server = HTTPServer((args.host, args.port), Handler)
    print(f"Serving on http://{args.host}:{args.port}")
    server.serve_forever()
