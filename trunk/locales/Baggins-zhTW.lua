local L = LibStub("AceLocale-3.0"):NewLocale("Baggins", "zhTW")
if not L then return end

--itemtypes, these must match the Type and SubType returns from GetItemInfo for the ItemType rule to work
L["Armor"] = "護甲"
	L["Cloth"] = "布甲"
	L["Idols"] = "雕像"
	L["Leather"] = "皮甲"
	L["Librams"] = "聖契"
	L["Mail"] = "鎖甲"
	L["Miscellaneous"] = "其他"
	L["Shields"] = "盾牌"
	L["Totems"] = "圖騰"
	L["Plate"] = "鎧甲"
L["Consumable"] = "消耗品"
L["Container"] = "容器"
	L["Bag"] = "容器"
	L["Enchanting Bag"] = "附魔包"
	L["Engineering Bag"] = "工程包"
	L["Herb Bag"] = "草藥包"
	L["Soul Bag"] = "靈魂碎片背包"
L["Key"] = "鑰匙"
L["Miscellaneous"] = "其他"
	L["Junk"] = "垃圾"
L["Reagent"] = "材料"
L["Recipe"] = "配方"
	L["Alchemy"] = "煉金術"
	L["Blacksmithing"] = "鍛造"
	L["Book"] = "書籍"
	L["Cooking"] = "烹飪"
	L["Enchanting"] = "附魔"
	L["Engineering"] = "工程學"
	L["First Aid"] = "急救"
	L["Leatherworking"] = "制皮"
	L["Tailoring"] = "剝皮"
L["Projectile"] = "彈藥"
	L["Arrow"] = "箭"
	L["Bullet"] = "子彈"
L["Quest"] = "任務"
L["Quiver"] = "箭袋"
	L["Ammo Pouch"] = "彈藥袋"
	L["Quiver"] = "箭袋"
L["Trade Goods"] = "商品"
	L["Devices"] = "裝置"
	L["Explosives"] = "爆炸物"
	L["Parts"] = "零件"
	L["Gems"] = "寶石"
L["Weapon"] = "武器"
	L["Bows"] = "弓"
	L["Crossbows"] = "弩"
	L["Daggers"] = "匕首"
	L["Guns"] = "槍械"
	L["Fishing Pole"] = "魚竿"
	L["Fist Weapons"] = "拳套"
	L["Miscellaneous"] = "其他"
	L["One-Handed Axes"] = "單手斧"
	L["One-Handed Maces"] = "單手錘"
	L["One-Handed Swords"] = "單手劍"
	L["Polearms"] = "長柄武器"
	L["Staves"] = "法杖"
	L["Thrown"] = "投擲武器"
	L["Two-Handed Axes"] = "雙手斧"
	L["Two-Handed Maces"] = "雙手錘"
	L["Two-Handed Swords"] = "雙手劍"
	L["Wands"] = "魔杖"
		--end of localizations needed for rules to work


