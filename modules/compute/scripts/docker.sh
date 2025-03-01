#!/bin/bash

# Updating existent packages and refreshing the system´s repositories
echo "Updating packages and refreshing repositories"
sudo yum update -y

# Installing the most recent Docker package community edition
echo "Installing Docker"
sudo yum install -y docker

# Initializing the Docker service
echo "Starting Docker"
sudo service docker start

# Enabling the Docker service to start on boot
echo "Enabling Docker to start on boot"
sudo systemctl enable docker.service

# Adding the ec2-user to the docker group
echo "Adding ec2-user to the Docker group"
sudo usermod -a -G docker ec2-user

# Pulling the docker image
echo "Pulling the Docker image"
docker pull centos

# Running the docker image with the sleep command to keep the container running
echo "Running the Docker image"
docker run -d centos sleep 180

# Creating local directory to store the Jenkins data
echo "Creating Jenkins data directory"
mkdir /var/my-jenkins-data

# Running docker jenkins image and mapping container port 8080 to host port 8080
# Mapping jenkins_home to /var/my-jenkins-data
# The credentilas can be found in /var/jenkins_home/secrets/initialAdminPassword
echo "Running Jenkins Docker image"
docker run -p 8080:8080 -v /var/my-jenkins-data:/var/jenkins_home -u root jenkins/jenkins