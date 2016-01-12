#!bin/bash

mkdir -p /data/models
mkdir -p /data/images

# download the pretrained CPU model
wget http://cs.stanford.edu/people/karpathy/neuraltalk2/checkpoint_v1_cpu.zip -P /data/models

# unzip it
unzip /data/models/checkpoint_v1_cpu.zip

