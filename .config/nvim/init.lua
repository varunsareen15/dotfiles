vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 2
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.termguicolors = true
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'latexmk'
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

vim.keymap.set('i', 'jj', '<esc>')
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>bd', ':bd<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = 'Split Vertical' })
vim.keymap.set('n', '<leader>h', ':split<CR>', { desc = 'Split Horizontal' })
vim.keymap.set('n', '<C-h>', '<C-w>h') -- Move Left
vim.keymap.set('n', '<C-j>', '<C-w>j') -- Move Down
vim.keymap.set('n', '<C-k>', '<C-w>k') -- Move Up
vim.keymap.set('n', '<C-l>', '<C-w>l') -- Move Right

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/lunacookies/vim-colors-xcode" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-file-browser.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/lervag/vimtex" },
	{ src = "https://github.com/norcalli/nvim-colorizer.lua" },
	{ src = "https://github.com/max397574/startup.nvim" },
	{ src = "https://github.com/kiyoon/jupynium.nvim" },
})


require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
})
require("colorizer").setup()

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set("n", "<leader>e", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

vim.lsp.enable({ "lua_ls", "clangd", "rust_analyzer", "pyright" })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

require("startup").setup({theme = "dashboard"}) 

vim.cmd("colorscheme kanagawa-wave")
vim.cmd(":hi statusline guibg=NONE")

vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#000000" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#000000" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "none" })

-- Bottom terminal toggle: <leader>tt
local Term = { buf = nil, win = nil }

local function ensure_term()
  if Term.win and vim.api.nvim_win_is_valid(Term.win) then
    vim.api.nvim_win_close(Term.win, true)
    Term.win = nil
    return
  end

  if not Term.buf or not vim.api.nvim_buf_is_valid(Term.buf) then
    Term.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[Term.buf].bufhidden = "hide"
  end

  vim.cmd("botright split")
  Term.win = vim.api.nvim_get_current_win()

  local h = math.max(10, math.min(math.floor(vim.o.lines * 0.30), 18))
  vim.api.nvim_win_set_height(Term.win, h)
  vim.api.nvim_win_set_buf(Term.win, Term.buf)

  if vim.bo[Term.buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.o.shell)
  end

  vim.wo[Term.win].number = false
  vim.wo[Term.win].relativenumber = false
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>tt", ensure_term, { desc = "Toggle bottom terminal" })

local function t_wincmd(dir)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  vim.cmd("wincmd " .. dir)
end

vim.keymap.set("t", "<C-j>", function() t_wincmd("j") end, { desc = "Terminal: window down" })
vim.keymap.set("t", "<C-k>", function() t_wincmd("k") end, { desc = "Terminal: window up" })

vim.keymap.set("t", "<Esc>", function()
  local cur = vim.api.nvim_get_current_win()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)

  if Term.win and vim.api.nvim_win_is_valid(Term.win) and cur == Term.win then
    vim.api.nvim_win_close(Term.win, true)
    Term.win = nil
  end
end, { desc = "Close toggle terminal" })

