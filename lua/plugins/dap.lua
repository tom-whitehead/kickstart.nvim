return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      {
        'mfussenegger/nvim-dap-python',
        build = false,
      },
    },
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = '[D]AP Toggle [B]reakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = '[D]AP [C]ontinue',
      },
      {
        '<leader>ds',
        function()
          require('dap').step_over()
        end,
        desc = '[D]AP [S]tep Over',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = '[D]AP Step [I]nto',
      },
      {
        '<leader>do',
        function()
          require('dap').step_out()
        end,
        desc = '[D]AP Step [O]ut',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.open()
        end,
        desc = '[D]AP Open [R]EPL',
      },
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = 'Toggle [D]AP [U]I',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      dapui.setup()

      -- Pick a reliable Python interpreter for the adapter
      local function pick_python()
        local venv = os.getenv 'VIRTUAL_ENV'
        if venv and #venv > 0 then
          local vpy = venv .. '/bin/python'
          if vim.fn.executable(vpy) == 1 then
            return vpy
          end
        end

        local cwd_venv = vim.fn.getcwd() .. '/.venv/bin/python'
        if vim.fn.executable(cwd_venv) == 1 then
          return cwd_venv
        end

        local py3 = vim.fn.exepath 'python3'
        if py3 and #py3 > 0 then
          return py3
        end

        local py = vim.fn.exepath 'python'
        return (py and #py > 0) and py or 'python3'
      end

      local adapter_python = pick_python()
      require('dap-python').setup(adapter_python)
      dap.configurations.python = {
        {
          type = 'python',
          request = 'attach',
          name = 'Docker Remote Attach',
          connect = {
            host = 'localhost',
            port = 5678,
          },
          pathMappings = {
            {
              localRoot = vim.fn.getcwd(),
              remoteRoot = '/app',
            },
          },
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Launch File',
          program = '${file}',
          pythonPath = function()
            -- Use the same interpreter as the adapter to ensure debugpy is available
            return adapter_python
          end,
        },
      }
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },
}
