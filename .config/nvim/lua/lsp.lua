local projects_dirs = require('projects')

local lsp_installer = require("nvim-lsp-installer")
-- You should install for each language server manually with :LspInstall

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
    local opts = {}
    if server.name == 'pylsp' then
        local orig_config = require('lspconfig.server_configurations.pylsp')
        local orig_root_dir = orig_config['default_config']['root_dir']
        opts.root_dir = function (fname)
            for _, value in pairs(projects_dirs) do
                if fname:find(value) then
                    return value
                end
            end
            return orig_root_dir(fname)
        end
    elseif server.name == 'pyright' then
        local orig_config = require('lspconfig.server_configurations.pyright')
        local orig_root_dir = orig_config['default_config']['root_dir']
        opts.root_dir = function (fname)
            for _, value in pairs(projects_dirs) do
                -- doesn't work as intedned due to null ls see comment
                if fname:find(value) then
                    print(value)
                    return value
                end
            end
            return orig_root_dir(fname)
        end
        opts.handlers = {
            ['textDocument/publishDiagnostics'] = function() end
        }
    elseif server.name == 'sumneko_lua' then
        opts.settings = {
            Lua = {
                diagnostics = { globals = {'vim'} }
            }
        }
    end
    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)

require('null-ls').setup({
    -- note that this also changes root dir so now the root dir will be of the file but will have 2 workspaces
    -- this is a bug but I actually wanted to have this feature so I don't care
    sources = {
        require('null-ls').builtins.diagnostics.pylint,
    }
})

vim.diagnostic.config{
    signs=false,
}

