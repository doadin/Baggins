--[[ ==========================================================================

Empty.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- WoW API
local GetContainerItemLink = _G.C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink
local GetContainerItemID = _G.C_Container and _G.C_Container.GetContainerItemID or _G.GetContainerItemID
local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER
local BANK_CONTAINER = _G.BANK_CONTAINER
local NUM_BAG_SLOTS = _G.NUM_TOTAL_EQUIPPED_BAG_SLOTS or _G.NUM_BAG_SLOTS
local NUM_BANKBAGSLOTS = _G.NUM_BANKBAGSLOTS
local REAGENTBANK_CONTAINER = _G.REAGENTBANK_CONTAINER

-- Libs
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local Scrap = _G.Scrap
if not Scrap then return end

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