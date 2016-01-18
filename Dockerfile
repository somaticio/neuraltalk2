FROM somatic/cuda
ENV DEBIAN_FRONTEND noninteractive
#ADD * /home/ubuntu/experiment/    <--- this should work,its a bug with docker https://github.com/docker/docker/issues/18396
RUN cd /home/ubuntu/ && wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
RUN cd /home/ubuntu &&  dpkg -i cuda-repo-ubuntu1404_7.5-18_amd64.deb
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y opencl-headers build-essential protobuf-compiler \
    libprotoc-dev libboost-all-dev libleveldb-dev hdf5-tools libhdf5-serial-dev \
    libopencv-core-dev  libopencv-highgui-dev libsnappy-dev libsnappy1 \
    libatlas-base-dev cmake libstdc++6-4.8-dbg libgoogle-glog0 libgoogle-glog-dev \
    libgflags-dev liblmdb-dev git python-pip gfortran
RUN apt-get clean
RUN apt-get install -y linux-image-extra-`uname -r` linux-headers-`uname -r` linux-image-`uname -r`
RUN apt-get install -y cuda
RUN export CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" && /home/ubuntu/torch/install/bin/luarocks install nngraph
RUN export CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" && /home/ubuntu/torch/install/bin/luarocks install optim
RUN export CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" && /home/ubuntu/torch/install/bin/luarocks install nn
RUN export CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" && /home/ubuntu/torch/install/bin/luarocks install cutorch
RUN export CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" && /home/ubuntu/torch/install/bin/luarocks install cunn
RUN export CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" && /home/ubuntu/torch/install/bin/luarocks install image
RUN export CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" && /home/ubuntu/torch/install/bin/luarocks install torch
RUN apt-get install -y libprotobuf-dev protobuf-compiler jq
RUN git clone https://github.com/somaticio/neuraltalk2 /home/ubuntu/experiment
ADD .docker-experimentconfig /home/ubuntu/experiment/.experimentconfig
RUN apt-get -y install libhdf5-dev hdf5-tools python-dev python-pip
RUN pip install cython numpy h5py
RUN export CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda" && /home/ubuntu/torch/install/bin/luarocks install hdf5
RUN pip install boto flask jinja2 markupsafe werkzeug futures itsdangerous requests wsgiref pyyaml py-cpuinfo psutil
RUN cd /home/ubuntu/somaticagent/ && git pull
RUN cd /home/ubuntu/experiment && git pull #use this to force an update
RUN apt-get install axel
RUN cd /tmp && wget http://www.linos.es/cudnn-7.0-linux-x64-v3.0-prod.tgz
RUN cd /usr/local &&tar xzvf /tmp/cudnn-7.0-linux-x64-v3.0-prod.tgz
RUN python /home/ubuntu/somaticagent/web.py -i