L["Baggins"] = "Baggins"
L["Toggle All Bags"] = "開關所有背包"
L["Columns"] = "列數"
L["Number of Columns shown in the bag frames"] = "在背包窗體中顯示的列數"
L["Layout"] = "佈局"
L["Layout of the bag frames."] = "背包窗體佈局"
L["Automatic"] = "自動"
L["Automatically arrange the bag frames as the default ui does"] = "背包按默認佈局自動排列"
L["Manual"] = "手動"
L["Each bag frame can be positioned manually."] = "可以自定義每個背包的位置"
L["Show Section Title"] = "顯示分類標題"
L["Show a title on each section of the bags"] = "在每個分類上顯示標題"
L["Sort"] = "物品排列方式"
L["How items are sorted"] = "物品如何排列"
L["Quality"] = "品質"
L["Items are sorted by quality."] = "物品按品質排列"
L["Name"] = "名稱"
L["Items are sorted by name."] = "物品按名稱排列"
L["Hide Empty Sections"] = "隱藏空分類背包"
L["Hide sections that have no items in them."] = "隱藏沒有物品的分類背包"
L["Hide Default Bank"] = "隱藏默認銀行"
L["Hide the default bank window."] = "隱藏默認銀行窗口"
L["FuBar Text"] = "Fubar 文字"
L["Options for the text shown on fubar"] = "Fubar 文字顯示選項"
L["Show empty bag slots"] = "顯示背包未使用狀態"
L["Show used bag slots"] = "顯示背包已使用狀態"
L["Show Total bag slots"] = "顯示背包總容量"
L["Combine Counts"] = "聯合計數"
L["Show only one count with all the seclected types included"] = "為所有選擇的類型顯示總數"
L["Show Ammo Bags Count"] = "彈藥袋狀態"
L["Show Soul Bags Count"] = "靈魂袋狀態"
L["Show Specialty Bags Count"] = "特殊背包狀態"
L["Show Specialty (profession etc) Bags Count"] = "特殊（專業等）背包狀態"
L["Set Layout Bounds"]= "設置佈局範圍"
L["Shows a frame you can drag and size to set where the bags will be placed when Layout is automatic"] = "顯示一個可以移動縮放的框體，當佈局設定為自動時背包將放置在此處"
L["Lock"] = "鎖定"
L["Locks the bag frames making them unmovable"] = "鎖定背包框體使之不能隨意移動"
L["Shrink Width"] = "收縮寬度"
L["Shrink the bag's width to fit the items contained in them"] = "按背包內物品收縮背包寬度"
L["Compress"] = "壓縮"
L["Compress Multiple stacks into one item button"] = "多組物品顯示在一個格子"
L["Compress All"] = "壓縮所有物品"
L["Show all items as a single button with a count on it"] = "所有物品及其數量顯示在一個格子"
L["Compress Empty Slots"] = "壓縮背包未用格"
L["Show all empty slots as a single button with a count on it"] = "所有背包未用格及其數量顯示在一個格子"
L["Compress Soul Shards"] = "壓縮靈魂碎片"
L["Show all soul shards as a single button with a count on it"] = "所有靈魂碎片及其數量顯示在一個格子"
L["Compress Ammo"] = "壓縮彈藥"
L["Show all ammo as a single button with a count on it"] = "所有彈藥及其數量顯示在一個格子"
L["Quality Colors"]= "按品質著色"
L["Color item buttons based on the quality of the item"] = "按照物品的品質給邊框著色"
L["Enable"] = "允許"
L["Enable quality coloring"] = "允許按品質著色"
L["Color Threshold"] = "著色等級"
L["Only color items of this quality or above"] = "僅著色這個品質及以上的物品"
L["Color Intensity"] = "著色亮度"
L["Intensity of the quality coloring"] = "品質著色亮度"
L["Edit Bags"] = "編輯背包"
L["Edit the Bag Definitions"] = "編輯背包的定義"
L["Edit Categories"] = "編輯分類"
L["Edit the Category Definitions"] = "編輯分類的定義"
L["Load Profile"] = "加載設置"
L["Load a built-in profile: NOTE: ALL Custom Bags will be lost and any edited built in categories will be lost."] = "加載內置設置：注：所有自定義背包和分類將會丟失。"
L["Default"] = "默認"
L["A default set of bags sorting your inventory into categories"] = "一個按分類排列背包的默認設置"
L["All in one"] = "整合背包"
L["A single bag containing your whole inventory, sorted by quality"] = "將所有背包整合成一個，按品質排序。"
L["Scale"] = "縮放"
L["Scale of the bag frames"] = "縮放所有窗體"
		--bagtypes
