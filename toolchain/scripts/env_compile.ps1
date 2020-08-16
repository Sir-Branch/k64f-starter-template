param (
    [Alias('c')]
    [switch]$clean = $false,
    [Alias('d')]
    [switch]$debug = $false,
    [string]$fw
)

[string]$PROJECT_ROOT = Resolve-Path $($PSScriptRoot + "\..\..\")
if ($clean) {
    [string]$FLAG_CLEAN = "-c"
}
if ($debug) {
    [string]$FLAG_CLEAN = "-d"
}
[string]$FLAG_FW_TARGET = $fw

docker run -it --rm --name nrf52_compile_env -v ${PROJECT_ROOT}:/external nrf52_compile_env /external/toolchain/linux_compile.sh $FLAG_CLEAN --fw $FLAG_FW_TARGET