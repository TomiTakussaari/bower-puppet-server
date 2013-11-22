#!/bin/bash -e
if [ "$(id -u)" != "52" ]; then
   echo "This script must be run as user Puppet" 1>&2
   exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

cd /opt/puppet/environments
npm install
npm update

node_modules/bower/bin/bower -f install
node_modules/bower/bin/bower -f update

popd > /dev/null
