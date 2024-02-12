local lsp = require('lsp-zero')
local navbuddy = require("nvim-navbuddy")

lsp.preset().on_attach(
    function(client, bufnr)
        navbuddy.attach(client, bufnr)
    end
)
lsp.setup()

