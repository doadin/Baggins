local Baggins = Baggins

local pairs, ipairs, tonumber, tostring, next, select, type, wipe, CopyTable =
      pairs, ipairs, tonumber, tostring, next, select, type, wipe, CopyTable

local tinsert, tremove =
      tinsert, tremove

local ITEM_QUALITY0_DESC, ITEM_QUALITY1_DESC, ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC, ITEM_QUALITY5_DESC, ITEM_QUALITY6_DESC =
ITEM_QUALITY0_DESC, ITEM_QUALITY1_DESC, ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC, ITEM_QUALITY5_DESC, ITEM_QUALITY6_DESC

local GetItemQualityColor = C_Item and C_Item.GetItemQualityColor or GetItemQualityColor

local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local dbIcon = LibStub("LibDBIcon-1.0")

local function noop()
end

local templates

if Baggins:IsRetailWow() then
    templates = {
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
                        { name=L["Equipment Set"], cats={ L["Equipment Set"] } },
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
                        { name=L["Inscription"], cats={ L["Inscription"] } },
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
                        { name=L["Inscription"], cats={ L["Inscription"] } },
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
end

if Baggins:IsCataWow() or Baggins:IsMistWow() then
    templates = {
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
                        { name=L["Equipment Set"], cats={ L["Equipment Set"] } },
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
                        { name=L["Metal & Stone"], cats={ L["Metal & Stone"] } },
                        { name=L["Cooking"], cats={ L["Cooking"] } },
                        { name=L["Herb"], cats={ L["Herb"] } },
                        { name=L["Enchanting"], cats={ L["Enchanting"] } },
                        { name=L["Jewelcrafting"], cats={ L["Jewelcrafting"] } },
                        { name=L["Engineering"], cats={ L["Engineering"] } },
                        { name=L["Inscription"], cats={ L["Inscription"] } },
                        { name=L["Item Enchantment"], cats={ L["Item Enchantment"] } },
                        { name=L["Recipes"], cats={ L["Recipes"] } },
                        { name = L["Tradeskill Mats"], cats = { L["Tradeskill Mats"] } },
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
                        { name=L["Inscription"], cats={ L["Inscription"] } },
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
    end

if Baggins:IsClassicWow() or Baggins:IsWrathWow() then
    templates = {
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
                        { name=L["Metal & Stone"], cats={ L["Metal & Stone"] } },
                        { name=L["Cooking"], cats={ L["Cooking"] } },
                        { name=L["Herb"], cats={ L["Herb"] } },
                        { name=L["Enchanting"], cats={ L["Enchanting"] } },
                        { name=L["Jewelcrafting"], cats={ L["Jewelcrafting"] } },
                        { name=L["Engineering"], cats={ L["Engineering"] } },
                        { name=L["Inscription"], cats={ L["Inscription"] } },
                        { name=L["Item Enchantment"], cats={ L["Item Enchantment"] } },
                        { name=L["Recipes"], cats={ L["Recipes"] } },
                        { name = L["Tradeskill Mats"], cats = { L["Tradeskill Mats"] } },
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
                        { name=L["Inscription"], cats={ L["Inscription"] } },
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
end

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
        newitemduration = 420,
        overridedefaultbags = true,
        overridebackpack = true,
        autoreagent = true,
        compressempty = true,
        compressstackable = true,
        sortnewfirst = true,
        compressall = false,
        CompressShards = false,
        CompressAmmo = false,
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
        DisableDefaultItemMenu = false,
        EnableItemUpgradeArrow = true,
        minimap = {
            hide = false,
        },
        unmatchedAlpha = 0.2,
        enableSearch = true,
        FontSize = 10,
        EnableItemLevelText = true,
        ItemLevelQualityColor = true,
        ItemLevelAncor = "BOTTOMRIGHT",
    },
    global = {
        pt3mods = {},
        template = "default",
    }
}
if Baggins:IsRetailWow() then
    dbDefaults.profile.EnableItemReagentQuality = true
    dbDefaults.profile.EnablePetLevel = true
    dbDefaults.profile.alwaysShowItemReagentQuality = true
end

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
    Baggins:Baggins_RefreshBags()
end

function Baggins:getCompressAll()
    return Baggins.db.profile.compressall
end

function Baggins:RebuildOptions()
    local p = self.db.profile
    if not p then return end
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
                    args = {
                        compressall = {
                            name = L["Compress All"],
                            type = "toggle",
                            desc = L["Show all items as a single button with a count on it"],
                            order = 10,
                            get = getCompressAll,
                            set = function(info, value) --luacheck: ignore 212
                                p.compressall = value
                                self:RebuildSectionLayouts()
                                self:Baggins_RefreshBags()
                            end,
                        },
                        CompressStackable = {
                            name = L["Compress Stackable Items"],
                            type = "toggle",
                            desc = L["Show stackable items as a single button with a count on it"],
                            order = 20,
                            disabled = getCompressAll,
                            get = function() return p.compressstackable or p.compressall end,
                            set = function(info, value) --luacheck: ignore 212
                                p.compressstackable = value
                                self:RebuildSectionLayouts()
                                self:Baggins_RefreshBags()
                            end,
                        },
                        CompressShards = {
                            name = L["Compress Soul Shards"],
                            type = "toggle",
                            desc = L["Show all soul shards as a single button with a count on it"],
                            order = 20,
                            disabled = getCompressAll,
                            get = function() return p.CompressShards or p.compressall end,
                            set = function(info, value) --luacheck: ignore 212
                                p.CompressShards = value
                                self:RebuildSectionLayouts()
                                self:Baggins_RefreshBags()
                            end,
                            hidden = Baggins:IsRetailWow(),
                        },
                        CompressAmmo = {
                            name = L["Compress Ammo"],
                            type = "toggle",
                            desc = L["Show all ammo as a single button with a count on it"],
                            order = 20,
                            disabled = getCompressAll,
                            get = function() return p.CompressAmmo or p.compressall end,
                            set = function(info, value) --luacheck: ignore 212
                                p.CompressAmmo = value
                                self:RebuildSectionLayouts()
                                self:Baggins_RefreshBags()
                            end,
                            hidden = Baggins:IsRetailWow(),
                        },
                        CompressEmptySlots = {
                            name = L["Compress Empty Slots"],
                            type = "toggle",
                            desc = L["Show all empty slots as a single button with a count on it"],
                            order = 100,
                            disabled = getCompressAll,
                            get = function() return p.compressempty or p.compressall end,
                            set = function(info, value) --luacheck: ignore 212
                                p.compressempty = value
                                self:RebuildSectionLayouts()
                                self:Baggins_RefreshBags()
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
                            set = function(info, value) --luacheck: ignore 212
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
                            set = function(info, value) --luacheck: ignore 212
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
                            set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
                        p.hideduplicates = value
                        self:ResortSections()
                        self:Baggins_RefreshBags()
                    end,
                    values = dbl({ 'global', 'bag', 'disabled' }),
                },
                AlwaysReSort = {
                    name = L["Always Resort"],
                    type = "toggle",
                    desc = L["Keeps Items sorted always, this will cause items to jump around when selling etc."],
                    order = 22,
                    get = function() return p.alwaysresort end,
                    set = function(info, value) --luacheck: ignore 212
                        p.alwaysresort = value
                    end
                },
                HighlightNew = {
                    name = L["Highlight New Items"],
                    type = "toggle",
                    desc = L["Add *New* to new items, *+++* to items that you have gained more of."],
                    order = 30,
                    get = function() return p.highlightnew end,
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
                        Baggins.db.profile.minimap.hide = not value
                        if value then
                            dbIcon:Show("Baggins")
                        else
                            dbIcon:Hide("Baggins")
                        end
                    end,
                    hidden = Baggins:IsRetailWow(),
                },
                Skin = {
                    name = L["Bag Skin"],
                    type = 'select',
                    desc = L["Select bag skin"],
                    order = 300,
                    get = function() return p.skin end,
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) p.hidedefaultbank = value end, --luacheck: ignore 212
                },
                NewItemDuration = {
                    name = L["New Item Duration"],
                    type = "range",
                    desc = L["Controls how long (in minutes) an item will be considered new. 0 disables the time limit."],
                    min = 0,
                    max = 15,
                    step = 1,
                    bigStep = 1,
                    order = 340,
                    get = function() return p.newitemduration / 60 end,
                    set = function(info, val) p.newitemduration = val * 60 end, --luacheck: ignore 212
                },
                Font = {
                    name = "Change Font",
                    type = "select",
                    desc = "Change the font used in baggins",
                    order = 341,
                    get = function() return p.Font end,
                    set = function(info, value) p.Font = value end, --luacheck: ignore 212
                    values = function()
                                local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true) --luacheck:ignore 113
                                if LSM then
                                    local fonts = {}
                                    --return fonts-
                                    for _,v in pairs(LSM:List("font")) do
                                        fonts[v] = v
                                    end
                                    return fonts
                                end
                            end
                    ,
                },
                FontSize = {
                    name = "Change Font Size",
                    type = "range",
                    desc = "Change the font size used in baggins",
                    order = 342,
                    max = 50,
                    min = 1,
                    step = 1,
                    get = function() return p.FontSize end,
                    set = function(info, value) p.FontSize = value end, --luacheck: ignore 212
                },
                EnableItemUpgradeArrow = {
                    name = "Enable Item Upgrade Arrow",
                    type = "toggle",
                    desc = "Enable Item Upgrade Arrow For Higher Item Level Gear or Pawn Upgrade!",
                    order = 343,
                    get = function() return p.EnableItemUpgradeArrow end,
                    set = function(info, value) p.EnableItemUpgradeArrow = value;self:UpdateItemButtons() end, --luacheck: ignore 212
                },
                EnableItemLevelText = {
                    name = "Enable Item Level text",
                    type = "toggle",
                    desc = "Enable Item level shown on armor and weapons.",
                    order = 344,
                    get = function() return p.EnableItemLevelText end,
                    set = function(info, value) p.EnableItemLevelText = value;self:UpdateItemButtons() end, --luacheck: ignore 212
                },
                ItemLevelQualityColor = {
                    name = "Item Level text Quality Color",
                    type = "toggle",
                    desc = "Set item level text color based on quality of item.",
                    order = 348,
                    get = function() return p.ItemLevelQualityColor end,
                    set = function(info, value) p.ItemLevelQualityColor = value;self:UpdateItemButtons() end, --luacheck: ignore 212
                },
                ItemLevelAncor = {
                    name = "Item Level text ancor",
                    type = "select",
                    desc = "Set item level text location.",
                    order = 349,
                    get = function() return p.ItemLevelAncor end,
                    set = function(info, value) p.ItemLevelAncor = value;self:UpdateItemButtons() end, --luacheck: ignore 212
                    values = {
                        TOPLEFT = "TOPLEFT",
                        TOP = "TOP",
                        TOPRIGHT = "TOPRIGHT",
                        LEFT = "LEFT",
                        CENTER = "CENTER",
                        RIGHT = "RIGHT",
                        BOTTOMLEFT = "BOTTOMLEFT",
                        BOTTOM = "BOTTOM",
                        BOTTOMRIGHT = "BOTTOMRIGHT",
                    }
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
                    set = function(info, value) p.overridedefaultbags = value self:UpdateBagHooks() end, --luacheck: ignore 212
                },
                OverrideBackpack = {
                    name = L["Override Backpack Button"],
                    type = "toggle",
                    desc = L["Baggins will open when clicking the backpack. Holding alt will open the default backpack."],
                    order = 700,
                    get = function() return p.overridebackpack end,
                    set = function(info, value) p.overridebackpack = value self:UpdateBackpackHook() end, --luacheck: ignore 212
                },
                DisableDefaultItemMenu = {
                    name = "Disable Default Item Menu",
                    type = "toggle",
                    desc = "Disable ItemMenu Showing On CTRL/ALT + Right Click (Recommend Setting Key Binding)",
                    order = 900,
                    get = function() return p.DisableDefaultItemMenu end,
                    set = function(info, value) p.DisableDefaultItemMenu = value end, --luacheck: ignore 212
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
                    set = function(info, value) p.layout = value self:UpdateLayout() end, --luacheck: ignore 212
                    values = dbl({ "auto", "manual" }),
                },
                LayoutAnchor = {
                    name = L["Layout Anchor"],
                    type = 'select',
                    order = 15,
                    desc = L["Sets which corner of the layout bounds the bags will be anchored to."],
                    get = function() return p.layoutanchor end,
                    set = function(info, value) p.layoutanchor =  value self:LayoutBagFrames() end, --luacheck: ignore 212
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
                    set = function(info, value) p.lock = value end, --luacheck: ignore 212
                    disabled = function() return p.layout == "auto" end,
                },
                OpenAtAuction = {
                    name = L["Automatically open at auction house"],
                    type = "toggle",
                    desc = L["Automatically open at auction house"],
                    order = 35,
                    get = function() return p.openatauction end,
                    set = function(info, value) p.openatauction = value end, --luacheck: ignore 212
                },
                ShrinkWidth = {
                    name = L["Shrink Width"],
                    type = "toggle",
                    desc = L["Shrink the bag's width to fit the items contained in them"],
                    order = 40,
                    get = function() return p.shrinkwidth end,
                    set = function(info, value) --luacheck: ignore 212
                        p.shrinkwidth = value
                        self:Baggins_RefreshBags()
                    end,
                },
                ShrinkTitle = {
                    name = L["Shrink bag title"],
                    type = "toggle",
                    desc = L["Mangle bag title to fit to content width"],
                    order = 50,
                    get = function() return p.shrinkbagtitle end,
                    set = function(info, value) --luacheck: ignore 212
                        p.shrinkbagtitle = value
                        self:Baggins_RefreshBags()
                    end,
                },
                Scale = {
                    name = L["Scale"],
                    type = "range",
                    desc = L["Scale of the bag frames"],
                    order = 60,
                    max = 2,
                    min = 0.3,
                    step = 0.01,
                    get = function() return p.scale end,
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) p.moneybag = tonumber(value) or -1 self:Baggins_RefreshBags() end, --luacheck: ignore 212
                    values = "GetMoneyBagChoices",
                },
                ShowBankControls = {
                    name = L["Show Bank Controls On Bag"],
                    type = 'select',
                    desc = L["Which Bag to Show Bank Controls On"],
                    order = 64,
                    arg = true,
                    get = function() return p.bankcontrolbag < 0 and "None" or tostring(p.bankcontrolbag) end,
                    set = function(info, value) p.bankcontrolbag = tonumber(value) or -1 self:Baggins_RefreshBags() end, --luacheck: ignore 212
                    values = "GetBankControlsBagChoices",
                },
                DisableBagRightClick = {
                    name = L["Disable Bag Menu"],
                    type = "toggle",
                    desc = L["Disables the menu that pops up when right clicking on bags."],
                    order = 65,
                    get = function() return p.disablebagmenu end,
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
                        p.section_layout = value
                        self:Baggins_RefreshBags()
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
                    set = function(info, value) --luacheck: ignore 212
                        p.showsectiontitle = value
                        self:Baggins_RefreshBags()
                    end
                },
                HideEmptySections = {
                    name = L["Hide Empty Sections"],
                    type = "toggle",
                    desc = L["Hide sections that have no items in them."],
                    order = 90,
                    get = function() return p.hideemptysections end,
                    set = function(info, value) --luacheck: ignore 212
                        p.hideemptysections = value
                        self:Baggins_RefreshBags()
                    end
                },
                HideEmptyBags = {
                    name = L["Hide Empty Bags"],
                    type = "toggle",
                    desc = L["Hide bags that have no items in them."],
                    order = 90,
                    get = function() return p.hideemptybags end,
                    set = function(info, value) --luacheck: ignore 212
                        p.hideemptybags = value
                        self:Baggins_RefreshBags()
                    end
                },
                Sort = {
                    name = L["Sort"],
                    type = 'select',
                    desc = L["How items are sorted"],
                    order = 100,
                    get = function() return p.sort end,
                    set = function(info, value) p.sort = value self:Baggins_RefreshBags() end, --luacheck: ignore 212
                    values = dbl({'quality', 'name', 'type', 'slot', 'ilvl' }),
                },
                SortNewFirst = {
                    name = L["Sort New First"],
                    type = "toggle",
                    desc = L["Sorts New Items to the beginning of sections"],
                    order = 105,
                    get = function() return p.sortnewfirst end,
                    set = function(info, value) p.sortnewfirst = value end, --luacheck: ignore 212
                },
                Columns = {
                    name = L["Columns"],
                    type = "range",
                    desc = L["Number of Columns shown in the bag frames"],
                    order = 110,
                    get = function() return p.columns end,
                    set = function(info, value) p.columns = value self:Baggins_RefreshBags() end, --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
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
                    set = function(info, value) --luacheck: ignore 212
                        p.combinecounts = value
                        self:UpdateText()
                    end,
                },
            },
        },
    }
    if Baggins:IsRetailWow() then
        self.opts.args.General.args.EnableItemReagentQuality = {
            name = "Enable Item Reagent Quality",
            type = "toggle",
            desc = "Enable Item Reagent Quality shown on profession items.",
            order = 345,
            get = function() return p.EnableItemReagentQuality end,
            set = function(info, value) p.EnableItemReagentQuality = value;self:UpdateItemButtons() end, --luacheck: ignore 212
        }
        self.opts.args.General.args.alwaysShowItemReagentQuality = {
            name = "Enable Always Showing Item Reagent Quality",
            type = "toggle",
            desc = "Enable Always Showing Item Reagent Quality.",
            order = 346,
            get = function() return p.EnablePetLevel end,
            set = function(info, value) p.EnablePetLevel = value;self:UpdateItemButtons() end, --luacheck: ignore 212
        }
        self.opts.args.General.args.EnablePetLevel = {
            name = "Enable Showing Battle Pet Level",
            type = "toggle",
            desc = "Enable Showing Battle Pet Level.",
            order = 347,
            get = function() return p.EnablePetLevel end,
            set = function(info, value) p.EnablePetLevel = value;self:UpdateItemButtons() end, --luacheck: ignore 212
        }
        self.opts.args.General.args.AutomaticReagentHandling = {
            name = L["Reagent Deposit"],
            type = "toggle",
            desc = L["Automatically deposits crafting reagents into the reagent bank if available."],
            order = 800,
            get = function() return p.autoreagent end,
            set = function(info, value) p.autoreagent = value end, --luacheck: ignore 212
        }
    end

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
                set = function(info, value) Baggins.db.global.template = value end, --luacheck: ignore 212
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
                func = function() Baggins:CloseAllBags(); Baggins.db:ResetProfile() end,
            },
        },
    }
