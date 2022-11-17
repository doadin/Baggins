local LibStub = _G.LibStub
local debug = false
local L = LibStub("AceLocale-3.0"):NewLocale("Baggins", "enUS", true, debug)
if not L then return end

--itemtypes, these must match the Type and SubType returns from GetItemInfo for the ItemType rule to work
L["Battle Pets"] = true
--end of localizations needed for rules to work

-- Translations for default-categories
L["Baggins"] = true
L["Toggle All Bags"] = true
L["Columns"] = true
L["Number of Columns shown in the bag frames"] = true
L["Layout"] = true
L["Layout of the bag frames."] = true
L["Automatic"] = true
L["Automatically arrange the bag frames as the default ui does"] = true
L["Manual"] = true
L["Each bag frame can be positioned manually."] = true
L["Show Section Title"] = true
L["Show a title on each section of the bags"] = true
L["Sort"] = true
L["How items are sorted"] = true
L["Quality"] = true
L["Items are sorted by quality."] = true
L["Name"] = true
L["Items are sorted by name."] = true
L["Hide Empty Sections"] = true
L["Hide sections that have no items in them."] = true
L["Hide Empty Bags"] = true
L["Hide bags that have no items in them."] = true
L["Hide Default Bank"] = true
L["Hide the default bank window."] = true
L["FuBar Text"] = true
L["Options for the text shown on fubar"] = true
L["Show empty bag slots"] = true
L["Show used bag slots"] = true
L["Show Total bag slots"] = true
L["Combine Counts"] = true
L["Show only one count with all the seclected types included"] = true
L["Show Ammo Bags Count"] = true
L["Show Soul Bags Count"] = true
L["Show Specialty Bags Count"] = true
L["Show Specialty (profession etc) Bags Count"] = true
L["Set Layout Bounds"]= true
L["Shows a frame you can drag and size to set where the bags will be placed when Layout is automatic"] = true
L["Lock"] = true
L["Locks the bag frames making them unmovable"] = true
L["Shrink Width"] = true
L["Shrink the bag's width to fit the items contained in them"] = true
L["Compress"] = true
L["Compress Multiple stacks into one item button"] = true
L["Compress All"] = true
L["Show all items as a single button with a count on it"] = true
L["Compress Empty Slots"] = true
L["Show all empty slots as a single button with a count on it"] = true
L["Compress Soul Shards"] = true
L["Show all soul shards as a single button with a count on it"] = true
L["Compress Ammo"] = true
L["Show all ammo as a single button with a count on it"] = true
L["Quality Colors"]= true
L["Color item buttons based on the quality of the item"] = true
L["Enable"] = true
L["Enable quality coloring"] = true
L["Color Threshold"] = true
L["Only color items of this quality or above"] = true
L["Color Intensity"] = true
L["Intensity of the quality coloring"] = true
L["Edit Bags"] = true
L["Edit the Bag Definitions"] = true
L["Edit Categories"] = true
L["Edit the Category Definitions"] = true
L["Load Profile"] = true
L["Load a built-in profile: NOTE: ALL Custom Bags will be lost and any edited built in categories will be lost."] = true
L["Default"] = true
L["A default set of bags sorting your inventory into categories"] = true
L["All in one"] = true
L["A single bag containing your whole inventory, sorted by quality"] = true
L["Scale"] = true
L["Scale of the bag frames"] = true
        --bagtypes
L["Backpack"] = true
L["Bag 1"] = true
L["Bag 2"] = true
L["Bag 3"] = true
L["Bag 4"] = true
L["Bag 5"] = true
L["Bank Frame"] = true
L["Bank Bag 1"] = true
L["Bank Bag 2"] = true
L["Bank Bag 3"] = true
L["Bank Bag 4"] = true
L["Bank Bag 5"] = true
L["Bank Bag 6"] = true
L["Bank Bag 7"] = true
L["Reagent Bank"] = true
L["KeyRing"] = true

        --quality names
