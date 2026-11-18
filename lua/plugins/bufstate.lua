-- Disable default keymaps before plugin loads (uncomment to use)
vim.g.bufstate_no_default_maps = 1

return {
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "syntaxpresso/bufstate.nvim",
    dependencies = { "folke/snacks.nvim" }, -- optional, for nicer UI
    lazy = false,
    opts = {
      -- LSP management
      stop_lsp_on_tab_leave = true, -- Stop LSP when leaving a tab
      stop_lsp_on_session_load = true, -- Stop all LSP before loading a session
      autoload_last_session = false, -- Auto-load last session on startup

      -- Autosave
      autosave = {
        enabled = true, -- Enable periodic background saves
        on_exit = true, -- Save when exiting Neovim
        interval = 300000, -- 5 minutes (in ms, 0 = disabled)
        debounce = 30000, -- Minimum 30 seconds between saves
      },
    },

    -- Override default keymaps (uncomment to use)
    keys = {
      { "<leader>qs", "<cmd>BufstateSave<CR>", desc = "Save session" },
      { "<leader>qS", "<cmd>BufstateSaveAs<CR>", desc = "Save session as" },
      { "<leader>ql", "<cmd>BufstateLoad<CR>", desc = "Load session" },
      { "<leader>qd", "<cmd>BufstateDelete<CR>", desc = "Delete session" },
      { "<leader>qn", "<cmd>BufstateNew<CR>", desc = "New session" },
      { "<leader>qc", "<cmd>BufstateClose<CR>", desc = "Close workspace" },
      { "<leader>qa", "<cmd>BufstateAlternate<CR>", desc = "Alternate session" },
    },
  },
  {
    "akinsho/bufferline.nvim",

    opts = function(_, opts)
      opts.options = opts.options or {}

      opts.options.always_show_bufferline = true

      opts.options.custom_filter = function(buf)
        return require("bufstate").buf_filter(buf)
      end

      opts.options.close_command = function(buf)
        require("bufstate").bdelete(buf)
      end
    end,
  },
}
