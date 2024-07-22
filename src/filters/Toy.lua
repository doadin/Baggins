--[[ ==========================================================================

Toy.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

local C_TooltipInfoGetBagItem = C_TooltipInfo.GetBagItem
local TooltipUtil = TooltipUtil

local function Matches(bag, slot, _)
    local tooltipData = C_TooltipInfoGetBagItem(bag, slot)
    if not tooltipData then return false end
    TooltipUtil.SurfaceArgs(tooltipData)
    for _, line in ipairs(tooltipData.lines) do
        TooltipUtil.SurfaceArgs(line)
    end

    -- The above SurfaceArgs calls are required to assign values to the
    -- 'type', 'guid', and 'leftText' fields seen below.
    for i=1,#tooltipData.lines do
        if tooltipData.lines[i].leftText and tooltipData.lines[i].leftText:find("Toy") then
            return true
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