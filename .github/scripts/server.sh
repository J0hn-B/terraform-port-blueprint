#!/usr/bin/env bash

# This script is used to start all components needed to run locally.

set -e

# # #  WSL  # # #

# Start Docker Desktop if it's not running
if ! docker ps -q; then
    powershell.exe "Start-Process -FilePath 'C:\Program Files\Docker\Docker\Docker Desktop.exe'"
    while ! docker ps; do # Wait for Docker to start
        echo "==> Docker is starting"
        sleep 3
    done
else
    echo "==> Docker is running"
    echo
fi

# # #  WSL  # # #
