#!/bin/bash

set -e

# Run tests
bash test.sh

# Remove generated files
make clean

# Build & publish (currently, we push the package under the username `mmicu_00`)
python3 setup.py sdist bdist_wheel
twine upload dist/*