end

function Baggins:UpdateDB()
    local p = self.db.profile
    if not p then return end
    for _, rules in pairs(p.categories) do
        local i = 1
        while(i < #rules + 1) do
            local rule = rules[i]
            if not rule then break end
            -- remove item-types that have been removed from the game
            if (rule.type == "ContainerType" and (rule.ctype == "Soul Bag" or rule.ctype == "Ammo Bag"))
                    or (rule.type == "ItemType" and (rule.isubtype == "Librams" or rule.isubtype == "Idols" or rule.isubtype == "Totems")) then
                tremove(rules, i)
                i = i - 1
            end
            i = i + 1
        end
    end
end

local oldskin
function Baggins:InitOptions()
    self.db = LibStub("AceDB-3.0"):New("BagginsDB", dbDefaults, "Default")
    self:UpdateDB()
    self:RebuildOptions()

    self.db.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
    self.db.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
    self.db.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
    self.db.RegisterCallback(self, "OnNewProfile", "NewProfile")

    AceConfig:RegisterOptionsTable("Baggins", self.opts)
    AceConfigDialog:AddToBlizOptions("Baggins", "Baggins")
    oldskin = self.db.profile.skin
end
local itemTypeReverse

if Baggins:IsRetailWow() then
    itemTypeReverse = {
        ["Quiver"] = {
            ["id"] = 11,
            ["subTypes"] = {
            },
        },
        ["WoW Token"] = {
            ["id"] = 18,
            ["subTypes"] = {
                ["WoW Token"] = 0,
            },
        },
        ["Recipe"] = {
            ["id"] = 9,
            ["subTypes"] = {
                ["Tailoring"] = 2,
                ["Blacksmithing"] = 4,
                ["Alchemy"] = 6,
                ["First Aid"] = 7,
                ["Book"] = 0,
                ["Cooking"] = 5,
                ["Fishing"] = 9,
                ["Jewelcrafting"] = 10,
                ["Engineering"] = 3,
                ["Leatherworking"] = 1,
                ["Inscription"] = 11,
                ["Enchanting"] = 8,
            },
        },
        ["Reagent"] = {
            ["id"] = 5,
            ["subTypes"] = {
                ["Reagent"] = 0,
                ["Keystone"] = 1,
                ["Context Token"] = 2,
            },
        },
        ["Key"] = {
            ["id"] = 13,
            ["subTypes"] = {
                ["Key"] = 0,
                ["Lockpick"] = 1,
            },
        },
        ["Armor"] = {
            ["id"] = 4,
            ["subTypes"] = {
                ["Leather"] = 2,
                ["Cosmetic"] = 5,
                ["Shields"] = 6,
                ["Mail"] = 3,
                ["Plate"] = 4,
                ["Cloth"] = 1,
                ["Miscellaneous"] = 0,
            },
        },
        ["Quest"] = {
            ["id"] = 12,
            ["subTypes"] = {
                ["Quest"] = 0,
            },
        },
        ["Container"] = {
            ["id"] = 1,
            ["subTypes"] = {
                ["Bag"] = 0,
                ["Mining Bag"] = 6,
                ["Cooking Bag"] = 10,
                ["Gem Bag"] = 5,
                ["Herb Bag"] = 2,
                ["Engineering Bag"] = 4,
                ["Tackle Box"] = 9,
                ["Leatherworking Bag"] = 7,
                ["Inscription Bag"] = 8,
                ["Enchanting Bag"] = 3,
            },
        },
        ["Tradeskill"] = {
            ["id"] = 7,
            ["subTypes"] = {
                ["Inscription"] = 16,
                ["Optional Reagents"] = 18,
                ["Elemental"] = 10,
                ["Jewelcrafting"] = 4,
                ["Leather"] = 6,
                ["Herb"] = 9,
                ["Other"] = 11,
                ["Enchanting"] = 12,
                ["Cloth"] = 5,
                ["Cooking"] = 8,
                ["Metal & Stone"] = 7,
                ["Parts"] = 1,
            },
        },
        ["Permanent(OBSOLETE)"] = {
            ["id"] = 14,
            ["subTypes"] = {
                ["Permanent"] = 0,
            },
        },
        ["Miscellaneous"] = {
            ["id"] = 15,
            ["subTypes"] = {
                ["Other"] = 4,
                ["Companion Pets"] = 2,
                ["Holiday"] = 3,
                ["Junk"] = 0,
                ["Reagent"] = 1,
                ["Mount"] = 5,
                ["Mount Equipment"] = 6,
            },
        },
        ["Battle Pets"] = {
            ["id"] = 17,
            ["subTypes"] = {
                ["Dragonkin"] = 1,
                ["Humanoid"] = 0,
                ["Elemental"] = 6,
                ["Critter"] = 4,
                ["Magic"] = 5,
                ["Flying"] = 2,
                ["Aquatic"] = 8,
                ["Undead"] = 3,
                ["Beast"] = 7,
                ["Mechanical"] = 9,
            },
        },
        ["Consumable"] = {
            ["id"] = 0,
            ["subTypes"] = {
                ["Other"] = 8,
                ["Elixir"] = 2,
                ["Explosives and Devices"] = 0,
                ["Potion"] = 1,
                ["Food & Drink"] = 5,
                ["Flask"] = 3,
                ["Bandage"] = 7,
                ["Vantus Runes"] = 9,
            },
        },
        ["Gem"] = {
            ["id"] = 3,
            ["subTypes"] = {
                ["Intellect"] = 0,
                ["Artifact Relic"] = 11,
                ["Haste"] = 7,
                ["Strength"] = 2,
                ["Multiple Stats"] = 10,
                ["Agility"] = 1,
                ["Other"] = 9,
                ["Versatility"] = 8,
                ["Stamina"] = 3,
                ["Mastery"] = 6,
                ["Critical Strike"] = 5,
            },
        },
        ["Money(OBSOLETE)"] = {
            ["id"] = 10,
            ["subTypes"] = {
                ["Money(OBSOLETE)"] = 0,
            },
        },
        ["Projectile"] = {
            ["id"] = 6,
            ["subTypes"] = {
            },
        },
        ["Item Enhancement"] = {
            ["id"] = 8,
            ["subTypes"] = {
                ["Waist"] = 7,
                ["Head"] = 0,
                ["Neck"] = 1,
                ["Shield/Off-hand"] = 13,
                ["Misc"] = 14,
                ["Two-Handed Weapon"] = 12,
                ["Feet"] = 9,
                ["Chest"] = 4,
                ["Cloak"] = 3,
                ["Finger"] = 10,
                ["Legs"] = 8,
                ["Hands"] = 6,
                ["Wrist"] = 5,
                ["Shoulder"] = 2,
                ["Weapon"] = 11,
            },
        },
        ["Glyph"] = {
            ["id"] = 16,
            ["subTypes"] = {
                ["Warrior"] = 1,
                ["Paladin"] = 2,
                ["Shaman"] = 7,
                ["Monk"] = 10,
                ["Rogue"] = 4,
                ["Mage"] = 8,
                ["Demon Hunter"] = 12,
                ["Warlock"] = 9,
                ["Priest"] = 5,
                ["Hunter"] = 3,
                ["Druid"] = 11,
                ["Death Knight"] = 6,
            },
        },
        ["Weapon"] = {
            ["id"] = 2,
            ["subTypes"] = {
                ["One-Handed Axes"] = 0,
                ["One-Handed Swords"] = 7,
                ["Staves"] = 10,
                ["Crossbows"] = 18,
                ["Polearms"] = 6,
                ["One-Handed Maces"] = 4,
                ["Warglaives"] = 9,
                ["Bows"] = 2,
                ["Two-Handed Swords"] = 8,
                ["Miscellaneous"] = 14,
                ["Fishing Poles"] = 20,
                ["Daggers"] = 15,
                ["Guns"] = 3,
                ["Fist Weapons"] = 13,
                ["Two-Handed Maces"] = 5,
                ["Wands"] = 19,
                ["Thrown"] = 16,
                ["Two-Handed Axes"] = 1,
            },
        },
    }
end

if Baggins:IsClassicWow() then
    itemTypeReverse = {
        ["Quiver"] = {
            ["id"] = 11,
            ["subTypes"] = {
                ["Quiver"] = 2,
                ["Ammo Pouch"] = 3,
            },
        },
        ["WoW Token"] = {
            ["id"] = 18,
            ["subTypes"] = {
                ["WoW Token"] = 0,
            },
        },
        ["Recipe"] = {
            ["id"] = 9,
            ["subTypes"] = {
                ["Tailoring"] = 2,
                ["Blacksmithing"] = 4,
                ["Alchemy"] = 6,
                ["First Aid"] = 7,
                ["Book"] = 0,
                ["Cooking"] = 5,
                ["Fishing"] = 9,
                ["Engineering"] = 3,
                ["Leatherworking"] = 1,
                ["Enchanting"] = 8,
            },
        },
        ["Reagent"] = {
            ["id"] = 5,
            ["subTypes"] = {
                ["Reagent"] = 0,
            },
        },
        ["Key"] = {
            ["id"] = 13,
            ["subTypes"] = {
                ["Key"] = 0,
                ["Lockpick"] = 1,
            },
        },
        ["Armor"] = {
            ["id"] = 4,
            ["subTypes"] = {
                ["Leather"] = 2,
                ["Shields"] = 6,
                ["Librams"] = 7,
                ["Idols"] = 8,
                ["Totems"] = 9,
                ["Mail"] = 3,
                ["Plate"] = 4,
                ["Cloth"] = 1,
                ["Miscellaneous"] = 0,
            },
        },
        ["Quest"] = {
            ["id"] = 12,
            ["subTypes"] = {
                ["Quest"] = 0,
            },
        },
        ["Container"] = {
            ["id"] = 1,
            ["subTypes"] = {
                ["Bag"] = 0,
                ["Soul Bag"] = 1,
                ["Herb Bag"] = 2,
                ["Enchanting Bag"] = 3,
            },
        },
        ["Trade Goods"] = {
            ["id"] = 7,
            ["subTypes"] = {
                ["Trade Goods"] = 0,
                ["Parts"] = 1,
                ["Explosives"] = 2,
                ["Devices"] = 3,
            },
        },
        ["Permanent(OBSOLETE)"] = {
            ["id"] = 14,
            ["subTypes"] = {
                ["Permanent"] = 0,
            },
        },
        ["Miscellaneous"] = {
            ["id"] = 15,
            ["subTypes"] = {
                ["Junk"] = 0,
            },
        },
        ["Consumable"] = {
            ["id"] = 0,
            ["subTypes"] = {
                ["Liquid"] = 2,
                ["Consumable"] = 0,
                ["Cheese/Bread"] = 1,
            },
        },
        ["Money(OBSOLETE)"] = {
            ["id"] = 10,
            ["subTypes"] = {
                ["Money(OBSOLETE)"] = 0,
            },
        },
        ["Projectile"] = {
            ["id"] = 6,
            ["subTypes"] = {
                ["Arrow"] = 2,
                ["Bullet"] = 3,
            },
        },
        ["Generic"] = {
            ["id"] = 8,
            ["subTypes"] = {},
        },
        ["Weapon"] = {
            ["id"] = 2,
            ["subTypes"] = {
                ["One-Handed Axes"] = 0,
                ["One-Handed Swords"] = 7,
                ["Staves"] = 10,
                ["Crossbows"] = 18,
                ["Polearms"] = 6,
                ["One-Handed Maces"] = 4,
                ["Bows"] = 2,
                ["Two-Handed Swords"] = 8,
                ["Miscellaneous"] = 14,
                ["Fishing Pole"] = 20,
                ["Daggers"] = 15,
                ["Guns"] = 3,
                ["Fist Weapons"] = 13,
                ["Two-Handed Maces"] = 5,
                ["Wands"] = 19,
                ["Thrown"] = 16,
                ["Two-Handed Axes"] = 1,
            },
        },
    }
end

if Baggins:IsTBCWow() then
    itemTypeReverse = {
        ["Quiver"] = {
            ["id"] = 11,
            ["subTypes"] = {
                ["Quiver"] = 2,
                ["Ammo Pouch"] = 3,
            },
        },
        ["WoW Token"] = {
            ["id"] = 18,
            ["subTypes"] = {
                ["WoW Token"] = 0,
            },
        },
        ["Recipe"] = {
            ["id"] = 9,
            ["subTypes"] = {
                ["Tailoring"] = 2,
                ["Blacksmithing"] = 4,
                ["Alchemy"] = 6,
                ["First Aid"] = 7,
                ["Book"] = 0,
                ["Cooking"] = 5,
                ["Fishing"] = 9,
                ["Jewelcrafting"] = 10,
                ["Engineering"] = 3,
                ["Leatherworking"] = 1,
                ["Enchanting"] = 8,
            },
        },
        ["Reagent"] = {
            ["id"] = 5,
            ["subTypes"] = {
                ["Reagent"] = 0,
            },
        },
        ["Key"] = {
            ["id"] = 13,
            ["subTypes"] = {
                ["Key"] = 0,
                ["Lockpick"] = 1,
            },
        },
        ["Armor"] = {
            ["id"] = 4,
            ["subTypes"] = {
                ["Leather"] = 2,
                ["Shields"] = 6,
                ["Mail"] = 3,
                ["Plate"] = 4,
                ["Cloth"] = 1,
                ["Miscellaneous"] = 0,
                ["Librams"] = 7,
                ["Idols"] = 8,
                ["Totems"] = 9,
            },
        },
        ["Quest"] = {
            ["id"] = 12,
            ["subTypes"] = {},
        },
        ["Container"] = {
            ["id"] = 1,
            ["subTypes"] = {
                ["Bag"] = 0,
                ["Soul Bag"] = 1,
                ["Mining Bag"] = 6,
                ["Gem Bag"] = 5,
                ["Herb Bag"] = 2,
                ["Engineering Bag"] = 4,
                ["Leatherworking Bag"] = 7,
                ["Enchanting Bag"] = 3,
            },
        },
        ["Trade Goods"] = {
            ["id"] = 7,
            ["subTypes"] = {
                ["Elemental"] = 10,
                ["Jewelcrafting"] = 4,
                ["Leather"] = 6,
                ["Herb"] = 9,
                ["Other"] = 11,
                ["Enchanting"] = 12,
                ["Cloth"] = 5,
                ["Meat"] = 8,
                ["Metal & Stone"] = 7,
                ["Parts"] = 1,
                ["Explosives"] = 2,
                ["Devices"] = 3,
            },
        },
        ["Permanent(OBSOLETE)"] = {
            ["id"] = 14,
            ["subTypes"] = {},
        },
        ["Miscellaneous"] = {
            ["id"] = 15,
            ["subTypes"] = {
                ["Other"] = 4,
                ["Holiday"] = 3,
                ["Junk"] = 0,
                ["Reagent"] = 1,
                ["Pet"] = 2,
                ["Mount"] = 5,
            },
        },
        ["Consumable"] = {
            ["id"] = 0,
            ["subTypes"] = {
                ["Other"] = 8,
                ["Flask"] = 3,
                ["Potion"] = 1,
                ["Elixir"] = 2,
                ["Food & Drink"] = 5,
                ["Scroll"] = 4,
                ["Bandage"] = 7,
            },
        },
        ["Gem"] = {
            ["id"] = 3,
            ["subTypes"] = {
                ["Red"] = 0,
                ["Blue"] = 1,
                ["Yellow"] = 2,
                ["Purple"] = 3,
                ["Green"] = 4,
                ["Orange"] = 5,
                ["Meta"] = 6,
                ["Simple"] = 7,
                ["Prismatic"] = 8,
            },
        },
        ["Money(OBSOLETE)"] = {
            ["id"] = 10,
            ["subTypes"] = {},
        },
        ["Projectile"] = {
            ["id"] = 6,
            ["subTypes"] = {
                ["Arrow"] = 2,
                ["Bullet"] = 3,
            },
        },
        ["Generic"] = {
            ["id"] = 8,
            ["subTypes"] = {},
        },
        ["Weapon"] = {
            ["id"] = 2,
            ["subTypes"] = {
                ["One-Handed Axes"] = 0,
                ["One-Handed Swords"] = 7,
                ["Staves"] = 10,
                ["Crossbows"] = 18,
                ["Polearms"] = 6,
                ["One-Handed Maces"] = 4,
                ["Bows"] = 2,
                ["Two-Handed Swords"] = 8,
                ["Miscellaneous"] = 14,
                ["Fishing Poles"] = 20,
                ["Daggers"] = 15,
                ["Guns"] = 3,
                ["Fist Weapons"] = 13,
                ["Two-Handed Maces"] = 5,
                ["Wands"] = 19,
                ["Thrown"] = 16,
                ["Two-Handed Axes"] = 1,
            },
        },
    }
end

if Baggins:IsWrathWow() then
    itemTypeReverse = {
        ["Quiver"] = {
            ["id"] = 11,
            ["subTypes"] = {
                ["Quiver"] = 2,
                ["Ammo Pouch"] = 3,
            },
        },
        ["WoW Token"] = {
            ["id"] = 18,
            ["subTypes"] = {
                ["WoW Token"] = 0,
            },
        },
        ["Recipe"] = {
            ["id"] = 9,
            ["subTypes"] = {
                ["Tailoring"] = 2,
                ["Blacksmithing"] = 4,
                ["Alchemy"] = 6,
                ["First Aid"] = 7,
                ["Book"] = 0,
                ["Cooking"] = 5,
                ["Fishing"] = 9,
                ["Jewelcrafting"] = 10,
                ["Engineering"] = 3,
                ["Leatherworking"] = 1,
                ["Enchanting"] = 8,
            },
        },
        ["Reagent"] = {
            ["id"] = 5,
            ["subTypes"] = {
                ["Reagent"] = 0,
            },
        },
        ["Key"] = {
            ["id"] = 13,
            ["subTypes"] = {
                ["Key"] = 0,
                ["Lockpick"] = 1,
            },
        },
        ["Armor"] = {
            ["id"] = 4,
            ["subTypes"] = {
                ["Leather"] = 2,
                ["Shields"] = 6,
                ["Mail"] = 3,
                ["Plate"] = 4,
                ["Cloth"] = 1,
                ["Miscellaneous"] = 0,
                ["Librams"] = 7,
                ["Idols"] = 8,
                ["Totems"] = 9,
            },
        },
        ["Quest"] = {
            ["id"] = 12,
            ["subTypes"] = {},
        },
        ["Container"] = {
            ["id"] = 1,
            ["subTypes"] = {
                ["Bag"] = 0,
                ["Soul Bag"] = 1,
                ["Mining Bag"] = 6,
                ["Gem Bag"] = 5,
                ["Herb Bag"] = 2,
                ["Engineering Bag"] = 4,
                ["Leatherworking Bag"] = 7,
                ["Enchanting Bag"] = 3,
            },
        },
        ["Trade Goods"] = {
            ["id"] = 7,
            ["subTypes"] = {
                ["Elemental"] = 10,
                ["Jewelcrafting"] = 4,
                ["Leather"] = 6,
                ["Herb"] = 9,
                ["Other"] = 11,
                ["Enchanting"] = 12,
                ["Cloth"] = 5,
                ["Meat"] = 8,
                ["Metal & Stone"] = 7,
                ["Parts"] = 1,
                ["Explosives"] = 2,
                ["Devices"] = 3,
            },
        },
        ["Permanent(OBSOLETE)"] = {
            ["id"] = 14,
            ["subTypes"] = {},
        },
        ["Miscellaneous"] = {
            ["id"] = 15,
            ["subTypes"] = {
                ["Other"] = 4,
                ["Holiday"] = 3,
                ["Junk"] = 0,
                ["Reagent"] = 1,
                ["Pet"] = 2,
                ["Mount"] = 5,
            },
        },
        ["Consumable"] = {
            ["id"] = 0,
            ["subTypes"] = {
                ["Other"] = 8,
                ["Flask"] = 3,
                ["Potion"] = 1,
                ["Elixir"] = 2,
                ["Food & Drink"] = 5,
                ["Scroll"] = 4,
                ["Bandage"] = 7,
            },
        },
        ["Gem"] = {
            ["id"] = 3,
            ["subTypes"] = {
                ["Red"] = 0,
                ["Blue"] = 1,
                ["Yellow"] = 2,
                ["Purple"] = 3,
                ["Green"] = 4,
                ["Orange"] = 5,
                ["Meta"] = 6,
                ["Simple"] = 7,
                ["Prismatic"] = 8,
            },
        },
        ["Money(OBSOLETE)"] = {
            ["id"] = 10,
            ["subTypes"] = {},
        },
        ["Projectile"] = {
            ["id"] = 6,
            ["subTypes"] = {
                ["Arrow"] = 2,
                ["Bullet"] = 3,
            },
        },
        ["Generic"] = {
            ["id"] = 8,
            ["subTypes"] = {},
        },
        ["Weapon"] = {
            ["id"] = 2,
            ["subTypes"] = {
                ["One-Handed Axes"] = 0,
                ["One-Handed Swords"] = 7,
                ["Staves"] = 10,
                ["Crossbows"] = 18,
                ["Polearms"] = 6,
                ["One-Handed Maces"] = 4,
                ["Bows"] = 2,
                ["Two-Handed Swords"] = 8,
                ["Miscellaneous"] = 14,
                ["Fishing Poles"] = 20,
                ["Daggers"] = 15,
                ["Guns"] = 3,
                ["Fist Weapons"] = 13,
                ["Two-Handed Maces"] = 5,
                ["Wands"] = 19,
                ["Thrown"] = 16,
                ["Two-Handed Axes"] = 1,
            },
        },
    }
end

if Baggins:IsCataWow() then
    itemTypeReverse = {
        ["Quiver"] = {
            ["id"] = 11,
            ["subTypes"] = {
                ["Quiver"] = 2,
                ["Ammo Pouch"] = 3,
            },
        },
        ["WoW Token"] = {
            ["id"] = 18,
            ["subTypes"] = {
                ["WoW Token"] = 0,
            },
        },
        ["Recipe"] = {
            ["id"] = 9,
            ["subTypes"] = {
                ["Tailoring"] = 2,
                ["Blacksmithing"] = 4,
                ["Alchemy"] = 6,
                ["First Aid"] = 7,
                ["Book"] = 0,
                ["Cooking"] = 5,
                ["Fishing"] = 9,
                ["Jewelcrafting"] = 10,
                ["Engineering"] = 3,
                ["Leatherworking"] = 1,
                ["Enchanting"] = 8,
            },
        },
        ["Reagent"] = {
            ["id"] = 5,
            ["subTypes"] = {
                ["Reagent"] = 0,
            },
        },
        ["Key"] = {
            ["id"] = 13,
            ["subTypes"] = {
                ["Key"] = 0,
                ["Lockpick"] = 1,
            },
        },
        ["Armor"] = {
            ["id"] = 4,
            ["subTypes"] = {
                ["Leather"] = 2,
                ["Shields"] = 6,
                ["Mail"] = 3,
                ["Plate"] = 4,
                ["Cloth"] = 1,
                ["Miscellaneous"] = 0,
                ["Librams"] = 7,
                ["Idols"] = 8,
                ["Totems"] = 9,
            },
        },
        ["Quest"] = {
            ["id"] = 12,
            ["subTypes"] = {},
        },
        ["Container"] = {
            ["id"] = 1,
            ["subTypes"] = {
                ["Bag"] = 0,
                ["Soul Bag"] = 1,
                ["Mining Bag"] = 6,
                ["Gem Bag"] = 5,
                ["Herb Bag"] = 2,
                ["Engineering Bag"] = 4,
                ["Leatherworking Bag"] = 7,
                ["Enchanting Bag"] = 3,
            },
        },
        ["Trade Goods"] = {
            ["id"] = 7,
            ["subTypes"] = {
                ["Elemental"] = 10,
                ["Jewelcrafting"] = 4,
                ["Leather"] = 6,
                ["Herb"] = 9,
                ["Other"] = 11,
                ["Enchanting"] = 12,
                ["Cloth"] = 5,
                ["Meat"] = 8,
                ["Metal & Stone"] = 7,
                ["Parts"] = 1,
                ["Explosives"] = 2,
                ["Devices"] = 3,
            },
        },
        ["Permanent(OBSOLETE)"] = {
            ["id"] = 14,
            ["subTypes"] = {},
        },
        ["Miscellaneous"] = {
            ["id"] = 15,
            ["subTypes"] = {
                ["Other"] = 4,
                ["Holiday"] = 3,
                ["Junk"] = 0,
                ["Reagent"] = 1,
                ["Pet"] = 2,
                ["Mount"] = 5,
            },
        },
        ["Consumable"] = {
            ["id"] = 0,
            ["subTypes"] = {
                ["Other"] = 8,
                ["Flask"] = 3,
                ["Potion"] = 1,
                ["Elixir"] = 2,
                ["Food & Drink"] = 5,
                ["Scroll"] = 4,
                ["Bandage"] = 7,
            },
        },
        ["Gem"] = {
            ["id"] = 3,
            ["subTypes"] = {
                ["Red"] = 0,
                ["Blue"] = 1,
                ["Yellow"] = 2,
                ["Purple"] = 3,
                ["Green"] = 4,
                ["Orange"] = 5,
                ["Meta"] = 6,
                ["Simple"] = 7,
                ["Prismatic"] = 8,
            },
        },
        ["Money(OBSOLETE)"] = {
            ["id"] = 10,
            ["subTypes"] = {},
        },
        ["Projectile"] = {
            ["id"] = 6,
            ["subTypes"] = {
                ["Arrow"] = 2,
                ["Bullet"] = 3,
            },
        },
        ["Generic"] = {
            ["id"] = 8,
            ["subTypes"] = {},
        },
        ["Weapon"] = {
            ["id"] = 2,
            ["subTypes"] = {
                ["One-Handed Axes"] = 0,
                ["One-Handed Swords"] = 7,
                ["Staves"] = 10,
                ["Crossbows"] = 18,
                ["Polearms"] = 6,
                ["One-Handed Maces"] = 4,
                ["Bows"] = 2,
                ["Two-Handed Swords"] = 8,
                ["Miscellaneous"] = 14,
                ["Fishing Poles"] = 20,
                ["Daggers"] = 15,
                ["Guns"] = 3,
                ["Fist Weapons"] = 13,
                ["Two-Handed Maces"] = 5,
                ["Wands"] = 19,
                ["Thrown"] = 16,
                ["Two-Handed Axes"] = 1,
            },
        },
    }
end

if Baggins:IsMistWow() then
    itemTypeReverse = {
        ["Recipe"] = {
            ["id"] = 9,
            ["subTypes"] = {
                ["Tailoring"] = 2,
                ["Blacksmithing"] = 4,
                ["Alchemy"] = 6,
                ["First Aid"] = 7,
                ["Book"] = 0,
                ["Cooking"] = 5,
                ["Fishing"] = 9,
                ["Jewelcrafting"] = 10,
                ["Engineering"] = 3,
                ["Leatherworking"] = 1,
                ["Enchanting"] = 8,
                ["Inscription"] = 11, -- new in mop
            },
        },
        ["Reagent"] = {
            ["id"] = 5,
            ["subTypes"] = {
                ["Reagent"] = 0,
            },
        },
        ["Key"] = {
            ["id"] = 13,
            ["subTypes"] = {
                ["Key"] = 0,
                ["Lockpick"] = 1,
            },
        },
        ["Armor"] = {
            ["id"] = 4,
            ["subTypes"] = {
                ["Leather"] = 2,
                ["Shields"] = 6,
                ["Mail"] = 3,
                ["Plate"] = 4,
                ["Cloth"] = 1,
                ["Miscellaneous"] = 0,
                ["Cosmetic"] = 5, -- new in mop
            },
        },
        ["Quest"] = {
            ["id"] = 12,
            ["subTypes"] = {},
        },
        ["Container"] = {
            ["id"] = 1,
            ["subTypes"] = {
                ["Bag"] = 0,
                ["Mining Bag"] = 6,
                ["Gem Bag"] = 5,
                ["Herb Bag"] = 2,
                ["Engineering Bag"] = 4,
                ["Leatherworking Bag"] = 7,
                ["Enchanting Bag"] = 3,
                ["Inscription Bag"] = 8, -- new in mop
                ["Tackle Box"] = 9, -- new in mop
                ["Cooking Bag"] = 10, -- new in mop
            },
        },
        ["Trade Goods"] = {
            ["id"] = 7,
            ["subTypes"] = {
                ["Elemental"] = 10,
                ["Jewelcrafting"] = 4,
                ["Leather"] = 6,
                ["Herb"] = 9,
                ["Other"] = 11,
                ["Enchanting"] = 12,
                ["Cloth"] = 5,
                ["Cooking"] = 8,
                ["Metal & Stone"] = 7,
                ["Parts"] = 1,
                ["Explosives"] = 2,
                ["Devices"] = 3,
                ["Materials"] = 13, -- new in mop
                ["Item Enchantment"] = 14, -- new in mop
            },
        },
        ["Permanent(OBSOLETE)"] = {
            ["id"] = 14,
            ["subTypes"] = {},
        },
        ["Miscellaneous"] = {
            ["id"] = 15,
            ["subTypes"] = {
                ["Other"] = 4,
                ["Holiday"] = 3,
                ["Junk"] = 0,
                ["Reagent"] = 1,
                ["Companion Pets"] = 2, -- wording changed in mop
                ["Mount"] = 5,
            },
        },
        ["Consumable"] = {
            ["id"] = 0,
            ["subTypes"] = {
                ["Other"] = 8,
                ["Flask"] = 3,
                ["Potion"] = 1,
                ["Elixir"] = 2,
                ["Food & Drink"] = 5,
                ["Scroll"] = 4,
                ["Bandage"] = 7,
                ["Item Enchantment"] = 6, -- new in mop
            },
        },
        ["Gem"] = {
            ["id"] = 3,
            ["subTypes"] = {
                ["Red"] = 0,
                ["Blue"] = 1,
                ["Yellow"] = 2,
                ["Purple"] = 3,
                ["Green"] = 4,
                ["Orange"] = 5,
                ["Meta"] = 6,
                ["Simple"] = 7,
                ["Prismatic"] = 8,
                ["Cogwheel"] = 10, -- new in mop
            },
        },
        ["Money(OBSOLETE)"] = {
            ["id"] = 10,
            ["subTypes"] = {},
        },
        ["Generic(OBSOLETE)"] = { -- wording changed in mop
            ["id"] = 8,
            ["subTypes"] = {},
        },
        ["Weapon"] = {
            ["id"] = 2,
            ["subTypes"] = {
                ["One-Handed Axes"] = 0,
                ["One-Handed Swords"] = 7,
                ["Staves"] = 10,
                ["Crossbows"] = 18,
                ["Polearms"] = 6,
                ["One-Handed Maces"] = 4,
                ["Bows"] = 2,
                ["Two-Handed Swords"] = 8,
                ["Miscellaneous"] = 14,
                ["Fishing Poles"] = 20,
                ["Daggers"] = 15,
                ["Guns"] = 3,
                ["Fist Weapons"] = 13,
                ["Two-Handed Maces"] = 5,
                ["Wands"] = 19,
                ["Thrown"] = 16,
                ["Two-Handed Axes"] = 1,
            },
        },
    }
end

function Baggins:NewProfile(_, _)
    --_,key
    self:ChangeProfile();
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

function Baggins:OpenConfig() --luacheck: ignore 212
    AceConfigDialog:Open("Baggins")
end

function Baggins:OpenEditConfig() --luacheck: ignore 212
    AceConfigDialog:Open("BagginsEdit")
end

if Baggins:IsRetailWow() then
    Baggins.defaultcategories = {
        [L["Misc Consumables"]] = {
            name=L["Misc Consumables"],
            {
                type="ItemType" ,
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Other"],
            }
        },
        [L["Consumables"]] = {
            name=L["Consumables"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id
            }
        },
        [L["Armor"]] = {
            name=L["Armor"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"],
                operation="NOT"
            },
        },
        [L["Weapons"]] = {
            name=L["Weapons"],
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"]
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                isubtype = itemTypeReverse["Weapon"].subTypes["Miscellaneous"],
                operation="NOT"
            },
        },
        [L["Quest"]] = { name=L["Quest"], { type="ItemType", itype = itemTypeReverse["Quest"].id }, { type="Tooltip", text="ITEM_BIND_QUEST" } },
        [L["Trash"]] = { name=L["Trash"], { type="Quality", quality = 0, comp = "<=" } },
        [L["TrashEquip"]] = {
            name=L["TrashEquip"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                operation="OR"
            },
            {
                type="Quality",
                quality = 0,
                comp = "<=",
                operation="AND"
            },
            {
                type="PeriodicTable Set",
                setname="Tradeskill.Tool",
                operation="NOT"
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Quest"].id,
                operation="NOT" },
            },
        [L["Other"]] = { name=L["Other"], { type="Other" } },
        [L["Empty"]] = { name=L["Empty"], { type="Empty" }, },
        [L["Bags"]] = { name=L["Bags"], { type="Bag", bagid=1 }, { type="Bag", bagid=2, operation="OR" }, { type="Bag", bagid=3, operation="OR" }, { type="Bag", bagid=4, operation="OR" },{ type="Bag", bagid=5, operation="OR" },{ type="Bag", bagid=0, operation="OR" }, },
        [L["BankBags"]] = { name=L["BankBags"], { type="Bag", bagid=-1 }, { type="Bag", bagid=5, operation="OR" }, { type="Bag", bagid=6, operation="OR" }, { type="Bag", bagid=7, operation="OR" }, { type="Bag", bagid=8, operation="OR" }, { type="Bag", bagid=9, operation="OR" }, { type="Bag", bagid=10, operation="OR" }, { type="Bag", bagid=11, operation="OR" }, },
        [L["Potions"]] = {
            name=L["Potions"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Potion"],
            },
        },
        [L["Flasks & Elixirs"]] = {
            name=L["Flasks & Elixirs"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Flask"],
            },
            {
                operation = "OR",
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Elixir"],
            },
        },
        [L["Food & Drink"]] = {
            name=L["Food & Drink"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Food & Drink"],
            },
        },
        [L["FirstAid"]] = {
            name=L["FirstAid"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Bandage"],
            },
        },
        [L["Item Enhancements"]] = {
            name=L["Item Enhancements"],
            {
                type="ItemType",
                itype = itemTypeReverse["Item Enhancement"].id
            },
        },
        [L["Tradeskill Mats"]] = {
            name=L["Tradeskill Mats"],
            {
                type="ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
            },
        },
        [L["Elemental"]] = {
            name=L["Elemental"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Elemental"],
            },
        },
        [L["Cloth"]] = {
            name=L["Cloth"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Cloth"],
            },
        },
        [L["Leather"]] = {
            name=L["Leather"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Leather"],
            },
        },
        [L["Metal & Stone"]] = {
            name=L["Metal & Stone"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Metal & Stone"],
            },
        },
        [L["Cooking"]] = {
            name=L["Cooking"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Cooking"],
            },
        },
        [L["Herb"]] = {
            name=L["Herb"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Herb"],
            },
        },
        [L["Enchanting"]] = {
            name=L["Enchanting"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Enchanting"],
            },
        },
        [L["Jewelcrafting"]] = {
            name=L["Jewelcrafting"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Jewelcrafting"],
            },
        },
        [L["Engineering"]] = {
            name=L["Parts"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Parts"],
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Explosives and Devices"],
                operation = "OR",
            }
        },
        [L["Inscription"]] = {
            name = L["Inscription"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Tradeskill"].id,
                isubtype = itemTypeReverse["Tradeskill"].subTypes["Inscription"],
            }
        },
        [L["Item Enchantment"]] = {
            name=L["Item Enchantment"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Item Enhancement"].id
            },
        },
        [L["Recipes"]] = {
            name=L["Recipes"],
            {
                type="ItemType",
                itype = itemTypeReverse["Recipe"].id,
            },
        },
        [L["Tools"]] = {
            name=L["Tools"],
            {
                setname="Tradeskill.Tool",
                type="PeriodicTable Set"
            },
            {
                operation="NOT",
                type="PeriodicTable Set",
                setname="Tradeskill.Tool.Fishing"
            },
        },
        [L["Fishing"]] = {
            name=L["Fishing"],
            {
                setname="Tradeskill.Tool.Fishing",
                type="PeriodicTable Set"
            },
        },
        ["Mounts"] = {
            name="Mounts",
            {
                type="ItemType",
                itype = itemTypeReverse["Miscellaneous"].id,
                isubtype = itemTypeReverse["Miscellaneous"].subTypes["Mount"],
            }
        },
        ["Mount Equipment"] = {
            name="Mount Equipment",
            {
                type="ItemType",
                itype = itemTypeReverse["Miscellaneous"].id,
                isubtype = itemTypeReverse["Miscellaneous"].subTypes["Mount Equipment"],
            }
        },
        [L["Equipment Set"]] = {
            name=L["Equipment Set"],
            {
                anyset=true,
                type="EquipmentSet"
            },
        },
        ["Pets"] = {
            name="Pets",
            {
                type="ItemType",
                itype = itemTypeReverse["Battle Pets"].id,
                isubtype = itemTypeReverse["Battle Pets"].subTypes["All"],
            },
            {
                operation="OR",
                type="ItemType",
                itype = itemTypeReverse["Miscellaneous"].id,
                isubtype = itemTypeReverse["Miscellaneous"].subTypes["Companion Pets"],
            },
        },
        ["Teleport Items"] = {
            name="Teleport Items",
            {
                type="Teleport",
            }
        },
        ["Conduit"] = {
            name="Conduit Items",
            {
                type="Conduit",
            }
        },
        ["Keystone"] = {
            name="Keystone",
            {
                type="Keystone",
            }
        },
        ["Lockbox"] = {
            name="Lockbox",
            {
                type="Lockbox",
            }
        },
        ["Toys"] = {
            name="Toys",
            {
                type="Toys",
            }
        },
        ["Gems"] = {
            name="Gems",
            {
                type="ItemType",
                itype = itemTypeReverse["Gem"].id,
            }
        },
        [L["New"]] = { { ["name"] = L["New"], ["type"] = "NewItems" }, },
    }
