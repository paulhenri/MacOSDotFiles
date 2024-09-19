require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end


require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

local cmp = require('cmp')
cmp.setup {
  completion = {
    autocomplete = false,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete()
  }
}
require('nvim-autopairs').disable()
vim.opt.colorcolumn = "135"

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimports()
  end,
  group = format_sync_grp,
})

require('go').setup()

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local l = vim.fn.line(".")
    local c = vim.fn.col(".")

    local glob_var = vim.g
    glob_var.mode_before_write = vim.cmd("echo mode()")

    vim.cmd("%s/\\s\\+$//e")

    vim.fn.cursor(l,c)
  end
})

