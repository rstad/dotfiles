local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

local is_windows = wezterm.target_triple:find('windows') ~= nil

config.color_scheme = 'idleToes'
config.font_size = 14

-- Windows: open WSL by default, with PowerShell and cmd a keystroke away
if is_windows then
  local function exe_exists(name)
    local ok = wezterm.run_child_process { 'where', name }
    return ok
  end

  -- Start WSL tabs in the Linux home, and make the first distro the default
  local wsl_domains = wezterm.default_wsl_domains()
  for _, dom in ipairs(wsl_domains) do
    dom.default_cwd = '~'
  end
  config.wsl_domains = wsl_domains
  local first_wsl_name = wsl_domains[1] and wsl_domains[1].name
  if first_wsl_name then
    config.default_domain = first_wsl_name
  end

  local shells = {}
  if exe_exists('pwsh.exe') then
    table.insert(shells, { label = 'PowerShell (pwsh)', args = { 'pwsh.exe', '-NoLogo' } })
  end
  if exe_exists('powershell.exe') then
    table.insert(shells, { label = 'PowerShell (Windows)', args = { 'powershell.exe', '-NoLogo' } })
  end
  local powershell = shells[1]
  local cmd = exe_exists('cmd.exe') and { label = 'Command Prompt', args = { 'cmd.exe' } }
  if cmd then
    table.insert(shells, cmd)
  end

  -- "local" forces the Windows side, since the default domain is WSL
  local windows_domain = { DomainName = 'local' }

  local launch_menu = {}
  for _, shell in ipairs(shells) do
    table.insert(launch_menu, { label = shell.label, domain = windows_domain, args = shell.args })
  end
  for _, dom in ipairs(wsl_domains) do
    table.insert(launch_menu, { label = 'WSL: ' .. dom.distribution, domain = { DomainName = dom.name } })
  end
  config.launch_menu = launch_menu

  local keys = {
    -- New tabs: WSL, PowerShell, cmd
    {
      key = 'w', mods = 'CTRL|ALT',
      action = first_wsl_name and act.SpawnTab { DomainName = first_wsl_name }
        or act.SpawnCommandInNewTab { args = { 'wsl.exe' } },
    },
    -- Splits stay in the current pane's domain
    { key = '\\', mods = 'CTRL|ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'CTRL|ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
    { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
    { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },
  }
  if powershell then
    table.insert(keys, {
      key = 'p', mods = 'CTRL|ALT',
      action = act.SpawnCommandInNewTab { domain = windows_domain, args = powershell.args },
    })
  end
  if cmd then
    table.insert(keys, {
      key = 'c', mods = 'CTRL|ALT',
      action = act.SpawnCommandInNewTab { domain = windows_domain, args = cmd.args },
    })
  end
  for i = 1, 9 do
    table.insert(keys, { key = tostring(i), mods = 'ALT', action = act.ActivateTab(i - 1) })
  end
  config.keys = keys
end

-- Link detection, used on Shift+click inside zellij or herdr (a plain click
-- goes to them). The built-in rule keeps a trailing ")", which breaks
-- markdown-style text(https://...). This one allows matched (...) pairs, as in
-- Wikipedia links, but never ends on an unmatched ")" or trailing punctuation.
-- [=[ ]=] quoting because the regex contains "]]".
config.hyperlink_rules = {
  { regex = [=[\b\w+://(?:[^\s()<>\[\]]|\([^\s()<>]*\))*(?:[^\s()<>\[\].,;:!?'"]|\([^\s()<>]*\))]=], format = '$0' },
  { regex = [=[\b\w+@[\w-]+(\.[\w-]+)+\b]=], format = 'mailto:$0' },
}

return config
