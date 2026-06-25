-- Load nixCats utility
require('nixCatsUtils').setup {
  non_nix_value = true,
}

-- Load config
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Setup lazy.nvim via nixCats wrapper
require('nixCatsUtils.lazyCat').setup(
  nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' },
  {
    { import = "plugins" },
  },
  {
    defaults = { lazy = false },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true, notify = false },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  }
)

-- Noctalia matugen setup
local function safe_require(name)
  local ok, module = pcall(require, name)
  return ok and module or nil
end

local matugen = safe_require('matugen')
if matugen then
  matugen.setup()
end

-- Signal handler for Noctalia theme reload
local signal = vim.loop.new_signal()
signal:start('sigusr1', vim.schedule_wrap(function()
  package.loaded['matugen'] = nil
  require('matugen').setup()
end))
