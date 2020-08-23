# K64F Starter Template -- Not tested waiting for DEV-BOARD!
This project contains a starter template and a lot of bundled tools to allow a quick start developing for the NXP K64F on a your IDE or text editor of choice. It is basically a CMake wrapper ontop of the NXP FRDM-K64F SDK v2.7.0.

It is not a one-size-fits-all environment, some customization and porting from the original SDK might still be needed, but for the most common and basic stuff, you should be good to go with this.

## Contents
* **fw-sample**: A minimalist user application as an example.
  - **(Note)** We're assuming that all applications are versioned using Semanting Versioning.
* **sdk_cmake**: The collection of .cmake files necessary to build this whole thing.
  Note: You'll have to tweak `fw-<your-project>/CMakeLists.txt` for your specific use-case.
* **sdk_k64f**: Here is where the files from the NXP FRDM-K64F SDK reside. The contents are almost identical to the v2.7.0 SDK download, the cmake_toolchain_files were moved to the sdk_cmake folder. In theory, if you want to upgrade to a newer SDK version, replacing the contents of this folder should be enough.
* **toolchain**: All the build scripts for the project in a containerized environment.
* **utils**: General utilities that you'd might find useful.
  * **vscode**: Some useful configurations for Visual Studio Code.
  
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
* https://github.com/pisontechnology/nrf52-starter-template
* https://github.com/peakhunt/frdm-k64f-projects

## License
All components within this project that have not been bundled from external creators, are licensed under the terms of the [MIT Licence](LICENCE.md).

