-- 执行命令并获取输出结果
local function executeCommand(command)
  local file = io.popen(command)
  local output = file:read "*a"
  file:close()
  return output
end

local function read_config_file()
  if vim.fn.filereadable ".syncconfig" == 0 then
    print "No configuration file found."
    return {}
  end
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
        -- password
        if parts[1] == "password" then current_config.password = parts[2] end
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
  local exclude = "--exclude='.*' --exclude='*.swp' --exclude='*.swo' --exclude='*.swx' --exclude='*__pycache__'"
  -- 设置无响应时间为 3s
  local command = "rsync -av "
    .. arg
    .. exclude
    .. " "
    .. parent_dir
    .. last_dir
    .. "/ "
    .. remote_dir
    .. last_dir
    .. "/"
    .. " --timeout=3"

  print(command)

  -- -- 使用 ~/.config/nvim/lua/user/sync.sh 脚本 参数 1 为 password 参数 2 为 command
  command = "~/.config/nvim/lua/user/sync.sh " .. selected_config.password .. " " .. "'" .. command .. "'"
  -- print(command)
  --
  print("Syncing folder " .. parent_dir .. last_dir .. " to " .. remote_dir .. last_dir .. "...")
  local res = executeCommand(command)
  print(res)
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
  local exclude = "--exclude='.*' --exclude='*.swp' --exclude='*.swo' --exclude='*.swx' --exclude='*__pycache__'"
  local command = "rsync -av "
    .. arg
    .. exclude
    .. " "
    .. remote_dir
    .. last_dir
    .. "/ "
    .. " "
    .. parent_dir
    .. "/"
    .. " --timeout=3"

  -- 使用 ~/.config/nvim/lua/user/sync.sh 脚本 参数 1 为 password 参数 2 为 command
  command = "~/.config/nvim/lua/user/sync.sh " .. selected_config.password .. " " .. "'" .. command .. "'"

  vim.cmd("echo 'Syncing folder " .. remote_dir .. last_dir .. " to " .. parent_dir .. last_dir .. "...'")
  local res = executeCommand(command)
  print(res)
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
  local command = "rsync -av "
    .. arg
    .. " "
    .. buffer_path
    .. " "
    .. remote_dir
    .. last_dir
    .. relative_path
    .. " --timeout=3"

  -- 使用 ~/.config/nvim/lua/user/sync.sh 脚本 参数 1 为 password 参数 2 为 command
  command = "~/.config/nvim/lua/user/sync.sh " .. selected_config.password .. " " .. "'" .. command .. "'"

  vim.cmd("echo 'Syncing file " .. buffer_path .. " to " .. remote_dir .. last_dir .. relative_path .. "...'")
  vim.cmd("! " .. command)
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

  local command = "rsync -av "
    .. arg
    .. " "
    .. remote_dir
    .. last_dir
    .. relative_path
    .. " "
    .. buffer_path
    .. " --timeout=3"
  command = "~/.config/nvim/lua/user/sync.sh " .. selected_config.password .. " " .. "'" .. command .. "'"
  vim.cmd("echo 'Syncing file " .. remote_dir .. last_dir .. relative_path .. " to " .. buffer_path .. "...'")
  local res = executeCommand(command)
  print(res)
end
