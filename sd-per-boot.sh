#!/bin/bash
echo "### started execution of per-boot script"
cd /home/ubuntu/setup/stable-diffusion-webui
#python3 -m venv venv
echo "activating environment"
source venv/bin/activate
echo " environment activated"
TORCH_COMMAND='pip3 install torch torchvision --extra-index-url https://download.pytorch.org/whl/rocm5.1.1' 
echo "torch params set"
COMMANDLINE_ARGS='--skip-torch-cuda-test'
echo "cuda params set"
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 7860
echo "port redirected from 80 to 7860"
echo "launcing stable diffusion app"
#ISGPU=$(sudo lshw -C display | wc -c)
ISGPU=$(sudo nvidia-smi |grep "NVIDIA-SMI has failed"|wc -c)
if [ $ISGPU -eq 0 ]
then
        echo "gpu instance"
        python3 launch.py --precision full --no-half  --listen --enable-insecure-extension-access --api #for cpu based instances
else
	echo "not a  gpu instance"
	python3 launch.py --precision full --no-half --skip-torch-cuda-test --listen --enable-insecure-extension-access --api #for nvidia gpu based instances
fi	
echo "app launched"

echo "### completed execution of per-boot script"
