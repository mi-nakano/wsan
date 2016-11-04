#!/bin/bash
pushd `pwd`
cd `dirname $0`

sh ./removeLog.sh
sh ./copyBeam.sh

popd
