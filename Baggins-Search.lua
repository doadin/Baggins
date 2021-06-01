--luacheck: no max line length

local DisableAddOn = _G.DisableAddOn
StaticPopupDialogs["BAGGINS_SEARCH"] = { --luacheck: ignore 112
    text = "Addon Baggins Search was found, however Baggins has search built-in, Would you like to disable Baggins Search?(requires reloadui, may need to disable manually)",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
        for i=1,50 do
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

for i=1,50 do
    local _, title, _, _, reason, _, _ = GetAddOnInfo(i)
    if title == "Baggins Search" or title == "Baggins_Search" then
        if not reason or not reason == "DISABLED" then
            StaticPopup_Show("BAGGINS_SEARCH")
            return
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
local LibStub = _G.LibStub
local GameTooltip = _G.GameTooltip
local GameTooltip_SetDefaultAnchor = _G.GameTooltip_SetDefaultAnchor
local getglobal = _G.getglobal
local IsControlKeyDown = _G.IsControlKeyDown

local BagginsAce3 = LibStub and LibStub("AceConfigRegistry-3.0")
BagginsAce3 = BagginsAce3 and BagginsAce3:GetOptionsTable("Baggins") and true


-- Simple search inspired by vBagnon for Baggins

local BagginsSearch = {}
local BagginsSearch_Save = {}


function BagginsSearch:Search(search) --luacheck: ignore 212
    local itemName, itemType, itemSubType
    for _, bag in ipairs(Baggins.bagframes) do --bagid,bag
        for _, section in ipairs(bag.sections) do --sectionid, section
            for _, button in ipairs(section.items) do --buttonid, button
                if button:IsVisible() then
                    local link = GetContainerItemLink(button:GetParent():GetID(), button:GetID())
                    if link then
                        itemName, _, _, _, _, itemType, itemSubType, _, _ = GetItemInfo(link)
                        if not itemName then
                            -- hack hack hack
                            itemName = string.match(link, "|h%[(.*)%]") or ""
                            -- TODO: should figure out what type of thing this is so we can populate these:
                            itemType = ""
                            itemSubType = ""
                        end
                        if strlen(search) == 0 then
                            button:UnlockHighlight()
                            button:SetAlpha(1)
                        elseif strfind(itemName:lower(), search:lower(),1,1) or strfind(itemType:lower(), search:lower(),1,1) or strfind(itemSubType:lower(), search:lower(),1,1) then
                            button:LockHighlight()
                            button:SetAlpha(1)
                        else
                            button:UnlockHighlight()
                            button:SetAlpha(tonumber(BagginsSearch_Save.unmatchedAlpha) or 0.2)
                        end
                    end
                end
            end
        end
    end
end
function BagginsSearch:UpdateEditBoxPosition() --luacheck: ignore 212
    local lastBag
    if type(Baggins.bagframes) == "table" then
        for bagid, _ in ipairs(Baggins.bagframes) do --bagid, bag
            if Baggins.bagframes[bagid]:IsVisible() then
                lastBag = bagid
            end
        end
    end
    if lastBag then
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

local function BagginsSearch_CreateEditBox()
    -- Create Baggins Search EditBox
    local editBox = CreateFrame('EditBox', 'BagginsSearch_EditBox', UIParent, BackdropTemplateMixin and "BackdropTemplate")
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

    if not BagginsSearch_Save.unmatchedAlpha then
        BagginsSearch_Save.unmatchedAlpha = 0.2
    end
end

-- I hate hooks too
Baggins.BagginsSearch_BRB = Baggins.Baggins_RefreshBags
function Baggins:Baggins_RefreshBags()
    self:BagginsSearch_BRB()
    BagginsSearch:UpdateEditBoxPosition()
    if _G.BagginsSearch_EditBox then
        BagginsSearch:Search(_G.BagginsSearch_EditBox:GetText())
    end
end
Baggins.BagginsSearch_UpdateBagScale = Baggins.UpdateBagScale
function Baggins:UpdateBagScale()
    self:BagginsSearch_UpdateBagScale()
    _G.BagginsSearch_EditBox:SetScale(Baggins.db.profile.scale)
end

--Baggins:RegisterSignal("Baggins_AllBagsClosed", BagginsSearch:UpdateEditBoxPosition, "BagginsSearch")


--Baggins.OnMenuRequest.args.BagginsSearch = {
--    name = "Search Item Fade",
--    type = "range",
--    desc = "Set the transparency for unmatched items",
--    order = 200,
--    max = 1,
--    min = 0,
--    step = 0.05,
--    get = function() return BagginsSearch_Save.unmatchedAlpha end,
--    set = function(value)
--        BagginsSearch_Save.unmatchedAlpha = value;
--        Search(_G.BagginsSearch_EditBox:GetText())
--    end
--}

if BagginsAce3 then
    Baggins.OnMenuRequest.args.BagginsSearch.set = function(_, value) --info, value
        BagginsSearch_Save.unmatchedAlpha = value;
        BagginsSearch:Search(_G.BagginsSearch_EditBox:GetText())
    end
    Baggins.OnMenuRequest.args.BagginsSearch.isPercent = true
end



-- Do it
BagginsSearch_CreateEditBox()
--BagginsSearch_CreateEditBox = nil
BagginsSearch:UpdateEditBoxPosition()
