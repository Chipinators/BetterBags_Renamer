local VERSION_INFO = "1.0.1";
local VERSION_DATE = 1725368747;

---@diagnostic disable: missing-fields
---@class BetterBags: AceAddon
local BetterBags = LibStub('AceAddon-3.0'):GetAddon("BetterBags")
assert(BetterBags, "BetterBags_Renamer requires BetterBags")

local addonName, root = ...
---@class BetterBags_Renamer: AceModule
local addon = LibStub("AceAddon-3.0"):NewAddon(root, addonName, 'AceHook-3.0')

---@class Categories: AceModule
local categories = BetterBags:GetModule('Categories')

---@class Config: AceModule
local config = BetterBags:GetModule('Config')

---@class Events: AceModule
local events = BetterBags:GetModule('Events')

---@class Localization: AceModule
local L = BetterBags:GetModule('Localization')

-- Variables
local selectedCategoryName = ""
local newCategoryName = ""
local currentCategories = {}

local function RefreshCategories()
    currentCategories = categories:GetAllCategories()
end

events:RegisterMessage("categories/Changed", function()
    RefreshCategories()
end)

local function DeepCopy(original)
    local copy
    if type(original) == 'table' then
        copy = {}
        for key, value in next, original, nil do
            copy[DeepCopy(key)] = DeepCopy(value)
        end
        setmetatable(copy, DeepCopy(getmetatable(original)))
    else -- number, string, boolean, etcb
        copy = original
    end
    return copy
end

local function IsDuplicateCategoryName(name)
    if name == selectedCategoryName then
        return false
    end

    for existingName, _ in pairs(currentCategories) do
        if existingName == name then
            return true
        end
    end
    return false
end

local function RenameCategory()
    local currentCategory = currentCategories[selectedCategoryName]
    assert(currentCategory, L:G("Attempted to call RenameCategory on a category that doesn't exist"))
    local newCategory = DeepCopy(currentCategory);
    newCategory.name = newCategoryName;

    categories:DeleteCategory(selectedCategoryName)
    categories:CreateCategory(newCategory)
    print(format(L:G("BetterBags - Renamer: Successfully Renamed '%s' to '%s'"), selectedCategoryName, newCategoryName))

    selectedCategoryName = ""
    newCategoryName = ""
    events:SendMessage('bags/FullRefreshAll')
end

local function RenameDisabled()
    local noOldCategory = string.len(selectedCategoryName) == 0
    local noNewCategory = string.len(newCategoryName) == 0
    local sameNames = selectedCategoryName == newCategoryName
    local duplicateName = IsDuplicateCategoryName(newCategoryName)

    return noOldCategory or noNewCategory or sameNames or duplicateName
end

local function GetAboutText()
    local version = L:G("Version")..": "..VERSION_INFO
    local date = L:G("Released")..": "..date("%m/%d/%y", VERSION_DATE)
    local developer = L:G("Developer")..": ".."Chipinators"

    return version.."\n\n"..date.."\n\n"..developer
end

---@type AceConfig.OptionsTable
local renamerConfigOptions = {
    renamer = {
        name = L:G("Category Renamer"),
        type = "group",
        order = 0,
        inline = true,
        args = {
            description = {
                type = "description",
                fontSize = "medium",
                name = L:G("Custom categories that are manually created are only allowed to be renamed.\n\nIf a category is missing from the list below, it means that its either created by BetterBags itself or an installed plugin."),
                order = 0,
            },
            categorySelect = {
                type = "select",
                name = L:G("Select Category"),
                desc = L:G("Select the category to rename"),
                order = 1,
                width = "full",
                values = function()
                    local catNames = {}
                    for name, filter in pairs(currentCategories) do
                        if filter.save then
                            catNames[name] = name
                        end
                    end
                    return catNames
                end,
                get = function() return selectedCategoryName end,
                set = function(_, value)
                    selectedCategoryName = value
                    newCategoryName = value
                end,
            },
            newCategoryInput = {
                type = "input",
                name = L:G("New Name"),
                desc = L:G("Enter the new name you want for the selected category"),
                order = 2,
                width = "full",
                get = function() return newCategoryName end,
                set = function(_, value) newCategoryName = value end,
                disabled = function() return selectedCategoryName == "" end,
            },
            duplicateCategory = {
                type = "description",
                fontSize = "medium",
                name = function()
                    if IsDuplicateCategoryName(newCategoryName) then
                        return "|cffd11717"..L:G("Error: A category with this name already exists.").."|r"
                    else
                        return ""
                    end
                end,
                order = 3,
                hidden = function() return not IsDuplicateCategoryName(newCategoryName) end,
            },
            buttons = {
                name = "",
                type = "group",
                inline = true,
                order = 99,
                args = {
                    rename = {
                        type = "execute",
                        name = L:G("Rename"),
                        order = 0,
                        func = function() RenameCategory() end,
                        disabled = function() return RenameDisabled() end,
                    },
                },
            },
        },
    },
    about = {
        name = L:G("About"),
        type = "group",
        order = 0,
        inline = false,
        args = {
            current = {
                name = L:G("About"),
                type = "group",
                order = 0,
                inline = true,
                args = {
                    description = {
                        fontSize = "medium",
                        type = "description",
                        name = GetAboutText,
                        order = 0,
                    },
                },
            },
            support = {
                name = L:G("Support"),
                type = "group",
                order = 1,
                inline = true,
                args = {
                    description = {
                        type = "description",
                        fontSize = "medium",
                        name = L:G("If you find any issues with the plugin, please submit an issue on the projects GitHub page."),
                        order = 0,
                    },
                    importer = {
                        type = "input",
                        name = L:G("GitHub"),
                        order = 1,
                        width = "full",
                        get = function() return "https://github.com/Chipinators/BetterBags_Renamer" end,
                        set = function(_, value) value = "https://github.com/Chipinators/BetterBags_Renamer" end,
                    },
                },
            },
            otherPlugins = {
                name = L:G("Check Out My Other BetterBags Plugins"),
                type = "group",
                order = 2,
                inline = true,
                args = {
                    importer = {
                        type = "input",
                        name = L:G("AdiBags Importer"),
                        order = 0,
                        width = "full",
                        get = function() return "https://github.com/Chipinators/BetterBags_AdiBagsImporter" end,
                        set = function(_, value) value = "https://github.com/Chipinators/BetterBags_AdiBagsImporter" end,
                    },
                },
            },
        }
    },
}

config:AddPluginConfig("Renamer", renamerConfigOptions)