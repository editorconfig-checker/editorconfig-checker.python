#!/bin/bash

set -e

py_docker_images=("2.7.16-slim" "3.7.4-slim")

# "."                    -> Local package
# "editorconfig-checker" -> PyPI package
packages=("." "editorconfig-checker")

dockerfile_template=tests/Dockerfile.template

for py_docker_image in "${py_docker_images[@]}"; do
    for package in "${packages[@]}"; do
        if [ "$package" == "." ]; then
            package_pp=local
        elif [ "$package" == "editorconfig-checker" ]; then
            package_pp=pypi
        else
            echo "Unknown package '$package'. Valid values are '.' and 'editorconfig-checker'."
            exit 1
        fi

        echo "docker image: $py_docker_image ~ package: $package ($package_pp)"

        # Generate a valid Dockerfile from a template file
        dockerfile=tests/Dockerfile-$py_docker_image-$package_pp
        cp $dockerfile_template $dockerfile
        sed -i '' "s/\$IMAGE/$py_docker_image/g" $dockerfile
        sed -i '' "s/\$PACKAGE/$package/g"       $dockerfile

        echo "Running docker file in $dockerfile"

        # Build, run and delete image
        docker_image=editorconfig-checker-$py_docker_image-$package_pp:latest
        docker build -t $docker_image -f $dockerfile --no-cache --quiet .
        docker run --rm $docker_image
        docker image rm $docker_image > /dev/null

        echo ""
    done
done
