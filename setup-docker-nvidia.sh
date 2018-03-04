#!/bin/bash

if lspci | grep -i 'nvidia'
then
  echo "\nNVIDIA GPU is likely present."
else
  echo "\nError: Needs NVIDIA GPU but it is not found. Stopping ...\n"
  exit 1
fi

echo "\nChecking for the presence of NVIDIA drivers ..."
if ! nvidia-smi ; then
  echo "Warning: nvidia-smi is not installed or not working."

  apt-get update
  apt-get install -y curl build-essential

  curl -O -s http://us.download.nvidia.com/XFree86/Linux-x86_64/387.34/NVIDIA-Linux-x86_64-387.34.run
  sh ./NVIDIA-Linux-x86_64-387.34.run -a --ui=none --no-x-check && rm NVIDIA-Linux-x86_64-387.34.run

  echo "\nInstalled NVIDIA drivers."
else
  echo "NVIDIA driver is already installed."
fi

echo "\nChecking docker ..."
if ! [ -x "$(command -v docker)" ]; then
  echo "docker is not installed."
  apt-get -y install apt-transport-https ca-certificates curl
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update

  apt-get -y install docker-ce
  echo "\nInstalled docker."
else
  echo "docker is already installed."
fi
echo "\nChecking nvidia-docker ..."
if ! [ -x "$(command -v nvidia-docker)" ]; then
  echo "nvidia-docker is not installled."

  wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
  dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

  echo "\nInstalled nvidia-docker."
else 
  echo "nvidia-docker is already installed."
fi
echo "\nAll dependencies are installed."
echo "\nTry running: \n\tsudo nvidia-docker run --rm nvidia/cuda nvidia-smi\n"