--[[ ==========================================================================

Proffesions.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- Libs
--local LibStub = LibStub
--local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo



-- Clean rule
local function CleanRule(rule)

    rule.bagid=0

end

local f = CreateFrame('Frame')
f:RegisterEvent("LOADING_SCREEN_DISABLED")
f:SetScript("OnEvent", function()

    local prof1, prof2, _, _, _ = GetProfessions() --prof1, prof2, archaeology, fishing, cooking
    --local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(index)
    local firstprof = prof1 and select(7,GetProfessionInfo(prof1))
    local secondprof = prof2 and select(7,GetProfessionInfo(prof2))
    --print(firstprof)
    --print(secondprof)

    --local profToIndex = {
    --    ["Archaeology"] = 794,
    --    ["Alchemy"] = 171,
    --    ["Blacksmith"] = 164,
    --    ["Cooking"] = 184,
    --    ["Enchanting"] = 333,
    --    ["Engineer"] = 202,
    --    ["First Aid"] = 129,
    --    ["Fishing"] = 356,
    --    ["Herbalism"] = 182,
    --    ["Inscription"] = 773,
    --    ["Jewelcrafting"] = 755,
    --    ["Leatherworking"] = 165,
    --    ["Mining"] = 186,
    --    ["Skinning"] = 393,
    --    ["Tailoring"] = 197
    --}
    --
    --for profName,Index in pairs(profToIndex) do
    --
    --end

    local profToIndex = {
        [794] = "Archaeology",
        [171] = "Alchemy",
        [164] = "Blacksmith",
        [184] = "Cooking",
        [333] = "Enchanting",
        [202] = "Engineer",
        [129] = "First Aid",
        [356] = "Fishing",
        [182] = "Herbalism",
        [773] = "Inscription",
        [755] = "Jewelcrafting",
        [165] = "Leatherworking",
        [186] = "Mining",
        [393] = "Skinning",
        [197] = "Tailoring"
    }

    local firstprofName = firstprof and profToIndex[firstprof] or ""
    local secondprofName = secondprof and profToIndex[secondprof] or ""
    --print(firstprofName)
    --print(secondprofName)

--
local function MatchesArchaeology() --bag, slot, _
    if firstprofName == "Archaeology" or secondprofName == "Archaeology" then
        return true
    end
end

AddOn:AddCustomRule("Archaeology", {
    DisplayName = "Profession: Archaeology",
    Description = "Matches having Archaeology as a proffesion.",
    Matches = MatchesArchaeology,
    CleanRule = CleanRule
})

--
local function MatchesAlchemy() --bag, slot, _
    if firstprofName == "Alchemy" or secondprofName == "Alchemy" then
        return true
    end
end

AddOn:AddCustomRule("Alchemy", {
    DisplayName = "Profession: Alchemy",
    Description = "Matches having Alchemy as a proffesion.",
    Matches = MatchesAlchemy,
    CleanRule = CleanRule
})

--
local function MatchesBlacksmith() --bag, slot, _
    if firstprofName == "Blacksmith" or secondprofName == "Blacksmith" then
        return true
    end
end

AddOn:AddCustomRule("Blacksmith", {
    DisplayName = "Profession: Blacksmith",
    Description = "Matches having Blacksmith as a proffesion.",
    Matches = MatchesBlacksmith,
    CleanRule = CleanRule
})

--
local function MatchesCooking() --bag, slot, _
    if firstprofName == "Cooking" or secondprofName == "Cooking" then
        return true
    end
end

AddOn:AddCustomRule("Cooking", {
    DisplayName = "Profession: Cooking",
    Description = "Matches having Cooking as a proffesion.",
    Matches = MatchesCooking,
    CleanRule = CleanRule
})

--
local function MatchesEnchanting() --bag, slot, _
    if firstprofName == "Enchanting" or secondprofName == "Enchanting" then
        return true
    end
end

AddOn:AddCustomRule("Enchanting", {
    DisplayName = "Profession: Enchanting",
    Description = "Matches having Enchanting as a proffesion.",
    Matches = MatchesEnchanting,
    CleanRule = CleanRule
})

--
local function MatchesEngineer() --bag, slot, _
    if firstprofName == "Engineer" or secondprofName == "Engineer" then
        return true
    end
end

AddOn:AddCustomRule("Engineer", {
    DisplayName = "Profession: Engineer",
    Description = "Matches having Engineer as a proffesion.",
    Matches = MatchesEngineer,
    CleanRule = CleanRule
})

--
local function MatchesFirstAid() --bag, slot, _
    if firstprofName == "First Aid" or secondprofName == "First Aid" then
        return true
    end
end

AddOn:AddCustomRule("First Aid", {
    DisplayName = "Profession: First Aid",
    Description = "Matches having First Aid as a proffesion.",
    Matches = MatchesFirstAid,
    CleanRule = CleanRule
})

--
local function MatchesFishing() --bag, slot, _
    if firstprofName == "Fishing" or secondprofName == "Fishing" then
        return true
    end
end

AddOn:AddCustomRule("Fishing", {
    DisplayName = "Profession: Fishing",
    Description = "Matches having Fishing as a proffesion.",
    Matches = MatchesFishing,
    CleanRule = CleanRule
})

--
local function MatchesHerbalism() --bag, slot, _
    if firstprofName == "Herbalism" or secondprofName == "Herbalism" then
        return true
    end
end

AddOn:AddCustomRule("Herbalism", {
    DisplayName = "Profession: Herbalism",
    Description = "Matches having Herbalism as a proffesion.",
    Matches = MatchesHerbalism,
    CleanRule = CleanRule
})

--
local function MatchesInscription() --bag, slot, _
    if firstprofName == "Inscription" or secondprofName == "Inscription" then
        return true
    end
end

AddOn:AddCustomRule("Inscription", {
    DisplayName = "Profession: Inscription",
    Description = "Matches having Inscription as a proffesion.",
    Matches = MatchesInscription,
    CleanRule = CleanRule
})

--
local function MatchesJewelcrafting() --bag, slot, _
    if firstprofName == "Jewelcrafting" or secondprofName == "Jewelcrafting" then
        return true
    end
end

AddOn:AddCustomRule("Jewelcrafting", {
    DisplayName = "Profession: Jewelcrafting",
    Description = "Matches having Jewelcrafting as a proffesion.",
    Matches = MatchesJewelcrafting,
    CleanRule = CleanRule
})

--
local function MatchesLeatherworking() --bag, slot, _
    if firstprofName == "Leatherworking" or secondprofName == "Leatherworking" then
        return true
    end
end

AddOn:AddCustomRule("Leatherworking", {
    DisplayName = "Profession: Leatherworking",
    Description = "Matches having Leatherworking as a proffesion.",
    Matches = MatchesLeatherworking,
    CleanRule = CleanRule
})

--
local function MatchesMining() --bag, slot, _
    if firstprofName == "Mining" or secondprofName == "Mining" then
        return true
    end
end

AddOn:AddCustomRule("Mining", {
    DisplayName = "Profession: Mining",
    Description = "Matches having Mining as a proffesion.",
    Matches = MatchesMining,
    CleanRule = CleanRule
})

--
local function MatchesSkinning() --bag, slot, _
    if firstprofName == "Skinning" or secondprofName == "Skinning" then
        return true
    end
end

AddOn:AddCustomRule("Skinning", {
    DisplayName = "Profession: Skinning",
    Description = "Matches having Skinning as a proffesion.",
    Matches = MatchesSkinning,
    CleanRule = CleanRule
})

--
local function MatchesTailoring() --bag, slot, _
    if firstprofName == "Tailoring" or secondprofName == "Tailoring" then
        return true
    end
end

AddOn:AddCustomRule("Tailoring", {
    DisplayName = "Profession: Tailoring",
    Description = "Matches having Tailoring as a proffesion.",
    Matches = MatchesTailoring,
    CleanRule = CleanRule
})

end)