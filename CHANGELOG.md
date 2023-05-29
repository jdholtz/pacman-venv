# Changelog

## Upcoming

### New Features
- Every shell will now look in the virtual environment for completions

### Improvements
- Improve virtual environment creation and reduce initial size
    - Pacman is no longer installed inside the virtual environment upon creation,
    only `filesystem` and `sed`

### Bug Fixes
- Fix commands prefixed with `sudo` not calling the virtual environment's shims
- Fix environments not being installed correctly when using a different name than the default


## 0.3 (2023-05-20)

### New Features
- Added completions for all supported shells
- Prevent nested virtual environments

### Improvements
- The order of the directories in the PATH are kept in the same order within the virtual environment
- Add support for the Fish shell ([#6](https://github.com/jdholtz/pacman-venv/pull/6))
- Add support for the Zsh shell ([#7](https://github.com/jdholtz/pacman-venv/pull/7))

### Bug Fixes
- Fix various packages not installing/uninstalling correctly (e.g. fish and gnupg)


## 0.2 (2023-05-17)

### New Features
- `pacman-conf` now correctly uses the virtual environment
- `sudo` uses the virtual environment in scripts (i.e. makepkg)

### Improvements
- Using the shims in a script (i.e. `pacman`) will now use the virtual environment correctly

### Bug Fixes
- Fix the man page not being installed in the correct location


## 0.1 (2023-04-23)

### New Features
- Initial release
