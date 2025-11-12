# Gurix Tools (gt)

> A small, practical and opinionated toolkit of handy commands and helpers for Linux power-users.

![gt version](https://img.shields.io/badge/version-1.6.0a-blue.svg)

---

## Index

- Roadmap
- How to install
	- Arch-based systems
	- Debian-based systems
- Quick usage & examples
- Contributing
- Credits
- License

---

## Roadmap

These are suggested improvements and features to make `gt` more useful, robust and maintainable.

Short term (easy wins)
- Add automatic package-manager detection (detect pacman/apt/dnf) and run the correct commands instead of hard-coding `yay`/`pacman`.
- Add a configuration file (`~/.config/gt/config`) to store user preferences (default download dir, mirror choices, language).
- Add command-line completion (bash/zsh) to speed up usage.
- Replace plaintext password file usage with an encrypted store option (gpg or pass) and fall back to secure clipboard copy.

Medium term
- Package `gt` as a proper distribution package (AUR PKGBUILD and Debian `.deb`) for easy installation.
- Split ISO lists into a small JSON file or remote source so ISO sources can be updated without editing the script.
- Add unit and integration tests for the script (shellspec or bats).
- Add a logging mechanism (rotating logs under `~/.local/share/gt/logs`) for debug and audit.

Long term (bigger features)
- Build a small TUI with `dialog` or `fzf` for interactive operations (selecting ISOs, package management, KVM control).
- Add plugin architecture so third-party extensions (e.g., cloud, docker helpers) can be added.

Priority suggestions
- 1) Package-manager detection and safe fallbacks
- 2) Config file and secure password handling
- 3) Packaging (AUR/DEB)

---

## How to install

Below are simple, safe instructions for installing `gt` on both Arch-based and Debian-based systems.

Notes
- The shipped script uses `yay`, `pacman` and other Arch tooling. On Debian/Ubuntu you can still use the script but some package-management commands will need to be adapted or replaced.
- You can always install the script and edit the package-manager lines to your preference.

### Arch-based systems (recommended)

1. Make the script executable and install it to `/usr/local/bin`:

```sh
# from the repository root
sudo cp "Arch Based/gt" /usr/local/bin/gt
sudo chmod +x /usr/local/bin/gt
```

2. (Optional) Install recommended dependencies used by the script:

```sh
sudo pacman -S --needed wget bc toilet p7zip unrar wl-clipboard
# If you rely on AUR helper usage inside the script, ensure you have one installed (e.g. yay/paru)
```

3. Run `gt` from the shell:

```sh
gt -h
```

Tip: If you want a single-file binary, you can compile the script with `shc` (not required):

```sh
# install shc, then:
shc -f /usr/local/bin/gt
# move and set permissions as needed
```

### Debian / Ubuntu based systems

Because the script uses `yay`/`pacman` operations, you have two main options on Debian/Ubuntu:

Option A — Install the script and edit package-manager lines

1. Copy and make executable:

```sh
sudo cp "Arch Based/gt" /usr/local/bin/gt
sudo chmod +x /usr/local/bin/gt
```

2. Edit `/usr/local/bin/gt` and replace `yay -S` / `pacman -R` / `yay -Syu` with `apt install -y` / `apt remove -y` / `apt update && apt upgrade -y` or adapt to your package manager.

Option B — Use a compatibility wrapper (quick)

Create small wrapper functions or aliases at the top of the script that map `install_pkg`, `remove_pkg`, `update_system` to appropriate commands depending on detected distro. Example snippet to add near the top of the script:

```sh
# simple detection
if command -v apt >/dev/null 2>&1; then
	install_cmd="sudo apt install -y"
	remove_cmd="sudo apt remove -y"
	update_cmd="sudo apt update && sudo apt upgrade -y"
else
	install_cmd="yay -S"
	remove_cmd="sudo pacman -R"
	update_cmd="yay -Syu"
fi

# then use "$install_cmd <package>" in the script
```

3. Install runtime dependencies used by the script:

```sh
sudo apt update
sudo apt install -y wget bc toilet p7zip unrar wl-clipboard
```

4. Use `gt -h` to see help and available options.

---

## Quick usage & examples

After installation, the script exposes a few handy flags. Example uses:

- Install a package (Arch by default in the script):
	- `gt -i firefox`
- Download an ISO (interactive list):
	- `gt -i iso list` or `gt -i iso ubuntu`
- Update the system:
	- `gt -u`
- KVM manager (start/stop):
	- `gt -vm`
- Copy stored password to clipboard (script uses `~/.guro_password` by default):
	- `gt -p`
- Move a file to trash:
	- `gt -tr myfile.txt`
- Unzip various archive formats:
	- `gt unzip archive.zip`

Run `gt -h` to see the full list of options and examples.

---

## Contributing

Contributions, ideas, bug reports and PRs are welcome.

Suggested workflow:

1. Fork the repo and create a feature branch.
2. Run shellcheck/linting and add tests for new behavior where possible.
3. Create a PR with a clear description and a short demo of the change.

Small ways to help right now:
- Add automated tests with `bats` or `shellspec`.
- Implement package-manager detection.
- Move ISO list to a JSON file and add a refresh mechanism.

---

## Credits

- Developer: @ReadyGurix

Special thanks to everyone who tests, files issues, or contributes improvements.

---

## License

This project includes a `LICENSE` file in the repository root. Review it for the exact terms. If you intend to reuse code from `gt`, keep the original license and credits.

---

Enjoy using `gt` - small tools, big productivity.

