--[[ ==========================================================================

Empty.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink

-- Libs
local LibStub = _G.LibStub
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