#!/bin/sh

# get script located dir
DIR=$(cd $(dirname $0);pwd)

set -e
set -x

# nvim
ln -shf $DIR ~/.config/nvim
