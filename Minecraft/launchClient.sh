#!/bin/bash

# run from the script directory
cd "$(dirname "$0")"

# Error if 1 argument or greater than 2 arguments
if [ \( $# -eq 1 \) -o \( $# -gt 2 \) ]; then
  echo "Usage: launchClient"
  echo "   or: launchClient -port 10123"
  exit 1
fi

if [ $# -eq 0 ]; then
  port=0
else
  if [ $1 != "-port" ]; then
    echo "Usage: launchClient"
    echo "   or: launchClient -port 10123"
    exit 1
  fi 

  port=$2
  
  if ! [[ $port =~ ^-?[0-9]+$ ]]; then
    echo "Port value should be numeric"
    exit 1
  fi
  
  if [ \( $port -lt 0 \) -o \( $port -gt 65535 \) ]; then
    echo "Port value out of range 0-65535"
    exit 1
  fi
  
fi

# Now write the configuration file
if [ ! -d "run/config" ]; then
  mkdir run/config
fi
echo "# Configuration file
# Autogenerated from command-line options

malmoports {
  I:portOverride=$port
}
" > run/config/malmomodCLIENT.cfg

# Finally we can launch the Mod, which will load the config file
./gradlew setupDecompWorkspace
./gradlew build
./gradlew runClient
