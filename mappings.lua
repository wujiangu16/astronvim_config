-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    -- H --> ^ L --> $
    ["H"] = { "^" },
    ["L"] = { "$" },
    ["<leader>b"] = { name = "Buffers" },
    ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "ToggleTerm" },
    ["<C-f>"] = { "10jzz", desc = "Page down" },
    ["<C-b>"] = { "10kzz", desc = "Page up" },
    ["<leader>td"] = { "<cmd>TodoTelescope<cr>", desc = "TodoTelescope" },
    ["<leader>a"] = { "ggVG", desc = "select all" },
    ["<leader>y"] = { ":%y+<cr>", desc = "yank all" },
    ["<leader>f'"] = { "<cmd>Telescope vim_bookmarks all<cr>", desc = "Telescope vim_bookmarks all" },
    -- sync
    ["<leader>r"] = { name = "sync folder or buffer" },
    ["<leader>rb"] = { name = "sync buffer" },
    ["<leader>rd"] = { name = "sync floder with delete" },
    ["<leader>rt"] = { name = "test sync floder" },
    ["<leader>rtd"] = { name = "test sync floder with delete" },
    ["<leader>rs"] = { ":lua  Sync_local_to_remote('')<cr>", desc = "Sync_local_to_remote" },
    ["<leader>rm"] = { ":lua  Sync_remote_to_local('')<cr>", desc = "Sync_remote_to_local" },
    ["<leader>rbs"] = { ":lua Sync_buffer_local_to_remote('')<cr>", desc = "Sync_buffer_local_to_remote" },
    ["<leader>rbm"] = { ":lua  Sync_buffer_remote_to_local('')<cr>", desc = "Sync_buffer_remote_to_local" },
    ["<leader>rds"] = { ":lua  Sync_local_to_remote(' --delete ')<cr>", desc = "Sync_local_to_remote(delete)" },
    ["<leader>rdm"] = { ":lua Sync_remote_to_local( ' --delete ')<cr>", desc = "Sync_remote_to_local(delete)" },
    ["<leader>rts"] = { ":lua  Sync_local_to_remote(' -n ')<cr>", desc = "Diff_local_to_remote" },
    ["<leader>rtm"] = { ":lua Sync_remote_to_local( ' -n ')<cr>", desc = "Diff_remote_to_local" },
    ["<leader>rtds"] = { ":lua  Sync_local_to_remote(' -n --delete ')<cr>", desc = "Diff_local_to_remote(delete)" },
    ["<leader>rtdm"] = { ":lua Sync_remote_to_local( ' -n --delete ')<cr>", desc = "Sync_remote_to_local(delete)" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
    ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "ToggleTerm" },
  },
  -- insert mode mapping
  i = {
    -- ["<C-s>"] = { "<esc>:w!<cr>", desc = "Save File" },
    ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "ToggleTerm" },
  },
  v = {
    ["<C-f>"] = { "10jzz", desc = "Page down" },
    ["<C-b>"] = { "10kzz", desc = "Page up" },
  },
}
