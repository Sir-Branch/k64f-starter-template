# NRF52 Starter Template
This project contains a starter template and a lot of bundled tools to allow a quick start developing for the Nordic NRF52 on a modern IDE or text editor. It is basically a CMake wrapper ontop of the Nordic SDK version 15.3.

It is not a one-size-fits-all environment, some customization and porting from the original SDK might still be needed, but for the most common and basic stuff, you should be good to go with this.

## Contents
* **fw-bootloader-secure**: A version of Nordic's secure bootloader without the board-dependent function calls.
* **fw-sample**: A minimalist user application as an example.
  - **(Note)** When calling `nRF5x_packageFirmware` within `CMakeLists.txt`, make sure that the digest value of Softdevice matches the one of your current version.
  - **(Note)** We're assuming that all applications are versioned using Semanting Versioning.
* **sdk_cmake**: The collection of .cmake files necessary to build this whole thing.
  Note: You'll probably have to tweak `configure_nordic_sdk.cmake` for your specific use-case.
* **sdk_nordic**: Here is where the files from the Nordic SDK reside. The contents are almost identical to the v15.3 SDK download, we just removed the examples. In theory, if you want to upgrade to a newer SDK version, replacing the contents of this folder should be enough.
* **toolchain**: All the build scripts for the project in a containerized environment.
  * Uses nRF Command Line Tools 10.7.0
* **utils**: General utilities that you'd might find useful.
  * **cmsis**: CMSIS Configuration Wizard - A graphical tool to modify `sdk_config.h` files.
  * **keys**: A bash script to use `nrfutil` to create a public-private key pair for DFU purposes.
  * **vscode**: Some useful configurations for Visual Studio Code.
* **vault**: Where keys are stored. Remember to store your keys safely!

## Build Environment Installation
Please follow the installation instructions for each of the supported build environments.

### Windows (Enterprise, Educational or Pro, DO NOT USE HOME)
* Ensure you have Docker installed, following [these instructions](https://docs.docker.com/docker-for-windows/install/). Be sure to add more resources to the virtual machine that Docker is creating for you.

### Linux, MacOS
* Ensure you have Docker installed, following [these instructions](https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/ubuntu/).
  * We've provided an automated script that does the process for you, just run `./toolchain/utils/linux_install_docker.sh`
  * After rebooting, make sure that you can run `docker run hello-world` **without requiring root privileges**.
  * Run `./toolchain/env_setup.sh`. This will create the Docker image with the entire build environment.

## Usage
Please follow the installation instructions for each of the supported platforms.

### Windows
* Run `./toolchain/env_compile.bat`
  * Use `-c` or `-clean` to perform a full rebuild of the project.
  * Use `-fw` to select which firmware target to build.

### Linux, MacOS
* Run `./toolchain/env_compile.sh`
  * Use `-c` or `-clean` to perform a full rebuild of the project.
  * Use `--fw` to select which firmware target to build.

**Note on target selection**: The name of each target is specified by those folders prefixed by `fx-`. One must specify the folder name without the prefix. (Eg. `--fw my-project` to select `fw-my-proyect`.)

## Reference Project
https://github.com/pisontechnology/nrf52-starter-template
https://github.com/peakhunt/frdm-k64f-projects

## License
All components within this project that have not been bundled from external creators, are licensed under the terms of the [MIT Licence](LICENCE.md).

