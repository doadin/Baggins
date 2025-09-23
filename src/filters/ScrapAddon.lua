--[[ ==========================================================================

Empty.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local IsAddOnLoadable = C_AddOns and C_AddOns.IsAddOnLoadable and C_AddOns.IsAddOnLoadable
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local GetAddOnInfo = C_AddOns and C_AddOns.GetAddOnInfo
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local GetContainerItemID = C_Container and C_Container.GetContainerItemID or GetContainerItemID
local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots

-- Libs
--local LibStub = LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

if not (IsAddOnLoaded("Scrap") or ( IsAddOnLoadable and IsAddOnLoadable("Scrap")) or ( GetAddOnInfo and select(4,GetAddOnInfo("Scrap"))) ) then
    return
end

local Scrap = Scrap

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


local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:SetScript("OnEvent", function(self, event, bagID)
    local numSlots = GetContainerNumSlots(bagID)
    for slot = 1, numSlots do
        Matches(bagID, slot, _)
    end
    Baggins:OnRuleChanged()
end)