<!--
SPDX-FileCopyrightText: 2021-2023 Carles Fernandez-Prades <carles.fernandez@cttc.es>
SPDX-FileCopyrightText: 2026 Stephan Lachnit <stephan.lachnit@desy.de>
SPDX-License-Identifier: MIT
-->

# docker-petalinux3

A somehow generic Xilinx PetaLinux Docker image, using Ubuntu 24.04 as the base image.

PetaLinux version `2024.1` is the first version handled by this release and the default version is `2024.2`.
For former versions, please check [docker-petalinux2](https://github.com/carlesfernandez/docker-petalinux2).

In order to use this tool, you need to [install
Docker](https://docs.docker.com/get-docker/) in your machine. If you want to use
the Vivado/Vitis graphical interface, you will also need the ipconfig utility
(on Debian/Ubuntu: `sudo apt-get install net-tools`).

A Xilinx user ID is required to download the PetaLinux and Vivado installers.

## Download the installers

### Prepare the PetaLinux installer

The PetaLinux Installer is to be downloaded from the [Adaptive SoCs & FPGA Embedded Software website](https://www.amd.com/en/support/downloads/adaptive-socs-and-fpgas/embedded-software.html).

Place the downloaded `petalinux-v<VERSION>-<TAG>-installer.run` file (where `<VERSION>` can be `2024.1`, `2024.2`, ...) in the `./installers` folder.

## Build the image

Run:

    ./docker_build.sh <VERSION>

> The default for `<VERSION>`, if not specified, is `2024.2`.

## Work with a PetaLinux project

A helper script `petalin3.sh` is provided that should be run _inside_ a PetaLinux project directory. It basically is a shortcut to:

    docker run -it -v "$PWD":"$PWD" -w "$PWD" --rm -u petalinux docker_petalinux3:<latest version> $@

When run without arguments, a shell will spawn, _with PetaLinux `settings.sh` already sourced_, so you can directly execute `petalinux-*` commands.

    user@host:/path/to/petalinux_project$ /path/to/petalin3.sh
    petalinux2@host:/path/to/petalinux_project$ petalinux-build

Otherwise, the arguments will be executed as a command. Example:

    user@host:/path/to/petalinux_project$ /path/to/petalin3.sh \
    "petalinux-create -t project --template zynq --name myproject"

## License

The content of this repository is published under the [MIT](./LICENSE) license.

