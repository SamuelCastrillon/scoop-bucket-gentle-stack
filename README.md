# Gentleman.Dots Windows

Windows native configuration for Gentleman.Dots development environment.

**NOTE**: This repository contains **configuration files only**, not tool manifests.
Tools are installed from Scoop's official [main](https://github.com/ScoopInstaller/scoop/wiki/Buckets#main-bucket) 
and [extras](https://github.com/ScoopInstaller/Extras) buckets.

## Prerequisites

- Windows 10/11 (64-bit or ARM64)
- [Scoop](https://scoop.sh) package manager

### Install Scoop

```powershell
iwr -useb get.scoop.sh | iex
```

## Quick Start

### 1. Add Scoop Buckets (if not already added)

```powershell
scoop bucket add main
scoop bucket add extras
```

### 2. Install All Tools

```powershell
# Main bucket tools
scoop install main/nvim main/nodejs-lts main/fd main/ripgrep main/fzf

# Extras bucket tools
scoop install extras/lazygit
```

### 3. Install Configuration

Clone and copy the config files:

```powershell
git clone --depth 1 https://github.com/SamuelCastrillon/gentleman-dots-windows.git
Copy-Item -Recurse gentleman-dots-windows/config/nvim/* $env:LOCALAPPDATA\nvim\
```

Or use the automated installer:

```powershell
irm https://raw.githubusercontent.com/SamuelCastrillon/gentleman-dots-windows/main/scripts/install-gentleman-dots.ps1 | iex
```

## Included Tools

| Tool | Bucket | Description |
|------|--------|-------------|
| Neovim | main | Modern terminal text editor |
| Node.js LTS | main | JavaScript runtime (LTS) |
| fd | main | Fast alternative to `find` |
| ripgrep | main | Fast alternative to `grep` |
| fzf | main | Fuzzy finder |
| LazyGit | extras | Terminal UI for Git |

## Verification

Verify your installation:

```powershell
irm https://raw.githubusercontent.com/SamuelCastrillon/gentleman-dots-windows/main/scripts/verify-gentleman-dots.ps1 | iex
```

Expected output: All checks should show `PASS`.

## Troubleshooting

### Scoop not found

If `scoop` is not recognized, restart PowerShell or add Scoop to your PATH:

```powershell
# Add scoop shims to PATH for current session
$env:PATH = "$env:USERPROFILE\scoop\shims;$env:PATH"
```

### Missing bucket

If a tool install fails, make sure the bucket exists:

```powershell
scoop bucket add main
scoop bucket add extras
```

### Update tools

```powershell
scoop update
scoop update *
```

## Configuration

### Structure

```
config/
└── nvim/
    ├── init.vim       # Main configuration
    ├── plugins.vim    # Plugin configuration  
    └── windows.vim    # Windows-specific overrides
```

### Windows Path Overrides

The `config/nvim/windows.vim` file provides Windows-specific path translations:

- `$HOME` → `%USERPROFILE%`
- `$XDG_CONFIG_HOME` → `%APPDATA%`
- `~/.config/nvim` → `%LOCALAPPDATA%\nvim`

These are applied automatically when running Neovim on Windows.

### Manual Configuration

If you prefer manual setup, you can set environment variables:

```powershell
# PowerShell
$env:XDG_CONFIG_HOME = "$env:APPDATA"
$env:VIM = "$env:LOCALAPPDATA\nvim"
```

### Verify Config Location

```vim
:echo stdpath('config')
```

Should return a Windows-style path like `C:\Users\<you>\AppData\Local\nvim`.

## Development

### Local Testing

Clone the repository and test locally:

```powershell
git clone https://github.com/SamuelCastrillon/gentleman-dots-windows.git
cd gentleman-dots-windows

# Run verification script
./scripts/verify-gentleman-dots.ps1
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This configuration follows the same license as Gentleman.Dots. Individual tool licenses apply to their respective packages.

## Resources

- [Scoop Documentation](https://scoop.sh)
- [Scoop Buckets](https://github.com/ScoopInstaller/Bucket)
- [Scoop Main Bucket](https://github.com/ScoopInstaller/Main)
- [Scoop Extras Bucket](https://github.com/ScoopInstaller/Extras)
- [Gentleman.Dots](https://github.com/gentleman-dots)
