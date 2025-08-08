local LibStub = LibStub
Baggins = LibStub("AceAddon-3.0"):NewAddon("Baggins", "AceEvent-3.0", "AceHook-3.0", "AceBucket-3.0", "AceTimer-3.0", "AceConsole-3.0")

local Baggins = Baggins

local L = LibStub("AceLocale-3.0"):GetLocale("Baggins")
local LBU = LibStub("LibBagUtils-1.0")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0", true)
local qt = LibStub('LibQTip-1.0')
local dbIcon = LibStub("LibDBIcon-1.0")
local console = LibStub("AceConsole-3.0")
local iui = LibStub("LibItemUpgradeInfo-1.0")

local next, pairs, ipairs, tonumber, select, strmatch, wipe, type, time, print =
      next, pairs, ipairs, tonumber, select, strmatch, wipe, type, time, print
local min, max, ceil, floor, mod  =
      min, max, ceil, floor, mod
local tinsert, tremove, tsort, tconcat =
      tinsert, tremove, table.sort, table.concat
local format =
      string.format
local band =
      bit.band

local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local BlizzSortBags = C_Container and C_Container.SortBags
local CloseBankFrame = C_Bank and C_Bank.CloseBankFrame or CloseBankFrame
local GetItemCount, GetItemInfo, GetInventoryItemLink, GetItemQualityColor, GetItemFamily, BankButtonIDToInvSlotID, GetNumBankSlots =
      GetItemCount, GetItemInfo, GetInventoryItemLink, GetItemQualityColor, GetItemFamily, BankButtonIDToInvSlotID, GetNumBankSlots
local GetContainerItemInfo, GetContainerItemLink, GetContainerNumFreeSlots, GetContainerItemCooldown =
    C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo, C_Container and C_Container.GetContainerItemLink or GetContainerItemLink, C_Container and C_Container.GetContainerNumFreeSlots or GetContainerNumFreeSlots, C_Container and C_Container.GetContainerItemCooldown or GetContainerItemCooldown
local BANK_PANELS = BANK_PANELS
local ItemButtonUtil = ItemButtonUtil
local IsBagOpen = IsBagOpen
local ShowInspectCursor = ShowInspectCursor
local ShowContainerSellCursor = C_Container and C_Container.ShowContainerSellCursor or ShowContainerSellCursor
local Enum = Enum and Enum


local ReagentBankButtonIDToInvSlotID, GetContainerItemQuestInfo, DepositReagentBank, IsReagentBankUnlocked =
      ReagentBankButtonIDToInvSlotID, C_Container and C_Container.GetContainerItemQuestInfo or GetContainerItemQuestInfo, DepositReagentBank and DepositReagentBank, IsReagentBankUnlocked and IsReagentBankUnlocked
local IsContainerItemAnUpgrade = IsContainerItemAnUpgrade and IsContainerItemAnUpgrade
local C_ItemUpgrade = C_ItemUpgrade and C_ItemUpgrade


local C_Item, ItemLocation, InCombatLockdown, IsModifiedClick, GetDetailedItemLevelInfo, GetContainerItemID, InRepairMode, KeyRingButtonIDToInvSlotID, C_PetJournal, C_NewItems, PlaySound =
      C_Item, ItemLocation, InCombatLockdown, IsModifiedClick, GetDetailedItemLevelInfo, C_Container and C_Container.GetContainerItemID or GetContainerItemID, InRepairMode, KeyRingButtonIDToInvSlotID, C_PetJournal, C_NewItems, PlaySound

local UseContainerItem = C_Container and C_Container.UseContainerItem or UseContainerItem

local WOW_PROJECT_ID = WOW_PROJECT_ID
local WOW_PROJECT_CLASSIC = WOW_PROJECT_CLASSIC
local WOW_PROJECT_BURNING_CRUSADE_CLASSIC = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
local WOW_PROJECT_WRATH_CLASSIC = WOW_PROJECT_WRATH_CLASSIC
local WOW_PROJECT_CATACLYSM_CLASSIC = WOW_PROJECT_CATACLYSM_CLASSIC
local WOW_PROJECT_MISTS_CLASSIC = WOW_PROJECT_MISTS_CLASSIC
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local LE_EXPANSION_LEVEL_CURRENT = LE_EXPANSION_LEVEL_CURRENT
local LE_EXPANSION_BURNING_CRUSADE = LE_EXPANSION_BURNING_CRUSADE
local LE_EXPANSION_WRATH_OF_THE_LICH_KING = LE_EXPANSION_WRATH_OF_THE_LICH_KING
local LE_EXPANSION_CATACLYSM = LE_EXPANSION_CATACLYSM
local LE_EXPANSION_MISTS_OF_PANDARIA = LE_EXPANSION_MISTS_OF_PANDARIA

-- Bank tab locals, for auto reagent deposit
--local BANK_TAB = BANK_PANELS[1].name
local BANK_TAB = "BankTab"
local REAGENT_BANK_TAB = BANK_PANELS and BANK_PANELS[2] and BANK_PANELS[2].name

Baggins.hasIcon = "Interface\\Icons\\INV_Jewelry_Ring_03"
Baggins.cannotDetachTooltip = true
Baggins.clickableTooltip = true
Baggins.independentProfile = true
Baggins.hideWithoutStandby = true

-- number of item buttons that should be kept in the pool, so that none need to be created in combat
Baggins.minSpareItemButtons = 10

BINDING_HEADER_BAGGINS = L["Baggins"]
BINDING_NAME_BAGGINS_TOGGLEALL = L["Toggle All Bags"]
BINDING_NAME_BAGGINS_ITEMBUTTONMENU = "Item Menu"
BINDING_NAME_BAGGINS_TOGGLECOMPRESSALL= "Toggle " .. L["Compress All"]

local equiplocs = {
    INVTYPE_AMMO = 0,
    INVTYPE_HEAD = 1,
    INVTYPE_NECK = 2,
    INVTYPE_SHOULDER = 3,
    INVTYPE_BODY = 4,
    INVTYPE_CHEST = 5,
    INVTYPE_ROBE = 5,
    INVTYPE_WAIST = 6,
    INVTYPE_LEGS = 7,
    INVTYPE_FEET = 8,
    INVTYPE_WRIST = 9,
    INVTYPE_HAND = 10,
    INVTYPE_FINGER = 11,
    INVTYPE_TRINKET = 13,
    INVTYPE_CLOAK = 15,
    INVTYPE_WEAPON = 16,
    INVTYPE_SHIELD = 17,
    INVTYPE_2HWEAPON = 16,
    INVTYPE_WEAPONMAINHAND = 16,
    INVTYPE_WEAPONOFFHAND = 17,
    INVTYPE_HOLDABLE = 17,
    INVTYPE_RANGED = 18,
    INVTYPE_THROWN = 18,
    INVTYPE_RANGEDRIGHT = 18,
    INVTYPE_RELIC = 18,
    INVTYPE_TABARD = 19,
    INVTYPE_BAG = 20,
}

Baggins.itemcounts = {}

function Baggins:Debug(str, ...) --luacheck: ignore 212
    if not str or strlen(str) == 0 then return end

    if (...) then
        if strfind(str, "%%%.%d") or strfind(str, "%%[dfqsx%d]") then
            str = format(str, ...)
        else
            str = strjoin(" ", str, tostringall(...))
        end
    end

    local name = "Baggins"
    DEFAULT_CHAT_FRAME:AddMessage(format("|cffff9933%s:|r %s", name, str))
end

function Baggins:IsClassicWow() --luacheck: ignore 212
    return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end

function Baggins:IsTBCWow() --luacheck: ignore 212
    return WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC and LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_BURNING_CRUSADE
end

function Baggins:IsWrathWow() --luacheck: ignore 212
    return WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC and LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_WRATH_OF_THE_LICH_KING
end

function Baggins:IsCataWow() --luacheck: ignore 212
    return WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC and LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CATACLYSM
end

function Baggins:IsMistWow() --luacheck: ignore 212
    return WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC and LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_MISTS_OF_PANDARIA
end

function Baggins:IsRetailWow() --luacheck: ignore 212
    return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

local timers = {}
function Baggins:ScheduleNamedTimer(name, callback, delay, arg)
    local alreadyScheduled = timers[name]
    if alreadyScheduled and self:TimeLeft(alreadyScheduled) then
        self:CancelTimer(alreadyScheduled, true)
    end

    timers[name] = self:ScheduleTimer(callback, delay, arg)
end
function Baggins:CancelNamedTimer(name)
    local timer = timers[name]
    if timer then
        timers[name] = nil
        self:CancelTimer(timer, true)
    end
end
local nextFrameTimers = {}
local timerFrame = CreateFrame('Frame')
timerFrame:SetScript("OnUpdate", function(self)
    while next(nextFrameTimers) do
        local func = next(nextFrameTimers)
        local args = nextFrameTimers[func]
        if type(args) == 'table' then
            Baggins[func](Baggins, unpack(args))
            wipe(args)
        else
            Baggins[func](Baggins)
        end
        nextFrameTimers[func] = nil
    end
    self:Hide()
end)
function Baggins:ScheduleForNextFrame(callback, arg, ...) --luacheck: ignore 212
    nextFrameTimers[callback] = arg and { arg, ... } or true
    timerFrame:Show()
end

-- internal signalling minilibrary

local signals = {}

function Baggins:RegisterSignal(name, handler, arg1) --luacheck: ignore 212		-- Example: RegisterSignal("MySignal", self.SomeHandler, self)
    if not arg1 then error("Usage: Baggins:RegisterSignal(name, handler, arg1)") end
    if not signals[name] then
        signals[name] = {}
    end
    signals[name][handler]=arg1;
end

function Baggins:FireSignal(name, ...) --luacheck: ignore 212		-- Example: FireSignal("MySignal", 1, 2, 3);
    if signals[name] then
        for handler,arg1 in pairs(signals[name]) do
            handler(arg1, ...);
        end
    end
end

local tooltip

local ldbDropDownFrame = CreateFrame("Frame", "Baggins_DropDownFrame", UIParent, "UIDropDownMenuTemplate")

local ldbDropDownMenu
local spacer = { text = "", disabled = true, notCheckable = true, notClickable = true}
local function initDropdownMenu()
    if Baggins:IsRetailWow() then
        ldbDropDownMenu = {
            {
                text = "Run Blizzard Bag Sort",
                tooltipText = "Runs Blizzard bag Sort",
                func = function()
                        Baggins:CloseAllBags()
                        BlizzSortBags()
                    end,
                notCheckable = true,
            },
            {
                text = L["Force Full Refresh"],
                tooltipText = L["Forces a Full Refresh of item sorting"],
                func = function()
                        Baggins:ForceFullRefresh()
                        Baggins:Baggins_RefreshBags()
                    end,
                notCheckable = true,
            },
            spacer,
            {
                text = L["Hide Default Bank"],
                tooltipText = L["Hide the default bank window."],
                checked = Baggins.db.profile.hidedefaultbank,
                keepShownOnClick = true,
                func = function()
                        Baggins.db.profile.hidedefaultbank = not Baggins.db.profile.hidedefaultbank
                    end,
            },
            {
                text = L["Override Default Bags"],
                tooltipText = L["Baggins will open instead of the default bags"],
                checked = Baggins.db.profile.overridedefaultbags,
                keepShownOnClick = true,
                func = function()
                        Baggins.db.profile.overridedefaultbags = not Baggins.db.profile.overridedefaultbags
                        Baggins:UpdateBagHooks()
                    end,
            },
            spacer,
            {
                text = L["Config Window"],
                func = function() Baggins:OpenConfig() end,
                notCheckable = true,
            },
            {
                text = L["Bag/Category Config"],
                func = function() Baggins:OpenEditConfig() end,
                notCheckable = true,
            },
        }
    else
        ldbDropDownMenu = {
            {
                text = L["Force Full Refresh"],
                tooltipText = L["Forces a Full Refresh of item sorting"],
                func = function()
                        Baggins:ForceFullRefresh()
                        Baggins:Baggins_RefreshBags()
                    end,
                notCheckable = true,
            },
            spacer,
            {
                text = L["Hide Default Bank"],
                tooltipText = L["Hide the default bank window."],
                checked = Baggins.db.profile.hidedefaultbank,
                keepShownOnClick = true,
                func = function()
                        Baggins.db.profile.hidedefaultbank = not Baggins.db.profile.hidedefaultbank
                    end,
            },
            {
                text = L["Override Default Bags"],
                tooltipText = L["Baggins will open instead of the default bags"],
                checked = Baggins.db.profile.overridedefaultbags,
                keepShownOnClick = true,
                func = function()
                        Baggins.db.profile.overridedefaultbags = not Baggins.db.profile.overridedefaultbags
                        Baggins:UpdateBagHooks()
                    end,
            },
            spacer,
            {
                text = L["Config Window"],
                func = function() Baggins:OpenConfig() end,
                notCheckable = true,
            },
            {
                text = L["Bag/Category Config"],
                func = function() Baggins:OpenEditConfig() end,
                notCheckable = true,
            },
        }
    end
end

local function updateMenu()
    if not ldbDropDownMenu then
        initDropdownMenu()
        return
    end
    if Baggins:IsRetailWow() then
        ldbDropDownMenu[4].checked = Baggins.db.profile.hidedefaultbank
        ldbDropDownMenu[5].checked = Baggins.db.profile.overridedefaultbags
    else
        ldbDropDownMenu[3].checked = Baggins.db.profile.hidedefaultbank
        ldbDropDownMenu[4].checked = Baggins.db.profile.overridedefaultbags
    end
end

local ldbdata = {
    type = "data source",
    icon = "Interface\\Icons\\INV_Jewelry_Ring_03",
    OnClick = function(_, message)
            if message == "RightButton" then
                tooltip:Hide()
                updateMenu()
                Baggins:EasyMenu(ldbDropDownMenu, ldbDropDownFrame, "cursor", 0, 0, "MENU")
                -- Baggins:OpenConfig()
            else
                Baggins:OnClick()
            end
        end,
    label = "Baggins",
    text = "",
    OnEnter = function(self)
            tooltip = qt:Acquire('BagginsTooltip', 1)
            tooltip:SetHeaderFont(GameFontNormalLarge)
            tooltip:SetScript("OnHide", function(self) --luacheck: ignore 432
                    qt:Release(self)
                end)
            Baggins:UpdateTooltip(true)
            self.tooltip = tooltip
            tooltip:SmartAnchorTo(self)
            tooltip:SetAutoHideDelay(0.2, self)
            tooltip:Show()
        end,
}
Baggins.obj = LibStub("LibDataBroker-1.1"):NewDataObject("Baggins", ldbdata)

do
    local buttonCount = 0
    local buttonPool = {}

    local function createItemButton()

        local frameType
        if Baggins:IsRetailWow() then
            frameType = "ItemButton"
        else
            frameType = "Button"
        end

        local frame = CreateFrame(frameType,"BagginsPooledItemButton"..buttonCount,nil,"ContainerFrameItemButtonTemplate")

        frame.GetItemContextMatchResult = nil
        buttonCount = buttonCount + 1
        if InCombatLockdown() then
            Baggins:Debug("Baggins: WARNING: item-frame will be tainted")
            Baggins:RegisterEvent("PLAYER_REGEN_ENABLED")
            frame.tainted = true
        end
        return frame
    end

    function Baggins:RepopulateButtonPool(num) --luacheck: ignore 212
        if InCombatLockdown() then
            Baggins:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end
        while #buttonPool < num do
            local frame = createItemButton()
            tinsert(buttonPool, frame)
        end
    end

    local usedButtons = 0
    function Baggins:GetItemButton()
        usedButtons = usedButtons + 1
        self.db.char.lastNumItemButtons = usedButtons
        local frame
        if next(buttonPool) then
            frame = tremove(buttonPool, 1)
        else
            frame = createItemButton()
        end
        self:ScheduleTimer("RepopulateButtonPool", 0, Baggins.minSpareItemButtons)
        return frame
    end

    function Baggins:ReleaseItemButton(button) --luacheck: ignore 212
        button.glow:Hide()
        button.newtext:Hide()
        tinsert(buttonPool, button)
    end
end

function Baggins:PLAYER_REGEN_ENABLED()
    for _,bagframe in ipairs(Baggins.bagframes) do
        for _,section in ipairs(bagframe.sections) do
            for i,item in ipairs(section.items) do
                if item.tainted then
                    local tainted = section.items[i]
                    tainted:Hide()
                    section.items[i] = self:CreateItemButton()
                end
            end
        end
    end
    self:ForceFullUpdate()
    self:RepopulateButtonPool(Baggins.minSpareItemButtons)
end

function Baggins:OnInitialize()
    self.bagframes = {}
    self.colors = {
        black = {r=0,g=0,b=0,hex="|cff000000"},
        white = {r=1,g=1,b=1,hex="|cffffffff"},
        blue = {r=0,g=0.5,b=1,hex="|cff007fff"},
        purple = {r=1,g=0.4,b=1,hex="|cffff66ff"},
    }

    self:InitOptions()
    local buttonsToPool = (self.db.char.lastNumItemButtons or 90) + Baggins.minSpareItemButtons -- create a few spare buttons
    self:RepopulateButtonPool(buttonsToPool)
    self:InitBagCategoryOptions()
    self:RegisterChatCommand("baggins", "OpenConfig")
    self.OnMenuRequest = self.opts

    if Baggins:IsClassicWow() or Baggins:IsTBCWow() or Baggins:IsWrathWow() or Baggins:IsCataWow() or Baggins:IsMistWow() then
        dbIcon:Register("Baggins", ldbdata, self.db.profile.minimap)
    end
    -- self:RegisterChatCommand({ "/baggins" }, self.opts, "BAGGINS")

end

function Baggins:IsActive() --luacheck: ignore 212
    return true
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
        local templates = {}
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