L["Backpack"] = "行囊"
L["Bag1"] = "1號背包"
L["Bag2"] = "2號背包"
L["Bag3"] = "3號背包"
L["Bag4"] = "4號背包"
L["Bank Frame"] = "銀行窗口"
L["Bank Bag1"] = "銀行1號背包"
L["Bank Bag2"] = "銀行2號背包"
L["Bank Bag3"] = "銀行3號背包"
L["Bank Bag4"] = "銀行4號背包"
L["Bank Bag5"] = "銀行5號背包"
L["Bank Bag6"] = "銀行6號背包"
L["Bank Bag7"] = "銀行7號背包"
L["Reagent Bank"] = true
L["KeyRing"] = "鑰匙圈"

		--qualoty names
L["Poor"] = "粗糙"
L["Common"] = "普通"
L["Uncommon"] = "優秀"
L["Rare"] = "精良"
L["Epic"] = "史詩"
L["Legendary"] = "傳說"
L["Artifact"] = "神器"

L["None"] = "無"
L["All"] = "所有"

L["Item Type"] = "物品類型"
L["Filter by Item type and sub-type as returned by GetItemInfo"] = "按照從GetItemInfo獲得的物品類型和子類型過濾"
L["ItemType - "] = "物品類型 - "
L["Item Type Options"] = "物品類型選項"
L["Item Subtype"] = "物品子類型"

L["Container Type"] = "容器類型"
L["Filter by the type of container the item is in."] = "按照其內物品類型過濾容器"
L["Container : "] = "容器："
L["Container Type Options"] = "容器類型選項"

L["Item ID"] = "物品ID"
L["Filter by ItemID, this can be a space delimited list or ids to match."] = "按照物品ID過濾。"
L["ItemIDs "] = "物品ID"
L["ItemID Options"] = "物品ID選項"
L["Item IDs (space seperated list)"] = "物品ID（以空格分割）"
L["New"] = "新物品"
L["Current IDs, click to remove"] = "當前ID，點擊刪除。"

L["Filter by the bag the item is in"] = "按照背包內物品過濾"
L["Bag "] = "背包"
L["Bag Options"] = "背包選項"
L["Ignore Empty Slots"] = "忽略背包未用格"

L["Item Name"] = "物品名稱"
L["Filter by Name or partial name"] = "按照名稱或部分名稱過濾"
L["Name: "] = "名稱："
L["Item Name Options"] = "物品名稱選項"
L["String to Match"] = "匹配字元"

L["PeriodicTable Set"] = "PeriodicTable項"
L["Filter by PeriodicTable Set"] = "按照PeriodicTable項過濾"
L["Periodic Table Set Options"] = "PeriodicTable項屬性"
L["Set"] = "項"

L["Empty Slots"] = "未用格"
L["Empty bag slots"] = "背包未用格"

L["Ammo Bag"] = "彈藥袋"
L["Items in an ammo pouch or quiver"] = "箭袋或者彈藥袋內的物品"
L["Ammo Bag Slots"] = "彈藥袋"

L["Quality"] = "品質"
L["Filter by Item Quality"] = "按照物品品質過濾"
L["Quality Options"] = "品質選項"
L["Comparison"] = "比較"

L["Equip Location"] = "裝備位置"
L["Filter by Equip Location as returned by GetItemInfo"] = "按照通過GetItemInfo得到的裝備位置過濾"

L["Equip Location Options"] = "裝備位置選項"
L["Location"] = "位置"

L["Unfiltered Items"] = "未過濾物品"
L["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"] = "除去所有已匹配其餘背包的物品，注：這將是分類中的唯一規則，忽略其餘規則。"
L["Unfiltered"] = "未過濾"

L["Bind"] = "綁定"
L["Filter based on if the item binds, or if it is already bound"] = "按照物品是否綁定過濾"
L["Bind *unset*"] = "無需綁定"
L["Unbound"] = "未綁定"
L["Bind Options"] = "綁定選項"
L["Bind Type"] = "綁定類型"
L["Binds on pickup"] = "拾取後綁定"
L["Binds on equip"] = "裝備後綁定"
L["Binds on use"] = "使用後綁定"
L["Soulbound"] = "靈魂綁定"

