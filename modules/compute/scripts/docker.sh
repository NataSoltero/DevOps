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

# Adding the ec2-user to the docker group
echo "Adding ec2-user to the Docker group"
sudo usermod -a -G docker ec2-user