# Functions for formatting output messages

init_colors() {
    BOLD=""
    GREEN=""
    RED=""
    RESET=""

    # Set colors if standard output is a terminal. Avoids color
    # escape sequences when output is redirected to a file.
    if [[ -t 1 ]]; then
        BOLD="$(tput bold)"
        GREEN="${BOLD}$(tput setaf 2)"
        RED="${BOLD}$(tput setaf 1)"
        RESET="$(tput sgr0)"
    fi

    readonly BOLD GREEN RED RESET
}

error() {
    printf "${RED}Error:${RESET}${BOLD} %s${RESET}\n" "$@" >&2
}

info() {
    printf "${GREEN}==>${RESET}${BOLD} %s${RESET}\n" "$@"
}

init_colors
