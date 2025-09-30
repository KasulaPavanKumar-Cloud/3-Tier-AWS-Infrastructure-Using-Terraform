#!/bin/bash
# App user_data - installs a simple python HTTP server to simulate app
set -eux

if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [[ "$ID" == "amzn" || "$ID_LIKE" == *"rhel"* ]]; then
    yum update -y
    yum install -y python3
  else
    apt-get update -y
    apt-get install -y -y python3
  fi
fi

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
cat > /home/ec2-user/app.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes(f"App server on {INSTANCE_ID}", "utf-8"))
if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), H)
    server.serve_forever()
PY
nohup python3 /home/ec2-user/app.py &
