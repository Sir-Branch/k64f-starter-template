[string]$PROJECT_ROOT = Resolve-Path $($PSScriptRoot + "\..\..\")

docker run -it --rm --name mk64f_compile_env -v ${PROJECT_ROOT}:/external mk64f_compile_env