L["Tooltip"] = "物品提示"
L["Filter based on text contained in its tooltip"] = "按照物品提示過濾"
L["Tooltip Options"] = "提示選項"

L["ItemID: "] = "物品ID："
L["Item Type: "] = "物品類型："
L["Item Subtype: "] = "物品子類型："

L["Click a bag to toggle it. Shift-click to move it up. Alt-click to move it down"] = "點擊開關背包。Shift-點擊向上移動。Alt-點擊向下移動。"

L["Bags"] = "背包"
L["Options"] = "選項"
L["Open With All"] = "總是打開"
L["Bank"] = "銀行"
L["Sections"] = "分類背包"
L["Categories"] = "分類"
L["Add Category"] = "增加分類"
L["New Section"] = "新分類背包"
L["New Bag"] = "新背包"
L["Close"] = "關閉"
L["Click on an entry to open. Shift-Click to move up. Alt-Click to move down. Ctrl-Click to delete."] = "點擊打開條目。Shift-點擊向上移動。Alt-點擊向下移動。Ctrl-點擊刪除。"
L["Rules"] = "規則"
L["New Rule"] = "新規則"
L["Add Rule"] = "增加規則"
L["New Category"] = "新分類"
L["Apply"] = "應用"
L["Click on an entry to open. Ctrl-Click to delete."] = "點擊打開一個條目。Ctrl-點擊刪除。"

L["Editing Rule"] = "編輯規則"
L["Type"] = "類型"
L["Select a rule type to create the rule"] = "選擇一個規則類型以創建規則"
L["Operation"] = "運算"
L["AND"] = "和"
L["OR"] = "與"
L["NOT"] = "非"

L["Baggins - New Bag"] = "Baggins - 新背包"
L["Baggins - New Section"] = "Baggins - 新分類背包"
L["Baggins - New Category"] = "Baggins - 新分類"
L["Accept"] = "接受"
L["Cancel"] = "取消"

L["Are you sure you want to delete this Bag? this cannot be undone"] = "你確認要刪除這個背包？ 這是個不可恢復的操作"
L["Are you sure you want to delete this Section? this cannot be undone"] = "你確認要刪除這個選項？ 這是個不可恢復的操作"
L["Are you sure you want to remove this Category? this cannot be undone"] = "你確認要刪除這個分類？ 這是個不可恢復的操作"
L["Are you sure you want to remove this Rule? this cannot be undone"] = "你確認要刪除這個規則？ 這是個不可恢復的操作"
L["Delete"] = "刪除"
L["Cancel"] = "取消"

L["That category is in use by one or more bags, you cannot delete it."] = "這個分類被一個或多個背包使用，不能被刪除。"
L["A category with that name already exists."] = "同名分類已經存在。"

L["Drag to Move\nRight-Click to Close"] = "點擊拖動\n右鍵關閉"
L["Drag to Size"] = "縮放拖動"

L["Previous "] = "向前"
L["Next "] = "向後"

L["All In One"] = "整合背包"
L["Bank All In One"] = "整合銀行"
L["Bank Bags"] = "銀行背包"

L["Equipment"] = "裝備"
L["Weapons"] = "武器"
L["Quest Items"] = "任務物品"
L["Consumables"] = "消耗品"
L["Water"] = "飲料"
L["Food"] = "食物"
L["FirstAid"] = "急救"
L["Potions"] = "藥劑"
L["Scrolls"] = "卷軸"
L["Misc"] = "其他"
L["Misc Consumables"] = "其他消耗品"

L["Mats"] = "基礎材料"
L["Tradeskill Mats"] = "[商]基礎材料"
L["Gathered"] = "採集"
L["BankBags"] = "銀行背包"
L["Ammo"] = "彈藥"
L["AmmoBag"] = "彈藥袋"
L["SoulShards"] = "靈魂碎片"
L["SoulBag"] = "靈魂袋"
L["Other"] = "其他"
L["Trash"] = "垃圾"
L["TrashEquip"] = "垃圾裝備"
L["Empty"] = "未用格"
L["Bank Equipment"] = "[銀]裝備"
L["Bank Quest"] = "[銀]任務"
L["Bank Consumables"] = "[銀]消耗品"
L["Bank Trade Goods"] = "[銀]商品"
L["Bank Other"] = "[銀]其他"

