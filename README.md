# alkupaaoma.nvim

A **minimal, lazy-loaded Neovim configuration** for backend development in **Rust, C/C++, TypeScript, Lua, and Python**. Includes LSP, debugging, formatting, linting, and project management tools.

---

## ✨ Features

- **Language Support**: Rust, C/C++, TypeScript, Lua, Python
- **LSP**: `rust_analyzer`, `clangd`, `tsserver`, `lua_ls`, `pyright`
- **Completion**: `nvim-cmp` with LSP, buffer, and snippet support
- **Debugging**: `nvim-dap` with `codelldb` (Rust/C++) and `lldb`
- **Testing**: `neotest` with adapters for Rust, Python, and TypeScript
- **Formatting**: `conform.nvim` with `stylua`, `rustfmt`, `clang-format`, `prettier`, `black`
- **Linting**: `nvim-lint` with `pylint`, `eslint_d`, `clang-tidy`
- **Project Management**: `telescope.nvim`, `nvim-tree.lua`, `neogit`
- **UI**: `lualine.nvim`, `bufferline.nvim`, `indent-blankline.nvim`, `noice.nvim`
- **Utilities**: `Comment.nvim`, `nvim-surround`, `nvim-autopairs`, `toggleterm.nvim`
- **Themes**: `catppuccin`

---

## 📦 Installation

### 1. Clone the Repository

```bash
# Backup your existing Neovim config (if any)
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

# Clone this repository
git clone https://github.com/vilppolahti/alkupaaoma.nvim ~/.config/nvim
```

### 2. Install System Dependencies

Run the included script to install all system-level dependencies (Neovim, Git, build tools, language servers, formatters, linters, debuggers):

```bash
cd ~/.config/nvim
chmod +x scripts/install_deps.sh
./scripts/install_deps.sh
```

> **Note:** The script detects your OS (Arch Linux or Ubuntu/Debian) and installs the correct packages.

### 3. Restart Your Terminal

After running the script, restart your terminal or run:

```bash
source ~/.bashrc
```

### 4. Launch Neovim and Sync Plugins

```bash
nvim
```

Inside Neovim, run:

```vim
:Lazy sync
```

This will install all the plugins defined in `lua/alkupaaoma/init.lua`.

---

## 🛠️ Requirements

- **Neovim**: >= 0.11.0 (required for full functionality)
- **Git**: For cloning plugins
- **OS**: Arch Linux or Ubuntu/Debian (tested and supported)

---

## 📂 Repository Structure

```
alkupaaoma.nvim/
├── lua/
│   └── alkupaaoma/
│       └── init.lua          # Main Neovim configuration
├── scripts/
│   └── install_deps.sh      # Script to install system dependencies
└── README.md                 # This file
```

---

## 🎯 Keybindings

The configuration uses **`9` as the leader key**. Here are the main keybindings:

### General
| Key       | Action                          |
|-----------|---------------------------------|
| `9e`      | Toggle file explorer (nvim-tree) |
| `9ff`     | Find files (Telescope)           |
| `9fg`     | Live grep (Telescope)            |
| `9fb`     | Find buffers (Telescope)         |
| `9fh`     | Help tags (Telescope)            |

### Git
| Key       | Action                          |
|-----------|---------------------------------|
| `9gs`     | Toggle Git signs                 |
| `9gb`     | Git blame line                   |
| `9gp`     | Preview Git hunk                 |
| `9gr`     | Reset Git hunk                   |
| `9gS`     | Stage Git hunk                   |
| `9gU`     | Undo stage Git hunk              |
| `9gt`     | Open Neogit                      |

### Debugging (DAP)
| Key       | Action                          |
|-----------|---------------------------------|
| `9dc`     | Continue debugging               |
| `9dt`     | Toggle breakpoint                |
| `9ds`     | Step over                       |
| `9di`     | Step into                       |
| `9do`     | Step out                        |
| `9dr`     | Open REPL                       |
| `9du`     | Toggle DAP UI                   |

### Formatting & Linting
| Key       | Action                          |
|-----------|---------------------------------|
| `9tf`     | Format buffer                    |
| `9tl`     | Lint buffer                      |

### Terminal
| Key       | Action                          |
|-----------|---------------------------------|
| `9tt`     | Toggle terminal (float)         |
| `9tv`     | Toggle terminal (vertical)       |
| `9th`     | Toggle terminal (horizontal)     |

### Comments
| Key       | Action                          |
|-----------|---------------------------------|
| `9/` (Normal) | Toggle comment line          |
| `9/` (Visual) | Toggle comment block         |

### Surround
| Key       | Action                          |
|-----------|---------------------------------|
| `ys`      | Surround selection               |
| `yss`     | Surround line                    |
| `S` (Visual) | Surround visual selection    |

### Noice (Notifications)
| Key       | Action                          |
|-----------|---------------------------------|
| `9nd`     | Dismiss notification             |
| `9nc`     | Toggle cmdline                   |

### Trouble (Diagnostics)
| Key       | Action                          |
|-----------|---------------------------------|
| `9xx`     | Toggle Trouble                   |

---

## 🔧 Customization

### Adding Plugins
Edit `lua/alkupaaoma/init.lua` and add your plugins to the `plugins` table. Use `lazy.nvim` for lazy-loading.

### Changing Keybindings
Modify the `vim.keymap.set` calls in `lua/alkupaaoma/init.lua` to change or add keybindings.

### Changing Themes
Replace `catppuccin` with your preferred theme in the `plugins` table and update the `colorscheme` command.

---

## 🐛 Troubleshooting

### Neovim Version
Ensure you are using **Neovim >= 0.11.0**:

```bash
nvim --version
```

### Missing Dependencies
If you encounter errors about missing tools (e.g., `rustfmt`, `clangd`), ensure the `install_deps.sh` script ran successfully.

### Plugin Issues
If a plugin fails to load, run:

```vim
:Lazy sync
```

### Debugging
To check for errors, run:

```vim
:messages
```

---

## 📜 License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- [Neovim](https://neovim.io/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- All the amazing plugin authors!