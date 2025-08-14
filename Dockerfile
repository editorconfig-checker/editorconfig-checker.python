# Dockerfile is run by `run-tests.sh`

# used to define the python tag
ARG IMAGE=3.13-slim


FROM python:$IMAGE AS pybase
RUN python -m pip install --upgrade pip

# separate the obtaining of the requirements from the actual test, so we can use build caching for the first step
FROM pybase as tester
LABEL maintainer="Marco M. (mmicu) <mmicu.github00@gmail.com>"

COPY . /app
WORKDIR /app

# used to define which python package is installed with pip:
# - a value of `.` builds the images using the docker build context - aka the revision of the package which is currently checked out
# - using a value of `editorconfig-checker` will instead pull the image from PyPI
ARG PACKAGE=.

RUN pip install --no-cache-dir $PACKAGE