function Baggins:OnEnable()
    --self:SetBagUpdateSpeed();
    self:RegisterEvent("BAG_CLOSED", "ForceFullRefresh")
    self:RegisterEvent("BAG_UPDATE","OnBagUpdate")
    self:RegisterEvent("BAG_UPDATE_COOLDOWN", "UpdateItemButtonCooldowns")
    self:RegisterEvent("ITEM_LOCK_CHANGED", "UpdateItemButtonLocks")
    self:RegisterEvent("QUEST_ACCEPTED", "UpdateItemButtons")
    self:RegisterEvent("UNIT_QUEST_LOG_CHANGED", "UpdateItemButtons")
    self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", "OnBankChanged")
    --if Baggins:IsRetailWow() then
    --    --self:RegisterEvent("PLAYERREAGENTBANKSLOTS_CHANGED", "OnReagentBankChanged")
    --    --self:RegisterEvent("REAGENTBANK_PURCHASED", "OnReagentBankChanged")
    --end

    --self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED", "OnBankSlotPurchased")
    self:RegisterEvent("BANKFRAME_CLOSED", "OnBankClosed")
    self:RegisterEvent("BANKFRAME_OPENED", "OnBankOpened")
    self:RegisterEvent("PLAYER_MONEY", "UpdateMoneyFrame")
    self:RegisterEvent('AUCTION_HOUSE_SHOW', "AuctionHouse")
    self:RegisterEvent('AUCTION_HOUSE_CLOSED', "CloseAllBags")

    -- Patch 10.0 Added Later Added To Classic
    self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW', "PlayerInteractionManager")
    self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE', "PlayerInteractionManager")
    self:RegisterEvent('SOCKET_INFO_UPDATE', "OpenAllBags")

    self:RegisterSignal('CategoryMatchAdded', self.CategoryMatchAdded, self)
    self:RegisterSignal('CategoryMatchRemoved', self.CategoryMatchRemoved, self)
    self:RegisterSignal('SlotMoved', self.SlotMoved, self)

    self:UpdateBagHooks()
    self:UpdateBackpackHook()
    self:RawHook("CloseSpecialWindows", true)
    --self:RawHookScript(BankFrame,"OnEvent","BankFrame_OnEvent")

    -- hook blizzard PLAYERBANKSLOTS_CHANGED function to filter inactive table
    -- this is required to prevent a nil error when working with a tab that the
    -- default UI is not currently showing
    --self:RawHook("BankFrameItemButton_Update", true)

    --force an update of all bags on first opening
    self.doInitialUpdate = true
    self.doInitialBankUpdate = true
    self:ResortSections()
    self:UpdateText()
    --self:SetDebugging(true)

    if self.db.profile.hideduplicates == true then
        self.db.profile.hideduplicates = "global"
    end
    self:CreateMoneyFrame()
    self:UpdateMoneyFrame()
    self:CreateBankControlFrame()
    self:UpdateBankControlFrame()
    local skin = self:GetSkin(self.db.profile.skin)
    if not skin then -- if skin doesn't exist anymore, reset to default
        console:Print("|cFFFF0000Baggins|r "..L["Skin '%s' not found, resetting to default"]:format(self.db.profile.skin))
        self.db.profile.skin = "default"
    end
    self:EnableSkin(self.db.profile.skin)
    self:OnProfileEnable()
    self:RunBagUpdates()
end

function Baggins:Baggins_CategoriesChanged()
    self:ReallyUpdateBags()
    self.doInitialBankUpdate = true
end

function Baggins:BankFrame_OnEvent(...)
    if not self:IsActive() or not self.db.profile.hidedefaultbank then
        self.hooks[BankFrame].OnEvent(...)
    end
end

function Baggins:UpdateBagHooks()
    if self.db.profile.overridedefaultbags then
        self:UnhookBagHooks()
        self:RawHook("OpenAllBags", "ToggleAllBags", true)
        self:RawHook("ToggleAllBags", true)
        self:RawHook('ToggleBackpack', 'ToggleAllBags', true)
        self:RawHook("CloseAllBags", true)

        self:RawHook('OpenBag', 'ToggleAllBags', true)
        self:RawHook('OpenBackpack', 'ToggleAllBags', true)
        self:RawHook('ToggleBag', 'ToggleAllBags', true)

        if Baggins:IsRetailWow() then
            self:RawHook("OpenAllBagsMatchingContext", "ToggleAllBags", true)
            --self:RawHook("OpenAndFilterBags", "ToggleAllBags", true)
        end

        --self:RawHook('ToggleBag', 'ToggleBags', true)
        --self:RawHook('OpenBackpack', 'OpenBags', true)
        --self:RawHook('CloseBackpack', 'CloseBags', true)
    else
        self:UnhookBagHooks()
    end
end

function Baggins:UnhookBagHooks()
    if self:IsHooked("OpenAllBags") then
        self:Unhook("OpenAllBags")
    end
    if self:IsHooked("ToggleAllBags") then
        self:Unhook("ToggleAllBags")
    end
    if self:IsHooked("ToggleBackpack") then
        self:Unhook("ToggleBackpack")
    end
    if self:IsHooked("CloseAllBags") then
        self:Unhook("CloseAllBags")
    end
    if self:IsHooked("OpenBag") then
        self:Unhook("OpenBag")
    end
    if self:IsHooked("OpenBackpack") then
        self:Unhook("OpenBackpack")
    end
    if self:IsHooked("ToggleBag") then
        self:Unhook("ToggleBag")
    end
    if Baggins:IsRetailWow() then
        if self:IsHooked("OpenAllBagsMatchingContext") then
            self:Unhook("OpenAllBagsMatchingContext")
        end
    end
end

function Baggins:UpdateBackpackHook()
    if self.db.profile.overridebackpack then
        if not self:IsHooked(MainMenuBarBackpackButton, "OnClick") then
            self:RawHookScript(MainMenuBarBackpackButton, "OnClick", "MainMenuBarBackpackButtonOnClick")
        end
        if not self:IsHooked(CharacterBag0Slot, "OnClick") then
            self:RawHookScript(CharacterBag0Slot, "OnClick", "MainMenuBarBackpackButtonOnClick")
        end
        if not self:IsHooked(CharacterBag1Slot, "OnClick") then
            self:RawHookScript(CharacterBag1Slot, "OnClick", "MainMenuBarBackpackButtonOnClick")
        end
        if not self:IsHooked(CharacterBag2Slot, "OnClick") then
            self:RawHookScript(CharacterBag2Slot, "OnClick", "MainMenuBarBackpackButtonOnClick")
        end
        if not self:IsHooked(CharacterBag3Slot, "OnClick") then
            self:RawHookScript(CharacterBag3Slot, "OnClick", "MainMenuBarBackpackButtonOnClick")
        end
        if Baggins:IsRetailWow() and not self:IsHooked(CharacterReagentBag0Slot, "OnClick") then
            self:RawHookScript(CharacterReagentBag0Slot, "OnClick", "MainMenuBarBackpackButtonOnClick")
        end
    else
        self:UnhookBackpack()
    end
end

function Baggins:UnhookBackpack()
    if self:IsHooked(MainMenuBarBackpackButton, "OnClick") then
        self:Unhook(MainMenuBarBackpackButton, "OnClick")
    end
    if self:IsHooked(CharacterBag0Slot, "OnClick") then
        self:RawHookScript(CharacterBag0Slot, "OnClick")
    end
    if self:IsHooked(CharacterBag1Slot, "OnClick") then
        self:RawHookScript(CharacterBag1Slot, "OnClick")
    end
    if self:IsHooked(CharacterBag2Slot, "OnClick") then
        self:RawHookScript(CharacterBag2Slot, "OnClick")
    end
    if self:IsHooked(CharacterBag3Slot, "OnClick") then
        self:RawHookScript(CharacterBag3Slot, "OnClick")
    end
    if Baggins:IsRetailWow() and self:IsHooked(CharacterReagentBag0Slot, "OnClick") then
        self:RawHookScript(CharacterReagentBag0Slot, "OnClick")
    end
end

function Baggins:OnDisable()
    self:CloseAllBags()
end

local INVSLOT_LAST_EQUIPPED, CONTAINER_BAG_OFFSET, NUM_BAG_SLOTS =
      INVSLOT_LAST_EQUIPPED, CONTAINER_BAG_OFFSET, NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS

function Baggins:SaveItemCounts()
    local itemcounts = self.itemcounts
    wipe(itemcounts)
    for _,_,link in LBU:Iterate("BAGS") do	-- includes keyring
        if link then
            local id = tonumber(link:match("item:(%d+)"))
            if id and not itemcounts[id] then
                itemcounts[id] = { count = GetItemCount(id), ts = time() }
            end
        end
    end
    if Baggins:IsRetailWow() then
        for _,_,link in LBU:Iterate("REAGENTBANK") do
            if link then
                local id = tonumber(link:match("item:(%d+)"))
                if id and not itemcounts[id] then
                    itemcounts[id] = { count = GetItemCount(id), ts = time() }
                end
            end
        end
    end

    for slot = 0, INVSLOT_LAST_EQUIPPED do	-- 0--19
        local link = GetInventoryItemLink("player",slot)
        if link then
            local id = tonumber(link:match("item:(%d+)"))
            if id and not itemcounts[id] then
                itemcounts[id] = { count = GetItemCount(id), ts = time() }
            end
        end
    end
    for slot = 1+CONTAINER_BAG_OFFSET, NUM_BAG_SLOTS+CONTAINER_BAG_OFFSET do  -- 20--23
        local link = GetInventoryItemLink("player",slot)
        if link then
            local id = tonumber(link:match("item:(%d+)"))
            if id and not itemcounts[id] then
                itemcounts[id] = { count = GetItemCount(id), ts = time() }
            end
        end
    end
end

function Baggins:RunItemCountUpdates()
    if self.db.profile.newitemduration > 0 then
        Baggins:ForceFullUpdate()
    end
end

function Baggins:IsCompressed(itemID)
    local p = self.db.profile
    if self.tempcompressnone then
        return false
    end
    --slot sorting will break compression horribly
    --if p.sort == "slot" then
    --    return false
    --end
    if p.compressall then
        return true
    end
    --string id's here are empty slots
    if type(itemID) == "string" and p.compressempty then
        return true
    end

    if type(itemID) == "number" then
        local itemFamily = GetItemFamily(itemID)
        local _, _, _, _, _, _, _, itemStackCount, itemEquipLoc = GetItemInfo(itemID)
        if itemFamily then	-- likes to be nil during login
            if Baggins:IsRetailWow() then
                if p.CompressShards and band(itemFamily,4)~=0 and itemEquipLoc~="INVTYPE_BAG" then
                    return true
                end
                if p.compressammo and band(itemFamily,3)~=0 and itemEquipLoc~="INVTYPE_BAG" then
                    return true
                end
            end

            if Baggins:IsClassicWow() or Baggins:IsTBCWow() or Baggins:IsWrathWow() or Baggins:IsCataWow() or Baggins:IsMistWow() then
                if p.CompressShards and itemFamily ~=3 and itemEquipLoc~="INVTYPE_BAG" then
                    return true
                end
                if p.compressammo and itemFamily ~=2 and itemEquipLoc~="INVTYPE_BAG" then
                    return true
                end
            end

        end
        if p.compressstackable and itemStackCount and itemStackCount>1 then
            --local charBags = {}
            --for i=0, NUM_BAG_SLOTS do
            --    tinsert(charBags, i);
            --end
            --if Baggins:IsClassicWow() or Baggins:IsTBCWow() then
            --    tinsert(charBags, KEYRING_CONTAINER)
            --end
            ----local bankBags = { BANK_CONTAINER }
            ----for i=NUM_BAG_SLOTS+1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
            ----    tinsert(bankBags, i);
            ----end
            ----local bags = bank and bankBags or charBags
            --local bags = charBags
            --for _,bag in ipairs(bags) do
            --    for slot=1,(GetContainerNumSlots(bag) or 0) do
            --        local _, itemCount, locked, _, _ = GetContainerItemInfo(bag, slot)
            --        local link = GetContainerItemLink(bag, slot)
            --        if link then
            --            local _, _, _, _, _, _, _, iMaxStack = GetItemInfo(link)
            --            if iMaxStack and itemCount < iMaxStack then
            --            end
            --        end
            --    end
            --end
            return true
        end
    end
end


function Baggins:OnBankClosed()
    -- don't remove the test, it prevents infinite recursion loop on CloseBankFrame()
    if self.bankIsOpen then
        self.bankIsOpen = nil
        self:CloseAllBags()
    end
end

function Baggins:OnBankOpened()
    if self.doInitialBankUpdate then
        self.doInitialBankUpdate = false
        Baggins:ForceFullBankUpdate()
    end
    self.bankIsOpen = true
    self:OpenAllBags()
end

function Baggins:OnBankChanged()
    self:OnBagUpdate(nil,-1)
end

function Baggins:OnReagentBankChanged()
    self:OnBagUpdate(nil,REAGENTBANK_CONTAINER)
end

function Baggins:OnReagentBankPurchased()
    self:UpdateBankControlFrame()
    self:ForceFullBankUpdate()
    self:UpdateBags()
end

function Baggins:OnBankSlotPurchased()
    self:UpdateBankControlFrame()
    self:ForceFullBankUpdate()
    self:UpdateBags()
end

-------------------------
-- Update Bag Contents --
-------------------------
local scheduled_refresh = false

function Baggins:ScheduleRefresh()
    if not scheduled_refresh then
        scheduled_refresh = self:ScheduleForNextFrame('Baggins_RefreshBags')
    end
end

function Baggins:Baggins_RefreshBags()
    if self.dirtyBags then
        --Baggins:Debug('Updating bags')
        self:ReallyUpdateBags()
    end
    for bagid,bagframe in pairs(self.bagframes) do
        for _,sectionframe in pairs(bagframe.sections) do
            if sectionframe.used and sectionframe.dirty then
                --Baggins:Debug('Updating section #%d-%d', bagid, secid)
                self:ReallyLayoutSection(sectionframe)
            end
        end

        if bagframe.dirty then
            self:ReallyUpdateBagFrameSize(bagid)
        end
    end
    if self.dirtyBagLayout then
        self:ReallyLayoutBagFrames()
    end

    scheduled_refresh = nil
    self:FireSignal("Baggins_RefreshBags")
end

function Baggins:UpdateBags()
    self.dirtyBags = true
    self:ScheduleRefresh()
end

local function CheckSection(bagframe, secid)
    for i = 1,secid do
        if not bagframe.sections[i] then
            bagframe.sections[i] = Baggins:CreateSectionFrame(bagframe,i)
            if i == 1 then
                bagframe.sections[i]:SetPoint("TOPLEFT",bagframe,"TOPLEFT",10,-36)
            else
                bagframe.sections[i]:SetPoint("TOPLEFT",bagframe.sections[i-1],"BOTTOMLEFT",0,1)
            end
        end
    end
end

local function GetSlotInfo(item)
    local bag, slot = item:match("^(-?%d+):(%d+)$")
    local bagType = Baggins:IsSpecialBag(bag)
    local itemID
    local cacheditem = Baggins:GetCachedItem(item)
    if cacheditem then
        itemID = tonumber(cacheditem:match("^(%d+)"))
    end
    return bag, slot, itemID, bagType
end

local function new() return {} end
local function del(t) wipe(t) end
--local rdel = del

function Baggins:CategoryMatchAdded(category, slot, isbank)
    local p = self.db.profile
    for bagid, bag in pairs(p.bags) do
        local bagframe = self.bagframes[bagid]
        if bagframe then
            for sectionid, section in pairs(bag.sections) do
                for _, catname in pairs(section.cats) do
                    if catname == category and ((not bag.isBank) == (not isbank)) then
                        CheckSection(bagframe, sectionid)
                        local secframe = bagframe.sections[sectionid]
                        secframe.slots[slot] = ( secframe.slots[slot] or 0 ) + 1
                        local layout = secframe.layout
                        local _, _, itemid, bagtype = GetSlotInfo(slot)
                        if not itemid then
                            itemid = (bagtype or "")
                        end
                        local found

                        --check for an existing stack to add the slot to
                        for k, entry in ipairs(layout) do
                            if type(entry) == "table" then
                                if entry.itemid == itemid and entry.slots[slot] then
                                    found = true
                                elseif entry.itemid == itemid then
                                    if self:IsCompressed(itemid) then
                                        if not entry.slots[slot] then
                                            entry.slots[slot] = true
                                            entry.slotcount = entry.slotcount + 1
                                        end
                                        found = true
                                    end
                                else
                                    if entry.slots[slot] then
                                        entry.slots[slot] = nil
                                        entry.slotcount = entry.slotcount - 1
                                        if entry.slotcount == 0 then
                                            del(entry.slots)
                                            del(entry)
                                            layout[k] = slot
                                        end
                                    end
                                end
                            end
                        end
                        if not found then
                            local newentry = new()
                            newentry.slots = new()
                            newentry.slots[slot] = true
                            newentry.slotcount = 1
                            newentry.itemid = itemid
                            tinsert(layout, newentry)
                            secframe.needssorting = true
                        end
                    end
                end
            end
        end
    end
end

function Baggins:CategoryMatchRemoved(category, slot, isbank)
    local p = self.db.profile
    for bagid, bag in pairs(p.bags) do
    local bagframe = self.bagframes[bagid]
        if bagframe then
            for sectionid, section in pairs(bag.sections) do
                for _, catname in pairs(section.cats) do
                    if catname == category and ((not bag.isBank) == (not isbank)) then
                        CheckSection(bagframe, sectionid)
                        local secframe = bagframe.sections[sectionid]
                        secframe.slots[slot] = ( secframe.slots[slot] or 1 ) - 1
                        if secframe.slots[slot] == 0 then
                            secframe.slots[slot] = false
                        end

                        local layout = secframe.layout

                        --remove the slot from any stacks that contain it
                        for k, entry in ipairs(layout) do
                            if type(entry) == "table" then
                                if entry.slots[slot] then
                                    entry.slots[slot] = nil
                                    entry.slotcount = entry.slotcount - 1
                                end
                                if entry.slotcount == 0 then
                                    del(entry.slots)
                                    del(entry)
                                    layout[k] = slot
                                end
                            end
                        end

                    end
                end
            end
        end
    end
end

function Baggins:SlotMoved(category, slot, isbank)
    local p = self.db.profile
    for bagid, bag in pairs(p.bags) do
        local bagframe = self.bagframes[bagid]
        if bagframe then
            for sectionid, section in pairs(bag.sections) do
                for _, catname in pairs(section.cats) do
                    if catname == category and ((not bag.isBank) == (not isbank)) then
                        CheckSection(bagframe, sectionid)
                        local secframe = bagframe.sections[sectionid]
                        secframe.needssorting = true
                        local layout = secframe.layout
                        local _, _, itemid, bagtype = GetSlotInfo(slot)
                        if not itemid then
                            itemid = (bagtype or "")
                        end

                        --remove the slot from any stacks that contain it
                        for k, entry in ipairs(layout) do
                            if type(entry) == "table" then
                                if entry.slots[slot] then
                                    entry.slots[slot] = nil
                                    entry.slotcount = entry.slotcount - 1
                                end
                                if entry.slotcount == 0 then
                                    del(entry.slots)
                                    del(entry)
                                    layout[k] = slot
                                end
                            end
                        end
                        local found
                        --check for an existing stack to add the slot to
                        for k, entry in ipairs(layout) do
                            if type(entry) == "table" then
                                if entry.itemid == itemid then
                                    if self:IsCompressed(itemid) then
                                        if not entry.slots[slot] then
                                            entry.slots[slot] = true
                                            entry.slotcount = entry.slotcount + 1
                                        end
                                        found = true
                                    end
                                else
                                    if entry.slots[slot] then
                                        entry.slots[slot] = nil
                                        entry.slotcount = entry.slotcount - 1
                                        if entry.slotcount == 0 then
                                            del(entry.slots)
                                            del(entry)
                                            layout[k] = slot
                                        end
                                    end
                                end
                            end
                        end
                        if not found then
                            local newentry = new()
                            newentry.slots = new()
                            newentry.slots[slot] = true
                            newentry.slotcount = 1
                            newentry.itemid = itemid
                            tinsert(layout, newentry)
                            secframe.needssorting = true
                        end

                    end
                end
            end
        end
    end
