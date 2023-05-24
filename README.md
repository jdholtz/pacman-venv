# Pacman Virtual Environment
A tool to create isolated virtual environments for [Pacman][0]. This tool is inspired
by Python's [virtualenv][1] and therefore works similarly.

**Note**: pacman-venv is still in its development and testing phase. Not all changes
will be backwards compatible. To stay updated with the latest changes, check out the
[Changelog](CHANGELOG.md). Additionally, each update may require you to reinstall your
virtual environment for the changes to be applied.

## Table of Contents
- [Overview](#overview)
    * [How It Works](#how-it-works)
- [Installation](#installation)
    * [From Source](#from-source)
- [Usage](#usage)
    * [Supported Software](#supported-software)
- [Contributing](#contributing)

## Overview
Isolating system packages is beneficial for a few reasons:
- Having two applications with conflicting requirements (one application requires
`gcc<=11.1.0` while another requires `gcc>=12.1.0`).
- Creating isolated development environments for different projects
- Keeping only necessary packages available system-wide (e.g. not needing to keep
track of which packages to remove after testing them)

### How It Works
After sourcing the activation script, pacman-venv configures your current environment
to correctly use the isolated environment.
- Most notably, your `PATH` is configured to look for commands to run in the virtual
environment before system-wide commands.
- Additionally, wrappers are created for all supported package managers and AUR helpers
(see [Supported AUR Helpers](#aur-helpers)). These wrappers execute their respective package
managers with the `--root` argument pointing to the location of the virtual environment.
- Last, the name of the virtual environment will appear in the prompt to indicate that the
virtual environment is active (similarly to [virtualenv][1]).

## Installation
The recommended way to install [pacman-venv][2] is with an AUR helper. Here is an example with [Yay][3]:
```shell
yay -S pacman-venv
```

The development version of this package can be installed with the [pacman-venv-git][4] package.

### From Source
Pacman-venv can also be installed by cloning the PKGBUILD and building with makepkg:
```shell
pacman -S --needed git
git clone https://aur.archlinux.org/pacman-venv.git
cd pacman-venv
makepkg -si
```

## Usage
Create a virtual environment in the current directory:
```shell
pacman-venv [name]
```
**Note**: If name is not specified, the default name will be used (pacman-venv)

To enter the virtual environment, source the `{name}/bin/pacman-venv-active` file
(Add the `.fish` extension if you are using the Fish shell). Here is an example for Bash:
```shell
source pacman-venv/bin/pacman-venv-activate
```

Exit the virtual environment by either executing `deactivate` or `exit`.

For the full usage of the tool, run:
```shell
pacman-venv --help
```

Additional information on how to use pacman-venv can be found in the man page (`man pacman-venv`)

### Supported Software
Below is a list of all shells and AUR helpers that pacman-venv currently supports

#### Shells
- [Bash][5]
- [Zsh][6]
- [Fish][7]

#### AUR Helpers
- [Yay][3]

## Contributing
If you run into any issues, please file it via [GitHub Issues][8]. Additionally, if you
have any questions or discussion topics, start a [GitHub Discussion][9].

Contributions are always welcome. Please read [Contributing.md](CONTRIBUTING.md) if you are considering making contributions.

[0]: https://archlinux.org/pacman/
[1]: https://virtualenv.pypa.io/en/latest/
[2]: https://aur.archlinux.org/packages/pacman-venv
[3]: https://github.com/Jguer/yay
[4]: https://aur.archlinux.org/packages/pacman-venv-git
[5]: https://www.gnu.org/software/bash/
[6]: https://zsh.sourceforge.io/
[7]: https://fishshell.com/
[8]: https://github.com/jdholtz/pacman-venv/issues/new/choose
[9]: https://github.com/jdholtz/pacman-venv/discussions/new/choose
