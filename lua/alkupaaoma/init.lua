-- alkupaaoma.nvim: Minimal Neovim configuration for backend development
-- Leader key: 9

-- Set leader key to 9
vim.g.mapleader = "9"

-- Ensure Neovim version is 0.11.0+
if vim.version().minor < 11 then
  vim.notify("This configuration requires Neovim 0.11.0 or higher!", vim.log.levels.ERROR)
  return
end

-- Basic settings
vim.cmd("filetype plugin indent on")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.lazyredraw = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.redrawtime = 1500
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0

-- Override vim.notify with noice
vim.notify = require("noice").notify

-- Override vim.ui.select with telescope
vim.ui.select = function(items, opts, on_choice)
  require("telescope.builtin").find_files({
    finder = require("telescope.finders").new_table({
      results = items,
    }),
    sorter = require("telescope.sorting").fuzzy_with_ordering,
    previewer = false,
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        on_choice(entry.value)
        require("telescope.actions").close(prompt_bufnr)
      end)
      return true
    end,
  })
end

-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = {
      prefix = "●",
      spacing = 4,
    },
    signs = true,
    underline = true,
  }
)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
local plugins = {
  -- Core
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Package management
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim", "nvim-lspconfig" } },
  { "jay-babu/mason-nvim-dap.nvim", dependencies = { "mason.nvim", "nvim-dap" } },

  -- LSP
  { "neovim/nvim-lspconfig", dependencies = { "mason.nvim", "mason-lspconfig.nvim" } },

  -- Completion
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "L3MON4D3/LuaSnip" } },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets", dependencies = { "LuaSnip" } },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", lazy = true },

  -- Debugging
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "nvim-dap" } },

  -- Testing
  { "nvim-neotest/neotest" },
  { "nvim-neotest/neotest-plenary" },
  { "rouge8/neotest-rust" },
  { "nvim-neotest/neotest-python" },
  { "nvim-neotest/neotest-jest" },

  -- Database
  { "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui", dependencies = { "vim-dadbod" } },

  -- REST API
  { "NTBBloodbath/rest.nvim", dependencies = { "plenary.nvim" } },

  -- Formatting
  { "stevearc/conform.nvim" },

  -- Linting
  { "mfussenegger/nvim-lint" },

  -- Project management
  { "nvim-telescope/telescope.nvim", dependencies = { "plenary.nvim" } },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-web-devicons" } },

  -- Git
  { "lewis6991/gitsigns.nvim" },
  { "NeogitOrg/neogit", dependencies = { "plenary.nvim" } },
  { "folke/trouble.nvim", dependencies = { "nvim-web-devicons" } },

  -- Terminal
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- UI
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-web-devicons" } },
  { "akinsho/bufferline.nvim", dependencies = { "nvim-web-devicons" } },
  { "lukas-reineke/indent-blankline.nvim" },
  { "folke/which-key.nvim" },
  { "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim" } },

  -- Theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- Utility
  { "numToStr/Comment.nvim" },
  { "kylechui/nvim-surround" },
  { "windwp/nvim-autopairs" },
  { "debugloop/telescope-undo.nvim", dependencies = { "telescope.nvim" } },

  -- Language-specific
  { "simrat39/rust-tools.nvim", dependencies = { "nvim-lspconfig", "nvim-dap" } },
  { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lspconfig" } },
}

-- Configure lazy.nvim
require("lazy").setup(plugins, {
  install = { missing = true, colorscheme = { "catppuccin" } },
  ui = { border = "rounded" },
})

-- Theme
vim.cmd.colorscheme("catppuccin")

-- LSP setup
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

-- List of LSP servers to install and configure
local servers = {
  "clangd",
  "tsserver",
  "lua_ls",
  "pyright",
}

-- Install and configure LSP servers
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- On attach function for LSP
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, silent = true, desc = "LSP: Go to definition" }
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = bufnr, silent = true, desc = "LSP: Hover" })
  vim.keymap.set("n", "9rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = bufnr, silent = true, desc = "LSP: Rename" })
  vim.keymap.set("n", "9ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = bufnr, silent = true, desc = "LSP: Code action" })
end

-- Configure each LSP server
for _, server in ipairs(servers) do
  lspconfig[server].setup({
    on_attach = on_attach,
  })
end

-- Configure lua_ls specifically
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- rust-tools setup (handles rust_analyzer)
require("rust-tools").setup({
  server = {
    on_attach = on_attach,
    standalone = true,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
        procMacro = {
          enable = true,
        },
        cargo = {
          allFeatures = true,
        },
      },
    },
  },
})

