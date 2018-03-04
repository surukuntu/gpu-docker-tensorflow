#### 1. Create a gpu instance on gcloud
```
gcloud compute instances create gpu-host-1 --machine-type n1-highmem-8  --zone us-west1-b --accelerator type=nvidia-tesla-k80,count=1 --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud --boot-disk-size 50GB --maintenance-policy TERMINATE --no-restart-on-failure
```

#### 2. SSH into the instance and install Nvidia drivers, Docker, Nvidia-Docker
```
gcloud compute ssh gpu-host-1
sudo sh setup-docker-nvidia.sh //copy this file on to the gpu machine and then execute
```

#### 3. Start the docker container 
Here we are using the container provided by Google. More info about the image here: https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/Dockerfile.gpu
```
sudo nvidia-docker run -it -p 8888:8888 -p 6006:6006 gcr.io/tensorflow/tensorflow:latest-gpu /bin/bash
```

#### 4. Start the jupyter notebook
```
jupyter notebook --ip=0.0.0.0 --no-browser --allow-root
```

#### 5. Connect to notebook from browser 
Ensure you have firewall rules correctly set up and access notebooks at below address. If you rather not open up the port to the public, you could use ssh tunneling. 
http://<<ip>>:8888/tree 

### Commands for stats

#### Gpu utilization stats
```
nvidia-smi --query-gpu=utilization.gpu,utilization.memory --format=csv -lms 500
```

#### Docker container stats 
```
sudo docker stats <<container-name>>
```

