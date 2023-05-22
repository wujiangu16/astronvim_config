return {
  {
    "linux-cultist/venv-selector.nvim",
    config = function()
      require("venv-selector").setup {
        -- your config
        -- python3_bin = "python3",
        python3_bin = "/opt/anaconda3/envs/torch/bin",
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    cmd = "TodoTelescope",
    config = function() require("todo-comments").setup {} end,
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function(plugin, opts)
      require "plugins.configs.luasnip" (plugin, opts)                                       -- include the default astronvim config that calls the setup call
      require("luasnip.loaders.from_vscode").lazy_load { paths = { "./lua/user/snippets" } } -- load snippets paths
    end,
  },
  {
    "MattesGroeger/vim-bookmarks",
    event = "UIEnter",
    -- cmd = "Telescope vim_bookmarks all",
  },
  {
    "tom-anders/telescope-vim-bookmarks.nvim",
    config = function() require("telescope").load_extension "vim_bookmarks" end,
  },
  {
    "mg979/vim-visual-multi",
    event = "BufRead",
  },
}
