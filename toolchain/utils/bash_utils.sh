style_reset="\e[0m"
style_bold="\e[1m"

style_red="\e[31m"
style_green="\e[32m"
style_yellow="\e[33m"
style_blue="\e[34m"
style_magenta="\e[35m"
style_cyan="\e[36m"

FAIL_DETECT () {
    if [ $? -ne 0 ]; then
        ERROR_LINE="${BASH_LINENO[-2]}";
        echo -e "${style_bold} ${style_red} COMMAND FAILED ON LINE $ERROR_LINE. ${style_reset}"
        exit 1
    fi
}

FAIL_DETECT2 () {
    ERROR_LINE="${BASH_LINENO[-2]}";
    ERROR_MESSAGE=$($@)
    if [ $? -ne 0 ]; then
        echo -e "${style_bold} ${style_red} COMMAND FAILED ON LINE $ERROR_LINE: $ERROR_MESSAGE ${style_reset}"
        exit 1
    fi
}