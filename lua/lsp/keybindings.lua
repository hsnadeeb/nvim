local M = {}

function M.setup(client, bufnr)
  local map = vim.keymap.set
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Navigation
  map('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', bufopts, { desc = 'Go to definition' }))
  map('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', bufopts, { desc = 'Go to declaration' }))
  map('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', bufopts, { desc = 'Go to implementation' }))
  map('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', bufopts, { desc = 'Show references' }))
  map('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', bufopts, { desc = 'Show documentation' }))
  map('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', bufopts, { desc = 'Show signature help' }))
  
  -- Workspace
  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', bufopts, { desc = 'Add workspace folder' }))
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', bufopts, { desc = 'Remove workspace folder' }))
  map('n', '<leader>wl', function() 
    print(vim.inspect(vim.lsp.buf.list_workspace_folders())) 
  end, vim.tbl_extend('force', bufopts, { desc = 'List workspace folders' }))
  
  -- Code actions and refactoring
  map('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = 'Rename symbol' }))
  map('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code action' }))
  map('v', '<leader>ca', ':<C-U>vsplit | lua vim.lsp.buf.range_code_action()<CR>', 
    vim.tbl_extend('force', bufopts, { desc = 'Range code action' }))
  
  -- Formatting
  map('n', '<leader>f', function() 
    vim.lsp.buf.format({ async = true }) 
  end, vim.tbl_extend('force', bufopts, { desc = 'Format buffer' }))
  
  -- Type definition
  map('n', 'gt', vim.lsp.buf.type_definition, vim.tbl_extend('force', bufopts, { desc = 'Go to type definition' }))
  
  -- Diagnostics
  map('n', 'gl', vim.diagnostic.open_float, vim.tbl_extend('force', bufopts, { desc = 'Show line diagnostics' }))
  map('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', bufopts, { desc = 'Previous diagnostic' }))
  map('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', bufopts, { desc = 'Next diagnostic' }))
  map('n', '<leader>d', vim.diagnostic.setloclist, vim.tbl_extend('force', bufopts, { desc = 'Show diagnostics' }))
  
  -- Setup autocommands
  M.setup_autocmds(client, bufnr)
end

function M.setup_autocmds(client, bufnr)
  -- Show diagnostics on CursorHold
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { 'BufEnter', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(bufnr, opts)
    end
  })
  
  -- Highlight symbol under cursor
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_create_autocmd('CursorHold', {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = 'lsp_document_highlight',
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = 'lsp_document_highlight',
    })
  end
end

return M
