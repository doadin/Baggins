
local pairs, ipairs, tonumber, tostring, next, select, type, wipe = 
      pairs, ipairs, tonumber, tostring, next, select, type, wipe


local tinsert, tremove, tsort = tinsert, tremove, tsort

-- GLOBALS: LibStub, GetItemQualityColor
-- GLOBALS: ITEM_QUALITY0_DESC, ITEM_QUALITY1_DESC, ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC, ITEM_QUALITY5_DESC, ITEM_QUALITY6_DESC




local Baggins = Baggins

local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local dbIcon = LibStub("LibDBIcon-1.0")

local function noop()
end


local templates = {
	allinone = {
		layout = "manual",
		columns = 12,
		sorttype = "quality",
		showsectiontitle = true,
		bags = {
			{
				name = L["All In One"],
				openWithAll = true,
				sections =
				{
					{ name=L["Bags"], cats={L["Bags"]} },
				}
			},
			{
				name = L["Bank All In One"],
				openWithAll = true,
				isBank = true,
				sections =
				{
					{ name=L["Bank Bags"], cats={L["BankBags"]} },
				}
			}
		}
	},
	allinonesorted = {
		layout = "manual",
		columns = 12,
		sorttype = "quality",
		showsectiontitle = true,
		section_layout = 'flow',
		bags = {
			{
				name = L["All In One"],
				openWithAll = true,
				sections =
				{
					{ name = L["New"], cats = { L["New"] } , allowdupes=true },
					{ name = L["Armor"], cats = { L["Armor"] },},
					{ name = L["Weapons"], cats = { L["Weapons"] } },
					{ name = L["Consumables"], cats = { L["Consumables"] } },
					{ name = L["Quest"], cats = { L["Quest"] } },
					{ name = L["Trade Goods"], cats = { L["Tradeskill Mats"], L["Recipes"] } },
					{ name = L["Other"], cats = { L["Other"] } },
				}
			},
			{
				name = L["Bank All In One"],
				openWithAll = true,
				isBank = true,
				sections =
				{
					{ name = L["Bank Equipment"], cats = { L["Armor"], L["Weapons"] },},
					{ name = L["Bank Consumables"], cats = { L["Consumables"] } },
					{ name = L["Bank Quest"], cats = { L["Quest"] } },
					{ name = L["Bank Trade Goods"], cats = { L["Tradeskill Mats"], L["Recipes"] } },
					{ name = L["Bank Other"], cats = { L["Other"] } },
				}
			}
		}
	},
	default = {
		showsectiontitle = true,
		columns = 5,
		sorttype = "quality",
		layout = "auto",
		bags = {
			{
				name = L["Other"],
				openWithAll = true,
				sections =
				{
					{ name=L["New"], cats = { L["New"] }, allowdupes=true },
					{ name=L["Other"], cats = { L["Other"] } },
					{ name=L["Trash"], cats = { L["Trash"], L["TrashEquip"] } },
					{ name=L["Empty"], cats = { L["Empty"] } }
				}
			},
			{
				name = L["Equipment"],
				openWithAll = true,
				sections =
				{
					{ name=L["In Use"], cats={ L["In Use"] } },
					{ name=L["Armor"], cats={ L["Armor"] } },
					{ name=L["Weapons"], cats={ L["Weapons"] } }
				}
			},
			{
				name = L["Quest"],
				openWithAll = true,
				sections =
				{
					{ name=L["Quest Items"], cats = { L["Quest"] } }
				}
			},
			{
				name = L["Consumables"],
				openWithAll = true,
				sections =
				{
					{ name = L["Food & Drink"], cats = {L["Food & Drink"]}},
					{ name = L["First Aid"], cats = {L["FirstAid"]}},
					{ name = L["Potions"], cats = {L["Potions"]}},
					{ name = L["Flasks & Elixirs"], cats = {L["Flasks & Elixirs"]}},
					{ name = L["Scrolls"], cats = {L["Scrolls"]}},
					{ name = L["Item Enhancements"], cats = {L["Item Enhancements"]}},
					{ name = L["Misc"], cats = { L["Misc Consumables"] }},
				}
			},
			{
				name = L["Trade Goods"],
				openWithAll = true,
				sections =
				{
					{ name=L["Elemental"], cats={ L["Elemental"] } },
					{ name=L["Cloth"], cats={ L["Cloth"] } },
					{ name=L["Leather"], cats={ L["Leather"] } },
					{ name=L["Metal & Stone"], cats={ L["Metal & Stone"] } },
					{ name=L["Cooking"], cats={ L["Cooking"] } },
					{ name=L["Herb"], cats={ L["Herb"] } },
					{ name=L["Enchanting"], cats={ L["Enchanting"] } },
					{ name=L["Jewelcrafting"], cats={ L["Jewelcrafting"] } },
					{ name=L["Engineering"], cats={ L["Engineering"] } },
					{ name=L["Misc Trade Goods"], cats={ L["Misc Trade Goods"] } },
					{ name=L["Item Enchantment"], cats={ L["Item Enchantment"] } },
					{ name=L["Recipes"], cats={ L["Recipes"] } },
				}
			},
			{
				name = L["Professions"],
				openWithAll = true,
				sections = {
					{ name=L["Fishing"], cats={ L["Fishing"] } },
					{ name=L["Tools"], cats={ L["Tools"] } },
				}
			},
			{
				name = L["Bank Equipment"],
				openWithAll = true,
				isBank = true,
				sections =
				{
					{ name=L["Armor"], cats={ L["Armor"] } },
					{ name=L["Weapons"], cats={ L["Weapons"] } }
				}
			},
			{
				name = L["Bank Quest"],
				openWithAll = true,
				isBank = true,
				sections =
				{
					{ name=L["Quest Items"], cats = { L["Quest"] } }
				}
			},
			{
				name = L["Bank Consumables"],
				openWithAll = true,
				isBank = true,
				sections =
				{
					{ name = L["Food & Drink"], cats = {L["Food & Drink"]}},
					{ name = L["First Aid"], cats = {L["FirstAid"]}},
					{ name = L["Potions"], cats = {L["Potions"]}},
					{ name = L["Flasks & Elixirs"], cats = {L["Flasks & Elixirs"]}},
					{ name = L["Scrolls"], cats = {L["Scrolls"]}},
					{ name = L["Item Enhancements"], cats = {L["Item Enhancements"]}},
					{ name = L["Misc"], cats = { L["Misc Consumables"] }},
				}
			},
			{
				name = L["Bank Trade Goods"],
				openWithAll = true,
				isBank = true,
				sections =
				{
					{ name=L["Elemental"], cats={ L["Elemental"] } },
					{ name=L["Cloth"], cats={ L["Cloth"] } },
					{ name=L["Leather"], cats={ L["Leather"] } },
					{ name=L["Metal & Stone"], cats={ L["Metal & Stone"] } },
					{ name=L["Cooking"], cats={ L["Cooking"] } },
					{ name=L["Herb"], cats={ L["Herb"] } },
					{ name=L["Enchanting"], cats={ L["Enchanting"] } },
					{ name=L["Jewelcrafting"], cats={ L["Jewelcrafting"] } },
					{ name=L["Engineering"], cats={ L["Engineering"] } },
					{ name=L["Misc Trade Goods"], cats={ L["Misc Trade Goods"] } },
					{ name=L["Item Enchantment"], cats={ L["Item Enchantment"] } },
					{ name=L["Recipes"], cats={ L["Recipes"] } },
				}
			},
			{
				name = L["Bank Other"],
				openWithAll = true,
				isBank = true,
				sections =
				{
					{ name=L["Other"], cats = { L["Other"] } },
					{ name=L["Trash"], cats = { L["Trash"], L["TrashEquip"] } },
					{ name=L["Empty"], cats = { L["Empty"] } }
				}
			},
		}
	}
}

