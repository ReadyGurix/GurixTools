# GurixTools Configuration & Management

This document outlines how to configure and manage your GurixTools installation.

## Configuration

GurixTools stores its configuration in `/etc/gurixtools/config`. This file is created during installation.

### Language Settings

The language is defined by the `GT_LANG` variable in the config file.

**Supported Languages:**
- `en_US`: English (US)
- `es_ES`: Spanish (Spain)
- `ca_ES`: Catalan (Spain)

**Changing Language:**
To change the language, edit the config file with root privileges:

```bash
sudo nano /etc/gurixtools/config
```

Update the `GT_LANG` variable:
```bash
GT_LANG="es_ES"
```

Save and exit. The changes will take effect immediately for the next command.

## Management

### Updating GurixTools

To update GurixTools itself (if installed via git or source):

```bash
cd /path/to/GurixTools
git pull
./install.sh
```

If you installed via the package manager (future feature), use your system's package manager.

### Uninstalling

You can uninstall GurixTools using the built-in command:

```bash
gt self-uninstall
```

Or manually by running the uninstall script if you have the source:

```bash
./uninstall.sh
```

### Troubleshooting

If you encounter issues with language loading:
1. Ensure `/usr/local/lib/gurixtools/lang/` contains the `.sh` files for your language.
2. Check that `/etc/gurixtools/config` exists and has valid permissions (readable by user).