end

function Baggins:ForceSectionReLayout(bagid)
    local bagframe = self.bagframes[bagid]
    if bagframe then
        for _, secframe in pairs(bagframe.sections) do
            if secframe then
                for k, v in pairs(secframe.slots) do
                    if v == false then
                        secframe.slots[k] = nil
                    end
                end
                secframe.needssorting = true
            end
        end
    end
end

function Baggins:ClearSectionCaches()
    for bagid, _ in ipairs(self.db.profile.bags) do
        local bagframe = self.bagframes[bagid]
        if bagframe then
            for _, secframe in pairs(bagframe.sections) do
                if secframe then
                    local layout = secframe.layout
                    for k, v in pairs(layout) do
                        if type(v) == "table" then
                            del(v.slots)
                            del(v)
                        end
                        layout[k] = nil
                    end
                    for k, _ in pairs(secframe.slots) do
                        secframe.slots[k] = nil
                    end
                end
            end
        end
    end
end

function Baggins:RebuildSectionLayouts()
    for bagid, _ in ipairs(self.db.profile.bags) do
        local bagframe = self.bagframes[bagid]
        if bagframe then
            for _, secframe in pairs(bagframe.sections) do
                if secframe then
                    local layout = secframe.layout
                    for k, v in pairs(layout) do
                        if type(v) == "table" then
                            del(v.slots)
                            del(v)
                        end
                        layout[k] = nil
                    end
                    for slot, _ in pairs(secframe.slots) do
                        local _, _, itemid, bagtype = GetSlotInfo(slot)
                        if not itemid then
                            itemid = (bagtype or "")
                        end
                        local found
                        --check for an existing stack to add the slot to
                        for k, entry in ipairs(layout) do
                            if entry then
                                if entry.itemid == itemid then
                                    if self:IsCompressed(itemid) then
                                        if not entry.slots[slot] then
                                            entry.slots[slot] = true
                                            entry.slotcount = entry.slotcount + 1
                                        end
                                        found = true
                                    end
                                else
                                    if entry.slots[slot] then
                                        entry.slots[slot] = nil
                                        entry.slotcount = entry.slotcount - 1
                                        if entry.slotcount == 0 then
                                            del(entry.slots)
                                            del(entry)
                                            layout[k] = slot
                                        end
                                    end
                                end
                            end
                        end
                        if not found then
                            local newentry = new()
                            newentry.slots = new()
                            newentry.slots[slot] = true
                            newentry.slotcount = 1
                            newentry.itemid = itemid
                            tinsert(layout, newentry)
                            secframe.needssorting = true
                        end
                    end
                    secframe.needssorting = true
                end
            end
        end
    end
end


function Baggins:ReallyUpdateBags()
    local p = self.db.profile
    local isVisible = false
    if BagginsMoneyFrame then
        BagginsMoneyFrame:Hide()
    end
    if BagginsBankControlFrame then
        BagginsBankControlFrame:Hide()
    end
    for bagid, _ in pairs(p.bags) do
        if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
            isVisible = true
        end
    end
    if not isVisible then return end
    for bagid, bag in pairs(p.bags) do
        if ( not bag.isBank ) or self.bankIsOpen then
            if self.bagframes[bagid] then
                self:SetBagTitle(bagid,bag.name)
                if self.currentSkin then
                    self.currentSkin:SetBankVisual(self.bagframes[bagid], bag.isBank)
                end
                for _, v in pairs(self.bagframes[bagid].sections) do
                    v.used = nil
                    v:Hide()
                    for _, itemframe in pairs(v.items) do
                        itemframe:Hide()
                    end
                end
                for sectionid, section in pairs(bag.sections) do
                    if (self.bagframes[bagid]:IsVisible() or p.hideemptybags) then
                        self:UpdateSection(bagid,sectionid,section.name) --,Baggins:FinishSection())
                    end
                end
                self:UpdateBagFrameSize(bagid)
            end
        end
    end

    self:UpdateLayout()
    self.dirtyBags = nil
end

function Baggins:UpdateSection(bagid, secid,title) --, contents)
    local bagframe = self.bagframes[bagid]
    if not bagframe then return end
    for i = 1,secid do
        if not bagframe.sections[i] then
            bagframe.sections[i] = self:CreateSectionFrame(bagframe,i)
            if i == 1 then
                bagframe.sections[i]:SetPoint("TOPLEFT",bagframe,"TOPLEFT",10,-36)
            else
                bagframe.sections[i]:SetPoint("TOPLEFT",bagframe.sections[i-1],"BOTTOMLEFT",0,1)
            end
        end
    end
    self:UpdateSectionContents(bagframe.sections[secid],title) --,contents)
    self:UpdateBagFrameSize(bagid)
end

-----------------
-- Bag Updates --
-----------------

local firstbagupdate = true

local bagupdatebucket = {}
local lastbag,lastbagfree=-1,-1

function Baggins:OnBagUpdate(_,bagid)
    --ignore bags -4 ( currency ); -3 is reagent bank
    if Baggins:IsCataWow() or Baggins:IsMistWow() then
        if bagid < -1 then return end
    else
        if bagid <= -4 then return end
        if bagid >= 13 then return end
    end
    bagupdatebucket[bagid] = true

    -- Update panel text.
    -- Optimization mostly for hunters - their bags change for every damn arrow they fire:
    local free=GetContainerNumFreeSlots(bagid)
    if lastbag==bagid and lastbagfree==free then --luacheck: ignore 542
        --Baggins:Debug("OnBagUpdate LastBag and LastBagFree")
    else
        lastbag=bagid
        lastbagfree=free
        self:UpdateText()
    end
    self:RunBagUpdates()
end

function Baggins:RunBagUpdates()
    if firstbagupdate then
        firstbagupdate = false
        self:SaveItemCounts()
        self:ForceFullUpdate()
    end

    if not next(bagupdatebucket) then
        return
    end
    self:UpdateText()

    local itemschanged
    for bag in pairs(bagupdatebucket) do
        itemschanged = Baggins:CheckSlotsChanged(bag) or itemschanged
        bagupdatebucket[bag] = nil
    end

    if itemschanged then
        self:UpdateBags()
    else
        self:UpdateItemButtons()
    end

    if(self:IsAnyBagOpen()) then
        Baggins:FireSignal("Baggins_BagsUpdatedWhileOpen");
    end
    self:ReallyUpdateBags()
end

-----------------------------
-- Update Section Contents --
-----------------------------
function Baggins:UpdateSectionContents(sectionframe,title)
    local p = self.db.profile

    sectionframe.used = true
    if sectionframe.needssorting or self.db.profile.alwaysresort then
        local layout = sectionframe.layout
        local size = #layout
        if size > 0 then
            for i = size, 1, -1 do
                if type(layout[i]) == "string" then
                    tremove(layout, i)
                end
            end
        end

        self:SortItemList(layout, p.sort)
        sectionframe.needssorting = false
    end
    sectionframe:Show()

    self:LayoutSection(sectionframe, title)
end


local function baseComp(a, b)
    local p = Baggins.db.profile
    if type(a) == "table" then
        for k, v in pairs(a.slots) do
            if v then
                a = k
                break
            end
        end
    end
    if type(b) == "table" then
        for k, v in pairs(b.slots) do
            if v then
                b = k
                break
            end
        end
    end
    -- getting a or b as nil here shouldn't happen. but it happens.
    local baga, slota = strmatch(a or "", "^(-?%d+):(%d+)$")
    local bagb, slotb = strmatch(b or "", "^(-?%d+):(%d+)$")
    baga=tonumber(baga)
    slota=tonumber(slota)
    bagb=tonumber(bagb)
    slotb=tonumber(slotb)
    local linka = baga and slota and GetContainerItemLink(baga, slota)
    local linkb = bagb and slotb and GetContainerItemLink(bagb, slotb)
    --if both are empty slots compare based on bag type
    if not linka and not linkb then
        local bagtypea = Baggins:IsSpecialBag(baga)
        local bagtypeb = Baggins:IsSpecialBag(bagb)
        if not bagtypea then
            return false
        end
        if not bagtypeb then
            return true
        end
        return bagtypea < bagtypeb
    end
    if not linka then
        return false
    end
    if not linkb then
        return true
    end

    if p.sortnewfirst and baga>=0 and baga<=NUM_BAG_SLOTS then
        local newa, newb = Baggins:IsNew(linka), Baggins:IsNew(linkb)
        if newa and not newb then
            return true
        end
        if newb and not newa then
            return false
        end
    end

    return nil,linka,linkb,baga,slota,bagb,slotb
end

local function getBattlePetInfoFromLink(link)
    --local speciesID, level, quality, maxHealth, power, speed, petid, name = link:match("battlepet:(%d):(%d):([-%d]+):(%d+):(%d+):(%d+):([x%d]+)|h%[([%a%s]+)")
    local _, speciesID, level, quality, maxHealth, power, speed, petid = link:match("(%l+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")
    local name = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
    --local a, speciesID, level, quality, maxHealth, power, speed, petid, name = strsplit(":", link)
    return tonumber(speciesID), tonumber(level), tonumber(quality), tonumber(maxHealth), tonumber(power), tonumber(speed), tonumber(petid), name
end

local function getCompInfo(link)
  if link:match("keystone:") then
    return GetItemInfo(158923)
  elseif link:match("battlepet:") then
    local speciesID, level, quality, _, _, _, _, name = getBattlePetInfoFromLink(link)
    --local _, speciesID = strsplit(":", link)
    local petType = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
    local subtype = _G["BATTLE_PET_NAME_" .. petType]
    return name, nil, quality, level, nil, L["Battle Pets"], subtype
  else
    return GetItemInfo(link)
  end
end

local function NameComp(a, b)
    local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
    if res~=nil then return res end

    local namea = getCompInfo(linka)
    local nameb = getCompInfo(linkb)

    if namea ~= nameb then
        return (namea  or "?") < (nameb or "?")
    end

    local itemInfoCounta = GetContainerItemInfo(baga, slota)
    local itemInfoCountb = GetContainerItemInfo(bagb, slotb)
    local counta = itemInfoCounta and itemInfoCounta.stackCount
    local countb = itemInfoCountb and itemInfoCountb.stackCount

    return (counta  or 0) > (countb or 0)
end
local function QualityComp(a, b)
    local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
    if res~=nil then return res end

    local namea, _, quala = getCompInfo(linka)
    local nameb, _, qualb = getCompInfo(linkb)

    if quala~=qualb then
        return (quala  or 0) > (qualb  or 0)
    end

    if namea ~= nameb then
        return (namea  or "?") < (nameb or "?")
    end

    local itemInfoCounta = GetContainerItemInfo(baga, slota)
    local itemInfoCountb = GetContainerItemInfo(bagb, slotb)
    local counta = itemInfoCounta and itemInfoCounta.stackCount
    local countb = itemInfoCountb and itemInfoCountb.stackCount

    return (counta  or 0) > (countb  or 0)
end
local function TypeComp(a, b)
    local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
    if res~=nil then return res end

    local namea, _, quala, _, _, typea, _, _, equiploca = getCompInfo(linka)
    local nameb, _, qualb, _, _, typeb, _, _, equiplocb = getCompInfo(linkb)

    if typea ~= typeb then
        return (typea or "?") < (typeb or "?")
    end

    if (equiploca and equiplocs[equiploca]) and (equiplocb and equiplocs[equiplocb]) then
        if equiplocs[equiploca] ~= equiplocs[equiplocb] then
            return equiplocs[equiploca] < equiplocs[equiplocb]
        end
    end

    if quala~=qualb then
        return (quala or 0)  > (qualb or 0)
    end

    if namea ~= nameb then
        return (namea or "?")  < (nameb or "?")
    end

    local itemInfoCounta = GetContainerItemInfo(baga, slota)
    local itemInfoCountb = GetContainerItemInfo(bagb, slotb)
    local counta = itemInfoCounta and itemInfoCounta.stackCount
    local countb = itemInfoCountb and itemInfoCountb.stackCount

    return (counta or 0)  > (countb or 0)
end
local function SlotComp(a, b)
    if type(a) == "table" then
        a, b = (next(a.slots)), (next(b.slots))
    end
    local baga, slota = a:match("^(-?%d+):(%d+)$")
    local bagb, slotb = b:match("^(-?%d+):(%d+)$")
    if baga == bagb then
        slota = tonumber(slota)
        slotb = tonumber(slotb)
        return slota < slotb
    else
        return baga < bagb
    end
end
local function IlvlComp(a, b)
    local res,linka,linkb,baga,slota,bagb,slotb=baseComp(a,b)
    if res~=nil then return res end

    local namea, _, quala = getCompInfo(linka)
    local nameb, _, qualb = getCompInfo(linkb)
    local ilvla = iui:GetUpgradedItemLevel(linka)
    local ilvlb = iui:GetUpgradedItemLevel(linkb)
    if ilvla~=ilvlb then
        return (ilvla or 0) > (ilvlb or 0)
    end

    if quala~=qualb then
        return (quala or 0) > (qualb or 0)
    end

    if namea ~= nameb then
        return (namea or "?")  < (nameb or "?")
    end

    local itemInfoCounta = GetContainerItemInfo(baga, slota)
    local itemInfoCountb = GetContainerItemInfo(bagb, slotb)
    local counta = itemInfoCounta and itemInfoCounta.stackCount
    local countb = itemInfoCountb and itemInfoCountb.stackCount

    return (counta  or 0) > (countb or 0)
end

function Baggins:SortItemList(itemlist, sorttype) --luacheck: ignore 212
    local func
    if sorttype == "name" then
        func = NameComp
    elseif sorttype == "quality" then
        func = QualityComp
    elseif sorttype == "type" then
        func = TypeComp
    elseif sorttype == "slot" then
        func = SlotComp
    elseif sorttype == "ilvl" then
        func = IlvlComp
    else
        return
    end
    tsort(itemlist, func)
end

------------------------
-- Section/Bag Layout --
------------------------
function Baggins:GetSectionSize(sectionframe, maxcols)
    local count
    local bagconf = self.db.profile.bags[sectionframe.bagid]
    if not bagconf then return 0,0 end
    local sectionconf = bagconf.sections[sectionframe.secid]
    if not sectionconf then return 0,0 end
    if sectionconf.hidden then
        count = 0
    else
        count = sectionframe.itemcount
    end
    maxcols = maxcols or count
    local columns = min(count, maxcols)
    local rows = ceil(count / maxcols)
    local width = columns * 39 - 2
    local height = rows * 39 - 2
    -- Flow requires we still get a height
    if maxcols < 1 then-- and not self.db.profile.flow_sections then
        height = 0
    end

    if self.db.profile.showsectiontitle then
        width = max(width, sectionframe.title:GetWidth())
        height = height + sectionframe.title:GetHeight()
    end

    return width, height, columns, rows
end


-- Flow layout
function Baggins:FlowSections(bagid)
    -- Bag references
    local bag = self.bagframes[bagid]
    local sections_conf = self.db.profile.bags[bagid].sections
    local skin = self.currentSkin
    -- Bag dimensions
    local width, height = 0, 0
    local xoff, yoff = skin.BagLeftPadding, -skin.BagTopPadding
    local max_cols = self.db.profile.columns
    -- Flow data
    local flow_x, flow_y, flow_anchor = 0, 0
    local flow_items, flow_sections, max_sections = 0, 0, 0
    local bagempty = true

    -- Like a river, man. LIKE A RIVER DO YOU HEAR ME
    for id, section in ipairs(self.bagframes[bagid].sections) do
        if section.used and section.itemcount > 0 then
            bagempty = false
            local available = max_cols - flow_items

            -- Give collapsed sections a virtual size to account for title length
            local x, y, section_items = self:GetSectionSize(section, max_cols)
            if not section_items then Baggins:Debug('oops') return nil end
            local title_length = ceil(section.title:GetStringWidth()/39)
            if sections_conf[id] and sections_conf[id].hidden then
                section_items = title_length
            -- Account for long labels with one or two items
            else
                section_items = max(title_length, section_items)
            end
            flow_items = flow_items + section_items

            -- Add to last row
            if flow_anchor and available >= section_items then
                flow_sections = flow_sections + 1
                section:SetPoint("TOPLEFT", flow_anchor, "TOPLEFT", flow_x + 10, 0)
                flow_x = flow_x + x + 10
                flow_y = max(y, flow_y)

            else
                -- New row
                if flow_anchor then
                    section:SetPoint("TOPLEFT", flow_anchor, "TOPLEFT", 0, -flow_y -5)
                    y = y + 5
                    max_sections = max(max_sections, flow_sections)
                    height = height + flow_y + 5

                -- First row
                else
                    section:SetPoint("TOPLEFT", bag, "TOPLEFT", xoff, yoff)
                    --height = height + y
                end

                -- Frame/flow Data
                flow_anchor = section
                flow_items = section_items
                flow_sections = 0
                flow_x = x
                flow_y = y
            end

            width = max(x, width, flow_x)
        end
    end

    if (self.db.profile.hideemptybags and bagempty) then
        bag.isempty = true
    end

    -- Dimensions
    return width + skin.BagLeftPadding + skin.BagRightPadding, height + flow_y + skin.BagTopPadding + skin.BagBottomPadding
end

