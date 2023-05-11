# TODO
- [ ] Copy makepkg and pacman config to virtual environment
    - [ ] Add flags to make copying optional, but default to true
- [ ] Work with pacman/yay aliases
- [ ] Add support for other shells (fish, zsh, etc.)
- [ ] Add support for other AUR helpers
- [ ] Add pre-commit hooks and github workflows for tests + linting/formatting
- [ ] Add unit tests
- [ ] Add completions for all shells
- [ ] Fix makepkg not working in virtual environments
    - [ ] This is possibly due to pacman-conf using the wrong root and DB path
- [ ] Add pacman-venv-git
- [ ] Improve how shims are copied to the virtual environment
    - [ ] Copy them to their own directory and append that directory to the front
      of the PATH. This allows for using cp shims/* without needing to add more
      changes every time a shim is added
