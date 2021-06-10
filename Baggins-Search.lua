--luacheck: no max line length

local NumberofAddons = _G.GetNumAddOns()
local DisableAddOn = _G.DisableAddOn
StaticPopupDialogs["BAGGINS_SEARCH"] = { --luacheck: ignore 112
    text = "Addon Baggins Search was found, however Baggins has search built-in, Would you like to disable Baggins Search?(requires reloadui, may need to disable manually)",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
        for i=1,NumberofAddons do
            local _, title, _, _, _, _, _ = GetAddOnInfo(i)
            if title == "Baggins Search" or title == "Baggins_Search" then
                DisableAddOn(i)
                DisableAddOn(i)
            end
        end
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}


if NumberofAddons >= 1 then
    for i=1,NumberofAddons do
        local _, title, _, _, reason, _, _ = GetAddOnInfo(i)
        if title == "Baggins Search" or title == "Baggins_Search" then
            if not reason or not reason == "DISABLED" then
                StaticPopup_Show("BAGGINS_SEARCH")
                return
            end
        end
    end
end

local _G = _G

local AddOnName, _ = ...
local AddOn = _G[AddOnName] --luacheck: ignore 211

--local _, addonTable = ... -- addonName, addonTable
--local L = addonTable.L

local Baggins = _G.Baggins
local GetItemInfo = _G.GetItemInfo
local strlen = _G.strlen
local strfind = _G.strfind
local GetContainerItemLink = _G.GetContainerItemLink
local CreateFrame = _G.CreateFrame
local ChatFontNormal = _G.ChatFontNormal
local GameTooltip = _G.GameTooltip
local GameTooltip_SetDefaultAnchor = _G.GameTooltip_SetDefaultAnchor
local getglobal = _G.getglobal
local IsControlKeyDown = _G.IsControlKeyDown

-- Simple search inspired by vBagnon for Baggins

local BagginsSearch = {}

function BagginsSearch:Search(search) --luacheck: ignore 212
    local itemName, itemType, itemSubType, itemEquipLoc
    for _, bag in ipairs(Baggins.bagframes) do --bagid,bag
        for _, section in ipairs(bag.sections) do --sectionid, section
            for _, button in ipairs(section.items) do --buttonid, button
                if button:IsVisible() then
                    local link = GetContainerItemLink(button:GetParent():GetID(), button:GetID())
                    if link then
                        --itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagent
                        itemName, _, _, _, _, itemType, itemSubType, _,itemEquipLoc = GetItemInfo(link)
                        if not itemName then
                            -- hack hack hack
                            itemName = string.match(link, "|h%[(.*)%]") or ""
                            -- TODO: should figure out what type of thing this is so we can populate these:
                            itemType = ""
                            itemSubType = ""
                            itemEquipLoc = ""
                        end
                        if strlen(search) == 0 then
                            button:UnlockHighlight()
                            button:SetAlpha(1)
                        elseif strfind(itemName:lower(), search:lower(),1,1) or strfind(itemType:lower(), search:lower(),1,1) or strfind(itemSubType:lower(), search:lower(),1,1) or strfind(itemEquipLoc:lower(), search:lower(),1,1) then
                            button:LockHighlight()
                            button:SetAlpha(1)
                        else
                            button:UnlockHighlight()
                            button:SetAlpha(tonumber(Baggins.db.profile.unmatchedAlpha) or 0.2)
                        end
                    end
                end
            end
        end
    end
end
function BagginsSearch:UpdateEditBoxPosition() --luacheck: ignore 212
    if Baggins.db.profile.enableSearch then
        if not _G.BagginsSearch_EditBox then
            BagginsSearch:BagginsSearch_CreateEditBox()
        end
    end
    if not Baggins.db.profile.enableSearch then
        if _G.BagginsSearch_EditBox then
            _G.BagginsSearch_EditBox:Hide()
            return
        end
    end
    local lastBag
    if type(Baggins.bagframes) == "table" then
        for bagid, _ in ipairs(Baggins.bagframes) do --bagid, bag
            if Baggins.bagframes[bagid]:IsVisible() then
                lastBag = bagid
            end
        end
    end
    if _G.BagginsSearch_EditBox and lastBag then
        _G.BagginsSearch_EditBox:ClearAllPoints()
        _G.BagginsSearch_EditBox:SetPoint("BOTTOMRIGHT", "BagginsBag"..lastBag, "TOPRIGHT", 0, 0)
        _G.BagginsSearch_EditBox:SetWidth(getglobal("BagginsBag"..lastBag):GetWidth())
        _G.BagginsSearch_EditBox:Show()
    else
        if _G.BagginsSearch_EditBox then
            _G.BagginsSearch_EditBox:Hide()
        end
    end
end

