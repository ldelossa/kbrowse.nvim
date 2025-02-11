local M = {}

local elixir_prefix = "https://elixir.bootlin.com/linux"

local function get_kernel_version()
	-- get output of git describe --tags --abbrev=0
	local f = io.popen("git describe --tags --abbrev=0")
	if f == nil then
		return nil
	end
	local version = f:read("*a")
	f:close()
	-- strip any new lines from version
	version = version:gsub("\n", "")

	if #version == 0 then
		version = "latest"
	end

	-- check if first character of version is a 'v', this indicates a stable
	-- branch
	if version:sub(1, 1) ~= 'v' then
		version = "latest"
	end

	return version
end

local function get_repo_root()
	-- git rev-parse --show-toplevel
	local f = io.popen("git rev-parse --show-toplevel")
	if f == nil then
		return nil
	end
	local root = f:read("*a")
	f:close()
	-- strip any new lines from repo_root
	root = root:gsub("\n", "")
	return root
end

-- create a link for given attributers
local function format_link(version, line_start, line_end, file)
	local l = string.format("%s/%s/source%s#L%d", elixir_prefix, version, file, line_start)
	if line_end ~= nil and tonumber(line_end) > tonumber(line_start) then
		l = l .. '-L' .. line_end
	end
	return l
end

local function user_command_handler(opts)
	local name = opts.name
	local repo_root = get_repo_root() .. '/'
	local buff_name = vim.api.nvim_buf_get_name(0)

	local buff_name_relative = buff_name:sub(#repo_root)

	local start_line = opts.line1
	local end_line = opts.line2

	local kversion = get_kernel_version()
	local link = format_link(kversion, start_line, end_line, buff_name_relative)

	if opts.name == "KBrowseClipboard" then
		vim.fn.setreg("+", link)
		vim.notify("Link copied to clipboard")
		return
	end

	if vim.fn.has("mac") == 1 then
		os.execute("open " .. link)
	end
	if vim.fn.has("unix") == 1 then
		os.execute("xdg-open " .. link)
	end
end

function M.setup()
	vim.api.nvim_create_user_command("KBrowse", user_command_handler, { range = true })
	vim.api.nvim_create_user_command("KBrowseClipboard", user_command_handler, { range = true })
end

return M
