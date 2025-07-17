---@class Module
---@field langs LanguageConfig[]
local M = {}

---@class LanguageConfig
---@field filePath string
---@field keymap string

---@class Options
---@field langs LanguageConfig[]
---@field creationKeymap string
---@field creationCmd string

---@param opts Options
M.setup = function(opts)
	M.langs = opts.langs
	vim.keymap.set(
		"n",
		opts.creationKeymap,
		"<cmd>lua require('i18n').create_translation_entry('" .. opts.creationCmd .. "')<cr>",
		{ noremap = true, silent = true }
	)
	for _, lang in ipairs(opts.langs) do
		vim.keymap.set(
			"n",
			lang.keymap,
			"<cmd>lua require('i18n').go_to_translation('" .. lang.filePath .. "')<cr>",
			{ noremap = true, silent = true }
		)
	end
end

local function char_is_quote(c)
	return c == '"' or c == "'" or c == "`"
end

--- Get all text inside quotes around cursor
local function get_string_at_cursor()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local token = ""

	-- Handle left of cursor
	local i = col
	local quotesFound = 0
	while i > 0 do
		local is_quote = char_is_quote(line:sub(i, i))
		local c = line:sub(i, i)
		if not is_quote then
			token = c .. token
		else
			quotesFound = quotesFound + 1
			break
		end
		i = i - 1
	end
	-- Handle right of cursor
	i = col + 1
	while i < #line do
		local is_quote = char_is_quote(line:sub(i, i))
		local c = line:sub(i, i)
		if not is_quote then
			token = token .. c
		else
			quotesFound = quotesFound + 1
			break
		end
		i = i + 1
	end
	if quotesFound ~= 2 then
		return ""
	end
	return token
end

---@param filePath string
M.go_to_translation = function(filePath)
	local token = get_string_at_cursor()
	if token == "" then
		return
	end
	-- Search for token in file in new buffer
	local searchWord = "\\\\<" .. token .. "\\\\>"
	vim.cmd('edit +/"' .. searchWord .. '" ' .. filePath)
end

---@param creationCmd string
M.create_translation_entry = function(creationCmd)
	local token = get_string_at_cursor()
	if token == "" then
		vim.notify("No string found at cursor", vim.log.levels.WARN)
		return
	end
	os.execute(creationCmd .. " " .. token .. " > /dev/null 2>&1")
	vim.notify("Translation entry created for: " .. token, vim.log.levels.INFO)
end

return M