function BagginsSearch:BagginsSearch_CreateEditBox()
    -- Create Baggins Search EditBox
    local editBox = CreateFrame('EditBox', 'BagginsSearch_EditBox', UIParent, BackdropTemplateMixin and "BackdropTemplate") --luacheck: ignore 113
    editBox:SetWidth(100)
    editBox:SetHeight(24)
    --editBox:SetScale(Baggins.db.profile.scale)
    editBox:SetFrameStrata("HIGH")

    editBox:SetFontObject(ChatFontNormal)
    editBox:SetTextInsets(8, 8, 0, 0)
    editBox:SetAutoFocus(false)

    editBox:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 2, right = 2, top = 2, bottom = 2}})
    editBox:SetBackdropBorderColor(0.6, 0.6, 0.6)

    local background = editBox:CreateTexture(nil, "BACKGROUND")
    background:SetTexture("Interface/ChatFrame/ChatFrameBackground")
    background:SetPoint("TOPLEFT", 4, -4)
    background:SetPoint("BOTTOMRIGHT", -4, 4)
    background:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.9, 0.2, 0.2, 0.2, 0.9)

    editBox:SetScript("OnHide", function(self)
            self:SetText("")
            _G.BagginsSearch_Label:Show()
        end)
    editBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    editBox:SetScript("OnEscapePressed", function(self)
            self:SetText("")
            self:ClearFocus()
            _G.BagginsSearch_Label:Show()
        end)
    editBox:SetScript("OnEditFocusGained", function(self)
            if IsControlKeyDown() then
                self:SetText("")
                self:ClearFocus()
                _G.BagginsSearch_Label:Show()
            else
                _G.BagginsSearch_Label:Hide()
                self:HighlightText()
            end
        end)
    editBox:SetScript("OnTextChanged", function(self)
            BagginsSearch:Search(self:GetText())
        end)
    editBox:SetScript("OnEnter", function(self)
            GameTooltip_SetDefaultAnchor(GameTooltip, self)
            GameTooltip:SetText("Baggins Search")
            --GameTooltip:AddLine("|c00FFFFFFv" .. BagginsSearch.version .. "|r")
            GameTooltip:Show()
        end)
    editBox:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local label = editBox:CreateFontString("BagginsSearch_Label", "OVERLAY", "GameFontHighlight")
    label:SetAlpha(0.2)
    label:SetText("Search")
    label:SetPoint("TOPLEFT", 8, 0)
    label:SetPoint("BOTTOMLEFT", -8, 0)
    label:Show()

end

Baggins:RegisterSignal("Baggins_UpdateBagScale",function() --luacheck: ignore 212
    _G.BagginsSearch_EditBox:SetScale(Baggins.db.profile.scale)
end, Baggins)


Baggins:RegisterSignal("Baggins_RefreshBags",function() --luacheck: ignore 212
    BagginsSearch:UpdateEditBoxPosition()
    if _G.BagginsSearch_EditBox then
        BagginsSearch:Search(_G.BagginsSearch_EditBox:GetText())
    end
end, Baggins)

Baggins:RegisterSignal("Baggins_AllBagsClosed",function() --luacheck: ignore 212
    local lastBag
    if type(Baggins.bagframes) == "table" then
        for bagid, _ in ipairs(Baggins.bagframes) do --bagid, bag
            if Baggins.bagframes[bagid]:IsVisible() then
                lastBag = bagid
            end
        end
    end
    if _G.BagginsSearch_EditBox and lastBag then
        _G.BagginsSearch_EditBox:ClearAllPoints()
        _G.BagginsSearch_EditBox:SetPoint("BOTTOMRIGHT", "BagginsBag"..lastBag, "TOPRIGHT", 0, 0)
        _G.BagginsSearch_EditBox:SetWidth(getglobal("BagginsBag"..lastBag):GetWidth())
        _G.BagginsSearch_EditBox:Show()
    else
        if _G.BagginsSearch_EditBox then
            _G.BagginsSearch_EditBox:Hide()
        end
    end
end, Baggins)

local f = CreateFrame('Frame')
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
    if Baggins.db.profile.enableSearch then
        BagginsSearch:BagginsSearch_CreateEditBox()
        BagginsSearch:UpdateEditBoxPosition()
        _G.BagginsSearch_EditBox:SetScale(Baggins.db.profile.scale)
    end
    Baggins.OnMenuRequest.args.General.args.BagginsSearchEnable = {
        name = "Enable Search",
        type = "toggle",
        desc = "Enable/Disable Search",
        order = 200,
        get = function() return Baggins.db.profile.enableSearch end,
        set = function(_, value)
            Baggins.db.profile.enableSearch = value
            BagginsSearch:UpdateEditBoxPosition()
        end
    }
    Baggins.OnMenuRequest.args.General.args.BagginsSearchFade = {
        name = "Search Item Fade",
        type = "range",
        desc = "Set the transparency for unmatched items",
        order = 201,
        max = 1,
        min = 0,
        step = 0.05,
        get = function() return Baggins.db.profile.unmatchedAlpha end,
        set = function(_, value)
            Baggins.db.profile.unmatchedAlpha = value
            BagginsSearch:Search(_G.BagginsSearch_EditBox:GetText())
        end
    }
end)