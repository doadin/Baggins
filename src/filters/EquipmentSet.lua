--[[ ==========================================================================

EquipmentSet.lua

========================================================================== ]]--

--@retail@
local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions
local ipairs = _G.ipairs
local pairs = _G.pairs

-- WoW API
local GetEquipmentSetIDs = _G.C_EquipmentSet.GetEquipmentSetIDs
local GetEquipmentSetInfo = _G.C_EquipmentSet.GetEquipmentSetInfo
local GetContainerItemEquipmentSetInfo = _G.GetContainerItemEquipmentSetInfo

-- Libs
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

-- Local storage
local EquipmentSets = {}

-- Update list of equipment sets
local function UpdateEquipmentSets()

	wipe(EquipmentSets)

	for _, id in next, GetEquipmentSetIDs() do
		local name = GetEquipmentSetInfo(id)
		EquipmentSets[name] = name
	end

end

-- Get argument 'sets'
local function GetOptionSets(info, key)

	return info.arg.sets and info.arg.sets[key]

end

-- Set argument 'sets'
local function SetOptionSets(info, key, value)

	if not info.arg.sets then
		info.arg.sets = {}
	end

	info.arg.sets[key] = value
	AddOn:OnRuleChanged()

end

-- Test for 'Any' set
local function isAnySet(info)

	return info.arg.anyset

end

-- Test for match
local function Matches(bag, slot, rule)

	-- Empty rule?
	if not rule.sets then 
		return false 
	end

	-- Item belongs to a set?
	local inset, setstring = GetContainerItemEquipmentSetInfo(bag, slot)
	if not inset then 
		return false 
	end

	-- Match all sets?
	if rule.anyset then 
		return true
	end

	-- Item belongs to a set in rule.sets[]?
	local sets = { (","):split(setstring) }
	for _, v in ipairs(sets) do
	local set = v:gsub("^ ", "")
		if rule.sets[set] then 
			return true 
		end
	end

	return false

end

-- TODO: [#24] https://github.com/doadin/Baggins/issues/24
-- Return name for specific rule
local function GetName(rule)

	local result = ""

	if rule.anySet then
		return L["Any"]
	elseif rule.sets then
		for k in pairs(rule.sets) do
			result = result .. " " .. k
		end
	end

	return result

end

-- Register filter
AddOn:AddCustomRule(
	"EquipmentSet", 
	{
		DisplayName = L["Equipment Set"],
		Description = L["Filter by Equipment Set"],
		GetName = GetName, -- TODO: [#24] https://github.com/doadin/Baggins/issues/24
		Matches = Matches,
		Ace3Options = 
		{
			anyset = 
			{
				name = L["Any"],
				type = 'toggle',
			},
			sets = 
			{
				name = L["Equipment Sets"],
				type = 'multiselect',
				values = EquipmentSets,
				get = GetOptionSets,
				set = SetOptionSets,
				disabled = isAnySet,
			},
		},
	}
)

-- Initialize filter
AddOn:RegisterEvent("EQUIPMENT_SETS_CHANGED", UpdateEquipmentSets)
AddOn:RegisterEvent("PLAYER_LOGIN", UpdateEquipmentSets)
UpdateEquipmentSets()

--@end-retail@