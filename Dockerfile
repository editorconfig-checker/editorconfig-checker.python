# Dockerfile is run by `run-tests.sh`

# used to define the python tag
ARG IMAGE=3.13-slim


FROM python:$IMAGE
LABEL maintainer="Marco M. (mmicu) <mmicu.github00@gmail.com>"

COPY . /app
WORKDIR /app

# used to define which python package is installed with pip:
# - a value of `.` builds the images using the docker build context - aka the revision of the package which is currently checked out
# - using a value of `editorconfig-checker` will instead pull the image from PyPI
ARG PACKAGE=.

RUN apt-get update                         \
    && apt-get install -y make             \
    && python -m pip install --upgrade pip \
    && pip install --no-cache-dir $PACKAGE
