return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[1] = LazyVim.lualine.root_dir({ cwd = true })
    end,
  },
}
