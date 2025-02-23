#!/bin/bash

# Updating existent packages and refreshing the system´s repositories
echo "Updating packages and refreshing repositories"
sudo yum -y update

# Installing git
echo "Installing git"s
sudo yum -y install git

