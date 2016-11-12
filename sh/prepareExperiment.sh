#!/bin/bash
pushd `pwd` > /dev/null
cd `dirname $0`

sh ./removeLog.sh

popd > /dev/null
