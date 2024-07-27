--[[ ==========================================================================

PeriodicTable.lua

========================================================================== ]]--

local AddOnName, _ = ...
local AddOn = _G[AddOnName]

-- LUA Functions

-- WoW API
local pairs, type, tonumber, wipe, ceil =
      pairs, type, tonumber, wipe, ceil
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local tinsert, tsort =
      tinsert, table.sort

-- Libs
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)

local pt = LibStub("LibPeriodicTable-3.1", true)
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local ptsets = {}

function AddOn:BuildPTSetTable()
    if not (pt and self.ptsetsdirty) then
        return
    end
    wipe(ptsets)

    local sets = pt.sets
    for setname in pairs(sets) do
        local workingLevel = ptsets
        local oldLevel, oldParent, allowedFlag
        for parent in setname:gmatch("([^%.]+)") do
            if not workingLevel[parent] then
                workingLevel[parent] = {}
                allowedFlag = true
            else
                allowedFlag = false
            end
            for k, _ in pairs(workingLevel) do
                local kname = k:match("0077ff([^%*]+)")
                if kname == parent then
                    workingLevel[k] = nil
                end
            end

            oldLevel = workingLevel
            oldParent = parent
            workingLevel = workingLevel[parent]
        end
        if allowedFlag then
            oldLevel[oldParent] = false
        end
    end
    self.ptsetsdirty = false
end

local function sortMenu(a, b)
    local function pad(s) return ("%04d"):format(tonumber(s)) end -- pseudo natural sorting!
    return a.text:gsub("(%d+)", pad) < b.text:gsub("(%d+)", pad)
end

local function buildMenu(tab, name)
	local menu = {}
    for k,v in pairs(tab) do
        local newName
        if not name then
            newName = k
        else
            newName = ("%s.%s"):format(name, k)
        end
        if not v then
            tinsert(menu, {
                text = k,
                func = function()
                    currentRule.setname = newName --luacheck: ignore 112
                    AceConfigRegistry:NotifyChange("BagginsEdit")
                    AddOn:OnRuleChanged()
                end,
            })
        elseif type(v) == 'table' then
            tinsert(menu, {
                text = k,
                hasArrow = true,
                menuList = buildMenu(v, newName),
                func = function()
                    currentRule.setname = newName --luacheck: ignore 112
                    AceConfigRegistry:NotifyChange("BagginsEdit")
                    AddOn:OnRuleChanged()
                end,
            })
        end
    end
    tsort(menu, sortMenu)
    local menuSize = 35
    if #menu > menuSize then
        local newMenu = {}
        for i=1, ceil(#menu/menuSize) do
            local subMenu = {}
            for j=1, menuSize do
                local index = menuSize * (i-1) + j
                if not menu[index] then break end
                tinsert(subMenu, menu[index])
            end
            tinsert(newMenu, {
                text = ("%s-%s"):format(subMenu[1].text:sub(1, 1), subMenu[#subMenu].text:sub(1, 1)),
                hasArrow = true,
                menuList = subMenu,
                notCheckable = true,
                notClickable = false,
            })
        end
        menu = newMenu
    end
    return menu
end

local ptdropdownFrame = CreateFrame("Frame", "Baggins_PTConfigMenuFrame", UIParent, "UIDropDownMenuTemplate")
local function showPTDropdown(info)
	local categoryname = info[#info-2]:sub(2) --luacheck: ignore 211
	local ruleid = info[#info-1] --luacheck: ignore 211
	local attr = info[#info] --luacheck: ignore 211
	currentRule = info.arg --luacheck: ignore 111
	local menu = buildMenu(ptsets)
	AddOn:EasyMenu(menu, ptdropdownFrame, "cursor", 0, 0, "MENU")
end

-- Test for match
local function Matches(bag, slot, rule)
	if not rule.setname then return end
	local link = GetContainerItemLink(bag, slot)
	if link then
		local itemid = link:match("item:(%d+)")
		if not itemid then
			return false
		end
		itemid = tonumber(itemid)
		return pt:ItemInSet(itemid,rule.setname)
	end
end

AddOn.ptsetsdirty = true
AddOn:BuildPTSetTable()
AddOn:AddCustomRule(
    "PeriodicTable Set",
    {
        DisplayName = L["PeriodicTable Set"],
		Description = L["Filter by PeriodicTable Set"],
        Matches = Matches,
		Ace3Options =
		{
            setname = {
                name = L["Edit"],
                desc = "",
                type = 'execute',
                func = showPTDropdown,
                order = 200,
            },
            description = {
                name = function(info) return info.arg.setname or "*" end,
                type = 'description',
                order = 199,
            }
        },
	}
)