L["Poor"] = true
L["Common"] = true
L["Uncommon"] = true
L["Rare"] = true
L["Epic"] = true
L["Legendary"] = true
L["Artifact"] = true

L["None"] = true
L["All"] = true

L["Item Type"] = true
L["Filter by Item type and sub-type as returned by GetItemInfo"] = true
L["ItemType - "] = true
L["Item Type Options"] = true
L["Item Subtype"] = true

L["Container Type"] = true
L["Filter by the type of container the item is in."] = true
L["Container : "] = true
L["Container Type Options"] = true

L["Item ID"] = true
L["Filter by ItemID, this can be a space delimited list or ids to match."] = true
L["ItemIDs "] = true
L["ItemID Options"] = true
L["Item IDs (space seperated list)"] = true
L["New"] = true
L["Current IDs, click to remove"] = true

L["Filter by the bag the item is in"] = true
L["Bag "] = true
L["Bag Options"] = true
L["Ignore Empty Slots"] = true

L["Item Name"] = true
L["Filter by Name or partial name"] = true
L["Name: "] = true
L["Item Name Options"] = true
L["String to Match"] = true

L["PeriodicTable Set"] = true
L["Filter by PeriodicTable Set"] = true
L["Periodic Table Set Options"] = true
L["Set"] = true

L["Empty Slots"] = true
L["Empty bag slots"] = true

L["Ammo Bag"] = true
L["Items in an ammo pouch or quiver"] = true
L["Ammo Bag Slots"] = true

L["Quality"] = true
L["Filter by Item Quality"] = true
L["Quality Options"] = true
L["Comparison"] = true

L["Equip Location"] = true
L["Filter by Equip Location as returned by GetItemInfo"] = true

L["Equip Location Options"] = true
L["Location"] = true

L["Unfiltered Items"] = true
L["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"] = true
L["Unfiltered"] = true

L["Bind"] = true
L["Filter based on if the item binds, or if it is already bound"] = true
L["Bind *unset*"] = true
L["Unbound"] = true
L["Bind Options"] = true
L["Bind Type"] = true
L["Binds on pickup"] = true -- DEPRICATED
L["Binds on equip"] = true -- DEPRICATED
L["Binds on use"] = true -- DEPRICATED
L["Soulbound"] = true -- DEPRICATED

L["Tooltip"] = true
L["Filter based on text contained in its tooltip"] = true
L["Tooltip Options"] = true

L["ItemID: "] = true
L["Item Type: "] = true
L["Item Subtype: "] = true

L["Click a bag to toggle it. Shift-click to move it up. Alt-click to move it down"] = true

L["Bags"] = true
L["Options"] = true
L["Open With All"] = true
L["Bank"] = true
L["Sections"] = true
L["Categories"] = true
L["Add Category"] = true
L["New Section"] = true
L["New Bag"] = true
L["Close"] = true
L["Click on an entry to open. Shift-Click to move up. Alt-Click to move down. Ctrl-Click to delete."] = true
L["Rules"] = true
L["New Rule"] = true
L["Add Rule"] = true
L["New Category"] = true
L["Apply"] = true
L["Click on an entry to open. Ctrl-Click to delete."] = true

L["Editing Rule"] = true
L["Type"] = true
L["Select a rule type to create the rule"] = true
L["Operation"] = true
L["AND"] = true
L["OR"] = true
L["NOT"] = true

L["Baggins - New Bag"] = true
L["Baggins - New Section"] = true
L["Baggins - New Category"] = true
L["Accept"] = true
L["Cancel"] = true

L["Are you sure you want to delete this Bag? this cannot be undone"] = true
L["Are you sure you want to delete this Section? this cannot be undone"] = true
L["Are you sure you want to remove this Category? this cannot be undone"] = true
L["Are you sure you want to remove this Rule? this cannot be undone"] = true
L["Delete"] = true
L["Cancel"] = true