end

if Baggins:IsClassicWow() then
    Baggins.defaultcategories = {
        [L["Consumables"]] = {
            name=L["Consumables"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id
            }
        },
        [L["Armor"]] = {
            name=L["Armor"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"],
                operation="NOT"
            },
        },
        [L["Weapons"]] = {
            name=L["Weapons"],
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"]
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                isubtype = itemTypeReverse["Weapon"].subTypes["Miscellaneous"],
                operation="NOT"
            },
        },
        [L["Quest"]] = { name=L["Quest"], { type="ItemType", itype = itemTypeReverse["Quest"].id }, { type="Tooltip", text="ITEM_BIND_QUEST" } },
        [L["Trash"]] = { name=L["Trash"], { type="Quality", quality = 0, comp = "<=" } },
        [L["TrashEquip"]] = {
            name=L["TrashEquip"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                operation="OR"
            },
            {
                type="Quality",
                quality = 0,
                comp = "<=",
                operation="AND"
            },
            {
                type="PeriodicTable Set",
                setname="Tradeskill.Tool",
                operation="NOT"
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Quest"].id,
                operation="NOT" },
            },
        [L["Other"]] = { name=L["Other"], { type="Other" } },
        [L["Empty"]] = { name=L["Empty"], { type="Empty" }, },
        [L["Bags"]] = { name=L["Bags"], { type="Bag", bagid=1 }, { type="Bag", bagid=2, operation="OR" }, { type="Bag", bagid=3, operation="OR" }, { type="Bag", bagid=4, operation="OR" }, { type="Bag", bagid=0, operation="OR" }, },
        [L["BankBags"]] = { name=L["BankBags"], { type="Bag", bagid=-1 }, { type="Bag", bagid=5, operation="OR" }, { type="Bag", bagid=6, operation="OR" }, { type="Bag", bagid=7, operation="OR" }, { type="Bag", bagid=8, operation="OR" }, { type="Bag", bagid=9, operation="OR" }, { type="Bag", bagid=10, operation="OR" }, { type="Bag", bagid=11, operation="OR" }, },
        [L["Tradeskill Mats"]] = {
            name=L["Tradeskill Mats"],
            {
                type="ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
            },
        },
        [L["Engineering"]] = {
            name=L["Parts"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Parts"],
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Explosives"],
                operation = "OR",
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Devices"],
                operation = "OR",
            }
        },
        [L["Recipes"]] = {
            name=L["Recipes"],
            {
                type="ItemType",
                itype = itemTypeReverse["Recipe"].id,
            },
        },
        [L["Tools"]] = {
            name=L["Tools"],
            {
                setname="Tradeskill.Tool",
                type="PeriodicTable Set"
            },
            {
                operation="NOT",
                type="PeriodicTable Set",
                setname="Tradeskill.Tool.Fishing"
            },
        },
        [L["Fishing"]] = {
            name=L["Fishing"],
            {
                setname="Tradeskill.Tool.Fishing",
                type="PeriodicTable Set"
            },
        },
        [L["New"]] = { { ["name"] = L["New"], ["type"] = "NewItems" }, },
    }
