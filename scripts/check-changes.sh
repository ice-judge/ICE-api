#!/bin/bash
set -e

if [[ -z $(git diff HEAD^ $1) ]]; then 
	echo "no"
else
	echo "yes"
fi
