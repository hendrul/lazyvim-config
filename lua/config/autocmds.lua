-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local tab_cwd_group = vim.api.nvim_create_augroup("tab_cwd_name", { clear = true })

local function update_tab_cwd_name(tabpage)
  if not vim.api.nvim_tabpage_is_valid(tabpage) then
    return
  end

  local tabnr = vim.api.nvim_tabpage_get_number(tabpage)
  local cwd = vim.fn.getcwd(-1, tabnr)

  if cwd == "" then
    return
  end

  local name = vim.fs.basename(vim.fs.normalize(cwd))
  vim.api.nvim_tabpage_set_var(tabpage, "name", name ~= "" and name or cwd)
end

local function refresh_tab_cwd_names()
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    update_tab_cwd_name(tabpage)
  end
  vim.cmd.redrawtabline()
end

vim.api.nvim_create_autocmd({ "DirChanged", "TabEnter", "TabNewEntered" }, {
  group = tab_cwd_group,
  callback = refresh_tab_cwd_names,
})

vim.schedule(refresh_tab_cwd_names)
