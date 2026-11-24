local function scope_explorer_dirchanged_to_its_tab(picker)
  local group = picker.list.win.augroup

  if not group then
    return
  end

  -- Neovim 0.13 fires DirChanged when switching between tabs with different
  -- tab-local directories. Snacks registers this event globally for every
  -- explorer, so replace its handler with one scoped to the active tab.
  for _, autocmd in
    ipairs(vim.api.nvim_get_autocmds({
      group = group,
      event = "DirChanged",
    }))
  do
    vim.api.nvim_del_autocmd(autocmd.id)
  end

  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function(ev)
      if picker.closed or not picker:on_current_tab() then
        return
      end

      local cwd = vim.fs.normalize(ev.file)

      if picker:cwd() ~= cwd then
        picker:set_cwd(cwd)
        picker:find()
      end
    end,
  })
end

return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      replace_netrw = false,
    },
    picker = {
      sources = {
        explorer = {
          on_show = scope_explorer_dirchanged_to_its_tab,
          win = {
            input = {
              keys = {
                ["<c-t>"] = {
                  "tab_tcd_selected",
                  mode = { "n", "i" },
                  desc = "newtab, tcd",
                },
              },
            },
            list = {
              keys = {
                ["<c-t>"] = {
                  "tab_tcd_selected",
                  desc = "newtab, tcd",
                },
              },
            },
          },
        },
        projects = {
          confirm = { "tcd", "picker_files" },
          win = {
            input = {
              keys = {
                ["<c-t>"] = {
                  "tab_tcd_selected",
                  mode = { "n", "i" },
                  desc = "newtab, tcd",
                },
                ["<C-c>"] = {
                  "tcd",
                  mode = { "n", "i" },
                },
              },
            },
            list = {
              ["<c-t>"] = {
                "tab_tcd_selected",
                mode = { "n", "i" },
                desc = "newtab, tcd",
              },
              ["<C-c>"] = {
                "tcd",
                mode = { "n", "i" },
              },
            },
          },
        },
      },
      actions = {
        tcd_selected = function(picker)
          local item = picker:selected({ fallback = true })[1]

          if not item then
            return
          end

          local dir = Snacks.picker.util.dir(item)
          vim.cmd.tcd(dir)
          picker:close()
          Snacks.notify.info("Tab cwd: " .. vim.fn.fnamemodify(dir, ":~"))
        end,
        tab_tcd_selected = function(picker)
          local item = picker:selected({ fallback = true })[1]

          if not item then
            return
          end

          local dir = Snacks.picker.util.dir(item)
          picker:close()
          vim.cmd.tabnew()
          vim.cmd.tcd(dir)
          Snacks.notify.info("New tab cwd: " .. vim.fn.fnamemodify(dir, ":~"))
        end,
      },
      win = {
        input = {
          keys = {
            ["<c-c>"] = {
              "tcd_selected",
              mode = "n",
              desc = "tcd",
            },

            ["<c-t>"] = {
              "tab_tcd_selected",
              mode = "n",
              desc = "newtab, tcd",
            },
            ["<C-M-/>"] = {
              "terminal",
              mode = { "n", "i" },
            },
          },
        },
        list = {
          keys = {
            ["<c-c>"] = {
              "tcd_selected",
              desc = "tcd",
            },
            ["<c-t>"] = {
              "tab_tcd_selected",
              desc = "newtab, tcd",
            },
            ["<C-M-/>"] = {
              "terminal",
              mode = { "n", "i" },
            },
          },
        },
      },
    },
  },
}
