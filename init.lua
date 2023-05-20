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

-- 将当前文件夹同步到远程目录
function Sync_local_to_remote()
  local current_folder = vim.fn.getcwd()

  local remote_dir = read_config_file().remote_dir
  local exclude = table.concat(read_config_file().exclude, " --exclude ")
  local command = "rsync -av --delete " .. "--exclude " .. exclude .. " " .. current_folder .. " " .. remote_dir

  vim.cmd("echo 'Syncing folder " .. current_folder .. " to " .. remote_dir .. "...'")
  vim.cmd("! " .. command)
  vim.cmd "echo 'Sync complete.'"
end

-- 将远程目录同步到本地目录
function Sync_remote_to_local()
  -- 本地目录的上一级目录
  local current_folder = vim.fn.expand "%:p:h:h"

  local remote_dir = read_config_file().remote_dir
  -- 本地目录的名称
  local local_dir_name = vim.fn.expand "%:p:h:t"
  local exclude = table.concat(read_config_file().exclude, " --exclude ")
  local command = "rsync -av --delete "
    .. "--exclude "
    .. exclude
    .. " "
    .. remote_dir
    .. "/"
    .. local_dir_name
    .. " "
    .. current_folder

  vim.cmd("echo 'Syncing folder " .. remote_dir .. " to " .. current_folder .. "...'")
  vim.cmd("! " .. command)
  vim.cmd "echo 'Sync complete.'"
end

-- 对比本地目录和远程目录
function Diff_local_remote()
  local remote_dir = read_config_file().remote_dir
  -- 本地目录的上一级目录
  local local_dir = vim.fn.expand "%:p:h:h"
  local local_dir_name = vim.fn.expand "%:p:h:t"
  local exclude = table.concat(read_config_file().exclude, " --exclude ")
  local command = "rsync -avn "
    .. " --exclude "
    .. exclude
    .. " "
    .. remote_dir
    .. "/"
    .. local_dir_name
    .. " "
    .. local_dir
  vim.cmd("echo 'Diff local dir " .. local_dir .. " and remote dir " .. remote_dir .. "...'")
  vim.cmd("! " .. command)
end

return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
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
