#!/bin/bash

echo "Update apt"
sudo apt update

echo "Installing git"
apt install git -y

echo "Installing Java 8"
sudo apt-get install openjdk-8-jdk

echo "Installing Maven"
sudo apt-get install maven

echo "Installing AWS CLI"
sudo apt-get install awscli

echo "Install IntelliJ IDEA"
sudo snap install intellij-idea-community --classic

echo "Install Sublime Text"
sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt install sublime-text