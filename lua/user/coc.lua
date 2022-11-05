local opts = { silent = true, noremap = true, expr = true }
local keymap = vim.api.nvim_set_keymap

vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions
vim.g.coc_global_extensions = {
  -- 'coc-java',
  'coc-rust-analyzer',
  'coc-go',
  'coc-golines',
  'coc-pyright',
  'coc-html',
  'coc-css',
  'coc-tsserver',
  'coc-sh',
  'coc-phpls',
  'coc-vimlsp',
  'coc-snippets',
  'coc-emmet',
  'coc-json',
  'coc-texlab',
  'coc-explorer',
  'coc-yaml',
  'coc-toml',
  'coc-tailwindcss',
  'coc-spell-checker',
  'coc-prettier',
  'coc-git',
  'coc-pairs',
  'coc-highlight'
}

function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

function _G.show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command('h ' .. cw)
  elseif vim.api.nvim_eval('coc#rpc#ready()') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
  end
end

vim.cmd([[
  augroup mygroup
  autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    autocmd CursorHold * silent call CocActionAsync('highlight')
  augroup end
]])


keymap("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keymap("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keymap("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
keymap("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)", opts)
keymap("i", "<c-space>", "coc#refresh()", opts)

-- scroll through documentation
local opts = { silent = true, nowait = true, expr = true }
keymap("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keymap("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keymap("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keymap("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keymap("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keymap("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

-- go to definition and other things
keymap("n", "K", '<cmd>lua _G.show_docs()<cr>', { silent = true })
keymap("n", "<c-k>", "<Plug>(coc-rename)", { silent = true })
keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keymap("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
keymap("n", "gd", "<Plug>(coc-definition)", { silent = true })
keymap("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keymap("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keymap("n", "gr", "<Plug>(coc-references)", { silent = true })

-- code actions and coc stuff
local opts = { silent = true, nowait = true }
keymap("n", "<space>a", "<Plug>(coc-codeaction-cursor)", opts)
keymap("x", "<space>a", "<Plug>(coc-codeaction-selected)", opts)
keymap("n", "<space>g", "<Plug>(coc-codelens-action)", opts)
keymap("n", "<space>f", "<Plug>(coc-fix-current)", opts)
keymap("n", "<space>d", ":<C-u>CocList diagnostics<cr>", opts)
keymap("n", "<space>l", ":<C-u>CocList extensions<cr>", opts)
keymap("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
keymap("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
keymap("n", "<space>q", ":<C-u>CocList<cr>", opts)
keymap("n", "<space>e", "<cmd>CocCommand explorer<cr>", opts)
