#!/bin/bash

set -u

k3d cluster create webapp \
  --servers 1 \
  --agents 2 \
  -p "80:80@loadbalancer"
