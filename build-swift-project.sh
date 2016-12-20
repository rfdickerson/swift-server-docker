#!/bin/bash

# Initialize the SwiftEnv project environment
eval "$(swiftenv init -)"

cd project

ls

# rm -rf .build 
# rm -rf Packages

# Fetch all of the 
swift package fetch

# Install all the APT dependencies
egrep -R "Apt *\(" Packages/*/Package.swift \
    | sed -e 's/^.*\.Apt *( *" *//' -e 's/".*$//' \
    | xargs -n 1 sudo apt-get install -y

exec swift build

# swift test

# lldb-server platform --listen *:1234

