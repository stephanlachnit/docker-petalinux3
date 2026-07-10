#!/bin/bash
# SPDX-FileCopyrightText: 2021-2023, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-FileCopyrightText: 2024, Max Wipfli <mail@maxwipfli.ch>
# SPDX-FileCopyrightText: 2026, Stephan Lachnit <stephan.lachnit@desy.de>
# SPDX-License-Identifier: MIT

# Default version 2024.2
PLVER=${1:-2024.2}

PLSUFFIX="final"
if [ $PLVER = "2024.1" ] ; then
	PLSUFFIX="05202009"
elif [ $PLVER = "2024.2" ] ; then
	PLSUFFIX="11062026"
elif [ $PLVER = "2025.1" ] ; then
	PLSUFFIX="05180714"
elif [ $PLVER = "2025.2" ] ; then
	PLSUFFIX="11160223"
elif [ $PLVER = "2026.1" ] ; then
	PLSUFFIX="06061130"
fi

docker build --build-arg PETA_RUN_FILE=petalinux-v${PLVER}-${PLSUFFIX}-installer.run --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t docker_petalinux3:${PLVER} .

