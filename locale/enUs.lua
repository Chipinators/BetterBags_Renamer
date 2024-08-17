---@class BetterBags: AceAddon
local BetterBags = LibStub('AceAddon-3.0'):GetAddon("BetterBags")

---@class Localization: AceModule
local L = BetterBags:GetModule('Localization')

if L then
    -- General Strings
    local generalStrings = {
        ["AdiBags Importer"] = "AdiBags Importer",
        ["About"] = "About",
        ["Version"] = "Version",
        ["Date"] = "Date",
        ["Developer"] = "Developer",
        ["Support"] = "Support",
        ["GitHub"] = "GitHub",
        ["Rename"] = "Rename",
        ["New Name"] = "New Name",
        ["Select Category"] = "Select Category",
        ["Category Renamer"] = "Category Renamer",
        ["Check Out My Other BetterBags Plugins"] = "Check Out My Other BetterBags Plugins",
        
    }

    -- Descriptions
    local descriptions = {
        ["If you find any issues with the plugin, please submit an issue on the projects GitHub page."] = "If you find any issues with the plugin, please submit an issue on the projects GitHub page.",
        ["Enter the new name you want for the selected category"] = "Enter the new name you want for the selected category",
        ["Select the category to rename"] = "Select the category to rename",
        ["Custom categories that are manually created are only allowed to be renamed.\n\nIf a category is missing from the list below, it means that its either created by BetterBags itself or an installed plugin."] = "Custom categories that are manually created are only allowed to be renamed.\n\nIf a category is missing from the list below, it means that its either created by BetterBags itself or an installed plugin.",
        ["BetterBags - Renamer: Successfully Renamed '%s' to '%s'"] = "BetterBags - Renamer: Successfully Renamed '%s' to '%s'",
    }
    
    -- Errors
    local errors = {
        ["Attempted to call RenameCategory on a category that doesn't exist"] = "Attempted to call RenameCategory on a category that doesn't exist",
        ["Error: A category with this name already exists."] = "Error: A category with this name already exists.",
    }

    -- Register Strings
    for key, value in pairs(generalStrings) do
        L:S(key, value)
    end

    for key, value in pairs(descriptions) do
        L:S(key, value)
    end

    for key, value in pairs(errors) do
        L:S(key, value)
    end
end