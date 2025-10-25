return {
  {
    'folke/snacks.nvim',
    opts = {
      input = { enabled = true },
    },
    keys = {
      {
        '<leader>go',
        function()
          Snacks.gitbrowse()
        end,
        desc = '[G]it [O]pen in Browser',
        mode = { 'n', 'x' },
      },
      {
        '<leader>gm',
        function()
          Snacks.gitbrowse { branch = 'main' }
        end,
        desc = '[G]it Open [M]ain in Browser',
        mode = { 'n', 'x' },
      },
    },
  },
}