L["Add To Category"] = "添加到分類"
L["Exclude From Category"] = "從分類中刪除"
L["Item Info"] = "物品信息"
L["Use"] = "使用"
	L["Use/equip the item rather than bank/sell it"] = "使用/裝備這件物品而不是放銀行/出售"
L["Quality: "] = "品質："
L["Level: "] = "等級："
L["MinLevel: "] = "最小等級："
L["Stack Size: "] = "堆疊數量："
L["Equip Location: "] = "裝備位置："
L["Periodic Table Sets"] = "PeriodicTable項"

L["Highlight New Items"] = "高亮新物品"
L["Add *New* to new items, *+++* to items that you have gained more of."] = "在新物品上增加*新*，在獲得了更多的物品上增加*+++*"
L["Reset New Items"] = "重置新物品"
L["Resets the new items highlights."] = "重置新物品高亮"
L["*New*"] = "*新*"

L["Hide Duplicate Items"] = "隱藏相同物品的範圍"
L["Prevents items from appearing in more than one section/bag."] = "阻止物品出現在超過一個的分類背包/背包中"

L["Optimize Section Layout"] = "優化分類背包佈局"
L["Change order and layout of sections in order to save display space."] = "更改分類背包的佈局和順序使之更節省螢幕"

L["All In One Sorted"]= "分類的整合背包"
L["A single bag containing your whole inventory, sorted into categories"]= "將所有背包整合成一個，按照分類排序"

L["Compress Stackable Items"]= "壓縮可堆疊物品"
L["Show stackable items as a single button with a count on it"]= "將所有可堆疊物品及其數量顯示在一個格子"

L["Appearance and layout"]= "外觀和佈局"
L["Bags"]= "背包"
L["Bag display and layout settings"]= "背包顯示和佈局設置"
L["Layout Type"]= "佈局類型"
L["Sets how all bags are laid out on screen."]= "設置所有背包如何在螢幕上排列"
L["Shrink bag title"]= "收縮背包標題"
L["Mangle bag title to fit to content width"]= "使背包標題適應內容寬度"
L["Sections"]= "分類背包"
L["Bag sections display and layout settings."]= "分類背包顯示和佈局設置"
L["Items"]= "物品"
L["Item display settings"]= "物品顯示設置"
L["Bag Skin"]= "背包皮膚"
L["Select bag skin"]= "選擇背包皮膚"

L["Compress bag contents"]= "壓縮背包"
L["Split %d"]= "分離%d"
L["Split_tooltip"] = "點擊按照設定分離物品\n並且在未用格中自動排列。\n\n按住shift僅揀取。"

L["PT3 LoD Modules"] = "PT3 LoD模塊"
L["Choose PT3 LoD Modules to load at startup, Will load immediately when checked"] = "選擇開始時加載的PT3 LoD模塊，選擇後將立即加載"
L["Load %s at Startup"] = "開始時加載%s"

L["Disable Compression Temporarily"] = "臨時禁用壓縮"
L["Disabled Item Compression until the bags are closed."] = "在背包關閉前禁用物品壓縮"

L["Always Resort"] = "總是重排"
L["Keeps Items sorted always, this will cause items to jump around when selling etc."] = "始終保持物品排列，將會在出售時導致物品跑來跑去"

L["Force Full Refresh"] = "全部刷新"
L["Forces a Full Refresh of item sorting"] = "刷新所有物品類別"

L["Override Default Bags"] = "取代默認背包"
L["Baggins will open instead of the default bags"] = "Baggins將會取代默認背包"
L["Sort New First"] = "新物品在前"
L["Sorts New Items to the beginning of sections"] = "在分類背包的開始位置排列新物品"
L["New Items"] = "新物品"

