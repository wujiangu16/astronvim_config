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
    ["<leader>b"] = { name = "Buffers" },
    -- ["<leader>b1"] = { ":BufferLineGoToBuffer 1<CR>", desc = "goto Buf 1" },
    -- ["<leader>b2"] = { ":BufferLineGoToBuffer 2<CR>", desc = "goto Buf 2" },
    -- ["<leader>b3"] = { ":BufferLineGoToBuffer 3<CR>", desc = "goto Buf 3" },
    -- ["<leader>b4"] = { ":BufferLineGoToBuffer 4<CR>", desc = "goto Buf 4" },
    -- ["<leader>b5"] = { ":BufferLineGoToBuffer 5<CR>", desc = "goto Buf 5" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "ToggleTerm" },
    ["<C-f>"] = { "10jzz", desc = "Page down" },
    ["<C-b>"] = { "10kzz", desc = "Page up" },
    ["<leader>td"] = { "<cmd>TodoTelescope<cr>", desc = "TodoTelescope" },
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
}
