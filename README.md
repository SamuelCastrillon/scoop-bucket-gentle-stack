# Gentleman.Dots Windows

Windows native installation of the Gentleman.Dots development environment via Scoop.

## Prerequisites

- Windows 10/11 (64-bit or ARM64)
- [Scoop](https://scoop.sh) package manager

### Install Scoop

```powershell
iwr -useb get.scoop.sh | iex
```

## Quick Start

### 1. Add the Bucket

```powershell
scoop bucket add gentleman-dots-windows https://github.com/SamuelCastrillon/gentleman-dots-windows
```

### 2. Install All Tools

```powershell
scoop install gentleman-dots-windows/neovim
scoop install gentleman-dots-windows/nodejs-lts
scoop install gentleman-dots-windows/lazygit
scoop install gentleman-dots-windows/fd
scoop install gentleman-dots-windows/ripgrep
scoop install gentleman-dots-windows/fzf
```

Or use the automated installer:

```powershell
irm https://raw.githubusercontent.com/SamuelCastrillon/gentleman-dots-windows/main/scripts/install-gentleman-dots.ps1 | iex
```

## Included Tools

| Tool | Version | Description |
|------|---------|-------------|
| Neovim | Latest | Modern terminal text editor |
| Node.js LTS | Latest | JavaScript runtime (LTS) |
| LazyGit | Latest | Terminal UI for Git |
| fd | Latest | Fast alternative to `find` |
| ripgrep | Latest | Fast alternative to `grep` |
| fzf | Latest | Fuzzy finder |

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

### Bucket add fails

Make sure Git is installed:

```powershell
scoop install git
```

Then try adding the bucket again.

### Installation fails with hash mismatch

This usually means a new version was released. Update the bucket:

```powershell
scoop update gentleman-dots-windows/*
scoop update
```

If the issue persists, [open an issue](https://github.com/SamuelCastrillon/gentleman-dots-windows/issues).

### Neovim not finding config

Windows path translations are applied automatically. If you have issues:

```vim
:echo stdpath('config')
```

Should return a Windows-style path like `C:\Users\<you>\AppData\Local\nvim`.

## Configuration

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

## Development

### Local Testing

Clone the repository and test manifests locally:

```powershell
git clone https://github.com/SamuelCastrillon/gentleman-dots-windows.git
cd gentleman-dots-windows

# Add as local bucket
scoop bucket add gentleman-dots-windows ./bucket

# Test install
scoop install gentleman-dots-windows/neovim
```

### Running Tests

```powershell
# Validate manifests
./bin/check-manifests.ps1

# Run verification script
./scripts/verify-gentleman-dots.ps1
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or update manifests
4. Submit a pull request

## License

This bucket follows the same license as Gentleman.Dots. Individual tool licenses apply to their respective packages.

## Resources

- [Scoop Documentation](https://scoop.sh)
- [Scoop Buckets](https://github.com/ScoopInstaller/Bucket)
- [Gentleman.Dots](https://github.com/gentleman-dots)