L["That category is in use by one or more bags, you cannot delete it."] = true
L["A category with that name already exists."] = true

L["Drag to Move\nRight-Click to Close"] = true
L["Drag to Size"] = true

L["Previous "] = true
L["Next "] = true

L["All In One"] = true
L["Bank All In One"] = true
L["Bank Bags"] = true

L["Armor"] = true
L["Equipment"] = true
L["In Use"] = true
L["Weapons"] = true
L["Quest Items"] = true
L["Consumables"] = true
    L["Water"] = true -- Deprecated
    L["Food"] = true -- Deprecated
L["FirstAid"] = true
L["Potions"] = true
L["Scrolls"] = true
L["Food & Drink"] = true
L["Flasks & Elixirs"] = true
L["Item Enhancements"] = true
L["Misc"] = true
L["Misc Consumables"] = true
L["Elemental"] = true
L["Cloth"] = true
L["Leather"] = true
L["Metal & Stone"] = true
L["Cooking"] = true
L["Herb"] = true
L["Enchanting"] = true
L["Jewelcrafting"] = true
L["Engineering"] = true
L["Inscription"] = true
L["Misc Trade Goods"] = true
L["Item Enchantment"] = true
L["Professions"] = true
L["Fishing"] = true
L["Tools"] = true
L["Parts"] = true
L["Quest"] = true
L["First Aid"] = true
L["Trade Goods"] = true
L["Mats"] = true
L["Tradeskill Mats"] = true
L["Recipes"] = true
    L["Gathered"] = true -- Deprecated
L["Bag"] = true
L["BankBags"] = true
L["Ammo"] = true
L["AmmoBag"] = true
L["SoulShards"] = true
L["SoulBag"] = true
L["Other"] = true
L["Trash"] = true
L["TrashEquip"] = true
L["Empty"] = true
L["Bank Equipment"] = true
L["Bank Quest"] = true
L["Bank Consumables"] = true
L["Bank Trade Goods"] = true
L["Bank Other"] = true

L["Add To Category"] = true
L["Exclude From Category"] = true
L["Item Info"] = true
L["Use"] = true
    L["Use/equip the item rather than bank/sell it"] = true
L["Quality: "] = true
L["Item Level: "] = true
L["Required Level: "] = true
L["Stack Size: "] = true
L["Equip Location: "] = true
L["Periodic Table Sets"] = true

L["Highlight New Items"] = true
L["Add *New* to new items, *+++* to items that you have gained more of."] = true
L["Reset New Items"] = true
L["Resets the new items highlights."] = true
L["*New*"] = true

L["Hide Duplicate Items"] = true
L["Prevents items from appearing in more than one section/bag."] = true

L["Optimize Section Layout"] = true
L["Change order and layout of sections in order to save display space."] = true

L["All In One Sorted"]= true
L["A single bag containing your whole inventory, sorted into categories"]= true

L["Compress Stackable Items"]= true
L["Show stackable items as a single button with a count on it"]= true

L["Appearance and layout"]= true
L["Bags"]= true
L["Bag display and layout settings"]= true
L["Layout Type"]= true
L["Sets how all bags are laid out on screen."]= true
L["Shrink bag title"]= true
L["Mangle bag title to fit to content width"]= true
L["Sections"]= true
L["Bag sections display and layout settings."]= true
L["Items"]= true
L["Item display settings"]= true
L["Bag Skin"]= true
L["Select bag skin"]= true

L["Compress bag contents"]= true
L["Split %d"]= true
L["Split_tooltip"] = "Click to split items according to slider setting\nand automatically place in an empty slot.\n\nHold down shift to only pick up."

L["PT3 LoD Modules"] = true
L["Choose PT3 LoD Modules to load at startup, Will load immediately when checked"] = true
L["Load %s at Startup"] = true

L["Disable Compression Temporarily"] = true
L["Disabled Item Compression until the bags are closed."] = true

