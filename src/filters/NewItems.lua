--[[ ==========================================================================

NewItems.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Local storage
local BagTypes = Baggins:GetBagTypes()

local function Matches(bag,slot)
    if not (bag and slot) then return end
    if BagTypes[bag] ~= 1 then return end
    local link = GetContainerItemLink(bag, slot)
    if link then
        return AddOn:IsNew(link)
    end
end

AddOn:AddCustomRule("NewItems",
    {
        DisplayName = L["New Items"],
        Description = L["New Items"],
        Matches = Matches,
    }
)