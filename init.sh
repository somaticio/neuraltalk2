#!/bin/bash

mkdir -p /data/models
mkdir -p /data/images

cd /tmp
# download and unzip the pretrained CPU model
axel -n 10 http://cs.stanford.edu/people/karpathy/neuraltalk2/checkpoint_v1_cpu.zip
unzip /tmp/checkpoint_v1_cpu.zip -d /data/models

# get GPU model checkpoint
axel -n 10 http://cs.stanford.edu/people/karpathy/neuraltalk2/checkpoint_v1.zip
unzip /tmp/checkpoint_v1.zip -d /data/models