local areas = {}
function Baggins:OptimizeSectionLayout(bagid)
    local bagframe = self.bagframes[bagid]
    if not bagframe then
        return
    end
    local p = self.db.profile
    local s = self.currentSkin
    local totalwidth, totalheight = 0, 0

    for k in pairs(areas) do areas[k] = nil end

    tinsert(areas, format('0:0:%d:3000', self.db.profile.columns * 39))

    --Baggins:Debug("**** Laying out bag #%d ***", bagid)
    local bagempty = true

    for _,sectionframe in ipairs(bagframe.sections) do
        local count = sectionframe.itemcount
        if sectionframe.used and (count > 0 or not p.hideemptysections) then
            bagempty = false
            local minwidth = self:GetSectionSize(sectionframe, 1)
            local minheight = select(2, self:GetSectionSize(sectionframe))

            --[[
            Baggins:Debug("Section #%d, %d item(s), title width: %q, min width: %q, min height: %q",
                secid,	sectionframe.itemcount, sectionframe.title:GetWidth(), minwidth,
                minheight)
            --]]

            sectionframe.layout_waste = nil
            sectionframe.layout_columns = nil
            sectionframe.layout_area_index = nil

            for areaid,area in pairs(areas) do
                --Baggins:Debug("  Area #%d: %s", areaid, area)

                local area_w,area_h = area:match('^%d+:%d+:(%d+):(%d+)$')
                area_w = tonumber(area_w)
                area_h = tonumber(area_h)

                if area_w >= minwidth and area_h >= minheight then
                    local cols = floor(area_w / 39)
                    local width, height = self:GetSectionSize(sectionframe, cols)
                    --Baggins:Debug("    %d columns", cols)

                    if area_h >= height then
                        local waste = (area_w * area_h) - (width * height)
                        --Baggins:Debug("    area waste: %d", waste)

                        if not sectionframe.layout_waste or waste < sectionframe.layout_waste then
                            sectionframe.layout_waste = waste
                            sectionframe.layout_columns = cols
                            sectionframe.layout_areaid = areaid
                            --Baggins:Debug("    -> best fit")
                        else --luacheck: ignore 542
                            --Baggins:Debug("    -> do not fit")
                        end

                    else --luacheck: ignore 542
                        --Baggins:Debug("  -> too short")
                    end
                else --luacheck: ignore 542
                    --Baggins:Debug("  -> too small")
                end
            end
            local areaid = sectionframe.layout_areaid
            local area_x, area_y, area_w, area_h = tremove(areas, areaid):match('^(%d+):(%d+):(%d+):(%d+)$')
            area_x = tonumber(area_x)
            area_y = tonumber(area_y)
            area_w = tonumber(area_w)
            area_h = tonumber(area_h)
            local cols = sectionframe.layout_columns
            local width, height = self:GetSectionSize(sectionframe, cols)
            sectionframe:SetPoint('TOPLEFT', bagframe, 'TOPLEFT', s.BagLeftPadding + area_x, - (s.BagTopPadding + area_y) )
            sectionframe:SetWidth(width)
            sectionframe:SetHeight(height)

            totalwidth = max(totalwidth, area_x + width)
            totalheight = max(totalheight,area_y + height)
            --self:ReallyLayoutSection(sectionframe, cols)

            width = width + 10
            height = height + 10
            if area_w - width >= 39 then
                local area = format('%d:%d:%d:%d', area_x + width, area_y, area_w - width, height)
                --Baggins:Debug("Created new area: %s", area)
                tinsert(areas, area)
            end
            if area_h - height >= 39 then
                local area = format('%d:%d:%d:%d', area_x, area_y + height, area_w, area_h - height)
                --Baggins:Debug("Created new area: %s", area)
                tinsert(areas, area)
            end
        end
    end
    if (p.hideemptybags and bagempty) then
        bagframe.isempty = true
    end
    return s.BagLeftPadding + s.BagRightPadding + totalwidth, s.BagTopPadding + s.BagBottomPadding + totalheight
end

function Baggins:UpdateBagFrameSize(bagid)
    local bagframe = self.bagframes[bagid]
    if not bagframe then return end
    bagframe.dirty = true
    self:ScheduleRefresh()
end

function Baggins:ReallyUpdateBagFrameSize(bagid)
    local bagframe = self.bagframes[bagid]
    if not bagframe then return end
    local p = self.db.profile
    local s = self.currentSkin

    --Baggins:Debug('Updating bag #%d', bagid)
    bagframe.isempty = false

    local hpadding = s.BagLeftPadding + s.BagRightPadding
    local width = s.BagLeftPadding + s.TitlePadding
    local height = s.BagTopPadding + s.BagBottomPadding

    if not p.shrinkbagtitle then
        width = width + bagframe.title:GetStringWidth()
     end

    local layout = p.section_layout or "flow"
    if layout == 'optimize' then
        local swidth, sheight = Baggins:OptimizeSectionLayout(bagid)
        width = max(width, swidth)
        height = max(height, sheight)
    elseif layout == 'flow' then
        local x, y = self:FlowSections(bagid)
        width = max(x, width)
        height = max(y, height)
    else
        local lastsection
        local bagempty = true
        for _,section in ipairs(bagframe.sections) do
            if section.used and (not p.hideemptysections or section.itemcount > 0) then
                bagempty = false
                if not lastsection then
                    section:SetPoint("TOPLEFT",bagframe,"TOPLEFT",s.BagLeftPadding,-s.BagTopPadding)
                else
                    section:SetPoint("TOPLEFT",lastsection,"BOTTOMLEFT",0,-5)
                    height = height + 5
                end
                lastsection = section
                --self:ReallyLayoutSection(section)
                width = max(width,section:GetWidth()+hpadding)
                height = height + section:GetHeight()
            end
        end
        if (p.hideemptybags and bagempty) then
            bagframe.isempty = true
        end
    end

    if p.moneybag == bagid then
        bagframe.isempty = false
        BagginsMoneyFrame:SetParent(bagframe)
        BagginsMoneyFrame:ClearAllPoints()
        BagginsMoneyFrame:SetPoint("BOTTOMLEFT",bagframe,"BOTTOMLEFT",8,6)
        BagginsMoneyFrame:Show()
        width = max(BagginsMoneyFrame:GetWidth() + 16, width)
        height = height + 30
    end

    if p.bankcontrolbag == bagid then
        bagframe.isempty = false
        BagginsBankControlFrame:SetParent(bagframe)
        BagginsBankControlFrame:ClearAllPoints()
        BagginsBankControlFrame:SetPoint("BOTTOMLEFT",bagframe,"BOTTOMLEFT",12,8)
        BagginsBankControlFrame:Show()
        width = max(BagginsBankControlFrame:GetWidth() + 16, width)
        height = height + BagginsBankControlFrame:GetHeight()
    end

    if not p.shrinkwidth then
        width = max(p.columns*39 + hpadding, width)
    end

    if bagframe:GetWidth() ~= width or bagframe:GetHeight() ~= height then
        bagframe:SetWidth(width)
        bagframe:SetHeight(height)
        self.dirtyBagLayout = true
    end

    bagframe.dirty = nil
end

local sectionSortTab = {}
local function sectionComp(a, b)
    local bags = Baggins.db.profile.bags

    local bagA, secA = floor(a/1000), mod(a,1000)
    local bagB, secB = floor(b/1000), mod(b,1000)

    local PriA = (bags[bagA].priority or 1) + (bags[bagA].sections[secA].priority or 1)
    local PriB = (bags[bagB].priority or 1) + (bags[bagB].sections[secB].priority or 1)

    if PriA == PriB then
        return a < b
    else
        return PriA > PriB
    end
end

function Baggins:ResortSections()
    self.sectionOrderDirty = true
end

function Baggins:IsSlotMine(mybagid, mysecid, slot, wasMine)
    local p = self.db.profile
    if not p.hideduplicates or p.hideduplicates == "disabled" then
        return true
    end

    local bag = p.bags[mybagid]
    if not bag then return false end
    local section = bag.sections[mysecid]
    if not section then return false end

    if section.allowdupes then
        return true
    end

    if type(slot) == 'table' then
        for k, v in pairs(slot) do
            if v then
                slot = k
                break
            end
        end
    end

    --if self.sectionOrderDirty then
        local i = 1

        local numbags = #p.bags

        if p.hideduplicates == true or p.hideduplicates == "global" then
            for bagid = 1, numbags do
                local numsections = #p.bags[bagid].sections
                local bag = p.bags[bagid] --luacheck: ignore 421
                if bag then
                    for secid = 1, numsections do
                        local section = bag.sections[secid] --luacheck: ignore 421
                        if not section.allowdupes then
                            sectionSortTab[i] = bagid*1000 + secid
                            i = i + 1
                        end
                    end
                end
            end
        elseif p.hideduplicates == "bag" then
            local numsections = #p.bags[mybagid].sections
            local bag = p.bags[mybagid] --luacheck: ignore 421
            if bag then
                for secid = 1, numsections do
                    local section = bag.sections[secid] --luacheck: ignore 421
                    if not section.allowdupes then
                        sectionSortTab[i] = mybagid*1000 + secid
                        i = i + 1
                    end
                end
            end
        end

        while sectionSortTab[i] do
            sectionSortTab[i] = nil
            i = i + 1
        end
        self.sectionOrderDirty = nil
    --end

    tsort(sectionSortTab, sectionComp)

    for _, v in ipairs(sectionSortTab) do
        local bagid, secid = floor(v/1000), mod(v,1000)
        local section = self.bagframes[bagid].sections[secid] --luacheck: ignore 421
        if section and ((not wasMine and section.slots[slot]) or (wasMine and section.slots[slot] == false)) then
            if mybagid == bagid and mysecid == secid then
                return true
            else
                return false
            end
        end
    end
end

function Baggins:LayoutSection(sectionframe, title, cols)
    sectionframe.dirty = true
    sectionframe.set_title = title
    sectionframe.set_columns = cols
    self:ScheduleRefresh()
end

function Baggins:ReallyLayoutSection(sectionframe, cols)
    local bagid, secid = sectionframe.bagid, sectionframe.secid
    local p = self.db.profile
    local bagconf = p.bags[sectionframe.bagid]
    if not bagconf then return end
    local sectionconf = bagconf.sections[sectionframe.secid]
    if not sectionconf then return end
    local totalwidth, totalheight = 1,1
    local s = self.currentSkin
    cols = cols or sectionframe.set_columns or p.columns

    if p.showsectiontitle then
        totalheight = totalheight + s.SectionTitleHeight
    end
    sectionframe.itemcount = 0
    if sectionconf.hidden then
        for _, itemframe in ipairs(sectionframe.items) do
            itemframe:Hide()
        end
        for _, _ in ipairs(sectionframe.layout) do
            sectionframe.itemcount = sectionframe.itemcount + 1
        end
    else
        local itemnum = 1
        local itemframeno = 1
        local BaseTop
        if p.showsectiontitle then
            BaseTop = (sectionframe.title:GetHeight() + 1)
        else
            BaseTop = 0
        end
        for _, v in pairs(sectionframe.items) do
            v:Hide()
        end
        for _, v in ipairs(sectionframe.layout) do
            if (type(v) == "string" and self:IsSlotMine(bagid, secid, v, true)) or (type(v) == "table" and self:IsSlotMine(bagid, secid, v.slots)) then
                if type(v) == "table" then
                    sectionframe.items[itemframeno] = sectionframe.items[itemframeno] or self:CreateItemButton(sectionframe,itemframeno)
                    local itemframe = sectionframe.items[itemframeno]
                    itemframeno = itemframeno + 1
                    itemframe:SetPoint("TOPLEFT",sectionframe,"TOPLEFT",((itemnum-1)%cols)*39,-(BaseTop+(floor((itemnum-1)/cols)*39)))
                    local bag, slot, itemid = GetSlotInfo(next(v.slots))
                    if v.slotcount > 1 or ((p.compressall or p.compressempty) and not itemid) then
                        itemframe.countoverride = true
                    else
                        itemframe.countoverride = nil
                    end
                    if not itemframe.slots then
                        itemframe.slots = {}
                    else
                        wipe(itemframe.slots)
                    end
                    for slot in pairs(v.slots) do --luacheck: ignore 421
                        tinsert(itemframe.slots, slot)
                    end
                    self:UpdateItemButton(sectionframe:GetParent(),itemframe,tonumber(bag),tonumber(slot))

                    itemframe:Show()
                end
                sectionframe.itemcount = sectionframe.itemcount + 1
                if itemnum == 1 then
                    totalwidth = 39
                    totalheight = totalheight+39
                elseif itemnum%cols == 1 then
                    totalheight = totalheight+39
                else
                    if itemnum <= cols then
                        totalwidth = totalwidth+39
                    end
                end
                itemnum = itemnum + 1
            end
        end
        -- cleaning up unused itembuttons
        for _ = itemframeno,#sectionframe.items do
            local unusedframe = tremove(sectionframe.items, itemframeno)
            self:ReleaseItemButton(unusedframe)
        end
    end

    if p.showsectiontitle then
        local title = sectionframe.set_title
        if sectionconf.hidden then
            title = ("+ %s (%d)"):format(title, sectionframe.itemcount)
        else
            title = ("- %s"):format(title)
        end
        sectionframe.title:SetFont(LSM and LSM:Fetch("font", p.Font) or STANDARD_TEXT_FONT,p.FontSize or 10)
        sectionframe.title:SetText(title)
        totalwidth = max(totalwidth,sectionframe.title:GetWidth())
    else
        sectionframe.title:SetText("")
    end

    if sectionframe.itemcount == 0 and p.hideemptysections then
        totalheight = 1
        sectionframe:Hide()
    end

    if sectionframe:GetWidth() ~= totalwidth or sectionframe:GetHeight() ~= totalheight then
        sectionframe:SetWidth(totalwidth)
        sectionframe:SetHeight(totalheight)
        self.bagframes[sectionframe.bagid].dirty = true
    end

    sectionframe.dirty = nil
end

---------------------
-- Frame Creation  --
---------------------
function Baggins:CreateBagPlacementFrame()
local f = CreateFrame("frame","BagginsBagPlacement",UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil) --luacheck: ignore 113

    f:SetWidth(130)
    f:SetHeight(300)
    f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                                edgeFile = false,
                                                edgeSize = 0,
                                                insets = { left = 0, right = 0, top = 0, bottom = 0 }})
    f:SetBackdropColor(0.2,0.5,1,0.5)

    f:EnableMouse(true)
    f:SetMovable(true)
    f:SetResizable(true)
    f:SetClampedToScreen(true)
    f:SetScript("OnMouseDown",function(this, button) if button == "RightButton" then this:Hide() else this:StartMoving() end end)
    f:SetScript("OnMouseUp", function(this) this:StopMovingOrSizing() self:SaveBagPlacement() end)

    f.t = CreateFrame("frame","BagginsBagPlacementTopMover",f, BackdropTemplateMixin and "BackdropTemplate" or nil) --luacheck: ignore 113
    f.t:SetPoint("TOPLEFT",f,"TOPLEFT",0,0)
    f.t:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,0)
    f.t:SetHeight(20)
    f.t:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                                edgeFile = false,
                                                edgeSize = 0,
                                                insets = { left = 0, right = 0, top = 0, bottom = 0 }})
    f.t:SetBackdropColor(0,0,1,1)
    f.t:EnableMouse(true)
    f.t:SetScript("OnMouseDown",function(this) this:GetParent():StartSizing("TOP") end)
    f.t:SetScript("OnMouseUp", function(this) this:GetParent():StopMovingOrSizing() self:SaveBagPlacement() end)

    f.b = CreateFrame("frame","BagginsBagPlacementTopMover",f, BackdropTemplateMixin and "BackdropTemplate" or nil) --luacheck: ignore 113
    f.b:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,0)
    f.b:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,0)
    f.b:SetHeight(20)
    f.b:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                                edgeFile = false,
                                                edgeSize = 0,
                                                insets = { left = 0, right = 0, top = 0, bottom = 0 }})
    f.b:SetBackdropColor(0,0,1,1)
    f.b:EnableMouse(true)
    f.b:SetScript("OnMouseDown",function(this) this:GetParent():StartSizing("BOTTOM") end)
    f.b:SetScript("OnMouseUp", function(this) this:GetParent():StopMovingOrSizing() self:SaveBagPlacement() end)

    f.midtext = f:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    f.midtext:SetText(L["Drag to Move\nRight-Click to Close"])
    f.midtext:SetPoint("LEFT",f,"LEFT",0,0)
    f.midtext:SetPoint("RIGHT",f,"RIGHT",0,0)
    f.midtext:SetHeight(45)
    f.midtext:SetVertexColor(1, 1, 1)

    f.toptext = f.t:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    f.toptext:SetText(L["Drag to Size"])
    f.toptext:SetPoint("TOPLEFT",f,"TOPLEFT",0,-2)
    f.toptext:SetPoint("TOPRIGHT",f,"TOPRIGHT",0,-2)
    f.toptext:SetHeight(15)
    f.toptext:SetVertexColor(1, 1, 1)

    f.bottext = f.b:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    f.bottext:SetText(L["Drag to Size"])
    f.bottext:SetPoint("BOTTOMLEFT",f,"BOTTOMLEFT",0,2)
    f.bottext:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",0,2)
    f.bottext:SetHeight(15)
    f.bottext:SetVertexColor(1, 1, 1)
end

local function BagginsItemButton_OnEnter(button)
    if ( not button ) then
        return
    end

    local x
    x = button:GetRight()
    if ( x >= ( GetScreenWidth() / 2 ) ) then
        GameTooltip:SetOwner(button, "ANCHOR_LEFT")
    else
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    end

    -- Keyring specific code
    button:UpdateTooltip()

end

local KEYRING_CONTAINER = KEYRING_CONTAINER

local function showBattlePetTooltip(link)
    local speciesID, level, quality, maxHealth, power, speed = getBattlePetInfoFromLink(link)
    BattlePetToolTip_Show(speciesID, level, quality, maxHealth, power, speed)
end

local function BagginsItemButton_UpdateTooltip(button)
    if ( button:GetParent():GetID() == KEYRING_CONTAINER ) then
        GameTooltip:SetInventoryItem("player", KeyRingButtonIDToInvSlotID(button:GetID(),button.isBag))
        CursorUpdate(button)
        return
    end

    if button:GetParent():GetID() == -1 then
        if ( not GameTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(button:GetID(),button.isBag)) ) then
            if ( button.isBag ) then
                GameTooltip:SetText(button.tooltipText);
            end
        end
        CursorUpdate(button);
        return
    end
    if button:GetParent():GetID() == REAGENTBANK_CONTAINER then
        if ( not GameTooltip:SetInventoryItem("player", ReagentBankButtonIDToInvSlotID(button:GetID(),button.isBag)) ) then
            if ( button.isBag ) then
                GameTooltip:SetText(button.tooltipText);
            end
        end
        CursorUpdate(button);
        return
    end


    local showSell = nil;
    local itemlink = GetContainerItemLink(button:GetParent():GetID(), button:GetID())
    if itemlink and itemlink:match("battlepet:") then
        showBattlePetTooltip(itemlink)
        return
    end
    local _, repairCost = GameTooltip:SetBagItem(button:GetParent():GetID(), button:GetID());
    if ( InRepairMode() and (repairCost and repairCost > 0) ) then
        GameTooltip:AddLine(REPAIR_COST, "", 1, 1, 1);
        SetTooltipMoney(GameTooltip, repairCost);
        GameTooltip:Show();
    elseif ( MerchantFrame:IsShown() and MerchantFrame.selectedTab == 1 and not button.locked ) then
        showSell = 1;
    end

    if ( IsModifiedClick("DRESSUP") and button.hasItem ) then
        ShowInspectCursor();
    elseif ( showSell ) then
        ShowContainerSellCursor(button:GetParent():GetID(),button:GetID());
    elseif ( button.readable ) then
        ShowInspectCursor();
    else
        ResetCursor();
    end
