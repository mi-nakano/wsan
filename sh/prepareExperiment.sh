#!/bin/bash
pushd `pwd` > /dev/null
cd `dirname $0`

echo remove *.beam
rm ../*.beam

sh ./removeLog.sh
sh ./copyBeam.sh

popd > /dev/null
