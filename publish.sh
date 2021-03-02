#!/bin/bash

set -e

# Run tests
bash test.sh

# Build & publish
rm -rf dist
python3 setp.py sdist bdist_wheel
twine upload --repository-url https://test.pypi.org/legacy/ dist/*
