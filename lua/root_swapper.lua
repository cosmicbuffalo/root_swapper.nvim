local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local default_config = {
  root_indicators = { ".git", "Gemfile", "Makefile" },
}

local root_indicators = {}
local root_cache = {}
local did_setup = false

function M.swap_root()
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return
  end
  path = vim.fs.dirname(path)

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_indicators, { path = path, upward = true })[1]
    if root_file == nil then
      return
    end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end

  vim.cmd("lcd " .. root)
end

local function setup_autocmd()
  local group = augroup("RootSwapper", { clear = true })
  autocmd("BufEnter", { group = group, callback = M.swap_root })
end

function M.setup(config)
  config = config or {}
  root_indicators = config.root_indicators or default_config.root_indicators

  if did_setup then
    return
  end

  setup_autocmd()
  did_setup = true
end

return M
