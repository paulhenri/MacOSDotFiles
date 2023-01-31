call plug#begin()

" General Programming Plugins
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'onsails/lspkind-nvim'
Plug 'alvan/vim-closetag'

" ------------
" Markdown
" ------------
Plug 'godlygeek/tabular'" Tabular plugin is used to format tables
Plug 'elzr/vim-json' " JSON front matter highlight plugin
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}

"Git Blame
Plug 'f-person/git-blame.nvim'
Plug 'tpope/vim-fugitive' "More infos about branches etc...

"Rust
Plug 'simrat39/rust-tools.nvim'

"Elixir
Plug 'elixir-editors/vim-elixir'

"FuzzySearch
Plug 'cloudhead/neovim-fuzzy'

" GUI enhancement
Plug 'drewtempelmeyer/palenight.vim'
Plug 'https://github.com/sainnhe/sonokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

"Neovim Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Initialize plugin system
call plug#end()

"---------------------------------
" General customization of NeoVim
" --------------------------------

set number
set mouse=a

set rnu

" Themings informations - Now using palenight
set background=dark

" The configuration options should be placed before `colorscheme sonokai`.
"let g:sonokai_style = 'atlantis'
"let g:sonokai_better_performance = 1

colorscheme tokyonight-storm

"Italics - Advice of palenight ==> Perfect !
let g:palenight_terminal_italics=1

" Customization of the light ligne and the airline
let g:lightligne = {'colorscheme': 'tokyonight'}
let g:airline_theme = "palenight"

" To enable true colors -- Thanks to palenight for the code
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif



lua << END


--Treesitter
require("nvim-treesitter.configs").setup(
    {
        ensure_installed = {
            "eex",
            "elixir",
            "erlang",
            "heex",
            "html",
            "surface",
            "javascript",
	    "rust"
        }, 
        highlight = {enable = true},
	auto_install = true,

    })




require'nvim-web-devicons'.setup {default = true;}

local lspconfig = require("lspconfig")

-- Neovim doesn't support snippets out of the box, so we need to mutate the
-- capabilities we send to the language server to let them know we want snippets.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Setup our autocompletion. These configuration options are the default ones
-- copied out of the documentation.
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Up>"] = cmp.mapping.select_prev_item(), --Needed from 0.7 onward
    ["<Down>"] = cmp.mapping.select_next_item(),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
  },
  formatting = {
    format = require("lspkind").cmp_format({
      with_text = true,
      menu = {
        nvim_lsp = "[LSP]",
      },
    }),
  },
})

-- Finally, let's initialize the Elixir language server

-- Replace the following with the path to your installation
local path_to_elixirls = vim.fn.expand("~/Code/elixir-ls/release/language_server.sh")

lspconfig.elixirls.setup({
  cmd = {path_to_elixirls},
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    elixirLS = {
      -- I choose to disable dialyzer for personal reasons, but
      -- I would suggest you also disable it unless you are well
      -- aquainted with dialzyer and know how to use it.
      dialyzerEnabled = false,
      -- I also choose to turn off the auto dep fetching feature.
      -- It often get's into a weird state that requires deleting
      -- the .elixir_ls directory and restarting your editor.
      fetchDeps = false 
    },
  files = {
      trimTrailingWhiteSpace = true
    },
  editor = {
      formatOnSave = true
    }

  }
})


--TerraformLSP 
require'lspconfig'.terraformls.setup{}

END

" Terraform help
autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync()

" -------------------------------
" Nvim Tree plugin configuration
"
"
"
"--------------------------------
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

set termguicolors
lua << EOF
    require("bufferline").setup{
		options = {
    		mode = "buffers",
		numbers = "ordinal",
		diagnostics = "nvim_lsp",
		show_buffer_icons = true , -- disable filetype icons for buffers
		    show_buffer_close_icons = true,
		    show_close_icon = true,
		    show_tab_indicators = true
		}
    }

require'nvim-tree'.setup {
  disable_netrw        = false,
  hijack_netrw         = true,
  open_on_setup        = false,
  ignore_ft_on_setup   = {},
  auto_reload_on_write = true,
  open_on_tab          = false,
  hijack_cursor        = false,
  update_cwd           = false,
  hijack_unnamed_buffer_when_opening = false,
  renderer = {
    icons = {
      glyphs = {
	   default = "❓",
    symlink = "",
     git = {
       unstaged = "✗",
       renamed = "➜",
       untracked =  "★",
       deleted = "",
       ignored= "◌"
       },
     folder = {
       arrow_open = "✓",
       arrow_closed = "✘",
       default = "",
       open = "",
       empty = "",
       empty_open = "",
       symlink = "",
       symlink_open = "",  
	}
      }
    }
  },
  hijack_directories   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    preserve_window_proportions = false,
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  },
  actions = {
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = {
            "notify",
            "packer",
            "qf"
          }
        }
      }
    }
  }
}


EOF


lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
           -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

vim.diagnostic.config({
  virtual_text = false
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

require('rust-tools').setup(opts)

EOF

" Format Rust code asap after save
let g:rustfmt_autosave = 1
let g:mix_format_on_save = 1

noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
nnoremap <C-p> :FuzzyOpen<CR>
nnoremap <S-f> :FuzzyGrep<CR>

" move among buffers with CTRL
map <C-J> :bprev<CR>
map <C-K> :bnext<CR>

" To avoid 135 character error on credo
:set colorcolumn=135

"-----------------------
" Airline Setup
" ----------------------
set shiftwidth=2

command Fmtjson :%!jq '.'  


" -----------------------
" Markdown Specific
" -----------------------
" disable header folding
let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0

" disable math tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END

let g:mkdp_auto_close = 0

nnoremap <M-m> :MarkdownPreview<CR>

lua <<EOF
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

EOF

" -----------------
"  Elixir speficic 
"  ----------------
syntax on
filetype plugin indent on
