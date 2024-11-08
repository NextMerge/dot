if not vim.g.vscode then
    error("This config is only for VSCode Neovim")
    return
end

local vscode = require("vscode")
vim.notify = vscode.notify

print("Hello from Neovim!")

vim.keymap.set({ "n", "v" }, "<Space>", function()
    vscode.call("whichkey.show")
end, { desc = "Show WhichKey menu" })

vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down a line" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up a line" })

vim.keymap.del("n", "H") -- Handle in keybindings

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })

vim.keymap.set("n", "'", function()
    local current_tab_is_pinned = vscode.eval("return vscode.window.tabGroups.activeTabGroup.activeTab.isPinned")

    vscode.call("whichkey.show", {
        args = {
            {
                {
                    key = "g",
                    name = "Toggle pin tab",
                    type = "command",
                    command = current_tab_is_pinned and "workbench.action.unpinEditor" or "workbench.action.pinEditor",
                },
                {
                    key = "h",
                    name = "Focus first editor",
                    type = "command",
                    command = "workbench.action.openEditorAtIndex1",
                },
                {
                    key = "t",
                    name = "Focus second editor",
                    type = "command",
                    command = "workbench.action.openEditorAtIndex2",
                },
                {
                    key = "n",
                    name = "Focus third editor",
                    type = "command",
                    command = "workbench.action.openEditorAtIndex3",
                },
                {
                    key = "s",
                    name = "Focus fourth editor",
                    type = "command",
                    command = "workbench.action.openEditorAtIndex4",
                },
                {
                    key = "C",
                    name = "Clear all tabs",
                    type = "command",
                    command = "workbench.action.closeEditorsAndGroup",
                },
            },
        },
    })
end, { desc = "Format Document" })

vim.keymap.set("n", "s", function()
    vscode.call("leap.findForward")
end, { desc = "Leap forward" })
vim.keymap.set("n", "S", function()
    vscode.call("leap.findBackward")
end, { desc = "Leap backward" })

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy-cursor/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup({
                mappings = {
                    add = ";a", -- Add surrounding in Normal and Visual modes
                    delete = ";d", -- Delete surrounding
                    find = ";f", -- Find surrounding (to the right)
                    find_left = ";F", -- Find surrounding (to the left)
                    highlight = ";h", -- Highlight surrounding
                    replace = ";r", -- Replace surrounding
                    update_n_lines = ";n", -- Update `n_lines`
                },
            })

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
})
