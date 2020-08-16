[string]$PROJECT_ROOT = Resolve-Path $($PSScriptRoot + "\..\..\")
[string]$DOCKERFILE_PATH = Resolve-Path $($PROJECT_ROOT + "\toolchain")

docker build -t nrf52_compile_env --build-arg USER_USERNAME=user --build-arg USER_UID=1000 --build-arg USER_GID=1000 $DOCKERFILE_PATH