end

if Baggins:IsTBCWow() then
    Baggins.defaultcategories = {
        [L["Misc Consumables"]] = {
            name=L["Misc Consumables"],
            {
                type="ItemType" ,
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Other"],
            }
        },
        [L["Consumables"]] = {
            name=L["Consumables"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id
            }
        },
        [L["Armor"]] = {
            name=L["Armor"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"],
                operation="NOT"
            },
        },
        [L["Weapons"]] = {
            name=L["Weapons"],
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"]
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                isubtype = itemTypeReverse["Weapon"].subTypes["Miscellaneous"],
                operation="NOT"
            },
        },
        [L["Quest"]] = { name=L["Quest"], { type="ItemType", itype = itemTypeReverse["Quest"].id }, { type="Tooltip", text="ITEM_BIND_QUEST" } },
        [L["Trash"]] = { name=L["Trash"], { type="Quality", quality = 0, comp = "<=" } },
        [L["TrashEquip"]] = {
            name=L["TrashEquip"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                operation="OR"
            },
            {
                type="Quality",
                quality = 0,
                comp = "<=",
                operation="AND"
            },
            {
                type="PeriodicTable Set",
                setname="Tradeskill.Tool",
                operation="NOT"
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Quest"].id,
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
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Potion"],
            },
        },
        [L["Flasks & Elixirs"]] = {
            name=L["Flasks & Elixirs"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Flask"],
            },
            {
                operation = "OR",
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Elixir"],
            },
        },
        [L["Food & Drink"]] = {
            name=L["Food & Drink"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Food & Drink"],
            },
        },
        [L["FirstAid"]] = {
            name=L["FirstAid"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Bandage"],
            },
        },
        [L["Tradeskill Mats"]] = {
            name=L["Tradeskill Mats"],
            {
                type="ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
            },
        },
        [L["Elemental"]] = {
            name=L["Elemental"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Elemental"],
            },
        },
        [L["Metal & Stone"]] = {
            name=L["Metal & Stone"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Metal & Stone"],
            },
        },
        [L["Herb"]] = {
            name=L["Herb"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Herb"],
            },
        },
        [L["Enchanting"]] = {
            name=L["Enchanting"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Enchanting"],
            },
        },
        [L["Engineering"]] = {
            name=L["Parts"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Parts"],
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Explosives"],
                operation="OR"
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Devices"],
                operation="OR"
            }
        },
        [L["Recipes"]] = {
            name=L["Recipes"],
            {
                type="ItemType",
                itype = itemTypeReverse["Recipe"].id,
            },
        },
        [L["Tools"]] = {
            name=L["Tools"],
            {
                setname="Tradeskill.Tool",
                type="PeriodicTable Set"
            },
            {
                operation="NOT",
                type="PeriodicTable Set",
                setname="Tradeskill.Tool.Fishing"
            },
        },
        [L["Fishing"]] = {
            name=L["Fishing"],
            {
                setname="Tradeskill.Tool.Fishing",
                type="PeriodicTable Set"
            },
        },
        ["Gems"] = {
            name="Gems",
            {
                type="ItemType",
                itype = itemTypeReverse["Gem"].id,
            }
        },
        [L["Cooking"]] = {
            name=L["Cooking"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Meat"],
            },
        },
        [L["New"]] = { { ["name"] = L["New"], ["type"] = "NewItems" }, },
    }
