#!/bin/bash
# These is my Web user_data - Here I installed nginx and i wrote about simple index.html showing About Me
set -eux

if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [[ "$ID" == "amzn" || "$ID_LIKE" == *"rhel"* ]]; then
    yum update -y
    yum install -y nginx aws-cli
    systemctl enable nginx
    systemctl start nginx
  else
    apt-get update -y
    apt-get install -y nginx awscli
    systemctl enable nginx
    systemctl start nginx
  fi
fi

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

cat > /usr/share/nginx/html/index.html <<HTML
<html>
  <body>
    <h1>${project} Web (${name})</h1>
    <p>Instance ID: \$INSTANCE_ID</p>

    <h2>About Me</h2>
    <p>Hello! I am Kasula Pavan Kumar, a passionate developer from Andhra Pradesh, India. I enjoy building cloud infrastructure, automating deployments, and creating AI-powered applications. My goal is to continuously learn new technologies and implement them in practical projects.</p>

    <h3>Hobbies & Interests</h3>
    <ul>
      <li>Learning cloud platforms like AWS and GCP</li>
      <li>Developing AI and web applications</li>
      <li>Reading technology blogs and tutorials</li>
      <li>Solving programming challenges</li>
    </ul>
  </body>
</html>
HTML
