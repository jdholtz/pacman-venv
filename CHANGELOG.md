# Changelog

## Upcoming

### New Features
- Completions were added for Bash
- Prevent nested virtual environments

### Improvements
- The order of the directories in the PATH are kept in the same order within the virtual environment
- Add support for the Fish shell ([#6](https://github.com/jdholtz/pacman-venv/pull/6))
- Add support for the Zsh shell ([#7](https://github.com/jdholtz/pacman-venv/pull/7))


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
