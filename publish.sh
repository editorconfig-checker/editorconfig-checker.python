#!/bin/bash

set -e

# Run tests & cleanup
make test
make clean

# Build & publish (currently, we push the package under the username `mmicu_00`)
python3 setup.py sdist
twine upload dist/*