end

if Baggins:IsWrathWow() then
    Baggins.defaultcategories = {
        [L["Misc Consumables"]] = {
            name=L["Misc Consumables"],
            {
                type="ItemType" ,
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Other"],
            }
        },
        [L["Consumables"]] = {
            name=L["Consumables"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id
            }
        },
        [L["Armor"]] = {
            name=L["Armor"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"],
                operation="NOT"
            },
        },
        [L["Weapons"]] = {
            name=L["Weapons"],
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"]
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                isubtype = itemTypeReverse["Weapon"].subTypes["Miscellaneous"],
                operation="NOT"
            },
        },
        [L["Quest"]] = { name=L["Quest"], { type="ItemType", itype = itemTypeReverse["Quest"].id }, { type="Tooltip", text="ITEM_BIND_QUEST" } },
        [L["Trash"]] = { name=L["Trash"], { type="Quality", quality = 0, comp = "<=" } },
        [L["TrashEquip"]] = {
            name=L["TrashEquip"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                operation="OR"
            },
            {
                type="Quality",
                quality = 0,
                comp = "<=",
                operation="AND"
            },
            {
                type="PeriodicTable Set",
                setname="Tradeskill.Tool",
                operation="NOT"
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Quest"].id,
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
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Potion"],
            },
        },
        [L["Flasks & Elixirs"]] = {
            name=L["Flasks & Elixirs"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Flask"],
            },
            {
                operation = "OR",
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Elixir"],
            },
        },
        [L["Food & Drink"]] = {
            name=L["Food & Drink"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Food & Drink"],
            },
        },
        [L["FirstAid"]] = {
            name=L["FirstAid"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Bandage"],
            },
        },
        [L["Tradeskill Mats"]] = {
            name=L["Tradeskill Mats"],
            {
                type="ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
            },
        },
        [L["Elemental"]] = {
            name=L["Elemental"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Elemental"],
            },
        },
        [L["Metal & Stone"]] = {
            name=L["Metal & Stone"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Metal & Stone"],
            },
        },
        [L["Herb"]] = {
            name=L["Herb"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Herb"],
            },
        },
        [L["Enchanting"]] = {
            name=L["Enchanting"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Enchanting"],
            },
        },
        [L["Engineering"]] = {
            name=L["Parts"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Parts"],
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Explosives"],
                operation="OR"
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Devices"],
                operation="OR"
            }
        },
        [L["Recipes"]] = {
            name=L["Recipes"],
            {
                type="ItemType",
                itype = itemTypeReverse["Recipe"].id,
            },
        },
        [L["Tools"]] = {
            name=L["Tools"],
            {
                setname="Tradeskill.Tool",
                type="PeriodicTable Set"
            },
            {
                operation="NOT",
                type="PeriodicTable Set",
                setname="Tradeskill.Tool.Fishing"
            },
        },
        [L["Fishing"]] = {
            name=L["Fishing"],
            {
                setname="Tradeskill.Tool.Fishing",
                type="PeriodicTable Set"
            },
        },
        ["Gems"] = {
            name="Gems",
            {
                type="ItemType",
                itype = itemTypeReverse["Gem"].id,
            }
        },
        [L["Cooking"]] = {
            name=L["Cooking"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Meat"],
            },
        },
        [L["New"]] = { { ["name"] = L["New"], ["type"] = "NewItems" }, },
    }
