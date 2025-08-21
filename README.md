# `root_swapper.nvim`

This is a tiny plugin that sets up an autocommand to `lcd` to detected root directories when switching buffers. 


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