local templateChoices = {}
for k in pairs(templates) do
	templateChoices[k] = k
end

local dbDefaults = {
	profile = {
		showsectiontitle = true,
		hideemptysections = true,
		hideemptybags = false,
		hidedefaultbank = false,
		overridedefaultbags = true,
		overridebackpack = true,
		autoreagent = true,
		compressempty = true,
		compressstackable = true,
		sortnewfirst = true,
		compressall = false,
		shrinkwidth = true,
		shrinkbagtitle = false,
		showspecialcount = true,
		showempty = true,
		showused = false,
		showtotal = true,
		combinecounts = false,
		highlightnew = true,
		hideduplicates = 'disabled',
		section_layout = 'default',
		skin = 'blizzard',
		scale = 1,
		rightoffset = 50,
		topoffset = 50,
		bottomoffset = 50,
		leftoffset = 50,
		layoutanchor = "BOTTOMRIGHT",
		highlightquestitems = true,
		qualitycolorintensity = 0.3,
		qualitycolor = true,
		qualitycolormin = 2,
		columns = 5,
		sort = "ilvl",
		layout = "auto",
		bags = { },
		categories = {},
		moneybag = 1,
		bankcontrolbag = 11, -- "Bank Other"
		disablebagmenu = false,
		openatauction = true,
		minimap = {
			hide = false,
		}
	},
	global = {
		pt3mods = {},
		template = "default",
	}
}

local catsorttable = {}

local function dbl(tab)
	for i=#tab,1,-1 do
		local v = tab[i]
		if v then
			tab[v] = v
		end
		tab[i]=nil
	end
	return tab
end

local function refresh()
	Baggins:ForceFullRefresh()
	Baggins:UpdateBags()
end

local function compressDisabled()
	return Baggins.db.profile.sort == "slot"
end

local function getCompressAll()
	return Baggins.db.profile.compressall
end

