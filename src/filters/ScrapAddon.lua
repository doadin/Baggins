--[[ ==========================================================================

Empty.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local IsAddOnLoadable = _G.C_AddOns and _G.C_AddOns.IsAddOnLoadable and _G.C_AddOns.IsAddOnLoadable
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink
local GetContainerItemID = _G.C_Container and _G.C_Container.GetContainerItemID or _G.GetContainerItemID

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

if not (IsAddOnLoaded("Scrap") or ( IsAddOnLoadable and IsAddOnLoadable("Scrap")) or ( C_AddOns.GetAddOnInfo and select(4,C_AddOns.GetAddOnInfo("Scrap"))) ) then
    return
end

local Scrap = _G.Scrap

local function Matches(bag,slot,_)
    if not Scrap then return end
    if not (bag and slot) then return end
    local link = GetContainerItemLink(bag, slot)
    local id = GetContainerItemID(bag, slot)
    if not link then return end
    if not id then return end
    if Scrap:IsJunk(id, bag, slot) then
        return true
    end
end

AddOn:AddCustomRule("Scrap Addon", {
    DisplayName = "Scrap Addon",
    Description = "Items set as junk by the Scrap Addon",
    Matches = Matches,
})