local M = {}

-- Load utility functions
local utils = require("utils")
local map = utils.map

-- Function to toggle nvim-tree
function M.toggle()
  require("nvim-tree.api").tree.toggle({
    find_file = false,
    focus = true,
    update_root = true,
  })
end

-- Function to find current file in nvim-tree
function M.find_file()
  require("nvim-tree.api").tree.find_file({
    open = true,
    focus = true,
    update_root = true,
  })
end

function M.setup()
  -- Defer setup to reduce startup time
  vim.defer_fn(function()
    local status_ok, nvim_tree = pcall(require, "nvim-tree")
    if not status_ok then
      vim.notify("nvim-tree.lua not found!", vim.log.levels.ERROR)
      return
    end

    -- Disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Configure nvim-tree with streamlined settings
    nvim_tree.setup({
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = { "help" },
      },
      view = {
        width = 35,
        side = "left",
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        highlight_opened_files = "icon",
        highlight_modified = "icon",
        root_folder_label = ":~:s?$?/..?",
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = "before",
          modified_placement = "after",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "󰆤",
            modified = "●",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = true,
        },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { "node_modules", "\\.cache", "^\\..*", "^_build$", "^deps$" },
      },
      git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        timeout = 400,
      },
      diagnostics = {
        enable = false, -- Disabled to reduce overhead
        show_on_dirs = false,
      },
      log = {
        enable = false,
        truncate = true,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          dev = false,
          diagnostics = false,
          git = false,
          profile = false,
          watcher = false,
        },
      },
    })

    -- Consolidated autocommands
    local nvim_tree_group = vim.api.nvim_create_augroup("NvimTreeIntegration", { clear = true })

    -- Auto-close if only NvimTree is open
    vim.api.nvim_create_autocmd("BufEnter", {
      group = nvim_tree_group,
      nested = true,
      callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") then
          vim.cmd("quit")
        end
      end,
    })

    -- Auto-open on directory
    vim.api.nvim_create_autocmd("VimEnter", {
      group = nvim_tree_group,
      nested = true,
      callback = function(data)
        local directory = vim.fn.isdirectory(data.file) == 1
        if not directory then
          return
        end
        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open()
      end,
    })

    -- Auto-close on quit if only NvimTree is open
    vim.api.nvim_create_autocmd("QuitPre", {
      group = nvim_tree_group,
      callback = function()
        local tree_wins = {}
        local floating_wins = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match("NvimTree_") then
            table.insert(tree_wins, w)
          end
          local config = vim.api.nvim_win_get_config(w)
          if config.relative ~= "" then
            table.insert(floating_wins, w)
          end
        end
        if #tree_wins == 1 and #wins == #floating_wins + #tree_wins then
          local modified = false
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(buf, "modified") then
              modified = true
              break
            end
          end
          if not modified then
            vim.cmd("NvimTreeClose")
          end
        end
      end,
    })

    -- Auto-resize windows
    vim.api.nvim_create_autocmd("VimResized", {
      group = vim.api.nvim_create_augroup("NvimTreeResize", { clear = true }),
      callback = function()
        vim.cmd("wincmd =")
      end,
    })
  end, 50) -- Defer setup by 50ms
end

-- Keymaps (defined immediately, lightweight)
map("n", "<leader>n", M.toggle, { desc = "Toggle NvimTree" })
map("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus NvimTree" })

return M