function Baggins:RebuildOptions()
	local p = self.db.profile
	if not self.opts then
		self.opts = {
			icon = "Interface\\Icons\\INV_Jewelry_Ring_03",
			type = 'group',
			handler = self,
			args = {},
		}
	else
		wipe(self.opts.args)
	end
	self.opts.args = {
		Refresh = {
			name = L["Force Full Refresh"],
			type = "execute",
			order = 3,
			desc = L["Forces a Full Refresh of item sorting"],
			func = refresh,
		},
		BagCatEdit = {
			name = L["Bag/Category Config"],
			type = "execute",
			order = 2,
			desc = L["Opens the Waterfall Config window"],
			func = "OpenEditConfig",
		},
		Items = {
			name = L["Items"],
			type = 'group',
			order = 120,
			desc = L["Item display settings"],
			args = {
				Compress = {
					name = L["Compress"],
					desc = L["Compress Multiple stacks into one item button"],
					type = "group",
					order = 10,
					disabled = compressDisabled,
					args = {
						compressall = {
							name = L["Compress All"],
							type = "toggle",
							desc = L["Show all items as a single button with a count on it"],
							order = 10,
							get = getCompressAll,
							set = function(info, value)
								p.compressall = value
								self:RebuildSectionLayouts()
								self:UpdateBags()
							end,
						},
						CompressStackable = {
							name = L["Compress Stackable Items"],
							type = "toggle",
							desc = L["Show stackable items as a single button with a count on it"],
							order = 20,
							disabled = getCompressAll,
							get = function() return p.compressstackable or p.compressall end,
							set = function(info, value)
								p.compressstackable = value
								self:RebuildSectionLayouts()
								self:UpdateBags()
							end,
						},
						CompressEmptySlots = {
							name = L["Compress Empty Slots"],
							type = "toggle",
							desc = L["Show all empty slots as a single button with a count on it"],
							order = 100,
							disabled = getCompressAll,
							get = function() return p.compressempty or p.compressall end,
							set = function(info, value)
								p.compressempty = value
								self:RebuildSectionLayouts()
								self:UpdateBags()
							end,
						},
					}
				},
				QualityColor = {
					name = L["Quality Colors"],
					desc = L["Color item buttons based on the quality of the item"],
					type = "group",
					order = 15,
					args = {
						Enable = {
							name = L["Enable"],
							type = "toggle",
							desc = L["Enable quality coloring"],
							order = 10,
							get = function() return p.qualitycolor end,
							set = function(info, value)
								p.qualitycolor = value
								self:UpdateItemButtons()
							end,
						},
						Threshold = {
							name = L["Color Threshold"],
							type = 'select',
							desc = L["Only color items of this quality or above"],
							order = 15,

							get = function() return ("%d"):format(p.qualitycolormin) end,
							set = function(info, value)
								p.qualitycolormin = tonumber(value)
								self:UpdateItemButtons()
							end,
							disabled = function() return not p.qualitycolor end,
							values = {
								["0"] = ('|c%s%s'):format(select(4,GetItemQualityColor(0)), ITEM_QUALITY0_DESC),
								["1"] = ('|c%s%s'):format(select(4,GetItemQualityColor(1)), ITEM_QUALITY1_DESC),
								["2"] = ('|c%s%s'):format(select(4,GetItemQualityColor(2)), ITEM_QUALITY2_DESC),
								["3"] = ('|c%s%s'):format(select(4,GetItemQualityColor(3)), ITEM_QUALITY3_DESC),
								["4"] = ('|c%s%s'):format(select(4,GetItemQualityColor(4)), ITEM_QUALITY4_DESC),
								["5"] = ('|c%s%s'):format(select(4,GetItemQualityColor(5)), ITEM_QUALITY5_DESC),
								["6"] = ('|c%s%s'):format(select(4,GetItemQualityColor(6)), ITEM_QUALITY6_DESC),
							}
						},
						Intensity = {
							name = L["Color Intensity"],
							type = "range",
							desc = L["Intensity of the quality coloring"],
							order = 20,
							max = 1,
							min = 0.1,
							step = 0.1,
							get = function() return p.qualitycolorintensity end,
							set = function(info, value)
								p.qualitycolorintensity = value
								self:UpdateItemButtons()
							end,
							disabled = function() return not p.qualitycolor end,
						},
					}
				},
				QuestItems = {
					name = L["Highlight quest items"],
					type = "toggle",
					desc = L["Displays a special border around quest items and a exclamation mark over items that starts new quests."],
					order = 17,
					get = function() return p.highlightquestitems end,
					set = function(info, value)
						p.highlightquestitems = value
						self:UpdateItemButtons()
					end,
				},
				HideDuplicates = {
					name = L["Hide Duplicate Items"],
					type = 'select',
					desc = L["Prevents items from appearing in more than one section/bag."],
					order = 20,
					get = function() return p.hideduplicates end,
					set = function(info, value)
						p.hideduplicates = value
						self:ResortSections()
						self:UpdateBags()
					end,
					values = dbl({ 'global', 'bag', 'disabled' }),
				},
				AlwaysReSort = {
					name = L["Always Resort"],
					type = "toggle",
					desc = L["Keeps Items sorted always, this will cause items to jump around when selling etc."],
					order = 22,
					get = function() return p.alwaysresort end,
					set = function(info, value)
						p.alwaysresort = value
					end
				},
				HighlightNew = {
					name = L["Highlight New Items"],
					type = "toggle",
					desc = L["Add *New* to new items, *+++* to items that you have gained more of."],
					order = 30,
					get = function() return p.highlightnew end,
					set = function(info, value)
						p.highlightnew = value
						self:UpdateItemButtons()
					end
				},
				ResetNew = {
					name = L["Reset New Items"],
					type = "execute",
					desc = L["Resets the new items highlights."],
					order = 35,
					func = function()
						self:SaveItemCounts()
						self:ForceFullUpdate()
					end,
					disabled = function() return not p.highlightnew end,
				},
			}
		},
		General = {
			name = L["General"],
			type = 'group',
			order = 1,
			desc = L["Display and Overrides"],
			args = {
				Display = {
					type = 'header',
					order = 1,
					name = L["Display"],
				},
				minimap = {
					name = L["Minimap icon"],
					type = 'toggle',
					order = 100,
					desc = L["Show an icon at the minimap if no Broker-Display is present."],
					get = function() return not Baggins.db.profile.minimap.hide end,
					set = function(info, value)
							Baggins.db.profile.minimap.hide = not value
							if value then
								dbIcon:Show("Baggins")
							else
								dbIcon:Hide("Baggins")
							end
						end
				},
				Skin = {
					name = L["Bag Skin"],
					type = 'select',
					desc = L["Select bag skin"],
					order = 300,
					get = function() return p.skin end,
					set = function(info, value)
							Baggins:ApplySkin(value)
						end,
					values = function() return dbl(CopyTable(self:GetSkinList())) end,
				},
				HideDefaultBank = {
					name = L["Hide Default Bank"],
					type = "toggle",
					desc = L["Hide the default bank window."],
					order = 200,
					get = function() return p.hidedefaultbank end,
					set = function(info, value) p.hidedefaultbank = value end,
				},
				Overrides = {
					type = 'header',
					order = 500,
					name = L["Overrides"],
				},
				OverrideBags = {
					name = L["Override Default Bags"],
					type = "toggle",
					desc = L["Baggins will open instead of the default bags"],
					order = 600,
					get = function() return p.overridedefaultbags end,
					set = function(info, value) p.overridedefaultbags = value self:UpdateBagHooks() end,
				},
				OverrideBackpack = {
					name = L["Override Backpack Button"],
					type = "toggle",
					desc = L["Baggins will open when clicking the backpack. Holding alt will open the default backpack."],
					order = 700,
					get = function() return p.overridebackpack end,
					set = function(info, value) p.overridebackpack = value self:UpdateBackpackHook() end,
				},
				AutomaticReagentHandling = {
					name = L["Reagent Deposit"],
					type = "toggle",
					desc = L["Automatically deposits crafting reagents into the reagent bank if available."],
					order = 800,
					get = function() return p.autoreagent end,
					set = function(info, value) p.autoreagent = value end,
				},
			}
		},
		Layout = {
			name = L["Layout"],
			type = 'group',
			order = 125,
			desc = L["Appearance and layout"],
			args = {
				Bags = {
					type = 'header',
					order = 5,
					name = L["Bags"],
				},
				Type = {
					name = L["Layout Type"],
					type = 'select',
					order = 10,
					desc = L["Sets how all bags are laid out on screen."],
					get = function() return p.layout end,
					set = function(info, value) p.layout = value self:UpdateLayout() end,
					values = dbl({ "auto", "manual" }),
				},
				LayoutAnchor = {
					name = L["Layout Anchor"],
					type = 'select',
					order = 15,
					desc = L["Sets which corner of the layout bounds the bags will be anchored to."],
					get = function() return p.layoutanchor end,
					set = function(info, value) p.layoutanchor =  value self:LayoutBagFrames() end,
					values = { TOPRIGHT = L["Top Right"],
								TOPLEFT = L["Top Left"],
								BOTTOMRIGHT = L["Bottom Right"],
								BOTTOMLEFT = L["Bottom Left"] },
					disabled = function() return p.layout ~= 'auto' end,
				},
				SetLayoutBounds = {
					name = L["Set Layout Bounds"],
					type = "execute",
					order = 20,
					desc = L["Shows a frame you can drag and size to set where the bags will be placed when Layout is automatic"],
					func = function() self:ShowPlacementFrame() end,
					disabled = function() return p.layout ~= 'auto' end,
				},
				Lock = {
					name = L["Lock"],
					type = "toggle",
					desc = L["Locks the bag frames making them unmovable"],
					order = 30,
					get = function() return p.lock or p.layout == "auto" end,
					set = function(info, value) p.lock = value end,
					disabled = function() return p.layout == "auto" end,
				},
				OpenAtAuction = {
					name = L["Automatically open at auction house"],
					type = "toggle",
					desc = L["Automatically open at auction house"],
					order = 35,
					get = function() return p.openatauction end,
					set = function(info, value) p.openatauction = value end,
				},
				ShrinkWidth = {
					name = L["Shrink Width"],
					type = "toggle",
					desc = L["Shrink the bag's width to fit the items contained in them"],
					order = 40,
					get = function() return p.shrinkwidth end,
					set = function(info, value)
						p.shrinkwidth = value
						self:UpdateBags()
					end,
				},
				ShrinkTitle = {
					name = L["Shrink bag title"],
					type = "toggle",
					desc = L["Mangle bag title to fit to content width"],
					order = 50,
					get = function() return p.shrinkbagtitle end,
					set = function(info, value)
						p.shrinkbagtitle = value
						self:UpdateBags()
					end,
				},
				Scale = {
					name = L["Scale"],
					type = "range",
					desc = L["Scale of the bag frames"],
					order = 60,
					max = 2,
					min = 0.3,
					step = 0.1,
					get = function() return p.scale end,
					set = function(info, value)
						p.scale = value
						self:UpdateBagScale()
						self:UpdateLayout()
					end,
				},
				ShowMoney = {
					name = L["Show Money On Bag"],
					type = 'select',
					desc = L["Which Bag to Show Money On"],
					order = 63,
					arg = true,
					get = function() return p.moneybag < 0 and "None" or tostring(p.moneybag) end,
					set = function(info, value) p.moneybag = tonumber(value) or -1 self:UpdateBags() end,
					values = "GetMoneyBagChoices",
				},
				ShowBankControls = {
					name = L["Show Bank Controls On Bag"],
					type = 'select',
					desc = L["Which Bag to Show Bank Controls On"],
					order = 64,
					arg = true,
					get = function() return p.bankcontrolbag < 0 and "None" or tostring(p.bankcontrolbag) end,
					set = function(info, value) p.bankcontrolbag = tonumber(value) or -1 self:UpdateBags() end,
					values = "GetBankControlsBagChoices",
				},
				DisableBagRightClick = {
					name = L["Disable Bag Menu"],
					type = "toggle",
					desc = L["Disables the menu that pops up when right clicking on bags."],
					order = 65,
					get = function() return p.disablebagmenu end,
					set = function(info, value)
						p.disablebagmenu = value
					end,
				},
				Sections = {
					type = 'header',
					order = 69,
					name = L["Sections"],
				},
				SectionLayout = { -- TODO: Select for layout type?
					name = L["Layout Type"],
					type = "select",
					desc = '',
					order = 70,
					get = function() return p.section_layout end,
					set = function(info, value)
						p.section_layout = value
						self:UpdateBags()
					end,
					values = {
						default = "Default", -- TODO: Localize
						optimize = L["Optimize Section Layout"],
						flow = "Flow sections", -- TODO: Localize
					}
				},
				SectionTitle = {
					name = L["Show Section Title"],
					type = "toggle",
					desc = L["Show a title on each section of the bags"],
					order = 80,
					get = function() return p.showsectiontitle end,
					set = function(info, value)
						p.showsectiontitle = value
						self:UpdateBags()
					end
				},
				HideEmptySections = {
					name = L["Hide Empty Sections"],
					type = "toggle",
					desc = L["Hide sections that have no items in them."],
					order = 90,
					get = function() return p.hideemptysections end,
					set = function(info, value)
						p.hideemptysections = value
						self:UpdateBags()
					end
				},
				HideEmptyBags = {
					name = L["Hide Empty Bags"],
					type = "toggle",
					desc = L["Hide bags that have no items in them."],
					order = 90,
					get = function() return p.hideemptybags end,
					set = function(info, value)
						p.hideemptybags = value
						self:UpdateBags()
					end
				},
				Sort = {
					name = L["Sort"],
					type = 'select',
					desc = L["How items are sorted"],
					order = 100,
					get = function() return p.sort end,
					set = function(info, value) p.sort = value self:UpdateBags() end,
					values = dbl({'quality', 'name', 'type', 'slot', 'ilvl' }),
				},
				SortNewFirst = {
					name = L["Sort New First"],
					type = "toggle",
					desc = L["Sorts New Items to the beginning of sections"],
					order = 105,
					get = function() return p.sortnewfirst end,
					set = function(info, value) p.sortnewfirst = value end,
				},
				Columns = {
					name = L["Columns"],
					type = "range",
					desc = L["Number of Columns shown in the bag frames"],
					order = 110,
					get = function() return p.columns end,
					set = function(info, value) p.columns = value self:UpdateBags() end,
					min = 2,
					max = 20,
					step = 1,
				},
			}
		},
		FubarText = {
			name = L["FuBar Text"],
			type = "group",
			desc = L["Options for the text shown on fubar"],
			order = 130,
			args = {
				ShowEmpty = {
					name = L["Show empty bag slots"],
					type = "toggle",
					order = 10,
					desc = L["Show empty bag slots"],
					get = function() return p.showempty end,
					set = function(info, value)
						p.showempty = value
						self:UpdateText()
					end,
				},
				ShowUsed = {
					name = L["Show used bag slots"],
					type = "toggle",
					order = 20,
					desc = L["Show used bag slots"],
					get = function() return p.showused end,
					set = function(info, value)
						p.showused = value
						self:UpdateText()
					end,
				},
				ShowTotal = {
					name = L["Show Total bag slots"],
					type = "toggle",
					order = 30,
					desc = L["Show Total bag slots"],
					get = function() return p.showtotal end,
					set = function(info, value)
						p.showtotal = value
						self:UpdateText()
					end,
				},
				ShowSpecialty = {
					name = L["Show Specialty Bags Count"],
					type = "toggle",
					order = 60,
					desc = L["Show Specialty (profession etc) Bags Count"],
					get = function() return p.showspecialcount end,
					set = function(info, value)
						p.showspecialcount = value
						self:UpdateText()
					end,
				},
				Combine = {
					name = L["Combine Counts"],
					type = "toggle",
					order = 99,
					desc = L["Show only one count with all the seclected types included"],
					get = function() return p.combinecounts end,
					set = function(info, value)
						p.combinecounts = value
						self:UpdateText()
					end,
				},
			},
		},
	}

	self.opts.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.opts.args.presets = {
		type = 'group',
		name = L["Presets"],
		desc = "",
		args = {
			message1 = {
				order = 1,
				type = "description",
				name = L["You can use the preset defaults as a starting point for setting up your interface."]
			},
			message2 = {
				order = 2,
				type = "description",
				name = L["|cffff0000WARNING|cffffffff: Pressing the button will reset your complete profile! If you're not sure about this, create a new profile and use that to experiment."],
			},
			template = {
				type = 'select',
				name = L["Presets"],
				desc = "",
				get = function() return Baggins.db.global.template end,
				set = function(info, value) Baggins.db.global.template = value end,
				values = templateChoices,
				order = 5,
			},
			empty = {
				type = 'description',
				name = "",
			},
			reset = {
				type = 'execute',
				name = L["Reset Profile"],
				desc = "",
				func = function() Baggins.db:ResetProfile() end,
			},
		},
	}
