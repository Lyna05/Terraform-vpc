#!/bin/bash
# Update the package list
sudo yum update -y

# Install Docker
sudo amazon-linux-extras install docker -y

# Start Docker service
sudo service docker start

# Add the ec2-user to the docker group so you can execute Docker commands without using sudo
sudo usermod -a -G docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone the Feedback App repository
git clone https://github.com/atamankina/feedback-app.git /home/ec2-user/feedback-app

# Navigate to the app directory
cd /home/ec2-user/feedback-app

# Start the app using Docker Compose
sudo /usr/local/bin/docker-compose up -d