end

do
    local menu = {}

    local function includeItemInCategory(info, itemID)
        Baggins:IncludeItemInCategory(info.value, itemID)
    end

    local function excludeItemFromCategory(info, itemID)
        Baggins:ExcludeItemFromCategory(info.value, itemID)
    end

    local useButton = CreateFrame("Button", "BagginsUseItemButton", UIParent, "SecureActionButtonTemplate")
    useButton:SetAttribute("type", "item")
    useButton:SetAttribute("item", nil)
    useButton:Hide()

    local function reallyHideUseButton()
        useButton:ClearAllPoints()
        useButton:SetAttribute("item", nil)
        useButton:UnregisterAllEvents()
        useButton:Hide()
        if useButton.owner then
            Baggins:Unhook(_G["DropDownList1Button" .. useButton.owner], "OnHide")
        end
        useButton.owner = nil
    end

    useButton:SetScript("OnEvent", function(self, event)
        UIDropDownMenu_Refresh(Baggins_ItemMenuFrame)
        if event == "PLAYER_REGEN_DISABLED" then
            self:Hide()
        elseif event == "PLAYER_REGEN_ENABLED" then
            if self.hideaftercombat then
                reallyHideUseButton()
                return
            end
            self:Show()
        end
    end)

    useButton:SetScript("OnEnter", function(self)
        local button = _G["DropDownList1Button" .. self.owner]
        button:GetScript("OnEnter")(button)
    end)

    useButton:SetScript("OnLeave", function(self)
        local button = _G["DropDownList1Button" .. self.owner]
        button:GetScript("OnLeave")(button)
    end)

    useButton:HookScript("OnClick", function(self)
        local button = _G["DropDownList1Button" .. self.owner]
        button:GetScript("OnClick")(button)
    end)

    local function hideUseButton()
        if InCombatLockdown() then
            useButton.hideaftercombat = true
            return
        end
        reallyHideUseButton()
    end

    local function showUseButton(bag, slot)
        useButton:SetAttribute("item", ("%d %d"):format(bag, slot))
        useButton:ClearAllPoints()
        local button = _G["DropDownList1Button" .. useButton.owner]
        useButton:SetAllPoints(button)
        useButton:SetFrameStrata(button:GetFrameStrata())
        useButton:SetFrameLevel(button:GetFrameLevel()+1)
        useButton:SetToplevel(true)
        useButton:RegisterEvent("PLAYER_REGEN_ENABLED")
        useButton:RegisterEvent("PLAYER_REGEN_DISABLED")
        useButton:Show()
        Baggins:SecureHookScript(button, "OnHide", hideUseButton)
    end

    local addCategoryIndex
    local excludeCategoryIndex
    -- some code to make the UIDropDownMenu scrollable
    local offset = 0
    local switchpage
    local catsorttable = {}
    local function pageup(self)
        offset = max(offset - 1,0)
        switchpage(self)
    end
    local function pagedown(self)
        offset = min(offset + 1, #catsorttable)
        switchpage(self)
    end
    function switchpage(self)
        -- check if it's one of the category-menus
        if self.parentID ~= addCategoryIndex and self.parentID ~= excludeCategoryIndex then
            offset = 0
            return
        end
        if offset < 0 then
            offset = 0
        end
        local maxoffset = #catsorttable - 20
        if offset > maxoffset then
            offset = maxoffset
        end
        for x = 1,20 do
            local y = x + offset
            local newtext
            local button = _G[self:GetName() .. "Button" .. x]
            if x == 1 and offset > 0 then
                newtext = "..."
                button.func = pageup
                button.keepShownOnClick = true
            elseif x == 20 and y < #catsorttable then
                newtext = "..."
                button.func = pagedown
                button.keepShownOnClick = true
            else
                newtext = catsorttable[y] or ""
                button.func = menu[self.parentID].menuList[2].func
                button.keepShownOnClick = false
            end
            button:SetText(newtext)
            button.value = newtext
        end
        UIDropDownMenu_Refresh(Baggins_ItemMenuFrame)
    end

    function makeMenu(bag, slot)
        wipe(menu)
        if not LBU:IsBank(bag, true) then
            local use = {
                text = L["Use"],
                tooltipTitle = L["Use"],
                tooltipText = L["Use/equip the item rather than bank/sell it"],
                -- tooltipOnButton = true,
                notCheckable = true,
                disabled = InCombatLockdown(),
                func = function()
                    if InCombatLockdown() then
                        Baggins:Debug("Baggins: Could not use item because you are in combat.")
                    end
                end,
            }
            tinsert(menu, use)
            useButton.owner = #menu
        end

        local addToCatMenu = {
            text = L["Add To Category"],
            hasArrow = true,
            menuList = {},
            notCheckable = true,
        }
        tinsert(menu, addToCatMenu)
        addCategoryIndex = #menu

        local excludeFromCatMenu = {
            text = L["Exclude From Category"],
            hasArrow = true,
            notCheckable = true,
            menuList = {},
        }
        tinsert(menu, excludeFromCatMenu)
        excludeCategoryIndex = #menu

        local itemID
        local CitemInfo = GetContainerItemInfo(bag, slot)
        local itemQuality = CitemInfo and CitemInfo.quality
        local itemLink = GetContainerItemLink(bag, slot)

        if itemLink then
          itemID = C_Item.GetItemID(ItemLocation:CreateFromBagAndSlot(bag, slot))
        end
        local itemName, _, _, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc = GetItemInfo(itemLink)
        if not itemName then
            _, _, _, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc = GetItemInfo(itemID)
            itemLink = itemID
        end

        local itemInfo = {
            text = L["Item Info"],
            hasArrow = true,
            notCheckable = true,
            menuList = {
                { text = L["ItemID: "]..itemID, notCheckable = true },
            },
        }

        if itemType then
            tinsert(itemInfo.menuList, { text = L["Item Type: "]..itemType, notCheckable = true })
            tinsert(itemInfo.menuList, { text = L["Item Subtype: "]..itemSubType, notCheckable = true })
        end
        tinsert(itemInfo.menuList, { text = L["Quality: "].._G["ITEM_QUALITY" .. itemQuality .. "_DESC"], notCheckable = true })
        if itemLevel and itemLevel > 1 then
            local effectiveItemLevel = GetDetailedItemLevelInfo(itemLink)
            if itemLevel ~= effectiveItemLevel then
                itemLevel = ("%d (%d)"):format(itemLevel, effectiveItemLevel)
            end
            tinsert(itemInfo.menuList, { text = L["Item Level: "]..itemLevel, notCheckable = true })
        end
        if itemMinLevel and itemMinLevel > 1 then
            tinsert(itemInfo.menuList, { text = L["Required Level: "]..itemMinLevel, notCheckable = true })
        end
        if itemStackCount and itemStackCount > 1 then
            tinsert(itemInfo.menuList, { text = L["Stack Size: "]..itemStackCount, notCheckable = true })
        end
        if itemEquipLoc and itemEquipLoc ~= "" then
            tinsert(itemInfo.menuList, { text = L["Equip Location: "]..(_G[itemEquipLoc] or itemEquipLoc), notCheckable = true })
        end
        -- tinsert(itemInfo.menuList, { text = ("Bag Location: %d %d"):format(bag, slot), notCheckable = true })

        tinsert(menu, itemInfo)
        local categories = Baggins.db.profile.categories
        while #catsorttable > 0 do
            tremove(catsorttable,#catsorttable)
        end
        for catid in pairs(categories) do
            tinsert(catsorttable,catid)
        end
        tsort(catsorttable)
        for i, name in ipairs(catsorttable) do
            if i == 20 and #catsorttable > 20 then
                addToCatMenu.menuList[i] = {
                    text= " ...",
                    notCheckable = true,
                    func = pagedown,
                    keepShownOnClick = true,
                }
                excludeFromCatMenu.menuList[i] = {
                    text = "...",
                    notCheckable = true,
                    func = pagedown,
                    keepShownOnClick = true,
                }
                break
            end
            addToCatMenu.menuList[i] = {
                text = name,
                notCheckable = true,
                func = includeItemInCategory,
                arg1 = itemID,
            }
            excludeFromCatMenu.menuList[i] = {
                text = name,
                notCheckable = true,
                func = excludeItemFromCategory,
                arg1 = itemID,
            }
        end
        DropDownList2:EnableMouseWheel(true)
        DropDownList2:SetScript("OnMouseWheel", function(self, delta)
            offset = offset - delta
            switchpage(self)
        end)
        return menu
    end

    local itemDropdownFrame = CreateFrame("Frame", "Baggins_ItemMenuFrame", UIParent, "UIDropDownMenuTemplate")

    local function BagginsItemButton_GetTargetBankTab(bag, slot)
        local itemLink = GetContainerItemLink(bag, slot)
        local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, isCraftingReagent = GetItemInfo(itemLink)
        if LBU:IsBank(bag) then
            if Baggins:IsRetailWow() then
                local count = LBU:CountSlots("REAGENTBANK")
                if isCraftingReagent and count ~= nil and count > 0 then
                    return REAGENT_BANK_TAB
                end
            end
        end
        return BANK_TAB
    end

    local function BagginsItemButton_OnClick(button)
        local bag = button:GetParent():GetID()
        local slot = button:GetID()
        UseContainerItem(bag, slot, nil, true)

        button:SetScript("OnClick",button.origOnClick)
        button.origOnClick = nil
    end

    local function BagginsItemButton_AutoReagent(button, mouseButton)
        if Baggins.bankIsOpen and Baggins.db.profile.autoreagent
                and not IsModifiedClick() and mouseButton == "RightButton" then
            local bag = button:GetParent():GetID()
            local slot = button:GetID()

            local target = BagginsItemButton_GetTargetBankTab(bag, slot)

            if target == REAGENT_BANK_TAB then
                BankFrame.selectedTab = 2
                button.origOnClick = button:GetScript("OnClick")
                button:SetScript("OnClick",BagginsItemButton_OnClick)
            else
                BankFrame.selectedTab = 1
            end
        end
    end

    local function BagginsItemButton_PreClick(button)
        BagginsItemButton_AutoReagent(button, GetMouseButtonClicked())
        if GetMouseButtonClicked() == "RightButton" and button.tainted then
            print("|cff00cc00Baggins: |cffffff00Right-clicking this button will not work until you leave combat|r")
        end
        for _, v in ipairs(button.slots) do
            local bag, slot = GetSlotInfo(v)
            local itemInfo = GetContainerItemInfo(bag, slot)
            local locked = itemInfo and itemInfo.isLocked

            if not locked then
                button:SetID(slot)
                local bagframe = button:GetParent():GetParent()
                if not bagframe.bagparents[bag] then
                    bagframe.bagparents[bag] = CreateFrame("Frame",nil,bagframe)
                    bagframe.bagparents[bag]:SetID(bag)
                end
                button:SetParent(bagframe.bagparents[bag])
                break
            end
        end
        local p = Baggins.db.profile
        if not p.DisableDefaultItemMenu then
            if (IsControlKeyDown() or IsAltKeyDown()) and GetMouseButtonClicked() == "RightButton" then
                local bag = button:GetParent():GetID();
                local slot = button:GetID();
                local itemid = GetContainerItemID(bag, slot)
                if itemid then
                    if DropDownList1:IsShown() then
                        DropDownList1:Hide()
                        return
                    end
                    makeMenu(bag, slot)
                    Baggins:EasyMenu(menu, itemDropdownFrame, "cursor", 0, 0, "MENU")
                    -- make sure we restore the original scroll-wheel behavior for the DropdownList2-Frame
                    -- when the item-dropdown is closed
                    Baggins:SecureHookScript(DropDownList1, "OnHide", function()
                        DropDownList2:EnableMouseWheel(false)
                        DropDownList2:SetScript("OnMouseWheel", nil)
                        Baggins:Unhook(DropDownList1, "OnHide")
                    end)

                    if not LBU:IsBank(bag, true) and not InCombatLockdown() then
                        showUseButton(bag, slot)
                    else
                        hideUseButton()
                    end
                end
            end
        end
    end

    function Baggins:SpawnMenuFromKeybind() --luacheck:ignore 212
        local button=GetMouseFocus() --luacheck:ignore 113
        --Baggins:Debug('Mouse focused on fame: ', button:GetName())
        if not string.find(button:GetName(),"Baggins") then return end
        local bag = button:GetParent():GetID();
        local slot = button:GetID();
        local itemid = GetContainerItemID(bag, slot)
        if itemid then
            if DropDownList1:IsShown() then
                DropDownList1:Hide()
                return
            end
            makeMenu(bag, slot)
            Baggins:EasyMenu(menu, itemDropdownFrame, "cursor", 0, 0, "MENU")
            -- make sure we restore the original scroll-wheel behavior for the DropdownList2-Frame
            -- when the item-dropdown is closed
            Baggins:SecureHookScript(DropDownList1, "OnHide", function()
                DropDownList2:EnableMouseWheel(false)
                DropDownList2:SetScript("OnMouseWheel", nil)
                Baggins:Unhook(DropDownList1, "OnHide")
            end)

            if not LBU:IsBank(bag, true) and not InCombatLockdown() then
                showUseButton(bag, slot)
            else
                hideUseButton()
            end
        end
    end

    function Baggins:CreateItemButton()
        local frame = Baggins:GetItemButton()
        frame.glow = frame.glow or frame:CreateTexture(nil,"OVERLAY")
        frame.glow:SetTexture("Interface\\Addons\\Baggins\\Textures\\Glow")
        frame.glow:SetAlpha(0.3)
        frame.glow:SetAllPoints(frame)

        frame.newtext = frame.newtext or frame:CreateFontString(frame:GetName().."NewText","OVERLAY","GameFontNormal")
        frame.newtext:SetFont(LSM and LSM:Fetch("font", Baggins.db.profile.Font) or STANDARD_TEXT_FONT,Baggins.db.profile.FontSize or 10)
        frame.newtext:SetPoint("TOP",frame,"TOP",0,0)
        frame.newtext:SetHeight(13)
        frame.newtext:SetTextColor(0,1,0,1)
        frame.newtext:SetShadowColor(0,0,0,1)
        frame.newtext:SetShadowOffset(1,-1)
        frame.newtext:SetText("*New*")
        frame.newtext:Hide()

        frame:ClearAllPoints()
        local cooldown = _G[frame:GetName().."Cooldown"]
        cooldown:SetAllPoints(frame)
        cooldown:SetFrameLevel(10)
        frame:SetFrameStrata("HIGH")
        frame:SetScript("OnEnter",BagginsItemButton_OnEnter)
        frame:SetScript("PreClick",BagginsItemButton_PreClick)
        frame.UpdateTooltip = BagginsItemButton_UpdateTooltip
        if frame.BattlepayItemTexture then
            -- New blue glow introduced in 6.0. Purposely keeping this conditional - it smells like something that could change name or get removed in a future patch.
            frame.BattlepayItemTexture:Hide()
        end
        --frame:SetScript("OnUpdate",BagginsItemButton_OnUpdate)
        if self.currentSkin then
            self.currentSkin:SkinItem(frame)
        end
        frame:Show()
        return frame
    end
end

do
    local dropdown = CreateFrame("Frame", "BagginsCategoryAddDropdown")
    local info = { }

    local function Close()
        CloseDropDownMenus()
    end

    local function Click(_, arg1, arg2)
        Baggins:IncludeItemInCategory(arg1, arg2)
        Baggins:Baggins_RefreshBags()
    end

    local dd_categories, dd_id
    dropdown.initialize = function()

        -- Title
        wipe(info)
        info.text = L["Add To Category"]
        info.isTitle = true
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, 1)

        -- Categories
        for _, v in ipairs(dd_categories) do
            wipe(info)
            info.text = v
            info.arg1 = v
            info.arg2 = dd_id
            info.func = Click
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, 1)
        end

        -- Close
        wipe(info)
        info.text = "|cff777777"..L["Close"]
        info.func = Close
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, 1)
    end

    local function RecieveDrag(self)
        local section = self:GetParent()
        local categories = Baggins.db.profile.bags[section.bagid].sections[section.secid].cats
        local ctype, cid = GetCursorInfo()
        if ctype ~= 'item' then return nil end
        if #categories == 1 then
            Click(nil, categories[1], cid)
        else
            dd_categories = categories
            dd_id = cid
            ToggleDropDownMenu(1, nil, BagginsCategoryAddDropdown, "UIParent", GetCursorPosition())
        end
        ClearCursor()
    end

    function Baggins:CreateSectionFrame(bagframe,secid)
        local frame = CreateFrame("Frame",bagframe:GetName().."Section"..secid,bagframe)

        frame.title = frame:CreateFontString(bagframe:GetName().."SectionTitle","OVERLAY","GameFontNormalSmall")
        frame.titleframe = CreateFrame("button",bagframe:GetName().."SectionTitleFrame",frame)
        frame.titleframe:SetAllPoints(frame.title)
        frame.titleframe:SetScript("OnClick", function(this) self:ToggleSection(this:GetParent()) end)
        frame.titleframe:SetScript("OnReceiveDrag", RecieveDrag)
        --[[
        frame.titleframe:SetScript("OnEnter", function(this) self:ShowSectionTooltip(this:GetParent()) end)
        frame.titleframe:SetScript("OnLeave", function(this) self:HideSectionTooltip(this:GetParent()) end)
        --]]
        frame:SetFrameStrata("HIGH")
        frame:Show()
        frame.items = {}
        frame.slots = {}
        frame.layout = {}
        frame.secid = secid
        frame.bagid = bagframe.bagid
        frame.itemcount = 0
        if self.currentSkin then
            self.currentSkin:SkinSection(frame)
        end

        return frame
    end
end

