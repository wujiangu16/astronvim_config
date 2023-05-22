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
  -- 本地目录的上一级目录
  local current_folder = vim.fn.expand "%:p:h:h"

  -- 本地目录的名称
  local local_dir_name = vim.fn.expand "%:p:h:t"
  local remote_dir = read_config_file().remote_dir
  local exclude = table.concat(read_config_file().exclude, " --exclude ")
  local command = "rsync -av "
    .. "--exclude "
    .. exclude
    .. " "
    .. current_folder
    .. "/"
    .. local_dir_name
    .. " "
    .. remote_dir

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
  local command = "rsync -av "
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

-- 模拟远程到本地的同步
function Diff_remote_to_local()
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
  vim.cmd("! " .. command)
  print(command)
  vim.cmd("echo 'Diff remode dir " .. remote_dir .. " to local dir " .. local_dir .. "...'")
end

-- 模拟本地到远程的同步
function Diff_local_to_remote()
  local remote_dir = read_config_file().remote_dir
  -- 本地目录的上一级目录
  local local_dir = vim.fn.expand "%:p:h:h"
  local local_dir_name = vim.fn.expand "%:p:h:t"
  local exclude = table.concat(read_config_file().exclude, " --exclude ")
  local command = "rsync -avn "
    .. " --exclude "
    .. exclude
    .. " "
    .. local_dir
    .. "/"
    .. local_dir_name
    .. " "
    .. remote_dir
  vim.cmd("! " .. command)
  print(command)
  vim.cmd("echo 'Diff local dir " .. local_dir .. " to remote dir " .. remote_dir .. "...'")
end