end

local oldskin
function Baggins:InitOptions()
	self.db = LibStub("AceDB-3.0"):New("BagginsDB", dbDefaults, "Default")
	self:UpdateDB()
	self:RebuildOptions()

	self.db.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	self.db.RegisterCallback(self, "OnNewProfile", "ChangeProfile")

	AceConfig:RegisterOptionsTable("Baggins", self.opts)
	AceConfigDialog:AddToBlizOptions("Baggins", "Baggins")
	oldskin = self.db.profile.skin
end

function Baggins:ChangeProfile()
	self:OnProfileEnable()
	self:UpdateDB()
	self:ResetCatInUse()
	self:RebuildOptions()
	self:RebuildBagOptions()
	self:RebuildCategoryOptions()
	self:SetCategoryTable(self.db.profile.categories)
	if oldskin then
		self:DisableSkin(oldskin)
		self:EnableSkin(self.db.profile.skin)
	end
	oldskin = self.db.profile.skin
	self:ForceFullRefresh()
	self:UpdateText()
	self:UpdateBagScale()
	self:UpdateLayout()
	self:UnhookBagHooks()
	self:UpdateBagHooks()
	self:UpdateBackpackHook()
end

function Baggins:OpenConfig()
	AceConfigDialog:Open("Baggins")
