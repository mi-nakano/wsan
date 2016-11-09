#!/bin/bash
pushd `pwd` > /dev/null
cd `dirname $0`
cd ../

rm -f ./*.beam

echo "mix compile"
`mix compile`

echo "copy *.beam file"
find . -name "*.beam" -type f | xargs -J% cp % ./

popd > /dev/null