function Baggins:ToggleSection(sectionframe)
    local p = self.db.profile

    local bag = p.bags[sectionframe.bagid]
    if bag then
        local section = bag.sections[sectionframe.secid]
        if section then
            section.hidden = not section.hidden
            self:LayoutSection(sectionframe, section.name, p.columns)
            self:UpdateBagFrameSize(sectionframe.bagid)
        end
    end
end

function Baggins:CreateAllBags()
    for k, _ in ipairs(self.db.profile.bags) do
        if not self.bagframes[k] then
            self:CreateBagFrame(k)
        end
    end
end

function Baggins:CreateBagFrame(bagid)
    if not bagid then return end
    local bagname = "BagginsBag"..bagid

    local frame = CreateFrame("Frame",bagname,UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil) --luacheck: ignore 113
    self.bagframes[bagid] = frame
    frame.bagid = bagid
    frame:SetToplevel(true)
    frame:SetWidth(100)
    frame:SetHeight(100)
    frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetScript("OnMouseDown",function(this,arg1)
        if arg1=="LeftButton" and not self:AreBagsLocked() then
            this:StartMoving()
        end
    end)
    frame:SetScript("OnMouseUp",function(this,arg1)
        if arg1=="LeftButton" then
            this:StopMovingOrSizing() self:SaveBagPosition(this.bagid)
        elseif arg1=="RightButton" then
            Baggins:DoBagMenu(frame);
        end
    end)
    frame:SetScript("OnShow",function() self:FireSignal("Baggins_BagOpened", frame); end)


    frame.closebutton = CreateFrame("Button",bagname.."CloseButton",frame,"UIPanelCloseButton")
    frame.closebutton:SetScript("OnClick", function(this)
        if IsShiftKeyDown() then
            self:CloseAllBags()
        else
              self:CloseBag(this:GetParent().bagid)
        end
    end)

    frame.compressbutton = CreateFrame("Button",bagname.."CompressButton",frame,nil);
    frame.compressbutton:Hide();
    frame.compressbutton:SetScript("OnClick", function()
        self:CompressBags(Baggins.db.profile.bags[frame.bagid].isBank);
    end)
    frame.compressbutton:SetScript("OnEnter", function(this)
        GameTooltip:SetOwner(this, 'ANCHOR_DEFAULT')
        GameTooltip:SetText(L["Compress bag contents"]);
        GameTooltip:Show();
    end)
    frame.compressbutton:SetScript("OnLeave", function(this)
        if(GameTooltip:IsOwned(this)) then
            GameTooltip:Hide();
        end
    end)
    frame.compressbutton:SetHeight(32);
    frame.compressbutton:SetWidth(32);
    frame.compressbutton:SetNormalTexture("Interface\\AddOns\\Baggins\\Textures\\compressbutton.tga");
    self:RegisterSignal("Baggins_CanCompress", function(BagTable, bank, compressable)
            if Baggins.db.profile.bags[BagTable.bagid] then
                if (not Baggins.db.profile.bags[BagTable.bagid].isBank) == (not bank) then
                    (compressable and BagTable.compressbutton.Show or BagTable.compressbutton.Hide)(BagTable.compressbutton);
                end
            end
        end,
        frame
    );

    frame.title = frame:CreateFontString(bagname.."Title","OVERLAY","GameFontNormalLarge")
    frame.title:SetText("Baggins")
    frame:SetFrameStrata("HIGH")
    frame:SetClampedToScreen(true)
    frame:SetScale(self.db.profile.scale)
    frame.sections = {}
    frame.bagparents = {}

    if self.currentSkin then
        self.currentSkin:SkinBag(frame)
    end

    self:UpdateBagFrameSize(bagid)
    frame:Hide()
end

local function getsecond(_, value)
    return value
end

local function MoneyFrame_OnClick(button)
    local money = GetMoney()
    local multiplier
    if money < 100 then
        multiplier = 1
    elseif money < 10000 then
        multiplier = 100
    else
        multiplier = 10000
    end
    button.moneyType = "PLAYER"
    CoinPickupFrame:ClearAllPoints()
    OpenCoinPickupFrame(multiplier, money, button)
    button.hasPickup = 1

    CoinPickupFrame:ClearAllPoints()
    local frame = button

    if frame:GetCenter() < GetScreenWidth()/2 then
        if getsecond(frame:GetCenter()) < GetScreenHeight()/2 then
            CoinPickupFrame:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
        else
            CoinPickupFrame:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")
        end
    else
        if getsecond(frame:GetCenter()) < GetScreenHeight()/2 then
            CoinPickupFrame:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT")
        else
            CoinPickupFrame:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT")
        end
    end
end

function Baggins:CreateMoneyFrame() --luacheck: ignore 212
    local frame = CreateFrame("Button","BagginsMoneyFrame",UIParent)
    frame:SetPoint("CENTER")
    frame:SetWidth(100)
    frame:SetHeight(18)
    frame:EnableMouse(true)
    frame:SetScript("OnClick",MoneyFrame_OnClick)
    local goldIcon = frame:CreateTexture("BagginsGoldIcon", "ARTWORK")
    goldIcon:SetWidth(16)
    goldIcon:SetHeight(16)
    if Baggins:IsRetailWow() then
        goldIcon:SetAtlas("coin-gold")
    else
        goldIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
        goldIcon:SetTexCoord(0, 0.25, 0, 1)
    end

    local silverIcon = frame:CreateTexture("BagginsSilverIcon", "ARTWORK")
    silverIcon:SetWidth(16)
    silverIcon:SetHeight(16)
    if Baggins:IsRetailWow() then
        silverIcon:SetAtlas("coin-silver")
    else
        silverIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
        silverIcon:SetTexCoord(0.25, 0.5, 0, 1)
    end

    local copperIcon = frame:CreateTexture("BagginsCopperIcon", "ARTWORK")
    copperIcon:SetWidth(16)
    copperIcon:SetHeight(16)
    if Baggins:IsRetailWow() then
        copperIcon:SetAtlas("coin-copper")
    else
        copperIcon:SetTexture("Interface\\MoneyFrame\\UI-MoneyIcons")
        copperIcon:SetTexCoord(0.5, 0.75, 0, 1)
    end

    local goldText = frame:CreateFontString("BagginsGoldText", "OVERLAY")
    goldText:SetJustifyH("RIGHT")
    goldText:SetPoint("RIGHT", goldIcon, "LEFT", 0, 1)
    goldText:SetFontObject(GameFontNormal)

    local silverText = frame:CreateFontString("BagginsSilverText", "OVERLAY")
    silverText:SetJustifyH("RIGHT")
    silverText:SetPoint("RIGHT", silverIcon, "LEFT", 0, 1)
    silverText:SetFontObject(GameFontNormal)

    local copperText = frame:CreateFontString("BagginsCopperText", "OVERLAY")
    copperText:SetJustifyH("RIGHT")
    copperText:SetPoint("RIGHT", copperIcon, "LEFT", 0, 1)
    copperText:SetFontObject(GameFontNormal)

    copperIcon:SetPoint("RIGHT", frame, "RIGHT")
    silverIcon:SetPoint("RIGHT", copperText, "LEFT")
    goldIcon:SetPoint("RIGHT", silverText, "LEFT")
    frame:Hide()
end

function Baggins:UpdateMoneyFrame() --luacheck: ignore 212

    local copper = GetMoney()
    local gold = floor(copper / 10000)
    local silver = mod(floor(copper / 100), 100)
    copper = mod(copper, 100)

    local width = 0

    if gold == 0 then
        BagginsGoldIcon:Hide()
        BagginsGoldText:Hide()
    else
        BagginsGoldIcon:Show()
        BagginsGoldText:Show()
        BagginsGoldText:SetWidth(0)
        BagginsGoldText:SetText(gold)
        width = width + BagginsGoldIcon:GetWidth() + BagginsGoldText:GetWidth()
    end
    if gold == 0 and silver == 0 then
        BagginsSilverIcon:Hide()
        BagginsSilverText:Hide()
    else
        BagginsSilverIcon:Show()
        BagginsSilverText:Show()
        BagginsSilverText:SetWidth(0)
        BagginsSilverText:SetText(silver)
        width = width + BagginsSilverIcon:GetWidth() + BagginsSilverText:GetWidth()
    end
    BagginsCopperIcon:Show()
    BagginsCopperText:Show()
    BagginsCopperText:SetWidth(0)
    BagginsCopperText:SetText(copper)
    width = width + BagginsCopperIcon:GetWidth() + BagginsCopperText:GetWidth()
    BagginsMoneyFrame:SetWidth(width)
end

function Baggins:CreateBankControlFrame() --luacheck: ignore 212
    local frame = CreateFrame("Frame", "BagginsBankControlFrame", UIParent)
    frame:SetPoint("CENTER")
    frame:SetWidth(160)
    --frame:SetHeight((18 + 2) * 3)

    -- A button to allow purchase of bank slots
    -- Not super useful as you still require the default UI to place the bags,
    -- but can help as a reminder if a slot is not purchased with the default UI hidden.
    -- OnClick handler's are just like Blizzards default UI (see BankFrame.xml)
    frame.slotbuy = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    frame.slotbuy:SetScript("OnClick", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
        StaticPopup_Show("CONFIRM_BUY_BANK_SLOT");
    end)
    frame.slotbuy:SetWidth(160)
    frame.slotbuy:SetHeight(18)
    frame.slotbuy:SetText(L["Buy Bank Bag Slot"])
    frame.slotbuy:Hide()

    -- A button to buy the reagent bank
    if Baggins:IsRetailWow() then
        frame.rabuy = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        frame.rabuy:SetScript("OnClick", function()
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
            StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
        end)
        frame.rabuy:SetWidth(160)
        frame.rabuy:SetHeight(18)
        frame.rabuy:SetText(L["Buy Reagent Bank"])
        frame.rabuy:Hide()

        -- Finally, a button to allow blizzards "Deposit All Reagents" feature to work.
        -- this takes all your reagents and moves them into the reagent bank
        frame.radeposit = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        frame.radeposit:SetScript("OnClick", function()
            DepositReagentBank()
        end)
        frame.radeposit:SetWidth(160)
        frame.radeposit:SetHeight(18)
        frame.radeposit:SetText(L["Deposit All Reagents"])
        frame.radeposit:Hide()
    end

    frame:Hide()
end

function Baggins:UpdateBankControlFrame() --luacheck: ignore 212
    local frame = BagginsBankControlFrame
    local numbuttons = 0
    local anchorframe = frame
    local anchorpoint = "TOPLEFT"
    local anchoryoffset = 0

    local full = 86
    if full then
        frame.slotbuy:Hide()
    else
        frame.slotbuy:SetPoint("TOPLEFT", anchorframe, anchorpoint, 0, anchoryoffset)
        frame.slotbuy:Show()

        numbuttons = numbuttons + 1
        anchorframe = frame.slotbuy
        anchorpoint = "BOTTOMLEFT"
        anchoryoffset = -2
    end

    if Baggins:IsRetailWow() then
        frame.radeposit:SetPoint("TOPLEFT", anchorframe, anchorpoint, 0, anchoryoffset)
        frame.radeposit:Show()
        frame.rabuy:Hide()
        numbuttons = numbuttons + 1
    end

    frame:SetHeight((18 + 2) * numbuttons)
end

function Baggins:SetBagTitle(bagid,title)
    if self.bagframes[bagid] then
        self.bagframes[bagid].title:SetFont(LSM and LSM:Fetch("font", Baggins.db.profile.Font) or STANDARD_TEXT_FONT,Baggins.db.profile.FontSize or 10)
        self.bagframes[bagid].title:SetText(title)
        self:UpdateBagFrameSize(bagid)
    end
end

function Baggins:AreBagsLocked()
    return self.db.profile.lock or self.db.profile.layout == "auto"
end

function Baggins:UpdateLayout()
    if self.db.profile.layout == "auto" then
        self:LayoutBagFrames()
    else
        self:LoadBagPositions()
    end
end

----------------------
-- ItemButton Funcs --
----------------------
function Baggins:UpdateItemButtons()
    for _, bag in ipairs(self.bagframes) do
        for _, section in ipairs(bag.sections) do
            for _, button in ipairs(section.items) do
                if button:IsVisible() then
                    self:UpdateItemButton(bag,button,button:GetParent():GetID(),button:GetID())
                end
            end
        end
    end
end

function Baggins:UpdateItemButtonLocks()
    for _, bag in ipairs(self.bagframes) do
        for _, section in ipairs(bag.sections) do
            for _, button in ipairs(section.items) do
                if button:IsVisible() then
                    local itemInfo = GetContainerItemInfo(button:GetParent():GetID(), button:GetID())
                    local locked = itemInfo and itemInfo.isLocked
                    SetItemButtonDesaturated(button, locked, 0.5, 0.5, 0.5)
                end
            end
        end
    end
end

function Baggins:UpdateItemButtonCooldowns()
    for _, bag in ipairs(self.bagframes) do
        for _, section in ipairs(bag.sections) do
            for _, button in ipairs(section.items) do
                if button:IsVisible() then
                    local container = button:GetParent():GetID()
                    local slot = button:GetID()
                    local itemInfo = GetContainerItemInfo(container, slot)
                    local texture = itemInfo and itemInfo.iconFileID
                    if ( texture ) then
                        self:UpdateItemButtonCooldown(container, button)
                        button.hasItem = 1
                    else
                        _G[button:GetName().."Cooldown"]:Hide()
                        button.hasItem = nil
                    end
                end
            end
        end
    end
end

function Baggins:SetItemButtonCount(button, count, realcount) --luacheck: ignore 212
    if not button then
        return
    end
    if not count then
        count = 0
    end
    local counttext = _G[button:GetName().."Count"]
    if button.countoverride then
        button.count = realcount
    else
        button.count = count
    end
    if type(count) == "string" then
        counttext:ClearAllPoints()
        counttext:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-5,2)
        counttext:SetText(count)
        counttext:Show()
    elseif ( count > 1 or (button.isBag and count > 0) ) then
        if ( count > 999 ) then
            count = (floor(count/100)/10).."k"
            counttext:ClearAllPoints()
            counttext:SetPoint("BOTTOM",button,"BOTTOM",0,2)
        else
            counttext:ClearAllPoints()
            counttext:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-5,2)
        end
        counttext:SetText(count)
        counttext:Show()
    else
        counttext:Hide()
    end
end

function Baggins:IsNew(itemid)
    local itemcounts = self.itemcounts
    itemid = tonumber(itemid) or tonumber(itemid:match("item:(%d+)"))
    if not itemid then
        return nil
    end
    local savedcount = itemcounts[itemid]
    if not savedcount then
        return 1	-- completely new
    else
        local count = GetItemCount(itemid)
        if count ~= savedcount.count
            and (self.db.profile.newitemduration > 0 and time() - savedcount.ts < self.db.profile.newitemduration) then
            return 2	-- more of an existing
        else
            return nil	-- not new
        end
    end
end