end

function Baggins:OpenEditConfig()
	AceConfigDialog:Open("BagginsEdit")
end

Baggins.defaultcategories = {
	[L["Misc Consumables"]] = {
		name=L["Misc Consumables"],
		{
			type="ItemType" ,
			itype = "Consumable",
			isubtype = "Other",
		},
		{
			type="ItemType" ,
			itype = "Consumable",
			isubtype = "Consumable",
		},
	},
	[L["Consumables"]] = {
		name=L["Consumables"],
		{
			type="ItemType",
			itype = "Consumable"
		}
	},
	[L["Armor"]] = {
		name=L["Armor"],
		{
			type="ItemType",
			itype="Armor"
		},
		{
			type="ItemType",
			itype="Armor",
			isubtype="Shields",
			operation="NOT"
		},
	},
	[L["Weapons"]] = {
		name=L["Weapons"],
		{
			type="ItemType",
			itype="Weapon"
		},
		{
			type="ItemType",
			itype="Armor",
			isubtype="Shields"
		},
		{
			type="ItemType",
			itype="Weapon",
			isubtype="Miscellaneous",
			operation="NOT"
		},
	},
	[L["Quest"]] = { name=L["Quest"], { type="ItemType", itype="Quest" }, { type="Tooltip", text="ITEM_BIND_QUEST" } },
	[L["Trash"]] = { name=L["Trash"], { type="Quality", quality = 0, comp = "<=" } },
	[L["TrashEquip"]] = {
		name=L["TrashEquip"],
		{
			type="ItemType",
			itype="Armor"
		},
		{
			type="ItemType",
			itype="Weapon",
			operation="OR"
		},
		{
			type="Quality",
			quality = 1,
			comp = "<=",
			operation="AND"
		},
		{
			type="PTSet",
			setname="Tradeskill.Tool",
			operation="NOT"
		},
		{
			type="ItemType",
			itype="Quest",
			operation="NOT" },
		},
	[L["Other"]] = { name=L["Other"], { type="Other" } },
	[L["Empty"]] = { name=L["Empty"], { type="Empty" }, },
	[L["Bags"]] = { name=L["Bags"], { type="Bag", bagid=1 }, { type="Bag", bagid=2, operation="OR" }, { type="Bag", bagid=3, operation="OR" }, { type="Bag", bagid=4, operation="OR" }, { type="Bag", bagid=0, operation="OR" }, },
	[L["BankBags"]] = { name=L["BankBags"], { type="Bag", bagid=-1 }, { type="Bag", bagid=5, operation="OR" }, { type="Bag", bagid=6, operation="OR" }, { type="Bag", bagid=7, operation="OR" }, { type="Bag", bagid=8, operation="OR" }, { type="Bag", bagid=9, operation="OR" }, { type="Bag", bagid=10, operation="OR" }, { type="Bag", bagid=11, operation="OR" }, },
	[L["Potions"]] = {
		name=L["Potions"],
		{
			type="ItemType",
			itype = "Consumable",
			isubtype = "Potion",
		},
	},
	[L["Flasks & Elixirs"]] = {
		name=L["Flasks & Elixirs"],
		{
			type="ItemType",
			itype = "Consumable",
			isubtype = "Flask",
		},
		{
			operation = "OR",
			type="ItemType",
			itype = "Consumable",
			isubtype = "Elixir",
		},
	},
	[L["Food & Drink"]] = {
		name=L["Food & Drink"],
		{
			type="ItemType",
			itype = "Consumable",
			isubtype = "Food & Drink",
		},
	},
	[L["Scrolls"]] = {
		name=L["Scrolls"],
		{
			type="ItemType",
			itype = "Consumable",
			isubtype = "Scroll",
		},
	},
	[L["FirstAid"]] = {
		name=L["FirstAid"],
		{
			type="ItemType",
			itype = "Consumable",
			isubtype = "Bandage",
		},
	},
	[L["Item Enhancements"]] = {
		name=L["Item Enhancements"],
		{
			type="ItemType",
			itype = "Consumable",
			isubtype = "Item Enhancement",
		},
	},
	[L["Tradeskill Mats"]] = {
		name=L["Tradeskill Mats"],
		{
			type="ItemType",
			itype = "Trade Goods",
		},
	},
	[L["Elemental"]] = {
		name=L["Elemental"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Elemental",
		},
	},
	[L["Cloth"]] = {
		name=L["Cloth"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Cloth",
		},
	},
	[L["Leather"]] = {
		name=L["Leather"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Leather",
		},
	},
	[L["Metal & Stone"]] = {
		name=L["Metal & Stone"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Metal & Stone",
		},
	},
	[L["Cooking"]] = {
		name=L["Cooking"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Cooking",
		},
	},
	[L["Herb"]] = {
		name=L["Herb"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Herb",
		},
	},
	[L["Enchanting"]] = {
		name=L["Enchanting"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Enchanting",
		},
	},
	[L["Jewelcrafting"]] = {
		name=L["Jewelcrafting"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Jewelcrafting",
		},
	},
	[L["Engineering"]] = {
		name=L["Parts"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Parts",
		},
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Devices",
			operation = "OR",
		},
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Devices",
			operation = "OR",
		},
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Explosives",
			operation = "OR",
		},
	},
	[L["Misc Trade Goods"]] = {
		name=L["Other"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Other",
		},
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Materials",
		},
	},
	[L["Item Enchantment"]] = {
		name=L["Item Enchantment"],
		{
			type = "ItemType",
			itype = "Trade Goods",
			isubtype = "Item Enchantment",
		},
	},
	[L["Recipes"]] = {
		name=L["Recipes"],
		{
			type="ItemType",
			itype = "Recipe",
		},
	},
	[L["Tools"]] = {
		name=L["Tools"],
		{
			setname="Tradeskill.Tool",
			type="PTSet"
		},
		{
			operation="NOT",
			type="PTSet",
			setname="Tradeskill.Tool.Fishing"
		},
	},
	[L["Fishing"]] = {
		name=L["Fishing"],
		{
			setname="Tradeskill.Tool.Fishing",
			type="PTSet"
		},
	},
	[L["In Use"]] = {
		name=L["In Use"],
		{
			anyset=true,
			type="EquipmentSet"
		},
	},
	[L["New"]] = { { ["name"] = L["New"], ["type"] = "NewItems" }, },
}


