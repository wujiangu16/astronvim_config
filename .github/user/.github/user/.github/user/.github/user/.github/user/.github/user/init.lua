-- 获取同步配置文件中的参数
local function read_config_file()
  local config = {}
  config.exclude = {}
  for line in io.lines ".syncconfig" do
    local parts = vim.split(line, " ")
    if parts[1] == "exclude" then
      table.remove(parts, 1)
      for _, exclude in ipairs(parts) do
        table.insert(config.exclude, exclude)
      end
    else
      config.remote_dir = parts[1]
    end
  end
  return config
end

-- 获取当前 buffer 所在文件夹的路径
local function get_current_folder() return vim.fn.expand "%:p:h" end

-- 获取当前 buffer 的文件/文件夹名称
local function get_current_name() return vim.fn.expand "%:t" end

-- 将当前文件夹同步到远程目录
function Sync_folder_to_remote()
  local current_folder = get_current_folder()
  local current_name = get_current_name()
  local remote_dir = read_config_file().remote_dir
  local exclude = table.concat(read_config_file().exclude, " --exclude ")
  local command = "rsync -aP --delete " .. current_folder .. " " .. remote_dir .. "/ --exclude " .. exclude
  vim.cmd("echo 'Syncing folder " .. current_name .. " to " .. remote_dir .. "...'")
  vim.cmd("! " .. command)
  vim.cmd "echo 'Sync complete.'"
end

-- 绑定快捷键，调用 sync_folder_to_remote 函数
vim.api.nvim_set_keymap("n", "<F12>", ":lua Sync_folder_to_remote()<CR>", { noremap = true, silent = true })

-- vim.api.nvim_set_keymap("n", "<F12>", ":lua SyncNerdTree()<CR>", { noremap = true, silent = true })
--
-- -- Define the function to sync the specified folder to the specified server directory
-- function SyncNerdTree()
--   local path = vim.fn.expand "%:p:h"         -- the current folder
--   local config_file = path .. "/.syncconfig" -- the config file
--   if vim.fn.filereadable(config_file) == 1 then
--     local server_dir = vim.fn.readfile(config_file)[1]
--     vim.fn.system('rsync -av --delete --exclude=".git" --exclude=".swp" -P' .. path .. " " .. server_dir)
--     print "Sync successful!"           -- feedback message
--   else
--     print "No .syncconfig file found!" -- feedback message
--   end
-- end

return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin",     -- remote to use
    channel = "stable",    -- "stable" or "nightly"
    version = "latest",    -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly",    -- branch name (NIGHTLY ONLY)
    commit = nil,          -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil,     -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false,  -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false,     -- automatically quit the current session after a successful update
    remotes = {            -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "astrodark",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    -- formatting = {
    --   -- control auto formatting on save
    --   format_on_save = {
    --     enabled = true,     -- enable or disable format on save globally
    --     allow_filetypes = { -- enable format on save for specified filetypes only
    --       -- "go",
    --     },
    --     ignore_filetypes = { -- disable format on save for specified filetypes
    --       -- "python",
    --     },
    --   },
    --   disabled = { -- disable formatting capabilities for the listed language servers
    --     -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
    --     -- "lua_ls",
    --   },
    --   timeout_ms = 1000, -- default format timeout
    --   -- filter = function(client) -- fully override the default formatting function
    --   --   return true
    --   -- end
    -- },
    -- enable servers that you already have installed without mason
    servers = {
      "pyright",
    },
    config = {
      pyright = {
        settings = {
          python = {
            analysis = {
              -- set include paths for intellisense
              extraPaths = {
                vim.fn.getcwd(),
              },
              workingDirectory = vim.fn.getcwd(),
              typeCheckingMode = "off",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}