function Baggins:UpdateItemButton(bagframe,button,bag,slot)
    local p = self.db.profile
    if not C_NewItems.IsNewItem(bag, slot) then
        local newItemTexture = _G[button:GetName().."NewItemTexture"]
        if newItemTexture then
            newItemTexture:Hide()
        end
    end

    local itemInfo = GetContainerItemInfo(bag, slot)
    local texture = itemInfo and itemInfo.iconFileID
    local itemCount = itemInfo and itemInfo.stackCount
    local locked = itemInfo and itemInfo.isLocked
    local quality = itemInfo and itemInfo.quality
    local readable = itemInfo and itemInfo.isReadable
    local link = itemInfo and itemInfo.hyperlink
    local itemid = itemInfo and itemInfo.itemID
    button:SetID(slot)
    -- quest item glow introduced in 3.3 (with silly logic)
    local isQuestItem, questId, isActive, ContainerItemQuestInfo
    if Baggins:IsRetailWow() or Baggins:IsWrathWow() then
        ContainerItemQuestInfo = GetContainerItemQuestInfo(bag, slot)
        isQuestItem = ContainerItemQuestInfo and ContainerItemQuestInfo.isQuestItem
        questId = ContainerItemQuestInfo and ContainerItemQuestInfo.questID
        isActive = ContainerItemQuestInfo and ContainerItemQuestInfo.isActive
    end
    local questTexture = (questId and not isActive) and TEXTURE_ITEM_QUEST_BANG or (questId or isQuestItem) and TEXTURE_ITEM_QUEST_BORDER
    if p.highlightquestitems and texture and questTexture then
        button.glow:SetTexture(questTexture)
        button.glow:SetVertexColor(1,1,1)
        button.glow:SetAlpha(1)
        button.glow:Show()
    elseif p.qualitycolor and texture and quality and quality >= p.qualitycolormin then
        local r, g, b = GetItemQualityColor(quality)
        button.glow:SetTexture("Interface\\Addons\\Baggins\\Textures\\Glow")
        button.glow:SetVertexColor(r,g,b)
        button.glow:SetAlpha(p.qualitycolorintensity)
        button.glow:Show()
    else
        button.glow:Hide()
    end
    local text = button.newtext
    if p.highlightnew and itemid and not LBU:IsBank(bag, true) then
        local isNew = self:IsNew(itemid)
        if isNew == 1 then
            text:SetText(L["*New*"])
            text:Show()
        elseif isNew == 2 then
            text:SetText("*+++*")
            text:Show()
        else
            text:Hide()
        end
    else
        text:Hide()
    end

    if not bagframe.bagparents[bag] then
        bagframe.bagparents[bag] = CreateFrame("Frame",nil,bagframe)
        bagframe.bagparents[bag]:SetID(bag)
    end
    button:SetParent(bagframe.bagparents[bag])
    if texture then
        SetItemButtonTexture(button, texture)
    elseif self.currentSkin and self.currentSkin.EmptySlotTexture then
        SetItemButtonTexture(button, self.currentSkin.EmptySlotTexture)
    else
        SetItemButtonTexture(button, nil)
    end
    if button.countoverride then
        local count
        if not itemid then
            local bagtype, itemFamily = Baggins:IsSpecialBag(bag)
            bagtype = bagtype or ""
            if Baggins:IsRetailWow() then
                --count = bagtype..LBU:CountSlots(LBU:IsBank(bag) and "BANK" or LBU:IsReagentBank(bag) and "REAGENTBANK" or "BAGS", itemFamily)
                count = 0
                if bag <=4 and bag >=0 then
                    for Bag = 0, 4 do
                        count = count + GetContainerNumFreeSlots(Bag)
                    end
                elseif bag == 5 then
                    count = count + GetContainerNumFreeSlots(bag)
                else
                    count = LBU:CountSlots(LBU:IsBank(bag) and "BANK" or LBU:IsReagentBank(bag) and "REAGENTBANK" or "BAGS", itemFamily)
                end
                count = bagtype..count
            end

            if not Baggins:IsRetailWow() then
                local freeslots
                if itemFamily == 0 then
                    -- lbu is screwing this up because it doesn't support classic keyring
                    -- So we do it manually
                    freeslots = 0
                    local startslot, endslot
                    if LBU:IsBank(bag) then
                        startslot, endslot = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
                    else
                        startslot, endslot = 0, NUM_BAG_SLOTS
                    end
                    for i=startslot, endslot do
                        local freeCount, bagType = GetContainerNumFreeSlots( i )
                        if bagType == 0 then
                            freeslots = freeslots + freeCount
                        end
                    end
                    count = bagtype..freeslots
                else
                    count = bagtype..LBU:CountSlots(LBU:IsBank(bag) and "BANK" or "BAGS", itemFamily)
                end
            end
        else
            count = GetItemCount(itemid)
            if LBU:IsBank(bag, true) then
                count = GetItemCount(itemid,true) - count
            end
            if IsEquippedItem(itemid) then
                count = count - 1
            end
        end
        self:SetItemButtonCount(button, count, itemCount)
    else
        self:SetItemButtonCount(button, itemCount)
    end
    SetItemButtonDesaturated(button, locked, 0.5, 0.5, 0.5)

    if ( texture ) then
        self:UpdateItemButtonCooldown(bag, button)
        button.hasItem = 1
    else
        _G[button:GetName().."Cooldown"]:Hide()
        button.hasItem = nil
    end
    if button.tainted then
        button.icon:SetAlpha(0.3)
    else
        button.icon:SetAlpha(1)
    end

    button.readable = readable

    if p.EnableItemUpgradeArrow then
        local itemClassID = itemid and select(12,GetItemInfo(itemid))
        if itemClassID and (itemClassID == 2 or itemClassID == 4) then
            local pawnLoaded = IsAddOnLoaded("Pawn")
            local pawnData
            local itemIsUpgrade
            local pawnContainerItem
            local pawnItem
            if pawnLoaded then
                pawnContainerItem = PawnIsContainerItemAnUpgrade and PawnIsContainerItemAnUpgrade(bag, slot)
                if pawnContainerItem == nil then
                    pawnData = PawnGetItemData and PawnGetItemData(link)
                    pawnItem = pawnData and PawnIsItemAnUpgrade(pawnData, true)
                end
                itemIsUpgrade = pawnContainerItem and pawnContainerItem or pawnItem and pawnItem
            else
                itemIsUpgrade = IsContainerItemAnUpgrade and IsContainerItemAnUpgrade(bag, slot)
            end
            button.UpgradeIcon:SetShown(itemIsUpgrade and itemIsUpgrade or false)
        end
    end

    if p.EnableItemLevelText then
        local ilvltext = button:CreateFontString("Bagginsilvltext", "OVERLAY", "GameFontNormal")
        if link then
            --itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent
            local _, _, _, _, _, _, _, _, _, _, _, classID = GetItemInfo(link)
            local item = Item:CreateFromBagAndSlot(bag, slot) --luacheck: ignore 113
            local level = item and item:GetCurrentItemLevel() or 0
            --if level and itemType == "Armor" or itemType == "Weapon" then
            if level and classID == Enum.ItemClass.Armor or classID == Enum.ItemClass.Weapon then
                --text:SetText(itemLevel)
                --text:Show()
                --ilvltext:SetFont(p.Font, 10)
                ilvltext:SetPoint(p.ItemLevelAncor,button,p.ItemLevelAncor,0,0)
                if p.ItemLevelQualityColor and quality then
                    local r, g, b = GetItemQualityColor(quality)
                    --print(r, g, b)
                    ilvltext:SetTextColor(r, g, b)
                else
                    ilvltext:SetTextColor(1, 1, 1)
                end
                ilvltext:SetText(level)
                button:SetFontString(ilvltext)
                ilvltext:Show()
                --print(type(tostring(level)))
                --self:SetItemButtonCount(button, level)
            else
                ilvltext:SetText("")
                button:SetFontString(ilvltext)
            end
        else
            ilvltext:SetText("")
            button:SetFontString(ilvltext)
        end
    end

    if Baggins:IsRetailWow() and not p.EnableItemReagentQuality then
        ClearItemCraftingQualityOverlay(button)
    end

    if Baggins:IsRetailWow() and link and p.EnableItemReagentQuality then
        if p.alwaysShowItemReagentQuality then
            button.alwaysShowProfessionsQuality = true
        else
            button.alwaysShowProfessionsQuality = false
        end
        SetItemCraftingQualityOverlay(button, link)
    end

    if Baggins:IsRetailWow() and link and p.EnablePetLevel then
        local petLeveltext = button:CreateFontString("BagginspetLeveltext", "OVERLAY", "GameFontNormal")
        local ExtractLink = LinkUtil.ExtractLink
        local linkType = ExtractLink(link) --linkType, linkOptions
        if linkType == "battlepet" then
            local _, _, petLevel, breedQuality = strsplit(":", link)
            petLeveltext:SetPoint(p.ItemLevelAncor,button,p.ItemLevelAncor,0,0)
            if p.ItemLevelQualityColor then
                local r, g, b = GetItemQualityColor(breedQuality)
                petLeveltext:SetTextColor(r, g, b)
            else
                petLeveltext:SetTextColor(1, 1, 1)
            end
            petLeveltext:SetText(petLevel)
            button:SetFontString(petLeveltext)
            petLeveltext:Show()
        elseif petLeveltext then
            petLeveltext:Hide()
        end
    end

    if Scrap and link then --  and p.EnablePetLevel
        --local scraptext = button:CreateFontString("Bagginsilvltext", "OVERLAY", "GameFontNormal")
        --scraptext:SetText("scrap")
        --button:SetFontString(scraptext)
        --local item = Item:CreateFromBagAndSlot(bag, slot)
        local id = GetContainerItemID(bag, slot)
        local icon = button:CreateTexture(nil, 'OVERLAY')
        if Scrap:IsJunk(id, bag, slot) then
            icon:SetTexture('Interface/Buttons/UI-GroupLoot-Coin-Up')
            icon:SetPoint('TOPLEFT', 2, -2)
            icon:SetSize(15, 15)
        else
            icon:SetTexture('')
        end
    end

    --local normalTexture = getglobal(name.."Item"..j.."NormalTexture")
    --if ( quality and quality ~= -1) then
    --	local color = getglobal("ITEM_QUALITY".. quality .."_COLOR")
    --	normalTexture:SetVertexColor(color.r, color.g, color.b)
    --else
    --	normalTexture:SetVertexColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
    --end
    --[[
    if button:GetParent():GetID() == -1 then
        if ( not GameTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(button:GetID(),button.isBag)) ) then
            if ( self.isBag ) then
                GameTooltip:SetText(self.tooltipText);
            end
        end
        CursorUpdate();
        return
    end

    local showSell = nil;
    local hasCooldown, repairCost = GameTooltip:SetBagItem(button:GetParent():GetID(), button:GetID());
    if ( InRepairMode() and (repairCost and repairCost > 0) ) then
        GameTooltip:AddLine(REPAIR_COST, "", 1, 1, 1);
        SetTooltipMoney(GameTooltip, repairCost);
        GameTooltip:Show();
    elseif ( MerchantFrame:IsShown() and MerchantFrame.selectedTab == 1 and not button.locked ) then
        showSell = 1;
    end

    if ( IsModifiedClick("DRESSUP") and button.hasItem ) then
        ShowInspectCursor();
    elseif ( showSell ) then
        ShowContainerSellCursor(button:GetParent():GetID(),button:GetID());
    elseif ( button.readable ) then
        ShowInspectCursor();
    else
        ResetCursor();
    end]]

    self:FireSignal("Baggins_ItemButtonUpdated", bagframe, button, bag, slot)
end

function Baggins:UpdateItemButtonCooldown(container, button) --luacheck: ignore 212
    local cooldown = _G[button:GetName().."Cooldown"]
    local start, duration, enable = GetContainerItemCooldown(container, button:GetID())

    -- CooldownFrame_SetTimer has been renamed to CooldownFrame_Set in 7.0
    -- We'll check for the new name and use it if it's available. This lets the patch
    -- work with both 6.2 and 7.0.
    local setTimer
    if (CooldownFrame_Set ~= nil) then
        setTimer = CooldownFrame_Set
    else
        setTimer = CooldownFrame_SetTimer
    end
    setTimer(cooldown, start, duration, enable)

    if ( duration > 0 and enable == 0 ) then
        SetItemButtonTextureVertexColor(button, 0.4, 0.4, 0.4)
    end
end


---------------------
-- Frame Placement --
---------------------
-- manual
function Baggins:SaveBagPosition(bagid)
    local frame = self.bagframes[bagid]
    if not frame then return end
    local s = frame:GetEffectiveScale()
    self.db.profile.bags[bagid].x = frame:GetLeft() * s
    self.db.profile.bags[bagid].y = frame:GetTop() * s
end

function Baggins:LoadBagPositions()
    for i = 1, #self.db.profile.bags do
        self:LoadBagPosition(i)
    end
end

function Baggins:LoadBagPosition(bagid)
    local bag = self.db.profile.bags[bagid]
    local frame = self.bagframes[bagid]
    if not frame then return end
    local s = frame:GetEffectiveScale()
    frame:ClearAllPoints()
    if bag.x and bag.y then
        frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT", bag.x / s, bag.y / s)
    else
        frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
    end
end
-- auto
function Baggins:SaveBagPlacement()
    local p = self.db.profile
    local frame = BagginsBagPlacement
    if not frame then return end
    p.rightoffset = (GetScreenWidth() - frame:GetRight() )
    p.bottomoffset = frame:GetBottom()
    p.topoffset = (GetScreenHeight() - frame:GetTop() )
    p.leftoffset = frame:GetLeft()
end

function Baggins:LoadBagPlacement()
    local p = self.db.profile
    local frame = BagginsBagPlacement
    if not frame then return end
    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", - p.rightoffset, p.bottomoffset)
    frame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT", - p.rightoffset, - p.topoffset)
end

function Baggins:ShowPlacementFrame()
    if not BagginsBagPlacement then
        self:CreateBagPlacementFrame()
    end
    Baggins:LoadBagPlacement()
    BagginsBagPlacement:Show()
end

function Baggins:LayoutBagFrames()
    self.dirtyBagLayout = true
    self:ScheduleRefresh()
end

local CONTAINER_SPACING = 0
local VISIBLE_CONTAINER_SPACING = 3

function Baggins:ReallyLayoutBagFrames()
    local p = self.db.profile
    if p.layout ~= "auto" then
        for _, frame in ipairs(self.bagframes) do
            if (p.hideemptybags) then
                if (frame.isempty) then
                    if (frame:IsVisible()) then
                        frame.autohide = true
                        frame:Hide()
                    end
                else
                    if (frame.autohide) then
                        frame.autohide = false
                        frame:Show()
                    end
                end
            end
        end
        return
    end
    local xOffset, yOffset, screenHeight, freeScreenHeight, column, maxwidth

    screenHeight = GetScreenHeight()

    local initialcorner = p.layoutanchor
    local nextcorner, vdir, hdir
    local availableScreenHeight
    if initialcorner == "BOTTOMRIGHT" then
        hdir = -1
        vdir = 1
        nextcorner = "TOPRIGHT"
        xOffset = p.rightoffset
        yOffset = p.bottomoffset
        availableScreenHeight = screenHeight - yOffset - p.topoffset
    elseif initialcorner == "BOTTOMLEFT" then
        hdir = 1
        vdir = 1
        nextcorner = "TOPLEFT"
        xOffset = p.leftoffset
        yOffset = p.bottomoffset
        availableScreenHeight = screenHeight - yOffset - p.topoffset
    elseif initialcorner == "TOPRIGHT" then
        hdir = -1
        vdir = -1
        nextcorner = "BOTTOMRIGHT"
        xOffset = p.rightoffset
        yOffset = p.topoffset
        availableScreenHeight = screenHeight - yOffset - p.bottomoffset
    elseif initialcorner == "TOPLEFT" then
        hdir = 1
        vdir = -1
        nextcorner = "BOTTOMLEFT"
        xOffset = p.leftoffset
        yOffset = p.topoffset
        availableScreenHeight = screenHeight - yOffset - p.bottomoffset
    end
    -- Adjust the start anchor for bags depending on the multibars

    -- freeScreenHeight determines when to start a new column of bags
    freeScreenHeight = availableScreenHeight
    maxwidth = 1
    column = 0
    local index = 1
    local columnoffset = 0
    local prevframe
    for id, frame in ipairs(self.bagframes) do
        if (p.hideemptybags) then
            if (frame.isempty) then
                if (frame:IsVisible()) then
                    frame.autohide = true
                    frame:Hide()
                end
            else
                if (frame.autohide) then
                    frame.autohide = false
                    frame:Show()
                end
            end
        end
        if frame:IsVisible() then
            --self:ReallyUpdateBagFrameSize(id)
            frame:ClearAllPoints()
            local s = frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
            if ( index == 1 ) then
                -- First bag
                frame:SetPoint(initialcorner, frame:GetParent(), initialcorner,  hdir * xOffset/s, vdir * yOffset/s )
                index = index + 1
                prevframe = frame
            elseif ( freeScreenHeight < frame:GetHeight()*s ) then
                -- Start a new column
                column = column + 1
                columnoffset = columnoffset + maxwidth
                maxwidth = 1
                freeScreenHeight = availableScreenHeight
                frame:SetPoint(initialcorner, frame:GetParent(), initialcorner, hdir * ( columnoffset + xOffset/s), vdir * yOffset/s )
                index = index + 1
                prevframe = frame
            else
                -- Anchor to the previous bag
                frame:SetPoint(initialcorner, prevframe, nextcorner, 0, vdir * CONTAINER_SPACING)
                index = index + 1
                prevframe = frame
            end
            maxwidth = max(maxwidth, frame:GetWidth())
            self:SaveBagPosition(id)
            freeScreenHeight = freeScreenHeight - frame:GetHeight()*s - VISIBLE_CONTAINER_SPACING
        end
    end
    self.dirtyBagLayout = nil
end

function Baggins:UpdateBagScale()
    for _, frame in ipairs(self.bagframes) do
        frame:SetScale(self.db.profile.scale)
    end
    self:FireSignal("Baggins_UpdateBagScale")
end

---------------------
-- Fubar Plugin    --
---------------------
function Baggins:UpdateText()
    self:OnTextUpdate()
end

function Baggins:SetText(text) --luacheck: ignore 212
    ldbdata.text = text
end

function BagginsOnAddonCompartmentClick(_,button)
    if button == "RightButton" then
        --tooltip:Hide()
        updateMenu()
        Baggins:EasyMenu(ldbDropDownMenu, ldbDropDownFrame, "cursor", 0, 0, "MENU")
        -- Baggins:OpenConfig()
    else
        Baggins:OnClick()
    end
end

function Baggins:OnClick()
    if IsShiftKeyDown() then
        self:SaveItemCounts()
        self:ForceFullUpdate()
    elseif IsControlKeyDown() and self.db.profile.layout == 'manual' then
        self.db.profile.lock = not self.db.profile.lock
    else
        self:ToggleAllBags()
    end
end

function Baggins:UpdateTooltip(force) --luacheck: ignore 212
    if not tooltip then return end
    if not tooltip:IsShown() and not force then return end
    ldbdata:OnTooltipUpdate()
end

local function openBag(_, line)
    Baggins:ToggleBag(line)
end

function ldbdata:OnTooltipUpdate()
    tooltip:Clear()
    local title = tooltip:AddHeader()
    tooltip:SetCell(title, 1, "Baggins", tooltip:GetHeaderFont(), "LEFT")
    tooltip:AddLine()
    for bagid, bag in ipairs(Baggins.db.profile.bags) do
        if not bag.isBank or (bag.isBank and self.bankIsOpen) then
            local name = bag.name
            if Baggins.bagframes[bagid] and Baggins.bagframes[bagid]:IsVisible() then
                name = "* "..name
            end
            local line = tooltip:AddLine(name)
            tooltip:SetLineScript(line, "OnMouseUp", openBag, line - 2)
        end
    end
end



function Baggins:BuildCountString(empty, total, color)
    local p = self.db.profile
    color = color or ""
    local div = "|r/"
    if p.showtotal then
        if p.showused and p.showempty then
            return format("%s%i%s%s%i%s%s%i", color, total-empty, div, color, empty, div, color, total)
        elseif p.showused then
            return format("%s%i%s%s%i", color, total-empty, div, color, total)
        elseif p.showempty then
            return format("%s%i%s%s%i", color, empty, div, color, total)
        end
        return format("%s%i", color, total)
    end

    if p.showused and p.showempty then
        return format("%s%i%s%s%i", color, total-empty, div, color, empty)
    elseif p.showused then
        return format("%s%i", color, total-empty)
    elseif p.showempty then
        return format("%s%i", color, empty)
    end
    return ""
end


local texts={}
function Baggins:OnTextUpdate()
    local p = self.db.profile
    local color

    if p.combinecounts then
        local normalempty, normaltotal = Baggins:CountNormalSlots("BAGS")
        local specialempty, specialtotal = 0,0
        local e, t

        if p.showspecialcount then
            e, t = Baggins:CountSpecialSlots("BAGS")
            specialempty = specialempty + e
            specialtotal = specialtotal + t
        end
        if p.showammocount then
            e, t = Baggins:CountAmmoSlots("BAGS")
            specialempty = specialempty + e
            specialtotal = specialtotal + t
        end
        if p.showsoulcount then
            e, t = Baggins.CountSoulSlots("BAGS")
            specialempty = specialempty + e --luacheck: ignore 311
            specialtotal = specialtotal + t --luacheck: ignore 311
        end

        local empty, total = 0,0
        empty=empty+normalempty
        total=total+normaltotal

        local fullness = 1 - (empty/total)
        local r, g
        r = min(1,fullness * 2)
        g = min(1,(1-fullness) *2)
        color = ("|cFF%2X%2X00"):format(r*255,g*255)

        self:SetText(self:BuildCountString(empty,total,color))
        return
    end

    -- separate normal/ammo/soul/special counts

    local n=0	-- count of strings in texts{}

    local normalempty, normaltotal = Baggins:CountNormalSlots("BAGS")

    local fullness = 1 - (normalempty/normaltotal)
    local r, g
    r = min(1,fullness * 2)
    g = min(1,(1-fullness) *2)
    color = ("|cFF%2X%2X00"):format(r*255,g*255)

    n=n+1
    texts[n] = self:BuildCountString(normalempty,normaltotal,color)

    if self.db.profile.showsoulcount then
        local soulempty, soultotal = Baggins:CountSoulSlots("BAGS")
        if soultotal>0 then
            color = self.colors.purple.hex
            n=n+1
            texts[n] = self:BuildCountString(soulempty,soultotal,color)
        end
    end

    if self.db.profile.showammocount then
        local ammoempty, ammototal = Baggins:CountAmmoSlots("BAGS")
        if ammototal>0 then
            color = self.colors.white.hex
            n=n+1
            texts[n] = self:BuildCountString(ammoempty,ammototal,color)
        end
    end

    if self.db.profile.showspecialcount then
        local specialempty, specialtotal = Baggins:CountSpecialSlots("BAGS")
        if specialtotal>0 then
            color = self.colors.blue.hex
            n=n+1
            texts[n] = self:BuildCountString(specialempty,specialtotal,color)
        end
    end

    if n==1 then
        self:SetText(texts[1])
    else
        self:SetText(tconcat(texts, " ", 1, n))
    end