--deep copy of a table, will NOT handle tables as keys or circular references
local function deepCopy(to, from)
	for k in pairs(to) do
		to[k] = nil
	end

	for k, v in pairs(from) do
		if type(v) == "table" then
			to[k] = {}
			deepCopy(to[k], from[k])
		else
			to[k] = from[k]
		end
	end
end

local wipe=wipe
local function new() return {} end
local function del(t) wipe(t) end
local rdel = del


---------------------
-- Dynamic Options --
---------------------
local moneyBagChoices = {}
function Baggins:GetMoneyBagChoices()
	if not next(moneyBagChoices) then
		moneyBagChoices.None = L["None"]
		for i, v in ipairs(Baggins.db.profile.bags) do
			local name = v.name
			if name=="" then name="(unnamed)" end
			moneyBagChoices[tostring(i)] = name
		end
	end
	return moneyBagChoices
end

function Baggins:BuildMoneyBagOptions()
	wipe(moneyBagChoices)
end

local bankControlBagChoices = {}
function Baggins:GetBankControlsBagChoices()
	if not next(bankControlBagChoices) then
		bankControlBagChoices.None = L["None"]
		for i, v in ipairs(Baggins.db.profile.bags) do
			if v.isBank then
				local name = v.name
				if name=="" then name="(unnamed)" end
				bankControlBagChoices[tostring(i)] = name
			end
		end
	end
	return bankControlBagChoices
end

function Baggins:BuildBankControlsBagOptions()
	wipe(bankControlBagChoices)
end

------------------------
-- Profile Management --
------------------------

function Baggins:ApplyProfile(profile)
	local p = self.db.profile
	self:CloseAllBags()
	for k, v in pairs(profile) do
		if type(v) == "table" then
			if not p[k] then
				p[k] = {}
			end
			deepCopy(p[k],v)
		else
			p[k] = v
		end
	end
	for k, v in pairs(self.defaultcategories) do
		if not p.categories[k] then
			p.categories[k] = {}
		end
		deepCopy(p.categories[k], v)
	end
	self:ResortSections()
	self:ResetCatInUse()
	self:CreateAllBags()
	self:OpenAllBags()
	self:ForceFullRefresh()
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
end

