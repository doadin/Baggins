--[[ ==========================================================================

Other.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local function Matches()
--local key = bag..":"..slot
--return not useditems[key]
end

AddOn:AddCustomRule("Other", {
    DisplayName = L["Unfiltered Items"],
    Description = L["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"],
    Matches = Matches,
})