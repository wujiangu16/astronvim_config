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
function Sync_local_to_remote(arg)
  local cwd = vim.fn.getcwd()
  local root_dir = string.gsub(cwd, [[\]], [[/]])

  -- 获取上一级目录名称
  local parent_dir = string.match(root_dir, "(.*/)(.*)")
  parent_dir = parent_dir ~= nil and parent_dir or ""

  -- 获取最后一级目录名称
  local _, _, last_dir = string.find(root_dir, "([^/]+)$")
  last_dir = last_dir ~= nil and last_dir or ""
  local remote_dir = read_config_file().remote_dir
  local exclude = table.concat(read_config_file().exclude, " --exclude ")
  local command = "rsync -av " .. arg .. "--exclude " .. exclude .. " " .. parent_dir .. last_dir .. " " .. remote_dir

  vim.cmd("echo 'Syncing folder " .. parent_dir .. last_dir .. " to " .. remote_dir .. last_dir .. "...'")
  vim.cmd("! " .. command)
  vim.cmd "echo 'Sync complete.'"
end

-- 将远程目录同步到本地目录
function Sync_remote_to_local(arg)
  local cwd = vim.fn.getcwd()
  local root_dir = string.gsub(cwd, [[\]], [[/]])

  -- 获取上一级目录名称
  local parent_dir = string.match(root_dir, "(.*/)(.*)")
  parent_dir = parent_dir ~= nil and parent_dir or ""

  -- 获取最后一级目录名称
  local _, _, last_dir = string.find(root_dir, "([^/]+)$")
  last_dir = last_dir ~= nil and last_dir or ""
  local remote_dir = read_config_file().remote_dir
  local exclude = table.concat(read_config_file().exclude, " --exclude ")
  local command = "rsync -av " .. arg .. "--exclude " .. exclude .. " " .. remote_dir .. last_dir .. " " .. parent_dir

  vim.cmd("echo 'Syncing folder " .. remote_dir .. last_dir .. " to " .. parent_dir .. last_dir .. "...'")
  vim.cmd("! " .. command)
  vim.cmd "echo 'Sync complete.'"
end

-- 将当前 buffer 同步到远程目录
function Sync_buffer_local_to_remote(arg)
  -- 获取当前工作目录
  local cwd = vim.fn.getcwd()
  local root_dir = string.gsub(cwd, [[\]], [[/]])

  -- 获取当前工作文件夹名称
  local _, _, last_dir = string.find(root_dir, "([^/]+)$")

  -- 获取工作到当前 buffer 的相对路径
  local buffer_path = vim.fn.expand "%:p"
  local _, _, relative_path = string.find(buffer_path, root_dir .. "(.*)")

  if relative_path == nil then
    vim.cmd "echo 'No relative path.'"
    return
  end

  local remote_dir = read_config_file().remote_dir
  local exclude = table.concat(read_config_file().exclude, " --exclude ")

  local command = "rsync -av "
      .. arg
      .. "--exclude "
      .. exclude
      .. " "
      .. buffer_path
      .. " "
      .. remote_dir
      .. last_dir
      .. relative_path
  vim.cmd("echo 'Syncing file " .. buffer_path .. " to " .. remote_dir .. last_dir .. relative_path .. "...'")
  vim.cmd("! " .. command)
  print(command)
end

-- 将远程目录同步到本地目录
function Sync_buffer_remote_to_local(arg)
  -- 获取当前工作目录
  local cwd = vim.fn.getcwd()
  local root_dir = string.gsub(cwd, [[\]], [[/]])

  -- 获取当前工作文件夹名称
  local _, _, last_dir = string.find(root_dir, "([^/]+)$")

  -- 获取工作到当前 buffer 的相对路径
  local buffer_path = vim.fn.expand "%:p"
  local _, _, relative_path = string.find(buffer_path, root_dir .. "(.*)")

  if relative_path == nil then
    vim.cmd "echo 'No relative path.'"
    return
  end

  local remote_dir = read_config_file().remote_dir
  local exclude = table.concat(read_config_file().exclude, " --exclude ")

  local command = "rsync -av "
      .. arg
      .. "--exclude "
      .. exclude
      .. " "
      .. remote_dir
      .. last_dir
      .. relative_path
      .. " "
      .. buffer_path
  vim.cmd("echo 'Syncing file " .. remote_dir .. last_dir .. relative_path .. " to " .. buffer_path .. "...'")
  vim.cmd("! " .. command)
  print(command)
end

-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true,         -- sets vim.opt.number
    spell = false,         -- sets vim.opt.spell
    signcolumn = "auto",   -- sets vim.opt.signcolumn to auto
    wrap = false,          -- sets vim.opt.wrap
  },
  g = {
    mapleader = " ",                 -- sets vim.g.mapleader
    autoformat_enabled = true,       -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true,              -- enable completion at start
    autopairs_enabled = true,        -- enable autopairs at start
    diagnostics_mode = 3,            -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true,            -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
  },
}
-- If you need more control, you can use the function()...end notation
-- return function(local_vim)
--   local_vim.opt.relativenumber = true
--   local_vim.g.mapleader = " "
--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
--
--   return local_vim
-- end
