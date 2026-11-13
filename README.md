# Neovim config

Standalone [lazy.nvim](https://github.com/folke/lazy.nvim) config (formerly based on NvChad). Requires **Neovim ≥ 0.11**.

## Installation

1. Clone it
2. Run the install script (`install.ps1` / `install.sh`)
3. Open nvim (plugins install automatically)
4. `:MasonInstallAll` (LSPs: lua, clangd, rust-analyzer, zls, vhdl_ls, plus tree-sitter-cli), then restart nvim
5. ???
6. Profit

## Layout

```
init.lua
lua/config/   options, keymaps, autocmds, lazy bootstrap
lua/plugins/  one lazy.nvim spec file per topic (ui, editor, lsp, rust, terminal, latex)
```

## Language servers

| Language | Server |
|---|---|
| C / C++ | clangd (format on save) |
| Rust | rust-analyzer via rustaceanvim |
| Zig | zls |
| VHDL | vhdl_ls (rust_hdl), needs a `vhdl_ls.toml` in the project root |
| Lua | lua_ls |

Inlay hints are enabled automatically wherever the server supports them (toggle: `<leader>ih`).

## Dependencies

- Yazi
- LaTeX (in some way or another) + zathura (Knap viewer)
- ripgrep (Telescope live grep)
- A C compiler (e.g. `zig cc`/gcc) for tree-sitter parsers
- git
