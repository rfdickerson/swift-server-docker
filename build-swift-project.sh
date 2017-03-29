#!/bin/bash
#------------------------------------------------------------
# Script: build-swift-project.sh
# Author: Robert F. Dickerson <rfdickerson@us.ibm.com>
# -----------------------------------------------------------
# Compiles, debugs, or runs your Swift on the Server project
# -----------------------------------------------------------

VERSION="1.0"
BUILD_DIR=".build-linux"

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
  swift package fetch

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
  echo "Compiling the Swift project..."
  swift build --configuration debug --build-path $BUILD_DIR
}

#----------------------------------------------------------
function runTests {
  echo "Running tests..."
  swift test
}

#----------------------------------------------------------
function runServer {
  echo "Running $2..."
  $BUILD_DIR/debug/$PROGRAM_NAME
}

#----------------------------------------------------------
function cleanProject {
  echo "Cleaning project"
  swift package --build-path $BUILD_DIR clean
  swift package update
}

#----------------------------------------------------------
# MAIN
# ---------------------------------------------------------

ACTION="$1"
PROGRAM_NAME="$2"

[[ -z $ACTION ]] && help && exit 0

[ "$ACTION" = "run" ] && [[ -z $PROGRAM_NAME ]] && help && exit 0

# Enter the build directory
cd project

case $ACTION in 
"run")                 runServer;;
"build")               buildProject;;
"debug")               debugServer;;
"test")                runTests;;
"install-system-libs") installSystemLibraries;;
"clean")               cleanProject;;
*)                     help;;
esac


