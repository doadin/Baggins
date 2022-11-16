--[[ ==========================================================================

Toy.lua

========================================================================== ]]--

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
local LibStub = _G.LibStub

local BankButtonIDToInvSlotID = _G.BankButtonIDToInvSlotID

local function Matches(bag, slot, _)
    --local itemId = GetContainerItemID(bag, slot)
    --local itemLink = C_ToyBox.GetToyLink(itemId)
    --if type(itemLink) == "string" then
    --    return true
    --end

    -- Local tooltip for getting tooltip contents
    local ScanTip = CreateFrame("GameTooltip", "BagginsScanTipToy", UIParent, "GameTooltipTemplate")
    ScanTip:SetOwner(UIParent, "ANCHOR_NONE")
    ScanTip:ClearLines()
    ScanTip:SetBagItem(bag, slot)
    for i = 1, select("#", ScanTip:GetRegions()) do
        local region = select(i, ScanTip:GetRegions())
        if region and region:GetObjectType() == "FontString" then
            local text = region:GetText() -- string or nil
            if text and text:find("Toy") then
                return true
            end
        end
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