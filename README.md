# `root_swapper.nvim`

This is a tiny plugin that sets up an autocommand to `lcd` to detected root directories when switching buffers.

Supports [oil.nvim](https://github.com/stevearc/oil.nvim) buffers - when navigating directories in oil, your `lcd` will update to the appropriate project root based on the current directory.


# 📦 Installation

[Lazy.nvim](https://github.com/folke/lazy.nvim) minimal installation:

```lua
return {
    "cosmicbuffalo/root_swapper.nvim",
}
```

## ⚙️ Customizable Configuration

```lua
opts = {
    root_indicators = { ".git", "Gemfile", "Makefile" } -- An array of filenames indicating root directories
}
```
