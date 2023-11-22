-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.listchars = {
  space = ".",
  tab = "» ",
  trail = ".",
  extends = ">",
  precedes = "<",
  eol = "↵",
}
--stab:\|.,trail:.,extends:>,precedes:<
vim.opt.list = true

-- Set color colum at 80 char boundary
vim.opt.colorcolumn = "80"
