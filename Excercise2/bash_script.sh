#!/bin/bash
if [[ $(which docker) && $(docker --version) ]]; then
    echo "Docker is already installed"

  else
    echo " Docker is not Installed on the system"
    sleep 2;
    echo "Installing Docker ........ "
    curl -sSL https://get.docker.com | sh
fi
