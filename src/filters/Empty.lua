--[[ ==========================================================================

Empty.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local function Matches(bag,slot,_)
    if not (bag and slot) then return end
    local link = GetContainerItemLink(bag, slot)
    if not link then
        return true
    end
end

AddOn:AddCustomRule("Empty", {
    DisplayName = L["Empty Slots"],
    Description = L["Empty bag slots"],
    Matches = Matches,
})