end

function Baggins:CountNormalSlots(which) --luacheck: ignore 212
    return LBU:CountSlots(which, 0)
end

function Baggins:CountAmmoSlots(which) --luacheck: ignore 212
    if not Baggins:IsRetailWow() then
        -- This version of LBU doesn't index special bags properly. but we can work around it by looking up each type individually.
           local qiverempty, quivertotal = LBU:CountSlots(which, 1)
           local ammoempty, ammototal = LBU:CountSlots(which, 2)
           return qiverempty+ammoempty, quivertotal+ammototal
    end
    if Baggins:IsRetailWow() then
        return LBU:CountSlots(which, 1+2)
    end
end

function Baggins:CountSoulSlots(which) --luacheck: ignore 212
    return LBU:CountSlots(which, 3)
end

function Baggins:CountSpecialSlots(which) --luacheck: ignore 212
    if not Baggins:IsRetailWow() then
        local empty, total = 0,0
        -- This version of LBU doesn't index special bags properly. but we can work around it by looking up each type individually.
        local e, t = LBU:CountSlots(which, 4) -- leather?
        empty = empty + e
        total = total + t

        local e, t = LBU:CountSlots(which, 5) --luacheck: ignore 411 -- inscription?
        empty = empty + e
        total = total + t

        local e, t = LBU:CountSlots(which, 6) --luacheck: ignore 411 -- herb
        empty = empty + e
        total = total + t

        local e, t = LBU:CountSlots(which, 7) --luacheck: ignore 411 -- enchant
        empty = empty + e
        total = total + t

        local e, t = LBU:CountSlots(which, 8) --luacheck: ignore 411 -- engineering?
        empty = empty + e
        total = total + t

        local e, t = LBU:CountSlots(which, 10) --luacheck: ignore 411 -- gems?
        empty = empty + e
        total = total + t

        local e, t = LBU:CountSlots(which, 11) --luacheck: ignore 411 -- mining?
        empty = empty + e
        total = total + t

        return empty, total
    end
    if Baggins:IsRetailWow() then
        return LBU:CountSlots(which, 2047-256-4-2-1)
    end
end

function Baggins:CountKeySlots(which) --luacheck: ignore 212
    if not Baggins:IsRetailWow() then
        return LBU:CountSlots(which, 9)
    end
    if Baggins:IsRetailWow() then
        return LBU:CountSlots(which,256)
    end
end

---------------------
-- Add/Remove/Move --
---------------------
function Baggins:NewBag(bagname)
    local bags = self.db.profile.bags
    tinsert(bags, { name=bagname, openWithAll=true, sections={}})
    if not self.bagframes[#bags] then
        self:CreateBagFrame(#bags)
    end
    currentbag = #bags
    self:ResortSections()
    self:ForceFullRefresh()
    self:Baggins_RefreshBags()
    self:UpdateLayout()
    self:BuildMoneyBagOptions()
    self:BuildBankControlsBagOptions()
end

function Baggins:MoveBag(bagid, down)
    local bags = self.db.profile.bags
    local other
    if down then
        other = bagid + 1
    else
        other = bagid - 1
    end

    if bags[bagid] and bags[other] then
        bags[bagid], bags[other] = bags[other], bags[bagid]
    end
    self:ResortSections()
    self:ForceFullRefresh()
    self:BuildMoneyBagOptions()
    self:BuildBankControlsBagOptions()
end

function Baggins:MoveSection(bagid, sectionid, down)
    local other
    if down then
        other = sectionid + 1
    else
        other = sectionid - 1
    end
    if self.db.profile.bags[bagid] then
        local sections = self.db.profile.bags[bagid].sections
        if sections[sectionid] and sections[other] then
            sections[sectionid], sections[other] = sections[other], sections[sectionid]
        end
    end
    self:ResortSections()
    self:ForceFullRefresh()
end

function Baggins:MoveRule(categoryid, ruleid, down)
    local other
    if down then
        other = ruleid + 1
    else
        other = ruleid - 1
    end
    local rules = self.db.profile.categories[categoryid]
    if rules then
        if rules[ruleid] and rules[other] then
            rules[ruleid], rules[other] = rules[other], rules[ruleid]
        end
    end
end

function Baggins:RemoveBag(bagid)
    self:CloseBag(bagid)
    tremove(self.db.profile.bags, bagid)
    self:ResetCatInUse()
    self:ResortSections()
    self:ForceFullRefresh()
    self:Baggins_RefreshBags()
    self:UpdateLayout()
    local numbags, numbagframes = #self.db.profile.bags, #self.bagframes
    for i = numbags+1, numbagframes do
        if self.bagframes[i] then
            self.bagframes[i]:Hide()
        end
    end
    self:BuildMoneyBagOptions()
    self:BuildBankControlsBagOptions()
end

function Baggins:NewSection(bagid,sectionname)
    tinsert(self.db.profile.bags[bagid].sections, { name=sectionname, cats = {} })
    currentsection = #self.db.profile.bags[bagid].sections
    self:ResortSections()
    self:ForceFullRefresh()
    self:Baggins_RefreshBags()
    self:UpdateLayout()
end

function Baggins:NewCategory(catname)
    if not self.db.profile.categories[catname] then
        self.db.profile.categories[catname] = { name=catname }
        currentcategory = catname
        --tablet:Refresh("BagginsEditCategories")
        self:RebuildCategoryOptions()
    end
end

function Baggins:RemoveSection(bagid, sectionid)
    tremove(self.db.profile.bags[bagid].sections, sectionid)
    self:ResetCatInUse()
    self:ResortSections()
    self:ForceFullRefresh()
    self:Baggins_RefreshBags()
    self:UpdateLayout()
end

function Baggins:AddRule()
    --tablet:Refresh("BagginsEditCategories")
    Baggins:OnRuleChanged()
    self:ForceFullRefresh()
    self:Baggins_RefreshBags()
    self:UpdateLayout()
end

function Baggins:RemoveRule(catid, ruleid)
    tremove(self.db.profile.categories[catid], ruleid)
    --tablet:Refresh("BagginsEditCategories")
    Baggins:OnRuleChanged()
    self:ForceFullRefresh()
    self:Baggins_RefreshBags()
    self:UpdateLayout()
end

function Baggins:AddCategory(bagid,sectionid,category)
    tinsert(self.db.profile.bags[bagid].sections[sectionid].cats,category)
    self:ResetCatInUse(category)
    self:ForceFullRefresh()
    self:Baggins_RefreshBags()
    self:UpdateLayout()
end

do
    local catinuse = { [true] = {}, [false] = {}}
    function Baggins:ResetCatInUse(catname) --luacheck: ignore 212
        if catname then
            catinuse[true][catname] = nil
            catinuse[false][catname] = nil
        else
            for k in pairs(catinuse[true]) do
                catinuse[true][k] = nil
            end
            for k in pairs(catinuse[false]) do
                catinuse[false][k] = nil
            end
        end
    end

    function Baggins:CategoryInUse(catname, isbank)
        if not catname then return end
        if isbank == nil or catinuse[isbank][catname] == nil then
            for _, bag in ipairs(self.db.profile.bags) do
                if isbank==nil or ((not bag.isBank) == (not isbank)) then
                    for _, section in ipairs(bag.sections) do
                        for _, cat in ipairs(section.cats) do
                            if cat == catname then
                                if isbank ~= nil then
                                    catinuse[isbank][catname] = true
                                end
                                return true
                            end
                        end
                    end
                end
            end
            if isbank ~= nil then
                catinuse[isbank][catname] = false
            end
            return false
        else
            return catinuse[isbank][catname]
        end
    end
end

function Baggins:RemoveCategory(bagid,sectionid,catid)
    local p = self.db.profile
    if type(bagid) == "string" then
        --removing a category completely
        if not self:CategoryInUse(bagid) then
            p.categories[bagid] = nil
        end
        self:RebuildCategoryOptions()
    else
        --removing a category from a bag
        tremove(p.bags[bagid].sections[sectionid].cats,catid)
        self:ResetCatInUse()
        self:ForceFullRefresh()
        self:Baggins_RefreshBags()
        self:UpdateLayout()
    end
end

---------------------
-- Bag Open/Close  --
---------------------
function Baggins:CloseBag(bagid)
    if self.bagframes[bagid] then
        self.bagframes[bagid]:Hide()
        if self.db.profile.hidedefaultbank and self.db.profile.bags[bagid].isBank then
            if self.bankIsOpen and not self:IsAnyBankOpen() then
                CloseBankFrame()
            end
        end
        self:UpdateLayout()
    end
    self:UpdateTooltip()

    if(not Baggins:IsAnyBagOpen()) then
        --self:SetBagUpdateSpeed(false);	-- indicate bags closed
        self:FireSignal("Baggins_AllBagsClosed");
        -- reset temp no item compression
        if self.tempcompressnone then
            self.tempcompressnone = nil
            self:RebuildSectionLayouts()
        end
    end
    PlaySound(863)
end

function Baggins:CloseAllBags()
    for bagid, _ in ipairs(self.db.profile.bags) do
        Baggins:CloseBag(bagid)
    end
    PlaySound(863)
end

function Baggins:MainMenuBarBackpackButtonOnClick(button)
    if IsAltKeyDown() then
        BackpackButton_OnClick(button)
    else
        self:ToggleAllBags()
        --button:SetChecked(false)
    end
end

function Baggins:ToggleBag(bagid)
    if not self.bagframes[bagid] then
        self:CreateBagFrame(bagid)
        self:OpenBag(bagid)
    elseif self.bagframes[bagid]:IsVisible() then
        self:CloseBag(bagid)
    else
        self:OpenBag(bagid)
    end
end

function Baggins:OpenBag(bagid,_) --bagid,noupdate

    --if self.db.profile.newitemduration > 0 then
        --Baggins:SaveItemCounts()
    --end
    --self:SetBagUpdateSpeed(true);	-- indicate bags open
    local p = self.db.profile
    if not self:IsActive() then
        return
    end
    if self.doInitialUpdate then
        Baggins:ForceFullUpdate()
        -- note: we use self.doInitialUpdate further down, and nil it there
    end

    if p.bags[bagid].isBank and not self.bankIsOpen then
        return
    end
    self:ForceSectionReLayout(bagid)
    if not self.bagframes[bagid] then
        self:CreateBagFrame(bagid)
    end
    self.bagframes[bagid]:Show()
    --if not noupdate then

    self:RunBagUpdates()
    self:UpdateBags()
    --end
    self:UpdateLayout()
    self:UpdateTooltip()

    -- reuse self.doInitialUpdate to only run once
    -- this fixes the duplicate stacks bug upon login
    if self.doInitialUpdate then
        -- this time we set to nil so this only runs the first time
        self.doInitialUpdate = false
        -- rebuild layouts to fix duplicate stacks
        --self:ScheduleForNextFrame('FixInit')
        --same
        self:ForceFullUpdate()
        self:RebuildSectionLayouts()
        self:UpdateBags()
    end
    PlaySound(862)
end

-- "All Bags" in these 3 functions refers to bags that are set to openWithAll
function Baggins:OpenAllBags()
    local p = self.db.profile
    if not self:IsActive() then
        return
    end
    for bagid, bag in ipairs(p.bags) do
        if bag.openWithAll then
            Baggins:OpenBag(bagid,true)
        end
    end
    self:RunBagUpdates()
    self:UpdateBags()
    self:UpdateLayout()
    PlaySound(862)
end

function Baggins:AuctionHouse()
     if self.db.profile.openatauction then
         self:OpenAllBags()
     end
end


function Baggins:ToggleAllBags(forceopen)
    local p = self.db.profile
    if (forceopen) then
        self:OpenAllBags()
    elseif (p.hideemptybags) then
        if self:IsAnyOpen() then
            self:CloseAllBags()
        else
            self:OpenAllBags()
        end
    else
        if self:IsAllOpen() then
            self:CloseAllBags()
        else
            self:OpenAllBags()
        end
    end
    if Baggins:IsRetailWow() then
        local count = 0;
        for i = 0, NUM_BAG_FRAMES do
            if ItemButtonUtil.GetItemContextMatchResultForContainer(i) == ItemButtonUtil.ItemContextMatchResult.Match then
                if not IsBagOpen(i) then
                    --OpenBag(i);
                    count = count + 1;
                end
            end
        end
        return count
    end
end

function Baggins:IsAllOpen()
    for bagid, bag in ipairs(self.db.profile.bags) do
        if bag.openWithAll and (not bag.isBank or self.bankIsOpen) then
            if not ( self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() ) then
                return false
            end
        end
    end
    return true
end

function Baggins:IsAnyOpen()
    for bagid, bag in ipairs(self.db.profile.bags) do
        if bag.openWithAll and (not bag.isBank or self.bankIsOpen) then
            if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
                return true
            end
        end
    end
end

function Baggins:IsAnyBagOpen()
    for bagid, _ in ipairs(self.db.profile.bags) do
        if self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
            return true
        end
    end
end

function Baggins:IsAnyBankOpen()
    for bagid, bag in ipairs(self.db.profile.bags) do
        if bag.isBank and self.bagframes[bagid] and self.bagframes[bagid]:IsVisible() then
            return true
        end
    end
end

function Baggins:IsEmpty(bagid)
    local count = 0
    if self.bagframes[bagid] then
        for _, v in ipairs(self.bagframes[bagid].sections) do
            count = count + v.itemcount or 0
        end
    end
    return count == 0
end

function Baggins:OpenBackpack()
    self:OpenAllBags()
end

function Baggins:CloseBackpack()
    self:CloseAllBags()
end

function Baggins:ToggleBackpack()
    if self:IsAnyOpen() then
        self:CloseAllBags()
    else
        self:OpenAllBags()
    end
end

function Baggins:CloseSpecialWindows()
    if self:IsAnyOpen() then
        self:CloseAllBags()
        return true
    end
    return self.hooks.CloseSpecialWindows()
end

function Baggins:BankFrameItemButton_Update(button)
    if button ~= nil then
        return self.hooks.BankFrameItemButton_Update(button)
    end
end

--local S_UPGRADE_LEVEL   = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "(%%d+)")
local scantip = CreateFrame("GameTooltip", "BagginsUpgradeScanningTooltip", nil, "GameTooltipTemplate")
local function GetItemUpgradeLevel(itemLink)
    scantip:SetOwner(UIParent, "ANCHOR_NONE")
    scantip:SetHyperlink(itemLink)
    for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
        local text = _G["BagginsUpgradeScanningTooltipTextLeft"..i]:GetText()
        if text and text ~= "" then
            local currentUpgradeLevel, maxUpgradeLevel = strmatch(text, "(%d+)/(%d+)")
            --local currentUpgradeLevel, maxUpgradeLevel = strmatch(text, S_UPGRADE_LEVEL)
            if currentUpgradeLevel then
                return currentUpgradeLevel, maxUpgradeLevel
            end
        end
    end
 end

 function Baggins:PlayerInteractionManager(event,typenumber) --luacheck: ignore 212
    if type(typenumber) ~= "number" then return end
    if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" and typenumber == 53 then
        C_Timer.After(1, function()
            for _, bag in ipairs(Baggins.bagframes) do --bagid,bag
                for _, section in ipairs(bag.sections) do --sectionid, section
                    for _, button in ipairs(section.items) do --buttonid, button
                        if button:IsVisible() then
                            local link = GetContainerItemLink(button:GetParent():GetID(), button:GetID())
                            if link then
                                local BagID = button:GetParent():GetID()
                                local SlotID = button:GetID()
                                if C_ItemUpgrade.CanUpgradeItem(ItemLocation:CreateFromBagAndSlot(BagID, SlotID)) then
                                    local currentUpgradeLevel, maxUpgradeLevel = GetItemUpgradeLevel(link)
                                    if (currentUpgradeLevel and maxUpgradeLevel) == nil then
                                        button:SetAlpha(tonumber(Baggins.db.profile.unmatchedAlpha) or 0.2)
                                    end
                                end
                                if not C_ItemUpgrade.CanUpgradeItem(ItemLocation:CreateFromBagAndSlot(BagID, SlotID)) then
                                    button:SetAlpha(tonumber(Baggins.db.profile.unmatchedAlpha) or 0.2)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    --26 VoidStorageBanker,39 ObliterumForge,40 ScrappingMachine,44 ItemInteraction,48 LegendaryCrafting,56 AzeriteForge
    if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" and type == 26 or type == 39 or type == 40 or type == 44 or type == 48 or type == 56 then
        self:OpenAllBags()
    end

    if event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" and typenumber == 8 and self.db.profile.hidedefaultbank then
        local function NeutralizeFrame(frame)
            if not frame then return end
            frame:UnregisterAllEvents()
            frame:SetScript("OnEvent", nil)
            frame:SetScript("OnShow", nil)
            frame:SetScript("OnHide", nil)
            HideUIPanel(frame)
            frame:ClearAllPoints()
            frame:Hide()
        end
        NeutralizeFrame(BankFrame)
        NeutralizeFrame(ReagentBankFrame)
    end

end

local function EasyMenu_Initialize(frame, level, menuList)
    for index = 1, #menuList do
        local value = menuList[index]
        if value.text then value.index = index; UIDropDownMenu_AddButton(value, level) end
    end
end

function Baggins:EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay)
    if displayMode=='MENU' then menuFrame.displayMode = displayMode end
    UIDropDownMenu_Initialize(menuFrame, EasyMenu_Initialize, displayMode, nil, menuList)
    ToggleDropDownMenu(1, nil, menuFrame, anchor, x, y, menuList, nil, autoHideDelay)
end