end

if Baggins:IsCataWow() then
    Baggins.defaultcategories = {
        [L["Misc Consumables"]] = {
            name=L["Misc Consumables"],
            {
                type="ItemType" ,
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Other"],
            }
        },
        [L["Consumables"]] = {
            name=L["Consumables"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id
            }
        },
        [L["Armor"]] = {
            name=L["Armor"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"],
                operation="NOT"
            },
        },
        [L["Weapons"]] = {
            name=L["Weapons"],
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"]
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                isubtype = itemTypeReverse["Weapon"].subTypes["Miscellaneous"],
                operation="NOT"
            },
        },
        [L["Quest"]] = { name=L["Quest"], { type="ItemType", itype = itemTypeReverse["Quest"].id }, { type="Tooltip", text="ITEM_BIND_QUEST" } },
        [L["Trash"]] = { name=L["Trash"], { type="Quality", quality = 0, comp = "<=" } },
        [L["TrashEquip"]] = {
            name=L["TrashEquip"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                operation="OR"
            },
            {
                type="Quality",
                quality = 0,
                comp = "<=",
                operation="AND"
            },
            {
                type="PeriodicTable Set",
                setname="Tradeskill.Tool",
                operation="NOT"
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Quest"].id,
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
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Potion"],
            },
        },
        [L["Flasks & Elixirs"]] = {
            name=L["Flasks & Elixirs"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Flask"],
            },
            {
                operation = "OR",
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Elixir"],
            },
        },
        [L["Food & Drink"]] = {
            name=L["Food & Drink"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Food & Drink"],
            },
        },
        [L["FirstAid"]] = {
            name=L["FirstAid"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Bandage"],
            },
        },
        [L["Tradeskill Mats"]] = {
            name=L["Tradeskill Mats"],
            {
                type="ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
            },
        },
        [L["Elemental"]] = {
            name=L["Elemental"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Elemental"],
            },
        },
        [L["Metal & Stone"]] = {
            name=L["Metal & Stone"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Metal & Stone"],
            },
        },
        [L["Herb"]] = {
            name=L["Herb"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Herb"],
            },
        },
        [L["Enchanting"]] = {
            name=L["Enchanting"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Enchanting"],
            },
        },
        [L["Engineering"]] = {
            name=L["Parts"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Parts"],
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Explosives"],
                operation="OR"
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Devices"],
                operation="OR"
            }
        },
        [L["Recipes"]] = {
            name=L["Recipes"],
            {
                type="ItemType",
                itype = itemTypeReverse["Recipe"].id,
            },
        },
        [L["Tools"]] = {
            name=L["Tools"],
            {
                setname="Tradeskill.Tool",
                type="PeriodicTable Set"
            },
            {
                operation="NOT",
                type="PeriodicTable Set",
                setname="Tradeskill.Tool.Fishing"
            },
        },
        [L["Fishing"]] = {
            name=L["Fishing"],
            {
                setname="Tradeskill.Tool.Fishing",
                type="PeriodicTable Set"
            },
        },
        ["Gems"] = {
            name="Gems",
            {
                type="ItemType",
                itype = itemTypeReverse["Gem"].id,
            }
        },
        [L["Cooking"]] = {
            name=L["Cooking"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Meat"],
            },
        },
        [L["New"]] = { { ["name"] = L["New"], ["type"] = "NewItems" }, },
        [L["Equipment Set"]] = {
            name=L["Equipment Set"],
            {
                anyset=true,
                type="EquipmentSet"
            },
        },
    }
