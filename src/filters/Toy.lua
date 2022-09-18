--[[ ==========================================================================

Toy.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
local LibStub = _G.LibStub
local LG = LibStub("LibGratuity-3.0")

local BankButtonIDToInvSlotID = _G.BankButtonIDToInvSlotID

local function Matches(bag, slot, _)
    --local itemId = GetContainerItemID(bag, slot)
    --local itemLink = C_ToyBox.GetToyLink(itemId)
    --if type(itemLink) == "string" then
    --    return true
    --end

    -- Is item in bags or in bank bags?
    if bag == -1 then
        LG:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
    else
        LG:SetBagItem(bag,slot)
    end

    -- Text found in tooltip?
    if LG:Find("Toy",3,3) then
        return true
    end

    return false
end

-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

AddOn:AddCustomRule("Toys", {
    DisplayName = "Toys",
    Description = "Matches toys.",
    Matches = Matches,
    CleanRule = CleanRule
})