function Baggins:UpdateDB()
	local p = self.db.profile
	for k, rules in pairs(p.categories) do
		local i = 1
		while(i < #rules + 1) do
			local rule = rules[i]
			if not rule then break end
			-- remove item-types that have been removed from the game
			if (rule.type == "ContainerType" and (rule.ctype == "Soul Bag" or rule.ctype == "Ammo Bag"))
					or (rule.type == "ItemType" and (rule.isubtype == "Librams" or rule.isubtype == "Idols" or rule.isubtype == "Totems")) then
				table.remove(rules, i)
				i = i - 1
			end
			i = i + 1
		end
	end
end

function Baggins:OnProfileEnable()
	local p = self.db.profile
	--check if this profile has been setup before, if not add the default bags and categories
	--cant leave these in the defaults since removing a bag would have it come back on reload
	local refresh = false
	if not next(p.categories) then
		deepCopy(p.categories, self.defaultcategories)
		refresh = true
	end
	if #p.bags == 0 then
		local templateName = self.db.global.template
		local template = templates[templateName]
		deepCopy(p.bags, template.bags)
		refresh = true
	end

	if refresh then
		self:ChangeProfile()
	end

	self:CreateAllBags()
	self:SetCategoryTable(self.db.profile.categories)
	self:ResortSections()
	self:ForceFullRefresh()
	self:UpdateBags()
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
end

----------------------
-- Bag Context Menu --
----------------------
local bagDropdownMenuFrame = CreateFrame("Frame", "Baggins_BagMenuFrame", UIParent, "UIDropDownMenuTemplate")
local menu = {}
local function resetNewItems()
	Baggins:SaveItemCounts()
	Baggins:ForceFullUpdate()
end

local function disableCompressionTemp()
	Baggins.tempcompressnone = not Baggins.tempcompressnone
	Baggins:RebuildSectionLayouts()
	Baggins:UpdateBags()
end

local function openBagCategoryConfig()
	Baggins:OpenEditConfig()
end

local function openBagginsConfig()
	Baggins:OpenConfig()
end

function Baggins:DoBagMenu(bagframe)
	local p = self.db.profile
	wipe(menu)
	
	if not p.disablebagmenu then
		if p.highlightnew then
			tinsert(menu, {
				text = L["Reset New Items"],
				tooltipTitle = L["Reset New Items"],
				tooltipText = L["Resets the new items highlights."],
				func = resetNewItems,
				notCheckable = true,
			})
		end

		if p.compressall or p.compressstackable or p.compressempty then
			tinsert(menu, {
				text = L["Disable Compression Temporarily"],
				tooltipText = L["Disabled Item Compression until the bags are closed."],
				func = disableCompressionTemp,
				checked = Baggins.tempcompressnone,
				keepShownOnClick = true,
			})
		end

		tinsert(menu, {
			text = L["Config Window"],
			tooltipText = L["Opens the Waterfall Config window"],
			func = openBagginsConfig,
			notCheckable = true,
		})

		tinsert(menu, {
			text = L["Bag/Category Config"],
			tooltipText = L["Edit the Bag Definitions"],
			func = openBagCategoryConfig,
			notCheckable = true,
		})
		EasyMenu(menu, bagDropdownMenuFrame, "cursor", 0, 0, "MENU")
	end
end

--------------------
-- Edit Rule Menu --
--------------------
function Baggins:setRuleOperation(rule,operation)
	rule.operation = operation
	Baggins:OnRuleChanged()
end

function Baggins:setRuleType(rule,type)
	rule.type = type
	Baggins:CleanRule(rule)
	Baggins:OnRuleChanged()
end

local function newBag(info)
	Baggins:NewBag("New")
	Baggins:RebuildBagOptions()
end

local function getArgName(info)
	return info.arg.name
end

local function setArgName(info, value)
	info.arg.name = value
end

local function doBagUp(info)
	Baggins:MoveBag(info.arg)
	Baggins:RebuildBagOptions()
end

local function doBagDown(info)
	Baggins:MoveBag(info.arg, true)
	Baggins:RebuildBagOptions()
end

local function removeBag(info)
	Baggins:RemoveBag(info.arg)
	Baggins:RebuildBagOptions()
end

local function confirmRemoveBag()
	return L["Are you sure you want to delete this Bag? this cannot be undone"]
end

local function getBagPriority(info)
	return info.arg.priority or 1
end

local function setBagPriority(info, value)
	info.arg.priority = value
	Baggins:ResortSections()
	Baggins:UpdateBags()
end

local function getArgValue(info)
	return info.arg[info[#info]]
end

local function setArgValue(info, value)
	info.arg[info[#info]] = value
end

local function moveSection(info, down)
	local sectionid = tonumber(info[#info-1])
	local bagid = tonumber(info[#info-3])
	Baggins:MoveSection(bagid, sectionid, down)
	Baggins:RebuildSections(bagid)
end

local function moveSectionUp(info)
	moveSection(info)
end

local function moveSectionDown(info)
	moveSection(info, true)
end

local function removeSectionFromBag(info)
	local sectionid = tonumber(info[#info-1])
	local bagid = tonumber(info[#info-3])
	Baggins:RemoveSection(bagid, sectionid)
	Baggins:RebuildBagOptions()
end

local function confirmRemoveSection(info)
	return L["Are you sure you want to delete this Section? this cannot be undone"]
end

local function getBagPriority(info)
	return info.arg.priority or 1
end

local function setBagPriority(info, value)
	Baggins:ResortSections()
	Baggins:UpdateBags()
	info.arg.priority = value
end

local function setAllowdupes(info, value)
	info.arg.allowdupes = value
	Baggins:ResortSections()
	Baggins:ForceFullRefresh()
	Baggins:UpdateBags()
end

local tmp = {}
local function getCategoryChoices(info)
	local section = info.arg
	wipe(tmp)
	for k in pairs(Baggins.db.profile.categories) do
		tmp[k] = k
	end
	for _, v in pairs(section.cats) do
		tmp[v] = nil
	end
	return tmp
end

local function addCategoryToSection(info, value)
	local section = info.arg
	local bagid = tonumber(info[#info - 3])
	local sectionid = tonumber(info[#info - 2])
	Baggins:AddCategory(bagid, sectionid, value)
	Baggins:RebuildSections(bagid)
end

local function removeCategoryFromSection(info)
	local bagid = tonumber(info[#info - 4])
	local sectionid = tonumber(info[#info - 3])
	local catid = tonumber(info[#info - 1])
	Baggins:RemoveCategory(bagid,sectionid,catid)
	Baggins:RebuildSections(bagid)
end

local function newSection(info)
	local bagid = tonumber(info[#info-2])
	Baggins:NewSection(bagid, "New")
	Baggins:RebuildSections(bagid)
end

function Baggins:CopyBag(from_id, to_id)
	local bags = self.db.profile.bags

	for i, v in ipairs(bags[from_id].sections) do
		tinsert(bags[to_id].sections,v)
	end
	
	self:ChangeProfile()
end

local bags_list = { }
local function ListBags()
	wipe(bags_list)
	for id, bag in ipairs(Baggins.db.profile.bags) do
		bags_list[id] = bag.name
	end
	return bags_list
end

local function CopyBagFromEdit(info, value)
	Baggins:CopyBag(value, info.arg)
end

function Baggins:RebuildSections(bagid)
	local bag = self.db.profile.bags[bagid]
	local bagopts = self.editOpts.args.Bags.args[tostring(bagid)]
	local margs = wipe(bagopts.args.sectionList.args)
	for sectionid, section in ipairs(bag.sections) do
		margs[tostring(sectionid)] = {
			name = "",
			desc = "",
			inline = true,
			type = 'group',
			arg = section,
			order = sectionid,
			args = {
				name = {
					name = "",
					desc = "",
					type = 'input',
					get = getArgValue,
					set = setArgValue,
					arg = section,
					order = 1,
				},
				up = {
					name = "^",
					desc = "",
					type = 'execute',
					width = "half",
					func = moveSectionUp,
					order = 2,
				},
				down = {
					name = "v",
					desc = "",
					type = 'execute',
					width = "half",
					func = moveSectionDown,
					order = 3,
				},
				delete = {
					name = "X",
					desc = "",
					type = 'execute',
					width = 'half',
					func = removeSectionFromBag,
					confirm = confirmRemoveSection,
					order = 4,
				}
			},
		}

		bagopts.args[tostring(sectionid)] = {
			name = getArgName,
			desc = "",
			type = 'group',
			order = sectionid,
			arg = section,
			args = {
				name = {
					name = "",
					desc = "",
					type = 'input',
					get = getArgValue,
					set = setArgValue,
					arg = section,
				},
				priority = {
					name = L["Section Priority"],
					desc = "",
					type = 'range',
					min = 1,
					max = 20,
					step = 1,
					get = getBagPriority,
					set = setBagPriority,
					arg = section,
				},
				allowdupes = {
					name = L["Allow Duplicates"],
					desc = "",
					type = 'toggle',
					get = getArgValue,
					set = setAllowdupes,
					arg = section
				},
				categories = {
					name = L["Categories"],
					desc = "",
					type = 'group',
					order = -1,
					inline = true,
					args = {
						addnew = {
							name = "",
							desc = "",
							type = 'select',
							order = 1,
							arg = section,
							values = getCategoryChoices,
							get = noop,
							set = addCategoryToSection,
						}
					},
				},
			},
		}

		for k,v in ipairs(section.cats) do
			bagopts.args[tostring(sectionid)].args.categories.args[tostring(k)] = {
				name = "",
				desc = "",
				type = 'group',
				args = {
					name = {
						name = v,
						type = 'description',
						width = "half",
					},
					delete = {
						name = "X",
						desc = "",
						type = 'execute',
						width = "half",
						func = removeCategoryFromSection,
						arg = section
					},
				},
			}
		end
	end
	margs.newSection = {
		name = L["New Section"],
		desc = "",
		type = 'execute',
		func = newSection,
	}
end

function Baggins:RebuildBagOptions()
	local bags = Baggins.db.profile.bags
	local bargs = wipe(self.editOpts.args.Bags.args)
	bargs.NewBag = {
		type = 'execute',
		order = -1,
		name = L["New Bag"],
		desc = L["New Bag"],
		func = newBag,
	}
	for bagid, bag in ipairs(bags) do
		local bagconfig = {
			name = getArgName,
			desc = getArgName,
			type = 'group',
			order = bagid,
			arg = bag,
			args = {
				name = {
					name = L["Name"],
					desc = L["Name"],
					type = 'input',
					get = getArgName,
					set = setArgName,
					arg = bag,
					order = 1,
				},
				-- TODO copy from
				-- TODO import sections from
				priority = {
					name = L["Bag Priority"],
					desc = L["Bag Priority"],
					type = 'range',
					min = 1,
					max = 20,
					step = 1,
					get = getBagPriority,
					set = setBagPriority,
					arg = bag,
					order = 2,
				},
				isBank = {
					name = L["Bank"],
					desc = L["Bank"],
					type = 'toggle',
					get = getArgValue,
					set = setArgValue,
					arg = bag,
					order = 3,
				},
				openWithAll = {
					name = L["Open With All"],
					desc = L["Open With All"],
					type = 'toggle',
					get = getArgValue,
					set = setArgValue,
					arg = bag,
					order = 4,
				},
				sectionList = {
					type = 'group',
					name = L["Sections"],
					desc = "",
					inline = true,
					args = {},
					order = 5,
				},
				import = {
					name = L["Import Sections From"],
					desc = "",
					type = 'select',
					set = CopyBagFromEdit,
					values = ListBags,
					arg = bagid,
					order = 6,
				},
			},
		}

		bargs[tostring(bagid)] = bagconfig
		self:RebuildSections(bagid)

		bargs["baglistitem" .. bagid] = {
			type = 'group',
			inline = true,
			name = "",
			desc = "",
			order = bagid,
			args = {
				name = {
					name = "",
					desc = "",
					type = 'input',
					get = getArgName,
					set = setArgName,
					arg = bag,
					order = 1,
				},
				up = {
					name = "^",
					desc = "up",
					type = 'execute',
					width = "half",
					func = doBagUp,
					arg = bagid,
					order = 2,
				},
				down = {
					name = "v",
					desc = "down",
					type = 'execute',
					width = "half",
					func = doBagDown,
					arg = bagid,
					order = 3,
				},
				delete = {
					name = "X",
					desc = "delete",
					type = 'execute',
					width = "half",
					func = removeBag,
					arg = bagid,
					confirm = confirmRemoveBag,
					order = 4,
				},
			}
		}
	end
end

local notCompatibleDesc = {
	type = 'description',
	name = "The plugin providing this rule is out of date and not compatible with Baggins-2.0",
	order = -1,
}

local function setRuleType(info, value)
	wipe(info.arg)
	info.arg.type = value
	local categoryname = info[#info - 2]:sub(2)
	Baggins:RebuildCategoryRules(categoryname)
end

local function getRuleTypeChoices()
	return Baggins:GetRuleTypes()
end

local function moveRule(info, down)
	local categoryname = info[#info - 3]:sub(2)
	local ruleid = tonumber(info[#info - 2])
	Baggins:MoveRule(categoryname, ruleid, down)
	Baggins:RebuildCategoryRules(categoryname)
end

local function moveRuleUp(info)
	moveRule(info)
end

local function moveRuleDown(info)
	moveRule(info, true)
end

local function removeRule(info)
	local categoryname = info[#info - 3]:sub(2)
	local ruleid = tonumber(info[#info - 2])
	Baggins:RemoveRule(categoryname, ruleid, true)
	Baggins:RebuildCategoryRules(categoryname)
end

local operationChoices = {
	OR = "OR",
	AND = "AND",
	NOT = "NOT",
}

local function confirmRemoveRule()
	return L["Are You Sure?"]
end

local function getOperation(info)
	return info.arg.operation or "OR"
end

local function setRuleValue(info, value)
	setArgValue(info, value)
	Baggins:OnRuleChanged()
end

function Baggins:RebuildCategoryRules(categoryname)
	local category = self.db.profile.categories[categoryname]
	local args = self.editOpts.args.Categories.args["c" .. categoryname].args
	for k,v in pairs(args) do
		if k ~= "new" and k ~= "delete" then
			wipe(v)
			args[k] = nil
		end
	end
	for ruleid,rule in ipairs(category) do
		local ruleopt = {
			type = 'group',
			name = rule.type,
			desc = "",
			inline = true,
			order = ruleid + 10,
			get = getArgValue,
			set = setRuleValue,
			arg = rule,
			args = {
				type = {
					type = 'select',
					name = L["Type"],
					desc = "",
					set = setRuleType,
					values = getRuleTypeChoices,
					arg = rule,
					order = 2,
				},
				control = {
					name = "",
					desc = "",
					type = 'group',
					order = -1,
					inline = true,
					args = {
						up = {
							name = "^",
							desc = "",
							type = 'execute',
							width = "half",
							order = 2,
							func = moveRuleUp,
							disabled = ruleid == 1,
						},
						down = {
							name = "v",
							desc = "",
							type = 'execute',
							width = "half",
							order = 3,
							func = moveRuleDown,
							disabled = ruleid == #category,
						},
						delete = {
							name = "X",
							desc = "",
							type = 'execute',
							width = "half",
							order = 4,
							func = removeRule,
							confirm = confirmRemoveRule,
						},
					},
				}
			},
		}
		if ruleid > 1 then
			ruleopt.args.operation = {
				type = 'select',
				name = L["Operation"],
				desc = "",
				order = 1,
				values = operationChoices,
				get = getOperation,
				arg = rule,
			}
		end

		local addOpts = Baggins:GetAce3Opts(rule)
		if addOpts then
			for k,v in pairs(addOpts) do
				ruleopt.args[k] = CopyTable(v) -- 60KB memory here
				ruleopt.args[k].arg = rule
			end
		elseif Baggins:RuleIsDeprecated(rule) then
			ruleopt.args.message = notCompatibleDesc
		end

		args[tostring(ruleid)] = ruleopt
	end
end


local function removeCategory(info)
	Baggins:RemoveCategory(info.arg)
	Baggins:RebuildCategoryOptions()
end

local function confirmRemoveCategory(info)
	return L["Are you sure you want to remove this Category? this cannot be undone"]
end

local function isCategoryInUse(info)
	return Baggins:CategoryInUse(info.arg)
end

local function addNewRule(info, value)
	local name = info[#info - 1]:sub(2)
	tinsert(info.arg, { type = value })
	Baggins:RebuildCategoryRules(name)
end

function Baggins:RebuildCategoryOptions()
	local categories = Baggins.db.profile.categories
	local args = wipe(self.editOpts.args.Categories.args)
	args.new = {
		name = "Create",
		desc = "",
		type = 'input',
		get = noop,
		set = function(info, value)
				Baggins:NewCategory(value)
			end,
	}
	for name,category in pairs(categories) do
		args["c" .. name] = {
			name = name,
			desc = "",
			type = 'group',
			args = {
				delete = {
					name = L["Delete"],
					desc = "",
					type = 'execute',
					func = removeCategory,
					arg = name,
					confirm = confirmRemoveCategory,
					disabled = isCategoryInUse,
					order = 1,
				},
				new = {
					name = L["Add new Rule"],
					desc = "",
					type = 'select',
					get = noop,
					set = addNewRule,
					arg = category,
					values = getRuleTypeChoices,
					order = 2,
				}
			},
		}
		self:RebuildCategoryRules(name)
	end
end

function Baggins:InitBagCategoryOptions()
	local p = Baggins.db.profile
	local bags = p.bags
	local categories = p.categories
	local opts = {
		type = "group",
		icon = "Interface\\Icons\\INV_Jewelry_Ring_03",
		args = {
			Bags = {
				name = L["Bags"],
				desc = L["Bags"],
				type = "group",
				args = {},
				order = 1,
			},
			Categories = {
				name = L["Categories"],
				desc = L["Categories"],
				type = "group",
				args = {},
				order = 2,
			},
		},
	}
	self.editOpts = opts
	self:RebuildBagOptions(opts)
	self:BuildMoneyBagOptions()
	self:BuildBankControlsBagOptions()
	

	AceConfig:RegisterOptionsTable("BagginsEdit", function()
		Baggins:RebuildCategoryOptions()
		return opts
	end)
end