-- TypeScript-tools setup
require("typescript-tools").setup({
  on_attach = on_attach,
  settings = {
    tsserver = {
      completions = {
        completeFunctionCalls = true,
      },
      diagnostics = {
        ignoredCodes = { 1375 },
      },
    },
  },
})

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "luasnip" },
  }),
})

-- Treesitter setup
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "rust", "c", "cpp", "typescript", "python" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- DAP setup
local dap = require("dap")

-- DAP Adapters
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}

dap.adapters.lldb = {
  type = "executable",
  command = "lldb",
  name = "lldb",
}

-- DAP Configurations
dap.configurations.rust = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.input("Binary name: ")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.getcwd() .. "/" .. vim.fn.input("Executable: ")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

-- nvim-dap-ui setup
require("dapui").setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      position = "left",
      size = 40,
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      position = "bottom",
      size = 10,
    },
  },
})

-- Auto-toggle dap-ui
vim.api.nvim_create_autocmd("User", {
  pattern = "DapStarted",
  callback = function()
    require("dapui").open()
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "DapTerminated",
  callback = function()
    require("dapui").close()
  end,
})

-- mason-nvim-dap setup
require("mason-nvim-dap").setup({
  automatic_installation = true,
  handlers = {},
})

-- Formatting setup
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua", stop_after_first = true },
    rust = { "rustfmt", stop_after_first = true },
    c = { "clang-format", stop_after_first = true },
    cpp = { "clang-format", stop_after_first = true },
    typescript = { "prettier", stop_after_first = true },
    python = { "black", stop_after_first = true },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Linting setup
require("lint").linters_by_ft = {
  rust = { "cargo" },
  c = { "clang-tidy" },
  cpp = { "clang-tidy" },
  typescript = { "eslint_d" },
  python = { "pylint" },
}

-- Autocommands for linting and formatting
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
    require("conform").format({ async = true, lsp_fallback = true })
  end,
})

-- Telescope setup
require("telescope").setup({
  extensions = {
    undo = {
      use_delta = true,
    },
  },
})

-- Load telescope-undo extension
require("telescope").load_extension("undo")

-- nvim-tree setup
require("nvim-tree").setup({
  filters = {
    dotfiles = false,
  },
})

-- Gitsigns setup
require("gitsigns").setup({
  signs = {
    add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
})

-- Trouble setup
require("trouble").setup({})

-- Toggleterm setup
require("toggleterm").setup({
  direction = "float",
})

-- LuaSnip setup
require("luasnip.loaders.from_vscode").lazy_load()

-- Lualine setup
require("lualine").setup({
  options = {
    theme = "catppuccin",
  },
})

-- Bufferline setup
require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
})

-- Indent-blankline setup
require("indent_blankline").setup({
  show_current_context = true,
  show_current_context_start = true,
})

-- Which-key setup
require("which-key").setup({
  plugins = {
    marks = true,
    registers = true,
  },
})
require("which-key").register({
  ["9d"] = { name = "+debug" },
  ["9t"] = { name = "+test" },
  ["9g"] = { name = "+git" },
  ["9c"] = { name = "+code" },
  ["9f"] = { name = "+file" },
  ["9n"] = { name = "+noice" },
})

-- Noice setup
require("noice").setup({
  lsp = {
    progress = { enabled = true },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    },
  },
})

-- Comment setup
require("Comment").setup({
  toggler = {
    line = "gcc",
    block = "gbc",
  },
  opleader = {
    line = "gc",
    block = "gb",
  },
})

-- Surround setup
require("nvim-surround").setup({})

-- Autopairs setup
require("nvim-autopairs").setup({
  check_ts = true,
})

-- Dadbod setup
vim.g.db_ui_use_nerd_fonts = 1

-- Rest.nvim setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    require("rest-nvim").setup({
      result_split_horizontal = false,
    })
  end,
})

-- Neotest setup
require("neotest").setup({
  adapters = {
    require("neotest-plenary")({}),
    require("neotest-rust")({}),
    require("neotest-python")({}),
    require("neotest-jest")({}),
  },
})

-- Neogit setup
require("neogit").setup({
  disable_signs = false,
})

-- Install formatters and linters via mason
require("mason").setup({
  ensure_installed = {
    -- Formatters
    "stylua",
    "rustfmt",
    "clang-format",
    "prettier",
    "black",
    -- Linters
    "pylint",
    "eslint_d",
    "clang-tidy",
    -- DAP
    "codelldb",
    "lldb",
  },
})

-- Keymaps
-- LSP
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { silent = true, desc = "LSP: Go to definition" })
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true, desc = "LSP: Hover" })

