return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      replace_netrw = false,
    },
    picker = {
      sources = {
        projects = {
          confirm = { "tcd", "picker_files" },
        },
      },
    },
  },
}
