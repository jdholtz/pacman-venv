#!/usr/bin/env bash

# This activation script is compatible with both Bash and Zsh

# This file is a modified version from Python's virtualenv
# https://github.com/pypa/virtualenv/blob/main/src/virtualenv/activation/bash/activate.sh

if [[ "${BASH_SOURCE-}" == "${0}" ]]; then
    echo "This script must be sourced. Use 'source ${0}'"
    exit 1
elif [[ -n "${_PACMAN_VENV}" ]]; then
    echo "Nested virtual environments are not supported"
    return 1
fi

exit() {
    # Reset all variables to their old values
    PATH="${_PACMAN_VENV_OLD_PATH}"
    FPATH="${_PACMAN_VENV_OLD_FPATH}"
    PS1="${_PACMAN_VENV_OLD_PS1}"
    LD_LIBRARY_PATH="${_PACMAN_VENV_OLD_LD_LIBRARY_PATH}"
    XDG_DATA_DIRS="${_PACMAN_VENV_OLD_XDG_DATA_DIRS}"
    PACMAN="${_PACMAN_VENV_OLD_PACMAN}"

    # Unset all the temporary variables/functions
    unset _PACMAN_VENV_OLD_PATH
    unset _PACMAN_VENV_OLD_FPATH
    unset _PACMAN_VENV_OLD_PS1
    unset _PACMAN_VENV_OLD_LD_LIBRARY_PATH
    unset _PACMAN_VENV_OLD_XDG_DATA_DIRS
    unset _PACMAN_VENV_OLD_PACMAN
    unset _PACMAN_VENV
    unset -f exit deactivate

    # Forget past commands because the $PATH changed
    hash -r
}

# Alias for exit
deactivate() {
    exit
}

# Different expansions need to be done if the shell is Bash vs. Zsh
get_file_name() {
    local file_name
    if [[ -n "$ZSH_VERSION" ]]; then
        # shellcheck disable=SC2296
        file_name="${(%):-%x}"
    else
        file_name="${BASH_SOURCE[0]}"
    fi

    echo "${file_name}"
}

# Prepend the pacman virtual environment directory to every
# directory in the provided path. This ensures all paths are
# looked at in the virtual environment before the system.
create_path() {
    local original_path="${1}"

    local read_array_flag="-a"
    # The zsh shell uses -A instead of -a
    [[ -n "$ZSH_VERSION" ]] && read_array_flag="-A"

    # Split the PATH variable into an array
    # shellcheck disable=SC2229
    IFS=: read -r "${read_array_flag}" path_array <<< "${original_path}"

    for path in "${path_array[@]}"; do
        echo -n "${_PACMAN_VENV}${path}:"
    done

    echo "${original_path}"
}

# Store all the old values of the variables
_PACMAN_VENV_OLD_PATH="${PATH}"
_PACMAN_VENV_OLD_FPATH="${FPATH}"
_PACMAN_VENV_OLD_PS1="${PS1}"
_PACMAN_VENV_OLD_LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
_PACMAN_VENV_OLD_XDG_DATA_DIRS="${XDG_DATA_DIRS}"
_PACMAN_VENV_OLD_PACMAN="${PACMAN}"

# Name of the virtual environment
_PACMAN_VENV="$(realpath "$(get_file_name)")"
_PACMAN_VENV="$(dirname "$(dirname "$(dirname "${_PACMAN_VENV}")")")"
export _PACMAN_VENV

# Point programs to look for libraries in the virtual environment first
export LD_LIBRARY_PATH="${_PACMAN_VENV}/lib:${LD_LIBRARY_PATH}"

# The shims directory needs to be first in the PATH so it has priority
# over every other path
PATH="${_PACMAN_VENV}/pacman-venv-shims:$(create_path "${PATH}")"
export PATH

# Add Zsh completion directories to point to the virtual environment first. This
# has no effect on Bash (FPATH is empty) so no check needs to be done.
FPATH="$(create_path "${FPATH}")"
export FPATH
# Regenerate Zsh completion because we modified FPATH
[[ -n "$ZSH_VERSION" ]] && compinit

# Set the custom prompt
PS1="[$(basename "${_PACMAN_VENV}")] ${PS1}"
export PS1

# Add the virtual environment's data directories. This is mainly here for Bash completion to look
# in the virtual environment for completion functions
XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
XDG_DATA_DIRS="$(create_path "${XDG_DATA_DIRS}")"
export XDG_DATA_DIRS

# Makepkg uses this variable to execute its Pacman command.
# However, we need to override the default to use the --root flag,
# so point makepkg to our pacman command.
export PACMAN="${_PACMAN_VENV}/pacman-venv-shims/pacman"

# Unset the helper functions used to activate the environment
unset -f get_file_name create_path

# Forget past commands because the $PATH changed
hash -r
