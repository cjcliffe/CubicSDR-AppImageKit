#!/bin/bash

function SET {
SET $1=$2
}

eval $(cat build_stage/CubicSDR/CMakeLists.txt | grep \(CUBICSDR_VERSION | sed "s/SET[(]//" | sed "s/ \"/=\"/" | sed "s/[)]/; /")

echo $CUBICSDR_VERSION