L["Always Resort"] = true
L["Keeps Items sorted always, this will cause items to jump around when selling etc."] = true

L["Force Full Refresh"] = true
L["Forces a Full Refresh of item sorting"] = true

L["Override Default Bags"] = true
L["Baggins will open instead of the default bags"] = true
L["Sort New First"] = true
L["Sorts New Items to the beginning of sections"] = true
L["New Items"] = true

L["Items that match another category"] = true
L["Category Options"] = true
L["Category"] = true

L["Layout Anchor"] = true
L["Sets which corner of the layout bounds the bags will be anchored to."] = true
L["Top Right"] = true
L["Top Left"] = true
L["Bottom Right"] = true
L["Bottom Left"] = true

L["Show Money On Bag"] = true
L["Which Bag to Show Money On"] = true

L["Show Bank Controls On Bag"] = true
L["Which Bag to Show Bank Controls On"] = true

L["User Defined"] = true
L["Load a User Defined Profile"] = true
L["Save Profile"] = true
L["Save a User Defined Profile"] = true
L["New"] = true
L["Create a new Profile"] = true
L["Delete Profile"] = true
L["Delete a User Defined Profile"] = true
L["Save"] = true
L["Load"] = true
L["Delete"] = true

L["Config Window"] = true
L["Opens the Waterfall Config window"] = true
L["Bag/Category Config"] = true
L["Opens the Waterfall Config window"] = true
L["Rename / Reorder"] = true
L["From Profile"] = true
L["User"] = true
L["Copy From"] = true
L["Edit"] = true
L["Automatically open at auction house"] = true
L["Create"] = true
L["Bag Priority"] = true
L["Section Priority"] = true

L["Allow Duplicates"] = true
L["Import Sections From"] = true

L["Item Level"] = true
L["Filter by item's level - either \"ilvl\" or minimum required level"] = true
L["ReqLvl"] = true
L["ILvl"] = true
L["Item Level Options"] = true
L["Include Level 0"] = true
L["Include Level 1"] = true
L["Look at Required Level"] = true
L["Look at Item's \"ILvl\""] = true
L["From level:"] = true
L["... plus Player's Level"] = true
L["To level:"] = true
L["... plus Player's Level"] = true

L["Highlight quest items"] = true
L["Displays a special border around quest items and a exclamation mark over items that starts new quests."] = true

L["Add new Rule"] = true
L["Item IDs "] = true
L["Profile Management"] = true
L["Are You Sure?"] = true
L["Any"] = true

L["Equipment Set"] = true
L["Equipment Sets"] = true
L["Filter by Equipment Set"] = true

L["Equipment Slot"] = true
L["Equipment Slots"] = true
L["Filter by Equipment Slot"] = true

L["Minimap icon"] = true
L["Show an icon at the minimap if no Broker-Display is present."] = true

L["Presets"] = true
L["|cffff0000WARNING|cffffffff: Pressing the button will reset your complete profile! If you're not sure about this, create a new profile and use that to experiment."] = true
L["You can use the preset defaults as a starting point for setting up your interface."] = true
L["Reset Profile"] = true

L["Skin '%s' not found, resetting to default"] = true

L["Buy Bank Bag Slot"] = true
L["Buy Reagent Bank"] = true
L["Deposit All Reagents"] = true
L["Crafting Reagent"] = true
L["Reagent Deposit"] = true
L["Automatically deposits crafting reagents into the reagent bank if available."] = true

L["Disable Bag Menu"] = true
L["Disables the menu that pops up when right clicking on bags."] = true

L["Override Backpack Button"] = true
L["Baggins will open when clicking the backpack. Holding alt will open the default backpack."] = true
L["General"] = true
L["Display and Overrides"] = true
L["Display"] = true
L["Overrides"] = true

L["New Item Duration"] = true
L["Controls how long (in minutes) an item will be considered new. 0 disables the time limit."] = true
