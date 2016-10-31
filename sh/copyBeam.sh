#!/bin/bash
cd `dirname $0`
cd ../

echo "copy *.beam file"

# beamファイルの用意
`mix compile`
rm ./*.beam
find . -name "*.beam" -type f | xargs -J% cp % ./
