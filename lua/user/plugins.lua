local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  autoremove = true,
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  use {
    "lewis6991/impatient.nvim",
    config = function()
      require("impatient").enable_profile()
    end
  }
  use { "wbthomason/packer.nvim" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs" } -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim" }
  use { "JoosepAlviste/nvim-ts-context-commentstring" }
  use { "kyazdani42/nvim-web-devicons" }
  use { "kyazdani42/nvim-tree.lua" }
  use {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup()
    end,
  }
  use { "akinsho/bufferline.nvim" }
  use { "moll/vim-bbye" }
  use { "nvim-lualine/lualine.nvim" }
  use { "akinsho/toggleterm.nvim" }
  use { "ahmedkhalf/project.nvim" }
  use { "lukas-reineke/indent-blankline.nvim" }
  use { "goolord/alpha-nvim" }
  use { "folke/which-key.nvim" }
  use { "rcarriga/nvim-notify" }
  use { "ethanholz/nvim-lastplace" }
  use { "windwp/nvim-spectre" }
  use { "tpope/vim-surround" }
  use { "folke/todo-comments.nvim" }
  use { "stevearc/aerial.nvim" }
  use { "norcalli/nvim-colorizer.lua" }
  use { "folke/trouble.nvim" }
  use { "sindrets/winshift.nvim" }
  use { "ldelossa/litee.nvim" }
  use { "ldelossa/litee-symboltree.nvim" }
  use { "ldelossa/litee-calltree.nvim" }
  use { "Pocco81/HighStr.nvim" }
  use { "mtdl9/vim-log-highlighting" }


  -- Colorschemes
  use { "LunarVim/Colorschemes" }
  use { "folke/tokyonight.nvim" }
  use { "lunarvim/darkplus.nvim" }
  use {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup {}
    end
  }
  use {
    "catppuccin/nvim",
    as = "catppuccin"
  }

  -- Cmp
  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-cmdline" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-nvim-lua" }
  use { "saadparwaiz1/cmp_luasnip" } -- snippet completions

  -- Snippets
  use { "L3MON4D3/LuaSnip" } --snippet engine
  use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use
  use { "hrsh7th/vim-vsnip" }

  -- LSP
  use { "neovim/nvim-lspconfig" }
  use {
    "williamboman/mason.nvim",
    requires = {
      "williamboman/mason-lspconfig.nvim"
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "html", "jsonls", "tsserver", "sumneko_lua",
          "pyright", "gopls", "rust_analyzer",
        }
      }
    end
  }
  use {
    "simrat39/rust-tools.nvim",
    config = function()
      local rt = require("rust-tools")
      rt.setup {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end
        }
      }
    end
  }

  -- use { "RRethy/vim-illuminate" }
  -- use { "kosayoda/nvim-lightbulb" }
  -- use { "ray-x/lsp_signature.nvim" }
  -- use { "j-hui/fidget.nvim" }

  -- debug
  use { "ravenxrz/DAPInstall.nvim" }
  use { "mfussenegger/nvim-dap" }
  use { "rcarriga/nvim-dap-ui" }
  use { "theHamsta/nvim-dap-virtual-text" }

  -- test
  use { "vim-test/vim-test" }
  -- use {
  --   "nvim-neotest/neotest",
  --   requires = {
  --     "antoinemadec/FixCursorHold.nvim",
  --     "nvim-neotest/neotest-go",
  --     "nvim-neotest/neotest-python",
  --     "rouge8/neotest-rust",
  --   },
  --   config = function()
  --     require("neotest").setup({
  --       icons = {
  --         failed = "x",
  --         passed = "√",
  --         running = "=",
  --         skipped = "~",
  --         unknown = "?",
  --       },
  --       adapters = {
  --         require("neotest-go"),
  --         require("neotest-rust") {
  --           args = { "--no-capture" },
  --         }
  --       },
  --     })
  --   end,
  -- }

  -- Telescope
  use { "nvim-telescope/telescope.nvim" }

  -- Treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1201
  -- :TSUpdate
  use { "nvim-treesitter/nvim-treesitter" }
  -- use { "nvim-treesitter/nvim-treesitter-textobjects" }
  -- use { "nvim-treesitter/nvim-treesitter-context" }

  -- Git
  -- use { "lewis6991/gitsigns.nvim" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
