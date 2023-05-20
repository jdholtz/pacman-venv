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
    PS1="${_PACMAN_VENV_OLD_PS1}"
    LD_LIBRARY_PATH="${_PACMAN_VENV_OLD_LD_LIBRARY_PATH}"
    PACMAN="${_PACMAN_VENV_OLD_PACMAN}"

    # Unset all the temporary variables/functions
    unset _PACMAN_VENV_OLD_PATH
    unset _PACMAN_VENV_OLD_PS1
    unset _PACMAN_VENV_OLD_LD_LIBRARY_PATH
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

# Prepend the pacman virtual environment directory to every
# directory in PATH. Then, add the new path created to the
# beginning of PATH. This ensures all paths are looked at in
# the virtual environment before the system.
create_path() {
    local read_array_flag="-a"
    if [[ -n "$ZSH_VERSION" ]]; then
        # The zsh shell uses -A instead of -a
        read_array_flag="-A"

        # Zsh starts arrays at 1 which is problematic for the code
        # below, so ksh is emulated to make sure it works similar
        # to Bash
        emulate -L ksh
    fi

    # Split the PATH variable into an array
    # shellcheck disable=SC2229
    IFS=":" read -r "${read_array_flag}" path_array <<< "${PATH}"

    # Add the shims directory to the beginning of the path
    local new_path="${_PACMAN_VENV}/pacman-venv-shims"

    # Prepend the PACMAN VENV to every directory in PATH
    for path in "${path_array[@]}"; do
        new_path="${new_path}:${_PACMAN_VENV}${path}"
    done

    echo "${new_path}"
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

# Store all the old values of the variables
_PACMAN_VENV_OLD_PATH="${PATH}"
_PACMAN_VENV_OLD_PS1="${PS1}"
_PACMAN_VENV_OLD_LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
_PACMAN_VENV_OLD_PACMAN="${PACMAN}"

# Name of the virtual environment
_PACMAN_VENV="$(realpath "$(get_file_name)")"
_PACMAN_VENV="$(dirname "$(dirname "$(dirname "${_PACMAN_VENV}")")")"
export _PACMAN_VENV

# Set all the needed values for the virtual environment
export LD_LIBRARY_PATH="${_PACMAN_VENV}/lib:${LD_LIBRARY_PATH}"
PATH="$(create_path):${PATH}"
PS1="[$(basename "${_PACMAN_VENV}")] ${PS1}"
export PATH
export PS1

# Makepkg uses this variable to execute its Pacman command.
# However, we need to override the default to use the --root flag,
# so point makepkg to our pacman command.
export PACMAN="${_PACMAN_VENV}/pacman-venv-shims/pacman"

# Unset the helper functions used to activate the environment
unset -f create_path get_file_name

# Forget past commands because the $PATH changed
hash -r
