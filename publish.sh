#!/bin/bash

set -e

# Run tests
bash test.sh

# Build & publish
rm -rf dist
python3 setup.py sdist bdist_wheel
twine upload dist/*