-- DAP
vim.keymap.set("n", "9dc", "<cmd>lua require('dap').continue()<CR>", { silent = true, desc = "DAP: Continue" })
vim.keymap.set("n", "9dt", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { silent = true, desc = "DAP: Toggle breakpoint" })
vim.keymap.set("n", "9ds", "<cmd>lua require('dap').step_over()<CR>", { silent = true, desc = "DAP: Step over" })
vim.keymap.set("n", "9di", "<cmd>lua require('dap').step_into()<CR>", { silent = true, desc = "DAP: Step into" })
vim.keymap.set("n", "9do", "<cmd>lua require('dap').step_out()<CR>", { silent = true, desc = "DAP: Step out" })
vim.keymap.set("n", "9dr", "<cmd>lua require('dap').repl.open()<CR>", { silent = true, desc = "DAP: Open REPL" })
vim.keymap.set("n", "9du", "<cmd>lua require('dapui').toggle()<CR>", { silent = true, desc = "DAP: Toggle UI" })

-- File
vim.keymap.set("n", "9e", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" })
vim.keymap.set("n", "9er", "<cmd>NvimTreeRefresh<CR>", { silent = true, desc = "Refresh file explorer" })
vim.keymap.set("n", "9en", "<cmd>NvimTreeFocus<CR>", { silent = true, desc = "Focus file explorer" })

-- Telescope
vim.keymap.set("n", "9ff", "<cmd>Telescope find_files<CR>", { silent = true, desc = "Find files" })
vim.keymap.set("n", "9fg", "<cmd>Telescope live_grep<CR>", { silent = true, desc = "Live grep" })
vim.keymap.set("n", "9fb", "<cmd>Telescope buffers<CR>", { silent = true, desc = "Find buffers" })
vim.keymap.set("n", "9fh", "<cmd>Telescope help_tags<CR>", { silent = true, desc = "Help tags" })
vim.keymap.set("n", "9tu", "<cmd>Telescope undo<CR>", { silent = true, desc = "Undo history" })

-- Git
vim.keymap.set("n", "9gs", "<cmd>Gitsigns toggle_signs<CR>", { silent = true, desc = "Toggle Git signs" })
vim.keymap.set("n", "9gb", "<cmd>Gitsigns blame_line<CR>", { silent = true, desc = "Git blame line" })
vim.keymap.set("n", "9gp", "<cmd>Gitsigns preview_hunk<CR>", { silent = true, desc = "Preview Git hunk" })
vim.keymap.set("n", "9gr", "<cmd>Gitsigns reset_hunk<CR>", { silent = true, desc = "Reset Git hunk" })
vim.keymap.set("n", "9gS", "<cmd>Gitsigns stage_hunk<CR>", { silent = true, desc = "Stage Git hunk" })
vim.keymap.set("n", "9gU", "<cmd>Gitsigns undo_stage_hunk<CR>", { silent = true, desc = "Undo stage Git hunk" })
vim.keymap.set("n", "9gt", "<cmd>Neogit<CR>", { silent = true, desc = "Open Neogit" })

-- Terminal
vim.keymap.set("n", "9tt", "<cmd>ToggleTerm direction=float<CR>", { silent = true, desc = "Toggle terminal (float)" })
vim.keymap.set("n", "9tv", "<cmd>ToggleTerm direction=vertical<CR>", { silent = true, desc = "Toggle terminal (vertical)" })
vim.keymap.set("n", "9th", "<cmd>ToggleTerm direction=horizontal<CR>", { silent = true, desc = "Toggle terminal (horizontal)" })

-- Formatting/Linting
vim.keymap.set("n", "9tf", "<cmd>lua require('conform').format()<CR>", { silent = true, desc = "Format buffer" })
vim.keymap.set("n", "9tl", "<cmd>lua require('lint').try_lint()<CR>", { silent = true, desc = "Lint buffer" })

-- Comment
vim.keymap.set("n", "9/", "gcc", { remap = true, silent = true, desc = "Toggle comment line" })
vim.keymap.set("v", "9/", "gc", { remap = true, silent = true, desc = "Toggle comment block" })

-- Surround
vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)", { silent = true, desc = "Surround selection" })
vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal-line)", { silent = true, desc = "Surround line" })
vim.keymap.set("v", "S", "<Plug>(nvim-surround-visual)", { silent = true, desc = "Surround visual selection" })

-- Noice
vim.keymap.set("n", "9nd", "<cmd>NoiceDismiss<CR>", { silent = true, desc = "Dismiss notification" })
vim.keymap.set("n", "9nc", "<cmd>NoiceCmdline<CR>", { silent = true, desc = "Toggle cmdline" })

-- Trouble
vim.keymap.set("n", "9xx", "<cmd>TroubleToggle<CR>", { silent = true, desc = "Toggle Trouble" })