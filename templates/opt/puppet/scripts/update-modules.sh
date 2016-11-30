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

CI=true #https://bower.io/docs/api/#running-on-a-continuous-integration-server
node_modules/bower/bin/bower prune
node_modules/bower/bin/bower install --force-latest
node_modules/bower/bin/bower update --force-latest

clean_up

popd > /dev/null

