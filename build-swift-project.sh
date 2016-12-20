#!/bin/bash
#------------------------------------------------------------
# Script: build-swift-project.sh
# Author: Robert F. Dickerson <rfdickerson@us.ibm.com>
# -----------------------------------------------------------
# Compiles, debugs, or runs your Swift on the Server project
# -----------------------------------------------------------

VERSION="1.0"

function help {
  cat <<-!!EOF
    Usage: $CMD [ build | run | debug ]

    Where:
      build                 Compiles your project
      run                   Runs your project at localhost:8090
      debug                 Debugs your container
      test                  Run the test cases
      install-system-libs   Install the system libraries from dependencies 
!!EOF
}

#----------------------------------------------------------
function debugServer {
  lldb-server platform --listen *:1234
}

#----------------------------------------------------------
function installSystemLibraries {

  # Fetch all of the dependencies
  echo "Fetching dependencies"
  # swift package fetch

  echo "Installing system dependencies: "

  # Update the Package cache
  sudo apt-get update &> /dev/null 

  egrep -R "Apt *\(" Packages/*/Package.swift \
    | sed -e 's/^.*\.Apt *( *" *//' -e 's/".*$//' \
    | xargs -n 1 echo

  # Install all the APT dependencies
  egrep -R "Apt *\(" Packages/*/Package.swift \
    | sed -e 's/^.*\.Apt *( *" *//' -e 's/".*$//' \
    | xargs -n 1 sudo apt-get install -y &> /dev/null
}

#----------------------------------------------------------
function buildProject {

  echo "Compiling the Swift project"
  exec swift build -Xswiftc -I/usr/include/postgresql --build-path .build-linux
}

#----------------------------------------------------------
function runTests {
  echo "Running tests"
  swift test
}

#----------------------------------------------------------
# MAIN
# ---------------------------------------------------------

ACTION="$1"

[[ -z $ACTION ]] && help && exit 0

# Initialize the SwiftEnv project environment
eval "$(swiftenv init -)"

# Enter the build directory
cd project

case $ACTION in 
"run")                 run;;
"build")               installSystemLibraries && buildProject;;
"debug")               debug;;
"test")                runTests;;
"install-system-libs") installSystemLibraries;;
*)                     help;;
esac

# buildProject;;

# rm -rf .build 
# rm -rf Packages

