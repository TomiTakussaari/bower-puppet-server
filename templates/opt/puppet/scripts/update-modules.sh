#!/bin/bash -e

function clean_up {
	rm -f update-modules.lock
    exit
}

if [ "$(id -u)" != "52" ]; then
   echo "This script must be run as user Puppet" 1>&2
   exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

cd <%= @root_directory %>/puppet/environments

lockfile -r0 update-modules.lock
trap clean_up EXIT

npm install
npm update

node_modules/bower/bin/bower -f install
node_modules/bower/bin/bower -f update

clean_up

popd > /dev/null