end

if Baggins:IsMistWow() then
    Baggins.defaultcategories = {
        [L["Misc Consumables"]] = {
            name=L["Misc Consumables"],
            {
                type="ItemType" ,
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Other"],
            }
        },
        [L["Consumables"]] = {
            name=L["Consumables"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id
            }
        },
        [L["Armor"]] = {
            name=L["Armor"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"],
                operation="NOT"
            },
        },
        [L["Weapons"]] = {
            name=L["Weapons"],
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id,
                isubtype = itemTypeReverse["Armor"].subTypes["Shields"]
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                isubtype = itemTypeReverse["Weapon"].subTypes["Miscellaneous"],
                operation="NOT"
            },
        },
        [L["Quest"]] = { name=L["Quest"], { type="ItemType", itype = itemTypeReverse["Quest"].id }, { type="Tooltip", text="ITEM_BIND_QUEST" } },
        [L["Trash"]] = { name=L["Trash"], { type="Quality", quality = 0, comp = "<=" } },
        [L["TrashEquip"]] = {
            name=L["TrashEquip"],
            {
                type="ItemType",
                itype = itemTypeReverse["Armor"].id
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Weapon"].id,
                operation="OR"
            },
            {
                type="Quality",
                quality = 0,
                comp = "<=",
                operation="AND"
            },
            {
                type="PeriodicTable Set",
                setname="Tradeskill.Tool",
                operation="NOT"
            },
            {
                type="ItemType",
                itype = itemTypeReverse["Quest"].id,
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
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Potion"],
            },
        },
        [L["Flasks & Elixirs"]] = {
            name=L["Flasks & Elixirs"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Flask"],
            },
            {
                operation = "OR",
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Elixir"],
            },
        },
        [L["Food & Drink"]] = {
            name=L["Food & Drink"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Food & Drink"],
            },
        },
        [L["FirstAid"]] = {
            name=L["FirstAid"],
            {
                type="ItemType",
                itype = itemTypeReverse["Consumable"].id,
                isubtype = itemTypeReverse["Consumable"].subTypes["Bandage"],
            },
        },
        [L["Tradeskill Mats"]] = {
            name=L["Tradeskill Mats"],
            {
                type="ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
            },
        },
        [L["Elemental"]] = {
            name=L["Elemental"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Elemental"],
            },
        },
        [L["Metal & Stone"]] = {
            name=L["Metal & Stone"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Metal & Stone"],
            },
        },
        [L["Herb"]] = {
            name=L["Herb"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Herb"],
            },
        },
        [L["Enchanting"]] = {
            name=L["Enchanting"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Enchanting"],
            },
        },
        [L["Engineering"]] = {
            name=L["Parts"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Parts"],
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Explosives"],
                operation="OR"
            },
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Devices"],
                operation="OR"
            }
        },
        [L["Recipes"]] = {
            name=L["Recipes"],
            {
                type="ItemType",
                itype = itemTypeReverse["Recipe"].id,
            },
        },
        [L["Tools"]] = {
            name=L["Tools"],
            {
                setname="Tradeskill.Tool",
                type="PeriodicTable Set"
            },
            {
                operation="NOT",
                type="PeriodicTable Set",
                setname="Tradeskill.Tool.Fishing"
            },
        },
        [L["Fishing"]] = {
            name=L["Fishing"],
            {
                setname="Tradeskill.Tool.Fishing",
                type="PeriodicTable Set"
            },
        },
        ["Gems"] = {
            name="Gems",
            {
                type="ItemType",
                itype = itemTypeReverse["Gem"].id,
            }
        },
        [L["Cooking"]] = {
            name=L["Cooking"],
            {
                type = "ItemType",
                itype = itemTypeReverse["Trade Goods"].id,
                isubtype = itemTypeReverse["Trade Goods"].subTypes["Meat"],
            },
        },
        [L["New"]] = { { ["name"] = L["New"], ["type"] = "NewItems" }, },
        [L["Equipment Set"]] = {
            name=L["Equipment Set"],
            {
                anyset=true,
                type="EquipmentSet"
            },
        },
    }
