[string]$PROJECT_ROOT = Resolve-Path $($PSScriptRoot + "\..\..\")

docker run -it --rm --name nrf52_compile_env -v ${PROJECT_ROOT}:/external nrf52_compile_env