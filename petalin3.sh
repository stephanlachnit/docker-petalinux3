#!/bin/bash
# SPDX-FileCopyrightText: 2021, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-FileCopyrightText: 2026, Stephan Lachnit <stephan.lachnit@desy.de>
# SPDX-License-Identifier: MIT
#
# Run from a PetaLinux project directory

# allow docker image selection
if [ -n "$1" ]; then
	PLVER="$1"
else
	PLVER=$(docker image list | grep ^docker_petalinux3 | awk '{ print $1 }' | awk -F':' '{ print $2 }' | sort | tail -1)
fi
echo "Starting petalinux2:$PLVER"

docker run -it -v "$PWD":"$PWD":z -v "$HOME/.ssh":"/home/petalinux/.ssh":z -w "$PWD" --rm -u petalinux docker_petalinux3:"${PLVER}"