end

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

--function new() return {} end
--function del(t) wipe(t) end
--rdel = del


---------------------
-- Dynamic Options --
---------------------
local moneyBagChoices = {}
function Baggins:GetMoneyBagChoices() --luacheck: ignore 212
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

function Baggins:BuildMoneyBagOptions() --luacheck: ignore 212
    wipe(moneyBagChoices)
end

local bankControlBagChoices = {}
function Baggins:GetBankControlsBagChoices() --luacheck: ignore 212
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

function Baggins:BuildBankControlsBagOptions() --luacheck: ignore 212
    wipe(bankControlBagChoices)
end

------------------------
-- Profile Management --
------------------------

function Baggins:ApplyProfile(profile)
    local p = self.db.profile
    if not p then return end
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

function Baggins:OnProfileEnable()
    local p = self.db.profile
    if not p then return end
    --check if this profile has been setup before, if not add the default bags and categories
    --cant leave these in the defaults since removing a bag would have it come back on reload
    local refresh = false --luacheck: ignore 431
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
    self:Baggins_RefreshBags()
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
    Baggins:ReallyUpdateBags()
end

local function openBagCategoryConfig()
    Baggins:OpenEditConfig()
end

local function openBagginsConfig()
    Baggins:OpenConfig()
end

function Baggins:DoBagMenu()
    local p = self.db.profile
    if not p then return end
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
        Baggins:EasyMenu(menu, bagDropdownMenuFrame, "cursor", 0, 0, "MENU")
    end
end

--------------------
-- Edit Rule Menu --
--------------------
function Baggins:setRuleOperation(rule,operation) --luacheck: ignore 212
    rule.operation = operation
    Baggins:OnRuleChanged()
end

function Baggins:setRuleType(rule,ruletype) --luacheck: ignore 212
    rule.ruletype = ruletype
    Baggins:CleanRule(rule)
    Baggins:OnRuleChanged()
end

local function newBag()
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

local function getArgValue(info)
    return info.arg[info[#info]]
end

local function setArgValue(info, value)
    info.arg[info[#info]] = value
    Baggins:ReallyUpdateBags()
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

local function confirmRemoveSection()
    return L["Are you sure you want to delete this Section? this cannot be undone"]
end

local function getBagPriority(info)
    return info.arg.priority or 1
end

local function setBagPriority(info, value)
    Baggins:ResortSections()
    Baggins:Baggins_RefreshBags()
    info.arg.priority = value
end

local function setAllowdupes(info, value)
    info.arg.allowdupes = value
    Baggins:ResortSections()
    Baggins:ForceFullRefresh()
    Baggins:Baggins_RefreshBags()
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
    if from_id == to_id then return end

    local bags = self.db.profile.bags

    for _, v in ipairs(bags[from_id].sections) do
        tinsert(bags[to_id].sections,v)
    end

    self:ChangeProfile()
end

local bags_list = { }
local function ListBagsExcept(bagid)
    wipe(bags_list)
    for id, bag in ipairs(Baggins.db.profile.bags) do
        if id ~= bagid then
            bags_list[id] = bag.name
        end
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
        local bagListExceptSelected = ListBagsExcept(bagid)
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
                    values = bagListExceptSelected,
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

local function confirmRemoveCategory()
    return L["Are you sure you want to remove this Category? this cannot be undone"]
end

local function isCategoryInUse(info)
    return Baggins:CategoryInUse(info.arg)
end

local function addNewRule(info, value)
    local name = info[#info - 1]:sub(2)
    tinsert(info.arg, { type = value })
    Baggins:RebuildCategoryRules(name)
    Baggins:AddRule()
end

function Baggins:RebuildCategoryOptions()
    local categories = Baggins.db.profile.categories
    local args = wipe(self.editOpts.args.Categories.args)
    args.new = {
        name = "Create",
        desc = "",
        type = 'input',
        get = noop,
        set = function(_, value)
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
    self:RebuildBagOptions()
    self:BuildMoneyBagOptions()
    self:BuildBankControlsBagOptions()

    AceConfig:RegisterOptionsTable("BagginsEdit", function()
        Baggins:RebuildCategoryOptions()
        return opts
    end)
end
