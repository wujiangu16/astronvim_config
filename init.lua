return {

  -- },
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
  -- colorscheme = "tokyonight-moon",
  -- colorscheme = "github_dark",
  -- colorscheme = "onedarkpro",
  colorscheme = "nordic",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
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
                -- all dir
                vim.fn.getcwd() .. "/**",
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
  icons = {
    ActiveLSP = "",
    ActiveTS = "",
    ArrowLeft = "",
    ArrowRight = "",
    -- BufferClose = "󰅖",
    BufferClose = "",
    DapBreakpoint = "",
    DapBreakpointCondition = "",
    DapBreakpointRejected = "",
    DapLogPoint = ".>",
    -- DapStopped = "󰁕",
    DapStopped = "",
    -- DefaultFile = "󰈙",
    DefaultFile = "",
    -- Diagnostic = "󰒡",
    Diagnostic = "",
    -- DiagnosticError = "",
    DiagnosticError = "",
    -- DiagnosticHint = "󰌵",
    DiagnosticHint = "",
    -- DiagnosticInfo = "󰋼",
    DiagnosticInfo = "",
    -- DiagnosticWarn = "",
    DiagnosticWarn = "",
    Ellipsis = "…",
    FileModified = "",
    FileReadOnly = "",
    FoldClosed = "",
    FoldOpened = "",
    FoldSeparator = " ",
    FolderClosed = "",
    FolderEmpty = "",
    FolderOpen = "",
    -- Git = "󰊢",
    Git = "",
    GitAdd = "",
    GitBranch = "",
    GitChange = "",
    GitConflict = "",
    GitDelete = "",
    -- GitIgnored = "◌",
    GitIgnored = "",
    GitRenamed = "➜",
    GitStaged = "✓",
    -- GitStaged = "",
    GitUnstaged = "✗",
    -- GitUntracked = "★",
    GitUntracked = "",
    LSPLoaded = "",
    LSPLoading1 = "",
    -- LSPLoading2 = "󰀚",
    LSPLoading2 = "",
    LSPLoading3 = "",
    MacroRecording = "",
    -- Paste = "󰅌",
    Paste = "",
    Search = "",
    Selected = "❯",
    -- Spellcheck = "󰓆",
    Spellcheck = "",
    -- TabClose = "󰅙",
    TabClose = "",
  },
}
