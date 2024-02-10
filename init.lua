-- local lspconfig = require('mason-lspconfig')
--
local utils = require "astronvim.utils"

return {
  plugins = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "php")
        end
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "intelephense") end,
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "php") end,
    },
    {
      "jay-babu/mason-null-ls.nvim",
      opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "php-cs-fixer") end,
    },
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require("astronvim.utils.status")
        local path_func = status.provider.filename { modify = ":.:h", fallback = "" }

        opts.statusline = { -- statusline
          hl = { fg = "fg", bg = "bg" },
          status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
          status.component.git_branch(),
          status.component.separated_path { path_func = path_func, separator = "/" },
          status.component.git_diff(),
          status.component.diagnostics(),
          status.component.fill(),
          status.component.cmd_info(),
          status.component.fill(),
          status.component.lsp(),
          status.component.treesitter(),
          status.component.nav(),
        }

        -- return the final configuration table
        return opts
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, opts)
        opts.filesystem.filtered_items = {
          visible = true,
        }

        return opts
      end
    },
    {
      "mrcjkb/rustaceanvim",
      ft = { "rust" },
      init = function() astronvim.lsp.skip_setup = utils.list_insert_unique(astronvim.lsp.skip_setup, "rust_analyzer") end,
      config = function()
        vim.g.rustaceanvim = {
          server = {
            on_attach = require('astronvim.utils.lsp').on_attach
          },
        }
      end,
    },
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require('todo-comments').setup {}
      end,
      event = "User AstroFile",
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      opts = {
        integrations = {
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
        },
      }
    }
  },
  colorscheme = "catppuccin",
  lsp = {
    config = {
      intelephense = {
        settings = {
          intelephense = {
            environment = {
              phpVersion = "7.3.20",
              includePaths = {
                "**/vendor/laravel/**"
              }
            },
            references = {
              exclude = {}
            }
          },
        }
      },
      volar = {
        -- Make sure to add "allowJs": true and "checkJs": true to jsconfig.json/tsconfig.json
        filetypes = { 'vue', 'typescript', 'javascript' },
      }
    }
  }
}

