local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
local util = require 'lspconfig/util'

local Dictionary_file = {
    ["en"] = {vim.fn.getcwd() .. "dictionary.ltex"}
}
local DisabledRules_file = {
    ["en"] = {vim.fn.getcwd() .. "disable.ltex"}
}

local FalsePositives_file = {
    ["en"] = {vim.fn.getcwd() .. "false.ltex"} 
}

local function readFiles(files)
    local dict = {}
    for _,file in ipairs(files) do
        local f = io.open(file, "r")
        for l in f:lines() do
            table.insert(dict, l)
        end
    end
    return dict
end

local function findLtexLang()
    local buf_clients = vim.lsp.buf_get_clients()
    for _, client in ipairs(buf_clients) do
        if client.name == "ltex" then
            return client.config.settings.ltex.language
        end
    end
end

local function findLtexFiles(filetype, value)
    local files = nil
    if filetype == 'dictionary' then
        files = Dictionary_file[value or findLtexLang()]
    elseif filetype == 'disable' then
        files = DisabledRules_file[value or findLtexLang()]
    elseif filetype == 'falsePositive' then
        files = FalsePositives_file[value or findLtexLang()]
    end

    if files then
        return files
    else
        return nil
    end
end

local function updateConfig(lang, configtype)
    local buf_clients = vim.lsp.buf_get_clients()
    local client = nil
    for _, lsp in ipairs(buf_clients) do
        if lsp.name == "ltex" then
            client = lsp
        end
    end

    if client then
        if configtype == 'dictionary' then
            if client.config.settings.ltex.dictionary then
                client.config.settings.ltex.dictionary = {
                    [lang] = readFiles(Dictionary_file[lang])
                };
                return client.notify('workspace/didChangeConfiguration', client.config.settings)
            else
                return vim.notify("Error when reading dictionary config, check it")
            end
        elseif configtype == 'disable' then
            if client.config.settings.ltex.disabledRules then
                client.config.settings.ltex.disabledRules = {
                    [lang] = readFiles(DisabledRules_file[lang])
                };
                return client.notify('workspace/didChangeConfiguration', client.config.settings)
            else
                return vim.notify("Error when reading disabledRules config, check it")
            end

        elseif configtype == 'falsePositive' then
            if client.config.settings.ltex.hiddenFalsePositives then
                client.config.settings.ltex.hiddenFalsePositives = {
                    [lang] = readFiles(FalsePositives_file[lang])
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
    file = io.open(file[#file-0], "a+") -- add in last file defined.
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
        return updateConfig(lang, "disable")
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

if not lspconfig.ltex then
    configs.ltex = {
        default_config = {
            cmd = {"ltex-ls"};
            filetypes = {'tex', 'bib', 'md'};
            root_dir = function(filename)
                return util.path.dirname(filename)
            end;
            settings = {
                ltex = {
                    enabled= {"latex", "tex", "bib", "md"},
                    checkFrequency="save",
                    language="en",
                    diagnosticSeverity="information",
                    setenceCacheSize=5000,
                    additionalRules = {
                        enablePickyRules = true,
                        motherTongue= "en",
                    };
                    dictionary = {
                        ["en"] = readFiles(Dictionary_file["en"] or {}),
                    };
                    disabledRules = {
                        ["en"] = readFiles(DisabledRules_file["en"] or {}),
                    };
                    hiddenFalsePositives = {
                        ["en"] = readFiles(FalsePositives_file["en"] or {}),
                    };
                },
            };
        };
    };
end

lspconfig.ltex.setup{}
lspconfig.ltex.dictionary_file = Dictionary_file
lspconfig.ltex.disabledrules_file = DisabledRules_file
lspconfig.ltex.falsepostivies_file = FalsePositives_file


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
