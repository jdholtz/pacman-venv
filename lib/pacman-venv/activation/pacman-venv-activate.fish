#!/usr/bin/env fish

# This file is a modified version from Python's virtualenv
# https://github.com/pypa/virtualenv/blob/main/src/virtualenv/activation/fish/activate.fish

if not string match -q -- "*from sourcing file*" (status)
    echo "This script must be sourced. Use 'source $(status filename)'"
    exit 1
else if test -n "$_PACMAN_VENV"
    echo "Nested virtual environments are not supported"
    return 1
end

# Prepend the pacman virtual environment directory to every
# directory in the provided path.
function create_path
    for path in $argv
        echo $_PACMAN_VENV$path
    end
end

# Store all the old values of the variables
set -gx _PACMAN_VENV_OLD_PATH $PATH
set -gx _PACMAN_VENV_OLD_PS1 $PS1
set -gx _PACMAN_VENV_OLD_COMPLETE_PATH $fish_complete_path
set -gx _PACMAN_VENV_OLD_LD_LIBRARY_PATH $LD_LIBRARY_PATH
set -gx _PACMAN_VENV_OLD_XDG_DATA_DIRS $XDG_DATA_DIRS
set -gx _PACMAN_VENV_OLD_PACMAN $PACMAN

# Name of the virtual environment
set _PACMAN_VENV (realpath (status filename))
set -gx _PACMAN_VENV (dirname (dirname (dirname $_PACMAN_VENV)))

# Point programs to look for libraries in the virtual environment first
set -gx -p LD_LIBRARY_PATH "$_PACMAN_VENV/lib"

# The shims directory needs to be first in the PATH so it has priority
# over every other path
set -p PATH "$_PACMAN_VENV/pacman-venv-shims" (create_path $PATH)

# Add the virtual environment's completion paths
set -p fish_complete_path (create_path $fish_complete_path)

# Add the virtual environment's data directories. This is mainly here to provide
# consistency between the different shell activation scripts. It is needed for
# bash-completion.
test -z "$XDG_DATA_DIRS"; and set --path XDG_DATA_DIRS /usr/share /usr/local/share
set -gx -p XDG_DATA_DIRS (create_path $XDG_DATA_DIRS)

# Unset the path creation function as it isn't needed anymore
functions -e create_path

# Makepkg uses this variable to execute its Pacman command.
# However, we need to override the default to use the --root flag,
# so point makepkg to our pacman command.
set -gx PACMAN "$_PACMAN_VENV/pacman-venv-shims/pacman"

# Save the current fish_prompt function to _pacman_venv_old_fish_prompt
functions -c fish_prompt _pacman_venv_old_fish_prompt

function fish_prompt
    # Set the user's original prompt
    set -l prompt (_pacman_venv_old_fish_prompt)

    printf '[%s] ' (basename $_PACMAN_VENV)

    # Handle multi-line prompts
    string join -- \n $prompt
end

# These functions need to be defined under the virtual environment configuration
# because fish's realpath can call exit
function exit -d "Exit the pacman virtual environment"
    # Reset all variables to their old values
    set -gx PATH $_PACMAN_VENV_OLD_PATH
    set -gx fish_complete_path $_PACMAN_VENV_OLD_COMPLETE_PATH
    set -gx LD_LIBRARY_PATH $_PACMAN_VENV_OLD_LD_LIBRARY_PATH
    set -gx XDG_DATA_DIRS $_PACMAN_VENV_OLD_XDG_DATA_DIRS
    set -gx PACMAN $_PACMAN_VENV_OLD_PACMAN

    # Unset all the temporary variables/functions
    set -e _PACMAN_VENV_OLD_PATH
    set -e _PACMAN_VENV_OLD_COMPLETE_PATH
    set -e _PACMAN_VENV_OLD_LD_LIBRARY_PATH
    set -e _PACMAN_VENV_OLD_XDG_DATA_DIRS
    set -e _PACMAN_VENV_OLD_PACMAN
    set -e _PACMAN_VENV

    # Reset the prompt to the original
    functions -e fish_prompt
    functions -c _pacman_venv_old_fish_prompt fish_prompt
    functions -e _pacman_venv_old_fish_prompt

    functions -e exit
    functions -e deactivate
end

# Alias for exit
function deactivate -d "Exit the pacman virtual environment"
    exit
end