L["Items that match another category"] = "匹配另一個分類的物品"
L["Category Options"] = "分類選項"
L["Category"] = "分類"

L["Layout Anchor"] = "佈局錨點"
L["Sets which corner of the layout bounds the bags will be anchored to."] = "設定背包定位到佈局框的哪個角落。"
L["Top Right"] = "右上"
L["Top Left"] = "左上"
L["Bottom Right"] = "右下"
L["Bottom Left"] = "左下"

L["Show Money On Bag"] = "在背包顯示金錢"
L["Which Bag to Show Money On"] = "選擇顯示金錢的背包"

L["Show Bank Controls On Bag"] = true
L["Which Bag to Show Bank Controls On"] = true

L["User Defined"] = "自定義設置"
L["Load a User Defined Profile"] = "加載一個自定義設置"
L["Save Profile"] = "保存設置"
L["Save a User Defined Profile"] = "保存一個自定義設置"
L["New"] = "新建"
L["Create a new Profile"] = "創建一個新設置"
L["Delete Profile"] = "刪除設置"
L["Delete a User Defined Profile"] = "刪除一個自定義設置"
L["Save"] = "保存"
L["Load"] = "加載"
L["Delete"] = "刪除"

L["Config Window"] = "設置窗口"
L["Opens the Waterfall Config window"] = "打開使用Waterfall的圖形設置視窗"
L["Bag/Category Config"] = "設置背包和分類"
L["Opens the Waterfall Config window"] = "打開使用Waterfall的圖形設置視窗"
L["Rename / Reorder"] = "重命名/重排"
L["From Profile"] = "從配置"
L["User"] = "玩家"
L["Copy From"] = "復制自："
L["Edit"] = "編輯"
L["Automatically open at auction house"] = "在拍賣行自動打開"
L["Create"] = "創建"
L["Bag Priority"] = "背包優先級"
L["Section Priority"] = "分類塊優先級"

L["Allow Duplicates"] = "允許顯示重復物品"
L["Import Sections From"] = "分類塊導入自："

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

--[[------------------- modified by lalibre -------------------------------
	------ Baggins-Options.lua ------
$38		hideduplicates = 'global'
$330						validate = {
							global = L["global"]
							bag = L["bag"]
							disabled = L["disabled"]
						}
$392						validate = {
							auto = L["auto"]
							manual = L["manual"]
						 }
$536						validate = {
							quality = L["quality"]
							name = L["name"]
							type = L["type"]
							slot = L["slot"]
						}
$1424		return L["Select a Bag/Category"]
$1508				waterfall:AddControl("type","linklabel","text",L["Remove"],"noNewLine",true,"r",1,"g",0.82,"b",0
$1530			if not category then return L["Invalid Category"] end
$1564								"execFunc",Baggins.RemoveRule,"confirm",L["Are You Sure?"]
$1581	waterfall:Register("BagginsEdit","tree",WaterfallTree,"children",WaterfallChildren,"treeType","SECTIONS","title",L["Baggins Bag/Category Editor"],"width",650)
$1452								"execArg1",Baggins,"execArg2",L["New"])
$1522								"execArg1",Baggins,"execArg2",bagid,"execArg3",L["New"])
--]]------------------- modified by lalibre -------------------------------
--[[------------------- modified by lalibre -------------------------------
L["global"] = "所有背包"
L["bag"] = "本背包"
L["disabled"] = "禁用"

L["auto"] = "自動"
L["manual"] = "手動"

L["quality"] = "品質"
L["name"] = "名稱"
L["type"] = "類型"
L["slot"] = "位置"

L["Select a Bag/Category"] = "選擇背包/分類"
L["Invalid Category"] = "未知分類"
L["Remove"] = "刪除"
L["Are You Sure?"] = "確認？"
L["Baggins Bag/Category Editor"] = "Baggins背包/分類編輯器"
--]]------------------- modified by lalibre -------------------------------
