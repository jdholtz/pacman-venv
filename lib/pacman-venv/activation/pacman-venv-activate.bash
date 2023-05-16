#!/usr/bin/env bash
# This file is a modified version from Python's virtualenv
# https://github.com/pypa/virtualenv/blob/main/src/virtualenv/activation/bash/activate.sh

if [[ "${BASH_SOURCE-}" == "$0" ]]; then
    echo "This script must be sourced. Use source ${0}"
    exit 1
fi

exit() {
    # Reset all variables to their old values
    PATH="${_PACMAN_VENV_OLD_PATH}"
    PS1="${_PACMAN_VENV_OLD_PS1}"
    LD_LIBRARY_PATH="${_PACMAN_VENV_OLD_LD_LIBRARY_PATH}"
    PACMAN="${_PACMAN_VENV_OLD_PACMAN}"

    # Reset the sudo alias if it was set before.
    # Otherwise, unset it
    if [[ ${_PACMAN_VENV_OLD_SUDO} ]]; then
        eval "${_PACMAN_VENV_OLD_SUDO}"
    else
        unalias sudo
    fi

    remove_shim_aliases

    # Unset all the temporary variables/functions
    unset _PACMAN_VENV_OLD_PATH
    unset _PACMAN_VENV_OLD_PS1
    unset _PACMAN_VENV_OLD_LD_LIBRARY_PATH
    unset _PACMAN_VENV_OLD_PACMAN
    unset _PACMAN_VENV_OLD_SUDO
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
    # Split the PATH variable into an array
    IFS=":" read -r -a path_array <<< "${PATH}"

    # Prepend the PACMAN VENV to every directory in PATH
    local new_path="${PATH}"
    for path in "${path_array[@]}"; do
        new_path="${_PACMAN_VENV}${path}:${new_path}"
    done

    echo "${new_path}"
}

# Point the package managers to Pacman Venv's command (include --root flag)
# Need to be wrapped in single quotes (SC2139)
create_shim_aliases() {
    for shim in "${_PACMAN_VENV}"/pacman-venv-shims/*; do
        alias_name="${shim##*.pacman-venv-}"
        # shellcheck disable=SC2139
        # These variables need to be expanded
        alias "${alias_name}"="${shim}"
    done
}

remove_shim_aliases() {
    for shim in "${_PACMAN_VENV}"/pacman-venv-shims/*; do
        alias_name="${shim##*.pacman-venv-}"
        unalias "${alias_name}"
    done

}

# Store all the old values of the variables
_PACMAN_VENV_OLD_PATH="${PATH}"
_PACMAN_VENV_OLD_PS1="${PS1}"
_PACMAN_VENV_OLD_LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
_PACMAN_VENV_OLD_PACMAN="${PACMAN}"
_PACMAN_VENV_OLD_SUDO="$(alias sudo 2>/dev/null)"

# Name of the virtual environment
_PACMAN_VENV="$(realpath "${BASH_SOURCE[0]}")"
_PACMAN_VENV="$(dirname "$(dirname "$(dirname "${_PACMAN_VENV}")")")"
export _PACMAN_VENV

# Set all the needed values for the virtual environment
export LD_LIBRARY_PATH="${_PACMAN_VENV}/lib:${LD_LIBRARY_PATH}"
PATH="$(create_path)"
PS1="[$(basename "${_PACMAN_VENV}")] ${PS1}"
export PATH
export PS1

# Makepkg uses this variable to execute its Pacman command.
# However, we need to override the default to use the --root flag,
# so point makepkg to our pacman command.
export PACMAN="${_PACMAN_VENV}/pacman-venv-shims/.pacman-venv-pacman"

# Preserve env variables and allow sudo to be run with aliases
alias sudo="sudo -E "

create_shim_aliases

# Forget past commands because the $PATH changed
hash -r
