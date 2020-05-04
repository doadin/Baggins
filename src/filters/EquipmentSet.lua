--[[ ==========================================================================

EquipmentSet.lua

========================================================================== ]]--

--@retail@
local _G = _G
local Baggins = _G.Baggins

local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")

local equipmentSets = {}

function updateSets()
	wipe(equipmentSets)
	for _, id in next, _G.C_EquipmentSet.GetEquipmentSetIDs() do
		local name = _G.C_EquipmentSet.GetEquipmentSetInfo(id)
		equipmentSets[name] = name
	end
end

local function getEquipmentSetChoices()
	return equipmentSets
end

local function getSetValue(info, key)
	return info.arg.sets and info.arg.sets[key]
end

local function toggleSetValue(info, key, value)
	if not info.arg.sets then
		info.arg.sets = {}
	end
	info.arg.sets[key] = value
	Baggins:OnRuleChanged()
end

local function isAnySet(info)
	return info.arg.anyset
end

Baggins:RegisterEvent("EQUIPMENT_SETS_CHANGED", updateSets)
Baggins:RegisterEvent("PLAYER_LOGIN", updateSets)
updateSets()

Baggins:AddCustomRule("EquipmentSet", {
	DisplayName = L["Equipment Set"],
	Description = L["Filter by Equipment Set"],
	GetName = function(rule)
			local result = ""
			if rule.anySet then
				return L["Any"]
			elseif rule.sets then
				for k in pairs(rule.sets) do
					result = result .. " " .. k
				end
			end
			return result
		end,
	Matches = function(bag, slot, rule)
			local _, item = _G.GetContainerItemInfo(bag, slot)
			local inset, setstring = _G.GetContainerItemEquipmentSetInfo(bag, slot)
			if not inset then return false end
			if rule.anyset then return true end
			if not rule.sets then return false end
			local sets = { (","):split(setstring) }
			for i,v in ipairs(sets) do
			local set = v:gsub("^ ", "")
				if rule.sets[set] then
					return true
				end
			end
			return false
		end,
	Ace3Options = {
		anyset = {
			name = L["Any"],
			desc = "",
			type = 'toggle',
		},
		sets = {
			name = L["Equipment Sets"],
			desc = "",
			type = 'multiselect',
			values = getEquipmentSetChoices,
			get = getSetValue,
			set = toggleSetValue,
			disabled = isAnySet,
		},
	},
})
--@end-retail@