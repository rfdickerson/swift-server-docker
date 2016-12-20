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
      build   Compiles your project
      run     Runs your project at localhost:8090
      debug   Debugs your container
!!EOF
}

#----------------------------------------------------------
function debugServer {
  lldb-server platform --listen *:1234
}

#----------------------------------------------------------
function buildProject {
  # Fetch all of the dependencies
  swift package fetch

  # Install all the APT dependencies
  egrep -R "Apt *\(" Packages/*/Package.swift \
    | sed -e 's/^.*\.Apt *( *" *//' -e 's/".*$//' \
    | xargs -n 1 sudo apt-get install -y
  
  exec swift build
}

#----------------------------------------------------------
function runTests {
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
"run")      run;;
"build")    buildProject;;
"debug")    debug;;
*)          help;;
esac

# buildProject;;

# rm -rf .build 
# rm -rf Packages

