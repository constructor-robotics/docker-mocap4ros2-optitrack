#!/bin/bash
# Clones all ROS 2 workspace source repos into files/src/

echo "Usage:"
echo "  ./setup.sh                                       Clone all repos into files/src/"
echo "  vcs import files/src < dependency_repos.repos   Run vcs manually"
echo ""

if ! command -v vcs &> /dev/null; then
  echo "Error: 'vcs' not found. Install with: pip install vcstool"
  exit 1
fi

mkdir -p files/src
vcs import files/src < dependency_repos.repos
