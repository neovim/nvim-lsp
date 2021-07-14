local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local function readFiles(files)
    local dict = {}
    for _,file in pairs(files) do
        local f = io.open(file, "r")
        for l in f:lines() do
            table.insert(dict, l)
        end
    end
    return dict
end

local function findLtexLang()
    local buf_clients = vim.lsp.buf_get_clients()
    for _, client in pairs(buf_clients) do
        if client.name == "ltex" then
            return client.config.settings.ltex.language
        end
    end
end

local function findLtexFiles(filetype, value)
    local buf_clients = vim.lsp.buf_get_clients()
    for _, client in pairs(buf_clients) do
        if client.name == "ltex" then
            local files = nil
            if filetype == 'dictionary' then
                files = client.config.dictionary_files[value or findLtexLang()]
            elseif filetype == 'disable' then
                files = client.config.disabledrules_files[value or findLtexLang()]
            elseif filetype == 'falsePositive' then
                files = client.config.falsepositive_files[value or findLtexLang()]
            end

            if files then
                return files
            else
                return nil
            end
        end
    end
end

local function updateConfig(lang, configtype)
    local buf_clients = vim.lsp.buf_get_clients()
    local client = nil
    for _, lsp in pairs(buf_clients) do
        if lsp.name == "ltex" then
            client = lsp
        end
    end

    if client then
        if configtype == 'dictionary' then
            -- if client.config.settings.ltex.dictionary then
                client.config.settings.ltex.dictionary = {
                    [lang] = readFiles(client.config.dictionary_files[lang])
                };
                return client.notify('workspace/didChangeConfiguration', client.config.settings)
            -- else
                -- return vim.notify("Error when reading dictionary config, check it")
            -- end
        elseif configtype == 'disable' then
            if client.config.settings.ltex.disabledRules then
                client.config.settings.ltex.disabledRules = {
                    [lang] = readFiles(client.config.disabledrules_files[lang])
                };
                return client.notify('workspace/didChangeConfiguration', client.config.settings)
            else
                return vim.notify("Error when reading disabledRules config, check it")
            end

        elseif configtype == 'falsePositive' then
            if client.config.settings.ltex.hiddenFalsePositives then
                client.config.settings.ltex.hiddenFalsePositives = {
                    [lang] = readFiles(client.config.falsepositive_files[lang])
                };
                return client.notify('workspace/didChangeConfiguration', client.config.settings)
            else
                return vim.notify("Error when reading hiddenFalsePositives config, check it")
            end
        end
    else
        return nil
    end
end

local function addToFile(filetype, lang, file, value)
    file = io.open(file[#file-0], "a+") -- add only to last file defined.
    if file then
        file:write(value .. "\n")
        file:close()
    else
        return print("Failed insert %q", value)
    end
    if filetype == 'dictionary' then
        return updateConfig(lang, "dictionary")
    elseif filetype == 'disable' then
        return updateConfig(lang, "disable")
    elseif filetype == 'falsePositive' then
        return updateConfig(lang, "falsePositive")
    end
end

local function addTo(filetype, lang, file, value)
    local dict = readFiles(file)
    for _, v in ipairs(dict) do
        if v == value then
            return nil
        end
    end
    return addToFile(filetype, lang, file, value)
end

configs.ltex = {
    default_config = {
        cmd = {"ltex-ls"};
        filetypes = {'tex', 'bib', 'markdown'};
        dictionary_files = { ["en"] = {vim.fn.getcwd() .. "dictionary.ltex"} };
        disabledrules_files = { ["en"] = {vim.fn.getcwd() .. "disable.ltex"} };
        falsepositive_files = { ["en"] = {vim.fn.getcwd() .. "false.ltex"}};
        settings = {
            ltex = {
                enabled= {"latex", "tex", "bib", "markdown"},
                checkFrequency="save",
                language="en",
                diagnosticSeverity="information",
                setenceCacheSize=2000,
                additionalRules = {
                    enablePickyRules = true,
                    motherTongue= "en",
                };
                dictionary = {};
                disabledRules = {};
                hiddenFalsePositives = {};
            },
        };
        on_attach = function(client, bufnr)
                    -- local lang = client.config.settings.ltex.language
            for lang,_ in ipairs(client.config.dictionary_files) do       --
                    updateConfig(lang, "dictionary")
                    updateConfig(lang, "disable")
                    updateConfig(lang, "falsePositive")
            end
        end;
    };
};
--
-- https://github.com/neovim/nvim-lspconfig/issues/858 can't intercept,
-- override it then.
local orig_execute_command = vim.lsp.buf.execute_command
vim.lsp.buf.execute_command = function(command)
    if command.command == '_ltex.addToDictionary' then
        local arg = command.arguments[1].words -- can I really access like this?
        for lang, words in pairs(arg) do
            for _, word in ipairs(words) do
                local filetype = "dictionary"
                addTo(filetype,lang, findLtexFiles(filetype,lang), word)
            end
        end
    elseif command.command == '_ltex.disableRules' then
        local arg = command.arguments[1].ruleIds -- can I really access like this?
        for lang, rules in pairs(arg) do
            for _, rule in ipairs(rules) do
                local filetype = "disable"
                addTo(filetype,lang,findLtexFiles(filetype,lang), rule)
            end
        end

    elseif command.command == '_ltex.hideFalsePositives' then
        local arg = command.arguments[1].falsePositives -- can I really access like this?
        for lang, rules in pairs(arg) do
            for _, rule in ipairs(rules) do
                local filetype = "falsePositive"
                addTo(filetype,lang,findLtexFiles(filetype,lang), rule)
            end
        end
    else
        orig_execute_command(command)
    end
end
