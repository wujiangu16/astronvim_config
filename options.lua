local function read_config_file()
  local configs = {}
  local current_config = {}
  local line_num = 1

  for line in io.lines ".syncconfig" do
    if line ~= "" then
      if line_num == 1 then
        local parts = vim.split(line, ":")
        if parts[1] ~= "name" then
          print "Invalid configuration file."
          return {}
        end
        current_config.name = parts[2]
      elseif line_num == 2 then
        local parts = vim.split(line, ":")
        if parts[1] ~= "remote" then
          print "Invalid configuration file."
          return {}
        end
        -- remove part[1]
        table.remove(parts, 1)
        local remote_dir = table.concat(parts, ":")
        current_config.remote_dir = remote_dir
      elseif line_num == 3 then
        local parts = vim.split(line, ":")
        if parts[1] ~= "exclude" then
          print "Invalid configuration file."
          return {}
        end
        local exclude = vim.split(parts[2], " ")
        current_config.exclude = {}
        for _, item in ipairs(exclude) do
          table.insert(current_config.exclude, item)
        end
        -- 将当前配置添加到列表中
        table.insert(configs, current_config)
        current_config = {}
      end

      line_num = line_num + 1
      if line_num > 3 then line_num = 1 end
    end
  end

  return configs
end

local function display_config_list(configs)
  print "Select a remote host to sync with:"
  for i, config in ipairs(configs) do
    print(i .. ". " .. config.name)
  end
end

function Sync_local_to_remote(arg)
  local configs = read_config_file()

  if #configs == 0 then
    print "No remote hosts found in the configuration file."
    return
  end

  display_config_list(configs)
  -- get user input
  -- 监听用户输入
  local input_str = vim.fn.input "Enter your choice: "
  local choice = tonumber(input_str)

  if choice == nil or choice < 1 or choice > #configs then
    print "Invalid choice."
    return
  end

  local selected_config = configs[choice]
  local cwd = vim.fn.getcwd()
  local root_dir = string.gsub(cwd, [[\]], [[/]])
  local parent_dir = string.match(root_dir, "(.*/)(.*)")
  parent_dir = parent_dir ~= nil and parent_dir or ""
  local _, _, last_dir = string.find(root_dir, "([^/]+)$")
  last_dir = last_dir ~= nil and last_dir or ""
  local remote_dir = selected_config.remote_dir
  local exclude = table.concat(selected_config.exclude, " --exclude ")
  local command = "rsync -av " .. arg .. exclude .. " " .. parent_dir .. last_dir .. " " .. remote_dir

  print("Syncing folder " .. parent_dir .. last_dir .. " to " .. remote_dir .. last_dir .. "...")
  vim.cmd("! " .. command)
  print(command)
  print "Sync complete."
end

-- 将远程目录同步到本地目录
function Sync_remote_to_local(arg)
  local configs = read_config_file()

  if #configs == 0 then
    print "No remote hosts found in the configuration file."
    return
  end

  display_config_list(configs)
  -- get user input
  -- 监听用户输入
  local input_str = vim.fn.input "Enter your choice: "
  local choice = tonumber(input_str)

  if choice == nil or choice < 1 or choice > #configs then
    print "Invalid choice."
    return
  end

  local selected_config = configs[choice]

  local cwd = vim.fn.getcwd()
  local root_dir = string.gsub(cwd, [[\]], [[/]])

  -- 获取上一级目录名称
  local parent_dir = string.match(root_dir, "(.*/)(.*)")
  parent_dir = parent_dir ~= nil and parent_dir or ""

  -- 获取最后一级目录名称
  local _, _, last_dir = string.find(root_dir, "([^/]+)$")
  last_dir = last_dir ~= nil and last_dir or ""
  local remote_dir = selected_config.remote_dir
  local exclude = table.concat(selected_config.exclude, " --exclude ")
  local command = "rsync -av " .. arg .. "--exclude " .. exclude .. " " .. remote_dir .. last_dir .. " " .. parent_dir

  vim.cmd("echo 'Syncing folder " .. remote_dir .. last_dir .. " to " .. parent_dir .. last_dir .. "...'")
  vim.cmd("! " .. command)
  vim.cmd "echo 'Sync complete.'"
end

-- 将当前 buffer 同步到远程目录
function Sync_buffer_local_to_remote(arg)
  local configs = read_config_file()

  if #configs == 0 then
    print "No remote hosts found in the configuration file."
    return
  end

  display_config_list(configs)
  -- get user input
  -- 监听用户输入
  local input_str = vim.fn.input "Enter your choice: "
  local choice = tonumber(input_str)

  if choice == nil or choice < 1 or choice > #configs then
    print "Invalid choice."
    return
  end

  local selected_config = configs[choice]
  -- 获取当前工作目录
  local cwd = vim.fn.getcwd()
  local root_dir = string.gsub(cwd, [[\]], [[/]])

  -- 获取当前工作文件夹名称
  local _, _, last_dir = string.find(root_dir, "([^/]+)$")

  -- 获取工作到当前 buffer 的相对路径
  local buffer_path = vim.fn.expand "%:p"
  -- buffer_path - root_dir = relative_path
  local relative_path = buffer_path:sub(#root_dir + 1)

  if relative_path == nil then
    vim.cmd "echo 'No relative path.'"
    return
  end

  local remote_dir = selected_config.remote_dir
  local command = "rsync -av " .. arg .. " " .. buffer_path .. " " .. remote_dir .. last_dir .. relative_path
  vim.cmd("echo 'Syncing file " .. buffer_path .. " to " .. remote_dir .. last_dir .. relative_path .. "...'")
  vim.cmd("! " .. command)
  print(command)
end

-- 将远程 buffer 同步到本地目录
function Sync_buffer_remote_to_local(arg)
  local configs = read_config_file()

  if #configs == 0 then
    print "No remote hosts found in the configuration file."
    return
  end

  display_config_list(configs)
  -- get user input
  -- 监听用户输入
  local input_str = vim.fn.input "Enter your choice: "
  local choice = tonumber(input_str)

  if choice == nil or choice < 1 or choice > #configs then
    print "Invalid choice."
    return
  end

  local selected_config = configs[choice]
  -- 获取当前工作目录
  local cwd = vim.fn.getcwd()
  local root_dir = string.gsub(cwd, [[\]], [[/]])

  -- 获取当前工作文件夹名称
  local _, _, last_dir = string.find(root_dir, "([^/]+)$")

  -- 获取工作到当前 buffer 的相对路径
  local buffer_path = vim.fn.expand "%:p"
  -- relative_path = buffer_path[len(root_dir):]
  local relative_path = buffer_path:sub(#root_dir + 1)

  if relative_path == nil then
    vim.cmd "echo 'No relative path.'"
    return
  end

  local remote_dir = selected_config.remote_dir

  local command = "rsync -av " .. arg .. " " .. remote_dir .. last_dir .. relative_path .. " " .. buffer_path
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
