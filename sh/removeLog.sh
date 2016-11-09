#!/bin/bash
pushd `pwd` > /dev/null
cd `dirname $0`
cd ../

echo "remove *.log"
find . -name "*.log" -type f | xargs -J% rm %

popd > /dev/null
