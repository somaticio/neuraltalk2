#!/bin/bash

mkdir -p /data/models
mkdir -p /data/images

cd /data/models
# download the pretrained CPU model
axel -n 10 http://cs.stanford.edu/people/karpathy/neuraltalk2/checkpoint_v1_cpu.zip

# unzip it
unzip /data/models/checkpoint_v1_cpu.zip -d /data/models

