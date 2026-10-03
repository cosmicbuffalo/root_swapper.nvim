---@class RootSwapper
local M = {}

---@class RootSwapperOpts
---@field root_indicators? string[]

---@class RootSwapperDefaults: RootSwapperOpts
---@field root_indicators string[]
local default_config = {
  root_indicators = { ".git", "Gemfile", "Makefile" },
}

local root_indicators = {} ---@type string[]
local root_cache = {} ---@type table<string, string>
local did_setup = false ---@type boolean

---@return string? path
local function get_path_from_buffer()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return
  end

  -- Check if this is an oil buffer
  if bufname:match("^oil://") then
    -- Try to use oil's API if available
    local ok, oil = pcall(require, "oil")
    -- Fallback: parse the oil:// URL directly
    return (ok and oil and oil.get_current_dir) and oil.get_current_dir() or (bufname:gsub("^oil://", ""))
  end

  -- Regular buffer - return the directory containing the file
  return vim.fs.dirname(bufname)
end

function M.swap_root()
  -- Get directory path to start search from
  local path = get_path_from_buffer()
  if not path then
    return
  end

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if not root then
    local root_file = vim.fs.find(root_indicators, { path = path, upward = true })[1]
    if not root_file then
      return
    end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end

  vim.cmd.lcd({ args = { root } })
end

local function setup_autocmd()
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("RootSwapper", { clear = true }),
    callback = function()
      M.swap_root()
    end,
  })
end

---@param config? RootSwapperOpts
function M.setup(config)
  config = config or {}
  root_indicators = config.root_indicators or default_config.root_indicators

  if not did_setup then
    setup_autocmd()
    did_setup = true
  end
end

return M
