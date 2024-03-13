#!/usr/bin/env bash

set -e

sudo usermod -aG docker containerapps 
newgrp docker
