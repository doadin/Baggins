local Baggins = Baggins
local pt = LibStub("LibPeriodicTable-3.1", true)
local gratuity = AceLibrary("Gratuity-2.0")
local L = AceLibrary("AceLocale-2.2"):new("Baggins")
local dewdrop = AceLibrary("Dewdrop-2.0")

local RuleTypes = nil

local new, del, rdel
do
	local tablePool = {}
	function new()
		return tremove(tablePool) or {}
	end
	function del(tab)
		for k in pairs(tab) do
			tab[k] = nil
		end
		tinsert(tablePool,tab)
	end
	function rdel(tab)
		for k in pairs(tab) do
			if type(tab[k]) == "table" then
				rdel(tab[k])
			end
			tab[k] = nil
		end
		tinsert(tablePool,tab)
	end
end

--Localization of item types and subtypes, must match the return values of GetItemInfo()
local ITEMTYPE = {}
local ITEMSUBTYPE = {}
Baggins.ITEMTYPE = ITEMTYPE
Baggins.ITEMSUBTYPE = ITEMSUBTYPE
	ITEMTYPE["Armor"] = "Armor"
		ITEMSUBTYPE["Cloth"] = "Cloth"
		ITEMSUBTYPE["Idols"] = "Idols"
		ITEMSUBTYPE["Leather"] = "Leather"
		ITEMSUBTYPE["Librams"] = "Librams"
		ITEMSUBTYPE["Mail"] = "Mail"
		ITEMSUBTYPE["Miscellaneous"] = "Miscellaneous"
		ITEMSUBTYPE["Shields"] = "Shields"
		ITEMSUBTYPE["Totems"] = "Totems"
		ITEMSUBTYPE["Plate"] = "Plate"
	ITEMTYPE["Consumable"] = "Consumable"
		ITEMSUBTYPE["Consumable"] = "Consumable"
		--New in 2.3
		ITEMSUBTYPE["Food & Drink"] = "Food & Drink"
		ITEMSUBTYPE["Potion"] = "Potion"
		ITEMSUBTYPE["Elixir"] = "Elixir"
		ITEMSUBTYPE["Flask"] = "Flask"
		ITEMSUBTYPE["Bandage"] = "Bandage"
		ITEMSUBTYPE["Item Enhancement"] = "Item Enhancement"
		ITEMSUBTYPE["Scroll"] = "Scroll"
		ITEMSUBTYPE["Other"] = "Other"
		
	ITEMTYPE["Container"] = "Container"
		ITEMSUBTYPE["Bag"] = "Bag"
		ITEMSUBTYPE["Enchanting Bag"] = "Enchanting Bag"
		ITEMSUBTYPE["Engineering Bag"] = "Engineering Bag"
		ITEMSUBTYPE["Herb Bag"] = "Herb Bag"
		ITEMSUBTYPE["Soul Bag"] = "Soul Bag"
		ITEMSUBTYPE["Mining Bag"] = "Mining Bag"
		ITEMSUBTYPE["Gem Bag"] = "Gem Bag"
		--New in 2.3
		ITEMSUBTYPE["Leatherworking Bag"] = "Leatherworking Bag"
		
	ITEMTYPE["Key"] = "Key"
		ITEMSUBTYPE["Key"] = "Key"
	ITEMTYPE["Miscellaneous"] = "Miscellaneous"
		ITEMSUBTYPE["Junk"] = "Junk"
		--New in 2.3
		ITEMSUBTYPE["Reagent"] = "Reagent"
		ITEMSUBTYPE["Pet"] = "Pet"
		ITEMSUBTYPE["Holiday"] = "Holiday"
		ITEMSUBTYPE["Other"] = "Other"
		
	ITEMTYPE["Reagent"] = "Reagent"
		ITEMSUBTYPE["Reagent"] = "Reagent"
	ITEMTYPE["Recipe"] = "Recipe"
		ITEMSUBTYPE["Alchemy"] = "Alchemy"
		ITEMSUBTYPE["Blacksmithing"] = "Blacksmithing"
		ITEMSUBTYPE["Book"] = "Book"
		ITEMSUBTYPE["Cooking"] = "Cooking"
		ITEMSUBTYPE["Enchanting"] = "Enchanting"
		ITEMSUBTYPE["Engineering"] = "Engineering"
		ITEMSUBTYPE["First Aid"] = "First Aid"
		ITEMSUBTYPE["Leatherworking"] = "Leatherworking"
		ITEMSUBTYPE["Tailoring"] = "Tailoring"
	ITEMTYPE["Projectile"] = "Projectile"
		ITEMSUBTYPE["Arrow"] = "Arrow"
		ITEMSUBTYPE["Bullet"] = "Bullet"
	ITEMTYPE["Quest"] = "Quest"
		ITEMSUBTYPE["Quest"] = "Quest"
	ITEMTYPE["Quiver"] = "Quiver"
		ITEMSUBTYPE["Ammo Pouch"] = "Ammo Pouch"
		ITEMSUBTYPE["Quiver"] = "Quiver"
	ITEMTYPE["Trade Goods"] = "Trade Goods"
		ITEMSUBTYPE["Trade Goods"] = "Trade Goods"
		ITEMSUBTYPE["Devices"] = "Devices"
		ITEMSUBTYPE["Explosives"] = "Explosives"
		ITEMSUBTYPE["Parts"] = "Parts"
		--New in 2.3
		ITEMSUBTYPE["Elemental"] = "Elemental"
		ITEMSUBTYPE["Cloth"] = "Cloth"
		ITEMSUBTYPE["Leather"] = "Leather"
		ITEMSUBTYPE["Metal & Stone"] = "Metal & Stone"
		ITEMSUBTYPE["Meat"] = "Meat"
		ITEMSUBTYPE["Herb"] = "Herb"
		ITEMSUBTYPE["Enchanting"] = "Enchanting"
		ITEMSUBTYPE["Jewelcrafting"] = "Jewelcrafting"
		ITEMSUBTYPE["Devices"] = "Devices"
		ITEMSUBTYPE["Other"] = "Other"

	ITEMTYPE["Gem"] = "Gem"
		ITEMSUBTYPE["Blue"] = "Blue"
		ITEMSUBTYPE["Green"] = "Green"
		ITEMSUBTYPE["Orange"] = "Orange"
		ITEMSUBTYPE["Meta"] = "Meta"
		ITEMSUBTYPE["Prismatic"] = "Prismatic"
		ITEMSUBTYPE["Purple"] = "Purple"
		ITEMSUBTYPE["Red"] = "Red"
		ITEMSUBTYPE["Simple"] = "Simple"
		ITEMSUBTYPE["Yellow"] = "Yellow"
	ITEMTYPE["Weapon"] = "Weapon"
		ITEMSUBTYPE["Bows"] = "Bows"
		ITEMSUBTYPE["Crossbows"] = "Crossbows"
		ITEMSUBTYPE["Daggers"] = "Daggers"
		ITEMSUBTYPE["Guns"] = "Guns"
		ITEMSUBTYPE["Fishing Poles"] = "Fishing Poles" --Changed in 2.3
		ITEMSUBTYPE["Fist Weapons"] = "Fist Weapons"
		ITEMSUBTYPE["Miscellaneous"] = "Miscellaneous"
		ITEMSUBTYPE["One-Handed Axes"] = "One-Handed Axes"
		ITEMSUBTYPE["One-Handed Maces"] = "One-Handed Maces"
		ITEMSUBTYPE["One-Handed Swords"] = "One-Handed Swords"
		ITEMSUBTYPE["Polearms"] = "Polearms"
		ITEMSUBTYPE["Staves"] = "Staves"
		ITEMSUBTYPE["Thrown"] = "Thrown"
		ITEMSUBTYPE["Two-Handed Axes"] = "Two-Handed Axes"
		ITEMSUBTYPE["Two-Handed Maces"] = "Two-Handed Maces"
		ITEMSUBTYPE["Two-Handed Swords"] = "Two-Handed Swords"
		ITEMSUBTYPE["Wands"] = "Wands"

if GetLocale() == "deDE" then
	ITEMTYPE["Armor"] = "Rüstung"
		ITEMSUBTYPE["Cloth"] = "Stoff"
		ITEMSUBTYPE["Idols"] = "Götze"
		ITEMSUBTYPE["Leather"] = "Leder"
		ITEMSUBTYPE["Librams"] = "Buchband"
		ITEMSUBTYPE["Mail"] = "Schwere Rüstung"
		ITEMSUBTYPE["Miscellaneous"] = "Verschiedenes"
		ITEMSUBTYPE["Shields"] = "Schilde"
		ITEMSUBTYPE["Totems"] = "Totem"
		ITEMSUBTYPE["Plate"] = "Platte"
	ITEMTYPE["Consumable"] = "Verbrauchbar"
		ITEMSUBTYPE["Consumable"] = "Verbrauchbar"
--New in 2.3
--		ITEMSUBTYPE["Food & Drink"] = "Food & Drink"
--		ITEMSUBTYPE["Potion"] = "Potion"
--		ITEMSUBTYPE["Elixir"] = "Elixir"
--		ITEMSUBTYPE["Flask"] = "Flask"
--		ITEMSUBTYPE["Bandage"] = "Bandage"
--		ITEMSUBTYPE["Item Enhancement"] = "Item Enhancement"
--		ITEMSUBTYPE["Scroll"] = "Scroll"
--		ITEMSUBTYPE["Other"] = "Other"
	ITEMTYPE["Container"] = "Behälter"
		ITEMSUBTYPE["Bag"] = "Tasche"
		ITEMSUBTYPE["Enchanting Bag"] = "Verzauberertasche"
		ITEMSUBTYPE["Engineering Bag"] = "Ingenieurstasche"
		ITEMSUBTYPE["Herb Bag"] = "Kräutertasche"
		ITEMSUBTYPE["Soul Bag"] = "Seelentasche"
		ITEMSUBTYPE["Mining Bag"] = "Bergbautasche"
	ITEMTYPE["Key"] = "Schlüssel"
		ITEMSUBTYPE["Key"] = "Schlüssel"
	ITEMTYPE["Miscellaneous"] = "Verschiedenes"
		ITEMSUBTYPE["Junk"] = "Plunder"
	ITEMTYPE["Reagent"] = "Reagenz"
		ITEMSUBTYPE["Reagent"] = "Reagenz"
	ITEMTYPE["Recipe"] = "Rezept"
		ITEMSUBTYPE["Alchemy"] = "Alchemie"
		ITEMSUBTYPE["Blacksmithing"] = "Schmiedekunst"
		ITEMSUBTYPE["Book"] = "Buch"
		ITEMSUBTYPE["Cooking"] = "Kochkunst"
		ITEMSUBTYPE["Enchanting"] = "Verzauberungskunst"
		ITEMSUBTYPE["Engineering"] = "Ingenierskunst"
		ITEMSUBTYPE["First Aid"] = "Erste Hilfe"
		ITEMSUBTYPE["Leatherworking"] = "Lederverarbeitung"
		ITEMSUBTYPE["Tailoring"] = "Schneiderrei"
	ITEMTYPE["Projectile"] = "Projektil"
		ITEMSUBTYPE["Arrow"] = "Pfeil"
		ITEMSUBTYPE["Bullet"] = "Kugel"
	ITEMTYPE["Quest"] = "Quest"
		ITEMSUBTYPE["Quest"] = "Quest"
	ITEMTYPE["Quiver"] = "Köcher"
		ITEMSUBTYPE["Ammo Pouch"] = "Munitionsbeutel"
		ITEMSUBTYPE["Quiver"] = "Köcher"
	ITEMTYPE["Trade Goods"] = "Handwerkswaren"
		ITEMSUBTYPE["Devices"] = "Geräte"
		ITEMSUBTYPE["Explosives"] = "Sprengstoff"
		ITEMSUBTYPE["Parts"] = "Teile"
		
		--New in 2.3
--		ITEMSUBTYPE["Elemental"] = "Elemental"
--		ITEMSUBTYPE["Cloth"] = "Cloth"
--		ITEMSUBTYPE["Leather"] = "Leather"
--		ITEMSUBTYPE["Metal & Stone"] = "Metal & Stone"
--		ITEMSUBTYPE["Meat"] = "Meat"
--		ITEMSUBTYPE["Herb"] = "Herb"
--		ITEMSUBTYPE["Enchanting"] = "Enchanting"
--		ITEMSUBTYPE["Jewelcrafting"] = "Jewelcrafting"
--		ITEMSUBTYPE["Devices"] = "Devices"
--		ITEMSUBTYPE["Other"] = "Other"
		
--	ITEMTYPE["Gem"] = "Gem"
--		ITEMSUBTYPE["Blue"] = "Blue"
--		ITEMSUBTYPE["Green"] = "Green"
--		ITEMSUBTYPE["Orange"] = "Orange"
--		ITEMSUBTYPE["Meta"] = "Meta"
--		ITEMSUBTYPE["Prismatic"] = "Prismatic"
--		ITEMSUBTYPE["Purple"] = "Purple"
--		ITEMSUBTYPE["Red"] = "Red"
--		ITEMSUBTYPE["Simple"] = "Simple"
--		ITEMSUBTYPE["Yellow"] = "Yellow"
	ITEMTYPE["Weapon"] = "Waffe"
		ITEMSUBTYPE["Bows"] = "Bögen"
		ITEMSUBTYPE["Crossbows"] = "Armbrüste"
		ITEMSUBTYPE["Daggers"] = "Dolche"
		ITEMSUBTYPE["Guns"] = "Schusswaffen"
		ITEMSUBTYPE["Fishing Poles"] = "Angel" --Needs fix for 2.3 ?
		ITEMSUBTYPE["Fist Weapons"] = "Faustkampfwaffen"
		ITEMSUBTYPE["Miscellaneous"] = "Verschiedenes"
		ITEMSUBTYPE["One-Handed Axes"] = "Einhandäxte"
		ITEMSUBTYPE["One-Handed Maces"] = "Einhandstreitkolben"
		ITEMSUBTYPE["One-Handed Swords"] = "Einhandschwerter"
		ITEMSUBTYPE["Polearms"] = "Stangenwaffen"
		ITEMSUBTYPE["Staves"] = "Stäbe"
		ITEMSUBTYPE["Thrown"] = "Wurfwaffe"
		ITEMSUBTYPE["Two-Handed Axes"] = "Zweihandäxte"
		ITEMSUBTYPE["Two-Handed Maces"] = "Zweihandstreitkolben"
		ITEMSUBTYPE["Two-Handed Swords"] = "Zweihandschwerter"
		ITEMSUBTYPE["Wands"] = "Zauberstäbe"
elseif GetLocale() == "frFR" then
	ITEMTYPE["Armor"] = "Armure"
		ITEMSUBTYPE["Cloth"] = "Tissu"
		ITEMSUBTYPE["Idols"] = "Idoles"
		ITEMSUBTYPE["Leather"] = "Cuir"
		ITEMSUBTYPE["Librams"] = "Librams"
		ITEMSUBTYPE["Mail"] = "Mailles"
		ITEMSUBTYPE["Miscellaneous"] = "Divers"
		ITEMSUBTYPE["Shields"] = "Boucliers"
		ITEMSUBTYPE["Totems"] = "Totems"
		ITEMSUBTYPE["Plate"] = "Plaques"
	ITEMTYPE["Consumable"] = "Consommable"
		ITEMSUBTYPE["Consumable"] = "Consommables"
		--New in 2.3
		ITEMSUBTYPE["Food & Drink"] = "Nourriture & boissons"
		ITEMSUBTYPE["Potion"] = "Potion"
		ITEMSUBTYPE["Elixir"] = "Elixir"
		ITEMSUBTYPE["Flask"] = "Flacon"
		ITEMSUBTYPE["Bandage"] = "Bandage"
		ITEMSUBTYPE["Item Enhancement"] = "Am\195\169lioration d'objet"
		ITEMSUBTYPE["Scroll"] = "Parchemin"
		ITEMSUBTYPE["Other"] = "Autre"

	ITEMTYPE["Container"] = "Conteneur"
		ITEMSUBTYPE["Bag"] = "Conteneur"
		ITEMSUBTYPE["Enchanting Bag"] = "Sac d'enchanteur"
		ITEMSUBTYPE["Engineering Bag"] = "Sac d'ing\195\169nieur"
		ITEMSUBTYPE["Herb Bag"] = "Sac d'herbes"
		ITEMSUBTYPE["Soul Bag"] = "Sac d'\195\162me"
		ITEMSUBTYPE["Mining Bag"] = "Sac de mineur"
		ITEMSUBTYPE["Gem Bag"] = "Sac de gemmes"
	ITEMTYPE["Key"] = "Cl\195\169"
		ITEMSUBTYPE["Key"] = "Cl\195\169"
	ITEMTYPE["Miscellaneous"] = "Divers"
		ITEMSUBTYPE["Junk"] = "Camelote"
	ITEMTYPE["Reagent"] = "Composant"
		ITEMSUBTYPE["Reagent"] = "Composant"
	ITEMTYPE["Recipe"] = "Recette"
		ITEMSUBTYPE["Alchemy"] = "Alchimie"
		ITEMSUBTYPE["Blacksmithing"] = "Forge"
		ITEMSUBTYPE["Book"] = "Livre"
		ITEMSUBTYPE["Cooking"] = "Cuisine"
		ITEMSUBTYPE["Enchanting"] = "Enchantement"
		ITEMSUBTYPE["Engineering"] = "Ing\195\169nierie"
		ITEMSUBTYPE["First Aid"] = "Secourisme"
		ITEMSUBTYPE["Leatherworking"] = "Travail du cuir"
		ITEMSUBTYPE["Tailoring"] = "Couture"
	ITEMTYPE["Projectile"] = "Projectile"
		ITEMSUBTYPE["Arrow"] = "Fl\195\168che"
		ITEMSUBTYPE["Bullet"] = "Balle"
	ITEMTYPE["Quest"] = "Qu\195\170te"
		ITEMSUBTYPE["Quest"] = "Qu\195\170te"
	ITEMTYPE["Quiver"] = "Carquois"
		ITEMSUBTYPE["Ammo Pouch"] = "Giberne"
		ITEMSUBTYPE["Quiver"] = "Carquois"
	ITEMTYPE["Trade Goods"] = "Artisanat"
		ITEMSUBTYPE["Trade Goods"] = "Artisanat"
		ITEMSUBTYPE["Devices"] = "Appareils"
		ITEMSUBTYPE["Explosives"] = "Explosifs"
		ITEMSUBTYPE["Parts"] = "El\195\169ments"
		ITEMSUBTYPE["Gems"] = "Gemmes"
--New in 2.3
		ITEMSUBTYPE["Elemental"] = "\195\137l\195\169mentaire"
		ITEMSUBTYPE["Cloth"] = "Tissu"
		ITEMSUBTYPE["Leather"] = "Cuir"
		ITEMSUBTYPE["Metal & Stone"] = "M\195\169tal & pierre"
		ITEMSUBTYPE["Meat"] = "Viande"
		ITEMSUBTYPE["Herb"] = "Herbe" -- to check !
		ITEMSUBTYPE["Enchanting"] = "Enchantement"
		ITEMSUBTYPE["Jewelcrafting"] = "Joaillerie"
		ITEMSUBTYPE["Devices"] = "Appareils"
		ITEMSUBTYPE["Other"] = "Autre"
	ITEMTYPE["Gem"] = "Gemme"
		ITEMSUBTYPE["Blue"] = "Bleue"
		ITEMSUBTYPE["Green"] = "Verte"
		ITEMSUBTYPE["Orange"] = "Orange"
		ITEMSUBTYPE["Meta"] = "M\195\169ta"
		ITEMSUBTYPE["Prismatic"] = "Prismatique"
		ITEMSUBTYPE["Purple"] = "Violette"
		ITEMSUBTYPE["Red"] = "Rouge"
		ITEMSUBTYPE["Simple"] = "Simple"
		ITEMSUBTYPE["Yellow"] = "Jaune"
	ITEMTYPE["Weapon"] = "Arme"
		ITEMSUBTYPE["Bows"] = "Arcs"
		ITEMSUBTYPE["Crossbows"] = "Arbal\195\168tes"
		ITEMSUBTYPE["Daggers"] = "Dagues"
		ITEMSUBTYPE["Guns"] = "Fusils"
		ITEMSUBTYPE["Fishing Poles"] = "Canne \195\160 p\195\170che" --Needs fix for 2.3 ?
		ITEMSUBTYPE["Fist Weapons"] = "Armes de pugilat"
		ITEMSUBTYPE["Miscellaneous"] = "Divers"
		ITEMSUBTYPE["One-Handed Axes"] = "Haches \195\160 une main"
		ITEMSUBTYPE["One-Handed Maces"] = "Maces \195\160 une main"
		ITEMSUBTYPE["One-Handed Swords"] = "Ep\195\169es \195\160 une main"
		ITEMSUBTYPE["Polearms"] = "Armes d'hast"
		ITEMSUBTYPE["Staves"] = "B\195\162tons"
		ITEMSUBTYPE["Thrown"] = "Armes de jet"
		ITEMSUBTYPE["Two-Handed Axes"] = "Haches \195\160 deux mains"
		ITEMSUBTYPE["Two-Handed Maces"] = "Maces \195\160 deux mains"
		ITEMSUBTYPE["Two-Handed Swords"] = "Ep\195\169es \195\160 deux mains"
		ITEMSUBTYPE["Wands"] = "Baguettes"
elseif GetLocale() == "koKR" then
   ITEMTYPE["Armor"] = "방어구"
		ITEMSUBTYPE["Cloth"] = "천"
		ITEMSUBTYPE["Idols"] = "우상"
		ITEMSUBTYPE["Leather"] = "가죽"
		ITEMSUBTYPE["Librams"] = "성서"
		ITEMSUBTYPE["Mail"] = "사슬"
		ITEMSUBTYPE["Miscellaneous"] = "기타"
		ITEMSUBTYPE["Shields"] = "방패"
		ITEMSUBTYPE["Totems"] = "토템"
		ITEMSUBTYPE["Plate"] = "판금"
	ITEMTYPE["Consumable"] = "소비 용품"
		ITEMSUBTYPE["Consumable"] = "소비 용품"
		--New in 2.3
--		ITEMSUBTYPE["Food & Drink"] = "Food & Drink"
--		ITEMSUBTYPE["Potion"] = "Potion"
--		ITEMSUBTYPE["Elixir"] = "Elixir"
--		ITEMSUBTYPE["Flask"] = "Flask"
--		ITEMSUBTYPE["Bandage"] = "Bandage"
--		ITEMSUBTYPE["Item Enhancement"] = "Item Enhancement"
--		ITEMSUBTYPE["Scroll"] = "Scroll"
--		ITEMSUBTYPE["Other"] = "Other"
	ITEMTYPE["Container"] = "가방"
		ITEMSUBTYPE["Bag"] = "가방"
		ITEMSUBTYPE["Enchanting Bag"] = "마법부여 가방 "
		ITEMSUBTYPE["Engineering Bag"] = "기계공학 가방"
		ITEMSUBTYPE["Herb Bag"] = "약초 가방"
		ITEMSUBTYPE["Soul Bag"] = "영혼의 가방"
		ITEMSUBTYPE["Mining Bag"] = "채광 가방"
	ITEMTYPE["Key"] = "열쇠"
		ITEMSUBTYPE["Key"] = "열쇠"
	ITEMTYPE["Miscellaneous"] = "기타"
		ITEMSUBTYPE["Junk"] = "잡동사니"
	ITEMTYPE["Reagent"] = "재료"
		ITEMSUBTYPE["Reagent"] = "재료"
	ITEMTYPE["Recipe"] = "제조법"
		ITEMSUBTYPE["Alchemy"] = "연금술"
		ITEMSUBTYPE["Blacksmithing"] = "대장기술"
		ITEMSUBTYPE["Book"] = "책"
		ITEMSUBTYPE["Cooking"] = "요리"
		ITEMSUBTYPE["Enchanting"] = "마법부여"
		ITEMSUBTYPE["Engineering"] = "기겨공학"
		ITEMSUBTYPE["First Aid"] = "응급치료"
		ITEMSUBTYPE["Leatherworking"] = "가죽세공"
		ITEMSUBTYPE["Tailoring"] = "재봉술"
	ITEMTYPE["Projectile"] = "투사체"
		ITEMSUBTYPE["Arrow"] = "화살"
		ITEMSUBTYPE["Bullet"] = "탄환"
	ITEMTYPE["Quest"] = "퀘스트"
		ITEMSUBTYPE["Quest"] = "퀘스트"
	ITEMTYPE["Quiver"] = "화살통"
		ITEMSUBTYPE["Ammo Pouch"] = "탄약 주머니"
		ITEMSUBTYPE["Quiver"] = "화살통"
	ITEMTYPE["Trade Goods"] = "직업 용품"
		ITEMSUBTYPE["Trade Goods"] = "직업 용품"
		ITEMSUBTYPE["Devices"] = "장치"
		ITEMSUBTYPE["Explosives"] = "폭발물"
		ITEMSUBTYPE["Parts"] = "부품"
		ITEMSUBTYPE["Gems"] = "보석"
		--New in 2.3
--		ITEMSUBTYPE["Elemental"] = "Elemental"
--		ITEMSUBTYPE["Cloth"] = "Cloth"
--		ITEMSUBTYPE["Leather"] = "Leather"
--		ITEMSUBTYPE["Metal & Stone"] = "Metal & Stone"
--		ITEMSUBTYPE["Meat"] = "Meat"
--		ITEMSUBTYPE["Herb"] = "Herb"
--		ITEMSUBTYPE["Enchanting"] = "Enchanting"
--		ITEMSUBTYPE["Jewelcrafting"] = "Jewelcrafting"
--		ITEMSUBTYPE["Devices"] = "Devices"
--		ITEMSUBTYPE["Other"] = "Other"

--	ITEMTYPE["Gem"] = "Gem"
--		ITEMSUBTYPE["Blue"] = "Blue"
--		ITEMSUBTYPE["Green"] = "Green"
--		ITEMSUBTYPE["Orange"] = "Orange"
--		ITEMSUBTYPE["Meta"] = "Meta"
--		ITEMSUBTYPE["Prismatic"] = "Prismatic"
--		ITEMSUBTYPE["Purple"] = "Purple"
--		ITEMSUBTYPE["Red"] = "Red"
--		ITEMSUBTYPE["Simple"] = "Simple"
--		ITEMSUBTYPE["Yellow"] = "Yellow"
	ITEMTYPE["Weapon"] = "무기"
		ITEMSUBTYPE["Bows"] = "활류"
		ITEMSUBTYPE["Crossbows"] = "석궁류"
		ITEMSUBTYPE["Daggers"] = "단검류"
		ITEMSUBTYPE["Guns"] = "총류"
		ITEMSUBTYPE["Fishing Poles"] = "낚싯대" --Needs fix for 2.3 ?
		ITEMSUBTYPE["Fist Weapons"] = "장착 무기류"
		ITEMSUBTYPE["Miscellaneous"] = "기타"
		ITEMSUBTYPE["One-Handed Axes"] = "한손 도끼류"
		ITEMSUBTYPE["One-Handed Maces"] = "한손 둔기류"
		ITEMSUBTYPE["One-Handed Swords"] = "한손 도검류"
		ITEMSUBTYPE["Polearms"] = "장창류"
		ITEMSUBTYPE["Staves"] = "지팡이류"
		ITEMSUBTYPE["Thrown"] = "투척 무기류"
		ITEMSUBTYPE["Two-Handed Axes"] = "양손 도끼류"
		ITEMSUBTYPE["Two-Handed Maces"] = "양손 둔기류"
		ITEMSUBTYPE["Two-Handed Swords"] = "양손 도검류"
		ITEMSUBTYPE["Wands"] = "마법봉류"
elseif GetLocale() == "esES" then
	ITEMTYPE["Armor"] = "Armadura"
		ITEMSUBTYPE["Cloth"] = "Tela"
		ITEMSUBTYPE["Idols"] = "Ídolos"
		ITEMSUBTYPE["Leather"] = "Cuero"
		ITEMSUBTYPE["Librams"] = "Tratados"
		ITEMSUBTYPE["Mail"] = "Malla"
		ITEMSUBTYPE["Miscellaneous"] = "Misceláneo"
		ITEMSUBTYPE["Shields"] = "Escudos"
		ITEMSUBTYPE["Totems"] = "Tótems"
		ITEMSUBTYPE["Plate"] = "Placas"
	ITEMTYPE["Consumable"] = "Consumible"
		ITEMSUBTYPE["Consumable"] = "Consumible"
		--New in 2.3
--		ITEMSUBTYPE["Food & Drink"] = "Food & Drink"
--		ITEMSUBTYPE["Potion"] = "Potion"
--		ITEMSUBTYPE["Elixir"] = "Elixir"
--		ITEMSUBTYPE["Flask"] = "Flask"
--		ITEMSUBTYPE["Bandage"] = "Bandage"
--		ITEMSUBTYPE["Item Enhancement"] = "Item Enhancement"
--		ITEMSUBTYPE["Scroll"] = "Scroll"
--		ITEMSUBTYPE["Other"] = "Other"
	ITEMTYPE["Container"] = "Contenedor"
		ITEMSUBTYPE["Bag"] = "Bolsa"
		ITEMSUBTYPE["Enchanting Bag"] = "Bolsa de encantamiento"
		ITEMSUBTYPE["Engineering Bag"] = "Bolsa de ingeniería"
		ITEMSUBTYPE["Herb Bag"] = "Bolsa de hierbas"
		ITEMSUBTYPE["Soul Bag"] = "Bolsa de almas"
		ITEMSUBTYPE["Mining Bag"] = "Bolsa de minería"
	ITEMTYPE["Key"] = "Llave"
		ITEMSUBTYPE["Key"] = "Llave"
	ITEMTYPE["Miscellaneous"] = "Misceláneo"
		ITEMSUBTYPE["Junk"] = "Basura"
	ITEMTYPE["Reagent"] = "Componente"
		ITEMSUBTYPE["Reagent"] = "Componente"
	ITEMTYPE["Recipe"] = "Receta"
		ITEMSUBTYPE["Alchemy"] = "Alquimia"
		ITEMSUBTYPE["Blacksmithing"] = "Herrería"
		ITEMSUBTYPE["Book"] = "Libro"
		ITEMSUBTYPE["Cooking"] = "Cocina"
		ITEMSUBTYPE["Enchanting"] = "Encantamiento"
		ITEMSUBTYPE["Engineering"] = "Ingeniería"
		ITEMSUBTYPE["First Aid"] = "Primeros auxilios"
		ITEMSUBTYPE["Leatherworking"] = "Peletería"
		ITEMSUBTYPE["Tailoring"] = "Sastrería"
	ITEMTYPE["Projectile"] = "Proyectil"
		ITEMSUBTYPE["Arrow"] = "Flecha"
		ITEMSUBTYPE["Bullet"] = "Bala"
	ITEMTYPE["Quest"] = "Misión"
		ITEMSUBTYPE["Quest"] = "Misión"
	ITEMTYPE["Quiver"] = "Carcaj"
		ITEMSUBTYPE["Ammo Pouch"] = "Bolsa de munición"
		ITEMSUBTYPE["Quiver"] = "Carcaj"
	ITEMTYPE["Trade Goods"] = "Objeto comerciable"
		ITEMSUBTYPE["Devices"] = "Aparatos"
		ITEMSUBTYPE["Explosives"] = "Explosivos"
		ITEMSUBTYPE["Parts"] = "Partes"
		--New in 2.3
--		ITEMSUBTYPE["Elemental"] = "Elemental"
--		ITEMSUBTYPE["Cloth"] = "Cloth"
--		ITEMSUBTYPE["Leather"] = "Leather"
--		ITEMSUBTYPE["Metal & Stone"] = "Metal & Stone"
--		ITEMSUBTYPE["Meat"] = "Meat"
--		ITEMSUBTYPE["Herb"] = "Herb"
--		ITEMSUBTYPE["Enchanting"] = "Enchanting"
--		ITEMSUBTYPE["Jewelcrafting"] = "Jewelcrafting"
--		ITEMSUBTYPE["Devices"] = "Devices"
--		ITEMSUBTYPE["Other"] = "Other"
	ITEMTYPE["Gem"] = "Gema"
		ITEMSUBTYPE["Blue"] = "Azul"
		ITEMSUBTYPE["Green"] = "Verde"
		ITEMSUBTYPE["Orange"] = "Naranja"
		ITEMSUBTYPE["Meta"] = "Meta"
		ITEMSUBTYPE["Prismatic"] = "Centelleante"
		ITEMSUBTYPE["Purple"] = "Morado"
		ITEMSUBTYPE["Red"] = "Rojo"
		ITEMSUBTYPE["Simple"] = "Simple"
		ITEMSUBTYPE["Yellow"] = "Amarillo"
	ITEMTYPE["Weapon"] = "Arma"
		ITEMSUBTYPE["Bows"] = "Arcos"
		ITEMSUBTYPE["Crossbows"] = "Ballestas"
		ITEMSUBTYPE["Daggers"] = "Dagas"
		ITEMSUBTYPE["Guns"] = "Armas de fuego"
		ITEMSUBTYPE["Fishing Poles"] = "Cañas de pescar" --Needs fix for 2.3 ?
		ITEMSUBTYPE["Fist Weapons"] = "Armas de puño"
		ITEMSUBTYPE["Miscellaneous"] = "Miscelánea"
		ITEMSUBTYPE["One-Handed Axes"] = "Hachas de una mano"
		ITEMSUBTYPE["One-Handed Maces"] = "Mazas de una mano"
		ITEMSUBTYPE["One-Handed Swords"] = "Espadas de una mano"
		ITEMSUBTYPE["Polearms"] = "Armas de asta"
		ITEMSUBTYPE["Staves"] = "Bastones"
		ITEMSUBTYPE["Thrown"] = "Armas arrojadizas"
		ITEMSUBTYPE["Two-Handed Axes"] = "Hachas de dos manos"
		ITEMSUBTYPE["Two-Handed Maces"] = "Mazas de dos manos"
		ITEMSUBTYPE["Two-Handed Swords"] = "Espadas de dos manos"
		ITEMSUBTYPE["Wands"] = "Varitas"
elseif GetLocale() == "zhCN" then
	ITEMTYPE["Armor"] = "护甲"
		ITEMSUBTYPE["Cloth"] = "布甲"
		ITEMSUBTYPE["Idols"] = "神像"
		ITEMSUBTYPE["Leather"] = "皮甲"
		ITEMSUBTYPE["Librams"] = "圣契"
		ITEMSUBTYPE["Mail"] = "锁甲"
		ITEMSUBTYPE["Miscellaneous"] = "其它"
		ITEMSUBTYPE["Shields"] = "盾牌"
		ITEMSUBTYPE["Totems"] = "图腾"
		ITEMSUBTYPE["Plate"] = "板甲"
	ITEMTYPE["Consumable"] = "消耗品"
		ITEMSUBTYPE["Consumable"] = "消耗品"
		--New in 2.3
--		ITEMSUBTYPE["Food & Drink"] = "Food & Drink"
--		ITEMSUBTYPE["Potion"] = "Potion"
--		ITEMSUBTYPE["Elixir"] = "Elixir"
--		ITEMSUBTYPE["Flask"] = "Flask"
--		ITEMSUBTYPE["Bandage"] = "Bandage"
--		ITEMSUBTYPE["Item Enhancement"] = "Item Enhancement"
--		ITEMSUBTYPE["Scroll"] = "Scroll"
--		ITEMSUBTYPE["Other"] = "Other"
	ITEMTYPE["Container"] = "容器"
		ITEMSUBTYPE["Bag"] = "容器"
		ITEMSUBTYPE["Enchanting Bag"] = "附魔材料袋"
		ITEMSUBTYPE["Engineering Bag"] = "工程学材料袋"
		ITEMSUBTYPE["Herb Bag"] = "草药袋"
		ITEMSUBTYPE["Soul Bag"] = "灵魂袋"
		ITEMSUBTYPE["Mining Bag"] = "矿石袋"
		ITEMSUBTYPE["Gem Bag"] = "宝石袋"
	ITEMTYPE["Key"] = "钥匙"
		ITEMSUBTYPE["Key"] = "钥匙"
	ITEMTYPE["Miscellaneous"] = "其它"
		ITEMSUBTYPE["Junk"] = "垃圾"
	ITEMTYPE["Reagent"] = "材料"
		ITEMSUBTYPE["Reagent"] = "材料"
	ITEMTYPE["Recipe"] = "配方"
		ITEMSUBTYPE["Alchemy"] = "炼金术"
		ITEMSUBTYPE["Blacksmithing"] = "锻造"
		ITEMSUBTYPE["Book"] = "书籍"
		ITEMSUBTYPE["Cooking"] = "烹饪"
		ITEMSUBTYPE["Enchanting"] = "附魔"
		ITEMSUBTYPE["Engineering"] = "工程学"
		ITEMSUBTYPE["First Aid"] = "急救"
		ITEMSUBTYPE["Leatherworking"] = "制皮"
		ITEMSUBTYPE["Tailoring"] = "剥皮"
	ITEMTYPE["Projectile"] = "弹药"
		ITEMSUBTYPE["Arrow"] = "箭"
		ITEMSUBTYPE["Bullet"] = "子弹"
	ITEMTYPE["Quest"] = "任务"
		ITEMSUBTYPE["Quest"] = "任务"
	ITEMTYPE["Quiver"] = "箭袋"
		ITEMSUBTYPE["Ammo Pouch"] = "弹药袋"
		ITEMSUBTYPE["Quiver"] = "箭袋"
	ITEMTYPE["Trade Goods"] = "商品"
		ITEMSUBTYPE["Trade Goods"] = "商品"
		ITEMSUBTYPE["Devices"] = "装置"
		ITEMSUBTYPE["Explosives"] = "爆炸物"
		ITEMSUBTYPE["Parts"] = "零件"
		--New in 2.3
--		ITEMSUBTYPE["Elemental"] = "Elemental"
--		ITEMSUBTYPE["Cloth"] = "Cloth"
--		ITEMSUBTYPE["Leather"] = "Leather"
--		ITEMSUBTYPE["Metal & Stone"] = "Metal & Stone"
--		ITEMSUBTYPE["Meat"] = "Meat"
--		ITEMSUBTYPE["Herb"] = "Herb"
--		ITEMSUBTYPE["Enchanting"] = "Enchanting"
--		ITEMSUBTYPE["Jewelcrafting"] = "Jewelcrafting"
--		ITEMSUBTYPE["Devices"] = "Devices"
--		ITEMSUBTYPE["Other"] = "Other"
	ITEMTYPE["Gem"] = "珠宝"
		ITEMSUBTYPE["Blue"] = "蓝色"
		ITEMSUBTYPE["Green"] = "绿色"
		ITEMSUBTYPE["Orange"] = "橙色"
		ITEMSUBTYPE["Meta"] = "多彩"
		ITEMSUBTYPE["Prismatic"] = "棱彩"
		ITEMSUBTYPE["Purple"] = "紫色"
		ITEMSUBTYPE["Red"] = "红色"
		ITEMSUBTYPE["Simple"] = "简易"
		ITEMSUBTYPE["Yellow"] = "黄色"
	ITEMTYPE["Weapon"] = "武器"
		ITEMSUBTYPE["Bows"] = "弓"
		ITEMSUBTYPE["Crossbows"] = "弩"
		ITEMSUBTYPE["Daggers"] = "匕首"
		ITEMSUBTYPE["Guns"] = "枪械"
		ITEMSUBTYPE["Fishing Poles"] = "鱼竿"--Needs fix for 2.3 ?
		ITEMSUBTYPE["Fist Weapons"] = "拳套"
		ITEMSUBTYPE["Miscellaneous"] = "其它"
		ITEMSUBTYPE["One-Handed Axes"] = "单手斧"
		ITEMSUBTYPE["One-Handed Maces"] = "单手锤"
		ITEMSUBTYPE["One-Handed Swords"] = "单手剑"
		ITEMSUBTYPE["Polearms"] = "长柄武器"
		ITEMSUBTYPE["Staves"] = "法杖"
		ITEMSUBTYPE["Thrown"] = "投掷武器"
		ITEMSUBTYPE["Two-Handed Axes"] = "双手斧"
		ITEMSUBTYPE["Two-Handed Maces"] = "双手锤"
		ITEMSUBTYPE["Two-Handed Swords"] = "双手剑"
		ITEMSUBTYPE["Wands"] = "魔杖"
elseif GetLocale() == "zhTW" then
	ITEMTYPE["Armor"] = "護甲"
		ITEMSUBTYPE["Cloth"] = "布衣"
		ITEMSUBTYPE["Idols"] = "雕像"
		ITEMSUBTYPE["Leather"] = "皮甲"
		ITEMSUBTYPE["Librams"] = "聖契"
		ITEMSUBTYPE["Mail"] = "鎖甲"
		ITEMSUBTYPE["Miscellaneous"] = "其他"
		ITEMSUBTYPE["Shields"] = "盾牌"
		ITEMSUBTYPE["Totems"] = "圖騰"
		ITEMSUBTYPE["Plate"] = "鎧甲"
	ITEMTYPE["Consumable"] = "消耗品"
		ITEMSUBTYPE["Consumable"] = "消耗品"
		--New in 2.3
--		ITEMSUBTYPE["Food & Drink"] = "Food & Drink"
--		ITEMSUBTYPE["Potion"] = "Potion"
--		ITEMSUBTYPE["Elixir"] = "Elixir"
--		ITEMSUBTYPE["Flask"] = "Flask"
--		ITEMSUBTYPE["Bandage"] = "Bandage"
--		ITEMSUBTYPE["Item Enhancement"] = "Item Enhancement"
--		ITEMSUBTYPE["Scroll"] = "Scroll"
--		ITEMSUBTYPE["Other"] = "Other"
	ITEMTYPE["Container"] = "容器"
		ITEMSUBTYPE["Bag"] = "容器"
		ITEMSUBTYPE["Enchanting Bag"] = "附魔包"
		ITEMSUBTYPE["Engineering Bag"] = "工程包"
		ITEMSUBTYPE["Herb Bag"] = "草藥包"
		ITEMSUBTYPE["Soul Bag"] = "靈魂碎片背包"
		ITEMSUBTYPE["Mining Bag"] = "採礦背包"
	ITEMTYPE["Key"] = "鑰匙"
		ITEMSUBTYPE["Key"] = "鑰匙"
	ITEMTYPE["Miscellaneous"] = "其他"
		ITEMSUBTYPE["Junk"] = "垃圾"
	ITEMTYPE["Reagent"] = "材料"
		ITEMSUBTYPE["Reagent"] = "材料"
	ITEMTYPE["Recipe"] = "配方"
		ITEMSUBTYPE["Alchemy"] = "鍊金術"
		ITEMSUBTYPE["Blacksmithing"] = "鍛造"
		ITEMSUBTYPE["Book"] = "書籍"
		ITEMSUBTYPE["Cooking"] = "烹飪"
		ITEMSUBTYPE["Enchanting"] = "附魔"
		ITEMSUBTYPE["Engineering"] = "工程"
		ITEMSUBTYPE["First Aid"] = "急救"
		ITEMSUBTYPE["Leatherworking"] = "制皮"
		ITEMSUBTYPE["Tailoring"] = "裁縫"
	ITEMTYPE["Projectile"] = "彈藥"
		ITEMSUBTYPE["Arrow"] = "彈藥 (箭)"
		ITEMSUBTYPE["Bullet"] = "彈藥 (子彈)"
	ITEMTYPE["Quest"] = "任務"
		ITEMSUBTYPE["Quest"] = "任務"
	ITEMTYPE["Quiver"] = "箭袋"
		ITEMSUBTYPE["Ammo Pouch"] = "彈藥袋"
		ITEMSUBTYPE["Quiver"] = "箭袋"
	ITEMTYPE["Trade Goods"] = "商品"
		ITEMSUBTYPE["Devices"] = "裝置"
		ITEMSUBTYPE["Explosives"] = "爆炸物"
		ITEMSUBTYPE["Parts"] = "零件"
		--New in 2.3
--		ITEMSUBTYPE["Elemental"] = "Elemental"
--		ITEMSUBTYPE["Cloth"] = "Cloth"
--		ITEMSUBTYPE["Leather"] = "Leather"
--		ITEMSUBTYPE["Metal & Stone"] = "Metal & Stone"
--		ITEMSUBTYPE["Meat"] = "Meat"
--		ITEMSUBTYPE["Herb"] = "Herb"
--		ITEMSUBTYPE["Enchanting"] = "Enchanting"
--		ITEMSUBTYPE["Jewelcrafting"] = "Jewelcrafting"
--		ITEMSUBTYPE["Devices"] = "Devices"
--		ITEMSUBTYPE["Other"] = "Other"
	ITEMTYPE["Gem"] = "珠寶"
		ITEMSUBTYPE["Blue"] = "藍色"
		ITEMSUBTYPE["Green"] = "綠色"
		ITEMSUBTYPE["Orange"] = "橘色"
		ITEMSUBTYPE["Meta"] = "變換"
		ITEMSUBTYPE["Prismatic"] = "棱石"
		ITEMSUBTYPE["Purple"] = "紫色"
		ITEMSUBTYPE["Red"] = "紅色"
		ITEMSUBTYPE["Simple"] = "簡單"
		ITEMSUBTYPE["Yellow"] = "黃色"
	ITEMTYPE["Weapon"] = "武器"
		ITEMSUBTYPE["Bows"] = "弓"
		ITEMSUBTYPE["Crossbows"] = "弩"
		ITEMSUBTYPE["Daggers"] = "匕首"
		ITEMSUBTYPE["Guns"] = "槍械"
		ITEMSUBTYPE["Fishing Poles"] = "魚竿"--Needs fix for 2.3 ?
		ITEMSUBTYPE["Fist Weapons"] = "拳套"
		ITEMSUBTYPE["Miscellaneous"] = "其他"
		ITEMSUBTYPE["One-Handed Axes"] = "單手斧"
		ITEMSUBTYPE["One-Handed Maces"] = "單手錘"
		ITEMSUBTYPE["One-Handed Swords"] = "單手劍"
		ITEMSUBTYPE["Polearms"] = "長柄武器"
		ITEMSUBTYPE["Staves"] = "法杖"
		ITEMSUBTYPE["Thrown"] = "投擲武器"
		ITEMSUBTYPE["Two-Handed Axes"] = "雙手斧"
		ITEMSUBTYPE["Two-Handed Maces"] = "雙手錘"
		ITEMSUBTYPE["Two-Handed Swords"] = "雙手劍"
		ITEMSUBTYPE["Wands"] = "魔杖"		
end

local categorycache = {}
local useditems = {}
local slotcache = {}

function Baggins:GetCategoryCache()
    return categorycache
end

local ptsets = {
		type = "group",
		args = {},
	}

local bankuseditems = {}
local bankcategorycache = {}

local categories

local colors = {
		black = {r=0,g=0,b=0,hex="|cff000000"},
		white = {r=1,g=1,b=1,hex="|cffffffff"},
		blue = {r=0,g=0.5,b=1,hex="|cff007fff"},
		purple = {r=1,g=0.4,b=1,hex="|cffff66ff"},
	}

function Baggins:SetCategoryTable(cats)
	categories = cats
end


local BagNames = {
	[0] = L["Backpack"],
	[1] = L["Bag1"],
	[2] = L["Bag2"],
	[3] = L["Bag3"],
	[4] = L["Bag4"],
	[-1] = L["Bank Frame"],
	[5] = L["Bank Bag1"],
	[6] = L["Bank Bag2"],
	[7] = L["Bank Bag3"],
	[8] = L["Bank Bag4"],
	[9] = L["Bank Bag5"],
	[10] = L["Bank Bag6"],
	[11] = L["Bank Bag7"],	
	[-2] = L["KeyRing"],
}

local BagTypes = { 
	--normal bags
	[0] = 1,
	[1] = 1,
	[2] = 1,
	[3] = 1,
	[4] = 1,
	--bank bags
	[-1] = 2,
	[5] = 2,
	[6] = 2,
	[7] = 2,
	[8] = 2,
	[9] = 2,
	[10] = 2,
	[11] = 2,
	--keyring
	[-2] = 3,		
}

local QualityNames = {
	[0] = "Poor",
	[1] = "Common",
	[2] = "Uncommon",
	[3] = "Rare",
	[4] = "Epic",
	[5] = "Legendary",
	[6] = "Artifact",
}

local ItemTypes = { 
	["Armor"] = { "Cloth", "Idols", "Leather", "Librams", "Mail", "Miscellaneous", "Shields", "Totems", "Plate"},
	["Consumable"] = { "Consumable", "Food & Drink", "Potion", "Elixir", "Flask", "Bandage", "Item Enhancement", "Scroll", "Other" },
	["Container"]  = {"Bag", "Enchanting Bag", "Engineering Bag", "Herb Bag", "Soul Bag", "Mining Bag", "Gem Bag", "Leatherworking Bag" },
	["Key"] = { "Key" },
	["Miscellaneous"] = { "Junk", "Reagent","Pet", "Holiday", "Other" },
	["Reagent"]  = { "Reagent" },
	["Recipe"]  = { "Alchemy","Blacksmithing","Book","Cooking","Enchanting","Engineering","First Aid","Leatherworking","Tailoring" },
	["Projectile"]  = {"Arrow","Bullet"},
	["Quest"]  = { "Quest" },
	["Quiver"]  = { "Ammo Pouch","Quiver" },
	["Trade Goods"]  = { "Elemental" ,"Cloth" ,"Leather" ,"Metal & Stone" ,"Meat" ,"Herb" ,"Enchanting" ,"Jewelcrafting" ,"Parts" ,"Devices" ,"Explosives" ,"Devices" ,"Other" ,"Trade Goods" },
	["Gem"] = { "Blue","Green","Orange","Meta","Prismatic","Purple","Red","Simple","Yellow" },
	["Weapon"]  = { "Bows","Crossbows","Daggers","Guns","Fishing Poles","Fist Weapons","Miscellaneous","One-Handed Axes","One-Handed Maces","One-Handed Swords","Polearms","Staves","Thrown","Two-Handed Axes","Two-Handed Maces","Two-Handed Swords","Wands"},
}

--local ItemTypes = {}
--
--local function BuildItemTypes(...)
--	local i
--	for i = 1, select('#', ...) do
--		ItemTypes[select(i,...)] = {GetAuctionItemSubClasses(i)}
--	end
--end

--BuildItemTypes(GetAuctionItemClasses())


local EquipLocs = {
	"INVTYPE_AMMO",
	"INVTYPE_HEAD",
	"INVTYPE_NECK",
	"INVTYPE_SHOULDER",
	"INVTYPE_BODY", 
	"INVTYPE_CHEST",
	"INVTYPE_ROBE",
	"INVTYPE_WAIST",
	"INVTYPE_LEGS",
	"INVTYPE_FEET",
	"INVTYPE_WRIST",
	"INVTYPE_HAND",
	"INVTYPE_FINGER",
	"INVTYPE_TRINKET",
	"INVTYPE_CLOAK",
	"INVTYPE_WEAPON",
	"INVTYPE_SHIELD",
	"INVTYPE_2HWEAPON",
	"INVTYPE_WEAPONMAINHAND",
	"INVTYPE_WEAPONOFFHAND",
	"INVTYPE_HOLDABLE",
	"INVTYPE_RANGED",
	"INVTYPE_THROWN",
	"INVTYPE_RANGEDRIGHT",
	"INVTYPE_RELIC",
	"INVTYPE_TABARD",
	"INVTYPE_BAG"
}
--removes any fields not used by the current rule type and sets up defaults if needed

function Baggins:AddCustomRule(type,description)
	RuleTypes[type] = description
end

function Baggins:CleanRule(rule)
	for k, v in pairs(rule) do
		if k ~= "type" then
			rule[k] = nil
		end
	end

	if RuleTypes[rule.type].CleanRule then
		RuleTypes[rule.type].CleanRule(rule)
	end

	if rule.type == "ItemType" then
		rule.itype = "Miscellaneous"
	end

	if rule.type == "Bag" then
		rule.bagid = 0
	end

	if rule.type == "EquipLoc" then
		rule.equiploc = EquipLocs[1]
	end
	
	if rule.type == "Quality" then
		rule.quality = 1
		rule.comp = "=="
	end
	
end

local ptsetstatus = {}
local function PTSetDewdrop(rule,level,value,value_1)
	local perlevel = 30
	
	if level == 1 then
		for k, v in pairs(ptsets) do
			dewdrop:AddLine("text",k,"hasArrow",true,"value",k)
		end
	else
		
	end
end

RuleTypes = {
	ItemType = {
		DisplayName = L["Item Type"],
		Description = L["Filter by Item type and sub-type as returned by GetItemInfo"],
		Matches = function(bag,slot,rule) 
			if not (rule.itype or rule.isubtype) then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local Type, SubType = select(6, GetItemInfo(link))
				if Type and SubType then
					return Type == ITEMTYPE[rule.itype] and (rule.isubtype == nil or SubType == ITEMSUBTYPE[rule.isubtype] )	
				end
			end
		end,
		GetName = function(rule) 
			local ltype, lsubtype = "*", "*"
			if rule.itype then
				ltype = ITEMTYPE[rule.itype] or "?"
			end
			if rule.isubtype then
				lsubtype = ITEMSUBTYPE[rule.isubtype] or "?"
			end
			return L["ItemType - "]..ltype..":"..lsubtype
		end,
		DewDropOptions = function(rule, level, value) 
			if level == 1 then
				dewdrop:AddLine('text', L["Item Type Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Item Type"], 'hasArrow', true,'value',"ItemType")
				dewdrop:AddLine('text', L["Item Subtype"], 'hasArrow', true,'value',"ItemSubtype")

			elseif level == 2 and value == "ItemType" then	
				for k, v in pairs(ItemTypes) do
					dewdrop:AddLine('text', ITEMTYPE[k], "checked", rule.itype == k,"func",function(k) rule.itype = k rule.isubtype = nil Baggins:OnRuleChanged() end,"arg1",k)
				end
			elseif level == 2 and value == "ItemSubtype" then
				dewdrop:AddLine('text', L["All"], "checked", rule.isubtype == nil,"func",function() rule.isubtype = nil Baggins:OnRuleChanged() end)
				dewdrop:AddLine()
				if rule.itype and ItemTypes[rule.itype] then
					for k, v in ipairs(ItemTypes[rule.itype]) do
						dewdrop:AddLine('text', ITEMSUBTYPE[v], "checked", rule.isubtype == v,"func",function(v) rule.isubtype = v Baggins:OnRuleChanged() end,"arg1",v)
					end
				end
			end
		end,
	},
	ContainerType = {
		DisplayName = L["Container Type"],
		Description = L["Filter by the type of container the item is in."],	
		Matches = function(bag,slot,rule)
			if bag < 1 or bag > 11 then return end
			if not rule.ctype then return end
			local link = GetInventoryItemLink("player",ContainerIDToInventoryID(bag))
			if link then
				local SubType = select(7, GetItemInfo(link))
				if SubType then
					return SubType == ITEMSUBTYPE[rule.ctype]
				end
			end
		end,
		GetName = function(rule) 
			local ctype
			if rule.ctype then
				ctype = ITEMSUBTYPE[rule.ctype]
			else
				ctype = L["None"]
			end
			return L["Container : "]..ctype
		end,
		DewDropOptions = function(rule, level, value) 
			if level == 1 then
				dewdrop:AddLine('text', L["Container Type Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Container Type"], 'hasArrow', true,'value',"ContainerType")
	
			elseif level == 2 and value == "ContainerType" then
				dewdrop:AddLine('text', L["All"], "checked", rule.ctype == nil,"func",function() rule.ctype = nil Baggins:OnRuleChanged() end)
				dewdrop:AddLine()
				for k, v in ipairs(ItemTypes["Container"]) do
					dewdrop:AddLine('text', ITEMSUBTYPE[v], "checked", rule.ctype == v,"func",function(v) rule.ctype = v Baggins:OnRuleChanged() end,"arg1",v)
				end	
				for k, v in ipairs(ItemTypes["Quiver"]) do
					dewdrop:AddLine('text', ITEMSUBTYPE[v], "checked", rule.ctype == v,"func",function(v) rule.ctype = v Baggins:OnRuleChanged() end,"arg1",v)
				end		
			end
		end,
	},
	ItemID = {
		DisplayName = L["Item ID"],
		Description = L["Filter by ItemID, this can be a space delimited list or ids to match."],
		Matches = function(bag,slot,rule) 
			if not rule.ids then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local itemid = link:match("item:(%d+)")
				return rule.ids[tonumber(itemid)]
			end
		end,
		GetName = function(rule) 
			return L["ItemIDs "]
		end,
		DewDropOptions = function(rule, level, value) 
			if level == 1 then
				dewdrop:AddLine('text', L["ItemID Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Current IDs, click to remove"], 'isTitle', true)
				if rule.ids then
					for k, v in pairs(rule.ids) do
						local name = GetItemInfo(k)
						dewdrop:AddLine('text', k.." "..(name or ""),"func", function(id) rule.ids[id] = nil end, "arg1", k )
					end
				end
				dewdrop:AddLine('text', L["New"], 'hasArrow', true,'value',"NewID","hasEditBox",true,"editBoxText", "",
								"editBoxFunc", function(text) 
									local id = tonumber(text)
									if not id then
										id = tonumber(text:match("item:(%d+)"))
									end
									if id ~= 0 then
										if not rule.ids then
											rule.ids = {}
										end
										rule.ids[id] = true 
									end
									Baggins:OnRuleChanged() 
								end )

			end
		end,
	},
	Bag = {
		DisplayName = L["Bag"],
		Description = L["Filter by the bag the item is in"],	
		Matches = function(bag,slot,rule) 
			if rule.noempty then
				local link = GetContainerItemLink(bag, slot)
				if link then
					return bag == rule.bagid 
				end
			else
				return bag == rule.bagid
			end
		end,
		GetName = function(rule) 
			return "Bag "..(BagNames[rule.bagid] or rule.bagid or "*none*")..((rule.noempty and " *NotEmpty*") or "")
		end,
		DewDropOptions = function(rule, level, value) 
			if level == 1 then
				dewdrop:AddLine('text', L["Bag Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Bag"], 'hasArrow', true,'value',"Bag")
				dewdrop:AddLine('text', L["Ignore Empty Slots"], "checked", rule.noempty ,"func",function() rule.noempty = not rule.noempty Baggins:OnRuleChanged() end)	
			elseif level == 2 and value == "Bag" then
				dewdrop:AddLine('text', L["Backpack"], "checked", rule.bagid == 0,"func",function() rule.bagid = 0 Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', L["Bag1"], "checked", rule.bagid == 1,"func",function() rule.bagid = 1 Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', L["Bag2"], "checked", rule.bagid == 2,"func",function() rule.bagid = 2 Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', L["Bag3"], "checked", rule.bagid == 3,"func",function() rule.bagid = 3 Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', L["Bag4"], "checked", rule.bagid == 4,"func",function() rule.bagid = 4 Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', L["KeyRing"], "checked", rule.bagid == -2,"func",function() rule.bagid = -2 Baggins:OnRuleChanged() end)
			end
		end,
	},
	ItemName = {
		DisplayName = L["Item Name"],
		Description = L["Filter by Name or partial name"],	
		Matches = function(bag,slot,rule) 
			if not rule.match then return end
			local link = GetContainerItemLink(bag, slot)
			
			if link then
				local itemname = GetItemInfo(link)
				if itemname and itemname:lower():match(rule.match:lower()) then
					return true
				end
			end
		end,
		GetName = function(rule) 
			return L["Name: "]..(rule.match or "")
		end,
		DewDropOptions = function(rule, level, value) 
			if level == 1 then
				dewdrop:AddLine('text', L["Item Name Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["String to Match"], 'hasArrow', true,"hasEditBox",true,"editBoxText", rule.match or "","editBoxFunc", function(text) rule.match = text Baggins:OnRuleChanged() end )	
			end
		end,
	},
	Empty = {
		DisplayName = L["Empty Slots"],
		Description = L["Empty bag slots"],
		Matches = function(bag,slot,rule) 
			if not (bag and slot) then return end
			if BagTypes[bag] == 3 then return end
			local link = GetContainerItemLink(bag, slot)
			if not link then 
				return true 
			end
		end,
		GetName = function(rule) 
			return L["Empty Slots"]
		end,
		DewDropOptions = function(rule, level, value) 
		end,
	},
	NewItems = {
		DisplayName = L["New Items"],
		Description = L["New Items"],
		Matches = function(bag,slot,rule) 
			if not (bag and slot) then return end
			if BagTypes[bag] ~= 1 then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				return Baggins:IsNew(link)			
			end
		end,
		GetName = function(rule) 
			return L["New Items"]
		end,
		DewDropOptions = function(rule, level, value) 
		end,
	},
	Category = {
		DisplayName = L["Category"],
		Description = L["Items that match another category"],
		Matches = function(bag,slot,rule) 
			if not (bag and slot and rule.category) then return end
			local key = bag..":"..slot
			if BagTypes[bag] == 2 then
				return bankcategorycache[rule.category] and bankcategorycache[rule.category][key]
			else
				return categorycache[rule.category] and categorycache[rule.category][key]
			end
		end,
		GetName = function(rule) 
			if rule.category then
				return L["Category"].." :"..rule.category
			else
				return L["Category"]
			end
		end,
		DewDropOptions = function(rule, level, value) 
			if level == 1 then
				dewdrop:AddLine('text', L["Category Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Category"], 'hasArrow', true,'value',"Category")

			elseif level == 2 and value == "Category" then	
				for k, v in pairs(categories) do
					dewdrop:AddLine('text', k, "checked", rule.category == k,"func",function(v) rule.category = k Baggins:OnRuleChanged() end,"arg1",v)
				end
			end
		end,
	},
	AmmoBag = {
		DisplayName = L["Ammo Bag"],
		Description = L["Items in an ammo pouch or quiver"],
		Matches = function(bag,slot,rule) 
			if bag < 1 or bag > 4 then return end
			local link = GetInventoryItemLink("player",19+bag)
			if link then
				local Type = select(6, GetItemInfo(link))
				if Type then
					return Type == ITEMTYPE["Quiver"]
				end
			end
		end,
		GetName = function(rule) 
			return L["Ammo Bag Slots"]
		end,
		DewDropOptions = function(rule, level, value)
		end,
	},
	Quality = {
		DisplayName = L["Quality"],
		Description = L["Filter by Item Quality"],
		Matches = function(bag,slot,rule) 
			if not (rule.comp and rule.quality) then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local Rarity = select(3, GetItemInfo(link))
				if Rarity then
					return ( rule.comp == "==" and Rarity == rule.quality ) or
					       ( rule.comp == "<=" and Rarity <= rule.quality ) or
					       ( rule.comp == ">=" and Rarity >= rule.quality )
				end
			end
		end,
		GetName = function(rule) 
			if rule.quality then
				local r,g,b,hex = GetItemQualityColor(rule.quality)
				qualname = hex..QualityNames[rule.quality]
			else
				qualname = "*none*"
			end
			return L["Quality"].." "..(rule.comp or "==").." "..qualname
		end,
		DewDropOptions = function(rule, level, value)
			if level == 1 then
				dewdrop:AddLine('text', L["Quality Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Quality"], 'hasArrow', true,'value',"Quality")
				dewdrop:AddLine('text', L["Comparison"], 'hasArrow', true, 'value', "QualComp")
		
			elseif level == 2 and value == "Quality" then
				for i = 0, 6 do
					local r,g,b = GetItemQualityColor(i)
					dewdrop:AddLine('text', QualityNames[i], "checked", rule.quality == i,"func",function() rule.quality = i Baggins:OnRuleChanged() end,
									'textR',r,'textG',g,'textB',b)
				end
			elseif level == 2 and value == "QualComp" then		
				dewdrop:AddLine('text', "==", "checked", rule.comp == "==","func",function() rule.comp = "==" Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', "<=", "checked", rule.comp == "<=","func",function() rule.comp = "<=" Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', ">=", "checked", rule.comp == ">=","func",function() rule.comp = ">=" Baggins:OnRuleChanged() end)
			end
		end,
	},
	EquipLoc = {
		DisplayName = L["Equip Location"],
		Description = L["Filter by Equip Location as returned by GetItemInfo"],
		Matches = function(bag,slot,rule) 
			if not rule.equiploc then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local EquipLoc = select(9, GetItemInfo(link))
				if EquipLoc then
					return EquipLoc == rule.equiploc
				end
			end
		end,
		GetName = function(rule) 
			return "Equip Location: "..(getglobal(rule.equiploc) or rule.equiploc or "*None*")
		end,
		DewDropOptions = function(rule, level, value) 
			if level == 1 then
				dewdrop:AddLine('text', L["Equip Location Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Location"], 'hasArrow', true,'value',"Location")

			elseif level == 2 and value == "Location" then	
				for k, v in pairs(EquipLocs) do
					dewdrop:AddLine('text', getglobal(v) or v or "", "checked", rule.equiploc == v,"func",function(v) rule.equiploc = v Baggins:OnRuleChanged() end,"arg1",v)
				end
			end
		end,
	},
	ItemLevel = {
		DisplayName = L["Item Level"],
		Description = L["Filter by item's level - either \"ilvl\" or minimum required level"],
		Matches = function(bag,slot,rule)
			local link = GetContainerItemLink(bag, slot)
			if not link then return false end
			
			local _,_,_, itemLevel, itemMinLevel = GetItemInfo(link)
			local lvl = rule.useminlvl and itemMinLevel or itemLevel
			
			if rule.include0 and lvl==0 then
				return true
			end
			if rule.include1 and lvl==1 then
				return true
			end
			
			local minlvl = rule.minlvl or -999
			local maxlvl = rule.maxlvl or 999
			if rule.minlvl_rel then
				minlvl = UnitLevel("player")+minlvl
			end
			if rule.maxlvl_rel then
				maxlvl = UnitLevel("player")+maxlvl
			end
			
			return lvl>=minlvl and lvl<=maxlvl
		end,
		GetName = function(rule)
			local minlvl = rule.minlvl or -999
			local maxlvl = rule.maxlvl or 999
			if rule.minlvl_rel then
				minlvl = UnitLevel("player")+minlvl
			end
			if rule.maxlvl_rel then
				maxlvl = UnitLevel("player")+maxlvl
			end
			return (rule.useminlvl and L["ReqLvl"] or L["ILvl"]) .. ": " ..
				(rule.include0 and "0, " or "") ..
				(rule.include1 and "1, " or "") ..
				max(minlvl,0) .. "-" ..
				min(maxlvl,999);
		end,
		DewDropOptions = function(rule, level, value)
			if level==1 then
				dewdrop:AddLine('text', L["Item Level Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Include Level 0"], "checked", rule.include0, "func",
					function(b) rule.include0=not rule.include0; Baggins:OnRuleChanged() end);
				dewdrop:AddLine('text', L["Include Level 1"], "checked", rule.include1, "func",
					function(b) rule.include1=not rule.include1; Baggins:OnRuleChanged() end);
				dewdrop:AddLine('text', L["Look at Required Level"], "checked", rule.useminlvl, "func",
					function(b) rule.useminlvl=not rule.useminlvl; Baggins:OnRuleChanged() end);
				dewdrop:AddLine('text', L["Look at Item's \"ILvl\""], "checked", not rule.useminlvl, "func",
					function(b) rule.useminlvl=not rule.useminlvl; Baggins:OnRuleChanged() end);
				dewdrop:AddSeparator()
				dewdrop:AddLine('text', L["From level:"], "hasArrow", true, "hasEditBox", true, 
					"editBoxText", tonumber(rule.minlvl) or -15, "editBoxFunc",
					function(text) rule.minlvl = tonumber(text) or -15; Baggins:OnRuleChanged() end);
				dewdrop:AddLine('text', L["... plus Player's Level"], "checked", rule.minlvl_rel, "func",
					function(b) rule.minlvl_rel=not rule.minlvl_rel; Baggins:OnRuleChanged() end);
				dewdrop:AddSeparator()
				dewdrop:AddLine('text', L["To level:"], "hasArrow", true, "hasEditBox", true, 
					"editBoxText", tonumber(rule.maxlvl) or 999, "editBoxFunc",
					function(text) rule.maxlvl = tonumber(text) or 999; Baggins:OnRuleChanged() end);
				dewdrop:AddLine('text', L["... plus Player's Level"], "checked", rule.maxlvl_rel, "func",
					function(b) rule.maxlvl_rel=not rule.maxlvl_rel; Baggins:OnRuleChanged() end);
			end
		end,
		CleanRule = function(rule)
			rule.include0 = true
			rule.include1 = false
			rule.useminlvl = false
			rule.minlvl_rel = true
			rule.minlvl = -15
			rule.maxlvl_rel = true
			rule.maxlvl = 10
		end,
	},
	Other = {
		DisplayName = L["Unfiltered Items"],
		Description = L["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"],
		Matches = function(bag,slot,rule) 
			
			--local key = bag..":"..slot
			--return not useditems[key]
		end,
		GetName = function(rule) 
			return L["Unfiltered"]
		end,
		DewDropOptions = function(rule, level, value) 
			
		end,
	},
	Bind = {
		DisplayName = L["Bind"],
		Description = L["Filter based on if the item binds, or if it is already bound"],
		Matches = function(bag, slot, rule)
			if not rule.bindtype then return end
			if rule.bindtype == "Soulbound" then
				if bag == -1 then
					gratuity:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
				else
					gratuity:SetBagItem(bag,slot)
				end
				if gratuity:Find(ITEM_SOULBOUND,2,2,false,false,true) then
					return true
				end
			elseif rule.bindtype == "Unbound" then
				local link = GetContainerItemLink(bag,slot)
					if link then
					if bag == -1 then
						gratuity:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
					else
						gratuity:SetBagItem(bag,slot)
					end
					if not gratuity:Find(ITEM_SOULBOUND,2,2,false,false,true) then
						return true
					end
				end
			elseif rule.bindtype == "BoP" then
				local link = GetContainerItemLink(bag,slot)
				if link then
					gratuity:SetHyperlink(link)
					if gratuity:Find(ITEM_BIND_ON_PICKUP,2,2) then
						return true
					end
				end
			elseif rule.bindtype == "BoE" then
				local link = GetContainerItemLink(bag,slot)
				if link then
					gratuity:SetHyperlink(link)
					if gratuity:Find(ITEM_BIND_ON_EQUIP,2,2) then
						return true
					end
				end
			elseif rule.bindtype == "BoU" then
				local link = GetContainerItemLink(bag,slot,2,2)
				if link then
					gratuity:SetHyperlink(link)
					if gratuity:Find(ITEM_BIND_ON_USE,2,2) then
						return true
					end
				end
			end
		end,
		GetName = function(rule)
			if rule.bindtype == "Soulbound" then
				return ITEM_SOULBOUND
			elseif rule.bindtype == "Unbound" then
				return L["Unbound"]
			elseif rule.bindtype == "BoP" then
				return ITEM_BIND_ON_PICKUP
			elseif rule.bindtype == "BoE" then
				return ITEM_BIND_ON_EQUIP
			elseif rule.bindtype == "BoU" then
				return ITEM_BIND_ON_USE
			else
				return L["Bind *unset*"]
			end
		end,
		DewDropOptions = function(rule, level, value)
			if level == 1 then
				dewdrop:AddLine('text', L["Bind Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["Bind Type"], 'hasArrow', true,'value',"BindType")

			elseif level == 2 and value == "BindType" then	
				dewdrop:AddLine('text', ITEM_SOULBOUND, "checked", rule.bindtype == "Soulbound","func",function() rule.bindtype = "Soulbound" Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', L["Unbound"], "checked", rule.bindtype == "Unbound","func",function() rule.bindtype = "Unbound" Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', ITEM_BIND_ON_PICKUP, "checked", rule.bindtype == "BoP","func",function() rule.bindtype = "BoP" Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', ITEM_BIND_ON_EQUIP, "checked", rule.bindtype == "BoE","func",function() rule.bindtype = "BoE" Baggins:OnRuleChanged() end)
				dewdrop:AddLine('text', ITEM_BIND_ON_USE, "checked", rule.bindtype == "BoU","func",function() rule.bindtype = "BoU" Baggins:OnRuleChanged() end)
			end
		end,
	},
	Tooltip = {
		DisplayName = L["Tooltip"],
		Description = L["Filter based on text contained in its tooltip"],
		Matches = function(bag, slot, rule)
			if not rule.text then return end
			local text = rule.text
			--if the text is the name of a global string then match against that
			if text:upper() == text then
				local gtext = getglobal(rule.text)
				if type(gtext) == "string" then
					text = gtext
				end
			end
			if bag == -1 then
				gratuity:SetInventoryItem("player", BankButtonIDToInvSlotID(slot))
			else
				gratuity:SetBagItem(bag,slot)
			end
			if gratuity:Find(text) then
				return true
			end
		end,
		GetName = function(rule)
			return L["Tooltip"]..": "..(rule.text or "")
		end,
		DewDropOptions = function(rule, level, value)
			if level == 1 then
				dewdrop:AddLine('text', L["Tooltip Options"], 'isTitle', true)
				dewdrop:AddLine('text', L["String to Match"], 'hasArrow', true,"hasEditBox",true,"editBoxText", rule.text or "","editBoxFunc", function(text) rule.text = text Baggins:OnRuleChanged() end )	
			end
		end,
	}
}

if pt then
	RuleTypes.PTSet = {
		DisplayName = L["PeriodicTable Set"],
		Description = L["Filter by PeriodicTable Set"],	
		Matches = function(bag,slot,rule) 
			if not rule.setname then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local itemid = link:match("item:(%d+)")
				itemid = tonumber(itemid)
				return pt:ItemInSet(itemid,rule.setname)
			end
		end,
		GetName = function(rule) 
			return "PTSet:"..(rule.setname or "*none*")
		end,
		DewDropOptions = function(rule, level, value, value_1, value_2)
			Baggins:BuildPTSetTable()
			if level == 1 then
				dewdrop:AddLine('text', L["Periodic Table Set Options"], 'isTitle', true)
			end
			dewdrop:FeedAceOptionsTable(ptsets)
		end,
	}
end
local currentRule = nil
function Baggins:OpenRuleDewdrop(rule,...)
	if RuleTypes[rule.type] then
		currentRule = rule
		RuleTypes[rule.type].DewDropOptions(rule, ...)
	end
end

function Baggins:RuleTypeIterator()
	return pairs(RuleTypes)
end

function Baggins:GetRuleDesc(rule)
	if RuleTypes[rule.type] then
		return RuleTypes[rule.type].GetName(rule)
	else
		return format("(|cffff8080%s not loaded|r)", rule.type);
	end
end

function Baggins:IsSpecialBag(bag)
	if not bag then return end
	if type(bag) == "string" then bag = tonumber(bag) end
	local prefix = ""
	if bag == -1 then
		return "b"
	end
	if BagTypes[bag] == 2 then
		prefix = "b"
	end
	if BagTypes[bag] == 3 then
		return "k"
	end
	local link
	if bag >= 1 and bag <= 11 then
		link = GetInventoryItemLink("player",ContainerIDToInventoryID(bag))
	end
	if link then
		local Type, SubType = select(6, GetItemInfo(link))
		if Type == ITEMTYPE["Quiver"] then
			return prefix.."a"
		end
		if Type == ITEMTYPE["Container"] then
			if SubType == ITEMSUBTYPE["Bag"] then
			if prefix ~= "" then
				return prefix
			else
				return
			end
			end
			if SubType == ITEMSUBTYPE["Soul Bag"] then 
				return prefix.."s"
			end
			if SubType == ITEMSUBTYPE["Enchanting Bag"] then
				return prefix.."n"
			end
			if SubType == ITEMSUBTYPE["Engineering Bag"] then
				return prefix.."e"
			end
			if SubType == ITEMSUBTYPE["Herb Bag"] then
				return prefix.."h"
			end
			if SubType == ITEMSUBTYPE["Mining Bag"] then
				return prefix.."m"
			end
			if SubType == ITEMSUBTYPE["Gem Bag"] then
				return prefix.."g"
			end
			if SubType == ITEMSUBTYPE["Leatherworking Bag"] then
				return prefix.."l"
			end

		end
	end
	if prefix ~= "" then
		return prefix
	end
end

--------------------
-- Item Filtering --
--------------------
function Baggins:CheckSlotsChanged(bag, forceupdate)
	local slot
	local itemschanged
	for slot = 1, GetContainerNumSlots(bag) do
		local key = bag..":"..slot
		local iteminfo
		
		local link = GetContainerItemLink(bag, slot)
		local itemCount = select(2, GetContainerItemInfo(bag, slot))
		local itemid, itemName
		if link then
			itemid = link:match("item:(%d+)")
			itemName = GetItemInfo(link)
			iteminfo = itemid.." "..itemCount.." "..(itemName or "_")
		end
		
		if slotcache[key] ~= iteminfo or forceupdate then
			local olditemid = (slotcache[key] or ""):match("^(%d+)")
			if itemid ~= olditemid then
				itemschanged = true
			end
			slotcache[key] = iteminfo
			self:OnSlotChanged(bag, slot)
		end
	end
	return itemschanged
end

local categoriesrun = { [true] = {}, [false] = {}}
local recursionmagic = 12345


local function CheckCategory(catid, category, bag, slot, key, isbank, cache, used)
	if (categoriesrun[isbank][catid] or 0) == recursionmagic then return end
	categoriesrun[isbank][catid] = recursionmagic
	
	if not cache[catid] then
		cache[catid] = {}
	end
	local wasMatch = cache[catid][key]
	cache[catid][key] = nil
	local anymatch
	local catmatch = false
	cache[catid]["Other"] = nil
	for ruleid, rule in ipairs(category) do
		local rulematch
		if rule.type == "Other" then
			cache[catid]["Other"] = true
		else
			if rule.type == "Category" then
				if rule.category and categories[rule.category] then
					anymatch = (CheckCategory(rule.category,categories[rule.category], bag, slot, key, isbank, cache, used) and Baggins:CategoryInUse(rule.category, isbank)) or anymatch
				end
			end
			
			if ruleid == 1 then 
				operation = "OR"
			else
				operation = rule.operation or "OR"
			end
			rulematch = (RuleTypes[rule.type] and RuleTypes[rule.type].Matches(bag,slot,rule))
			if operation == "OR" then
				catmatch = catmatch or rulematch
			elseif operation == "AND" then
				catmatch = catmatch and rulematch
			elseif operation == "NOT" then
				catmatch = catmatch and (not rulematch)
			end
		end
	end

	
	if catmatch then
		cache[catid][key] = true
	end
	
	if not wasMatch and catmatch then
		Baggins:FireSignal("CategoryMatchAdded", catid, key, isbank)
	elseif wasMatch and not catmatch then
		Baggins:FireSignal("CategoryMatchRemoved", catid, key, isbank)
	elseif catmatch and wasMatch then
		Baggins:FireSignal("SlotMoved", catid, key, isbank)
	end
	
	return catmatch or anymatch
end

function Baggins:OnSlotChanged(bag, slot)
	recursionmagic = recursionmagic + 1
	local isbank
	local cache
	if BagTypes[bag] == 2 then
		used = bankuseditems
		cache = bankcategorycache
		isbank = true
	else
		used = useditems
		cache = categorycache
		isbank = false	-- nil ain't good enuf because of how :CategoryInUse treats nils
	end
	
	local key = bag..":"..slot
	if not used[key] then
		used[key] = false
	end
	local anymatch
	for catid, category in pairs(categories) do
		if self:CategoryInUse(catid, isbank) then
		--if true then
			anymatch = CheckCategory(catid, category, bag, slot, key, isbank, cache, used) or anymatch
		end
	end
	
		
	for catid, category in pairs(categories) do
		if cache[catid] and cache[catid]["Other"] then
			local wasMatch = cache[catid][key]
			local catmatch
			if not anymatch then
				cache[catid][key] = true
				catmatch = true
			else
				cache[catid][key] = nil
			end
			if not wasMatch and catmatch then
				self:FireSignal("CategoryMatchAdded", catid, key, isbank)
			elseif wasMatch and not catmatch then
				self:FireSignal("CategoryMatchRemoved", catid, key, isbank)
			elseif catmatch and wasMatch then
				self:FireSignal("SlotMoved", catid, key, isbank)
			end	
			cache[catid]["Other"] = nil			
		end
	end
	
end

function Baggins:OnRuleChanged()
	--self:ForceFullUpdate()
	currentRule = nil
	self:CategoriesChanged()
end

local function ClearCache(cache)
	for k, v in pairs(cache) do
		if type(v) == "table" then
			ClearCache(v)
		else
			cache[k] = nil
		end
	end
end

function Baggins:ClearSortingCaches()
	ClearCache(bankuseditems)
	ClearCache(bankcategorycache)
	ClearCache(useditems)
	ClearCache(categorycache)
	ClearCache(slotcache)
end
		
		
function Baggins:ForceFullRefresh()
	self:ClearSortingCaches()
	self:ClearSectionCaches()
	self:ForceFullUpdate()
end

function Baggins:ForceFullUpdate()
	--local start = GetTime()
	local bagid
	for bagid = 0, 11 do
		self:CheckSlotsChanged(bagid, true)
	end
	self:CheckSlotsChanged(-2,true)
	self:CheckSlotsChanged(-1,true)
	self:CategoriesChanged()
	--self:Print("Full Update took "..(math.floor((GetTime()-start)*1000)/1000).." seconds")
end

function Baggins:CategoriesChanged()
	self:TriggerEvent("Baggins_CategoriesChanged")
end

function Baggins:ForceFullBankUpdate()
	local bagid
	for bagid = 5, 11 do
		self:CheckSlotsChanged(bagid, true)
	end
	self:CheckSlotsChanged(-1,true)
end

function Baggins:GetIncludeRule(category,create)
	local numrules = #category
	for i = numrules,1,-1 do
		if category[i].type == "ItemID" then
			if category[i].operation ~= "NOT" then
				return category[i]
			end
		end		
	end
	if create then
		local newrule = { type="ItemID", operation="OR"}
		table.insert( category, newrule )
		return newrule
	end
end

function Baggins:GetExcludeRule(category,create)
	local numrules = #category
	for i = numrules,1,-1 do
		if category[i].type == "ItemID" then
			if category[i].operation == "NOT" then
				return category[i]
			end
		end
	end
	if create then
		local newrule = { type="ItemID", operation="NOT"}
		table.insert( category, newrule )
		return newrule
	end
end

function Baggins:IncludeItemInCategory(catname, itemid)
	local cat = categories[catname]
	if not cat then return end
	
	for i, rule in ipairs(cat) do
		if rule.ids and rule.operation == "NOT" then
			rule.ids[itemid] = nil
		end
	end
	local rule = self:GetIncludeRule(cat,true)
	if not rule.ids then
		rule.ids = {}
	end
	rule.ids[itemid] = true
	--tablet:Refresh("BagginsEditCategories")
	self:RefreshEditWaterfall() 
	self:ForceFullUpdate()
end

function Baggins:ExcludeItemFromCategory(catname, itemid)
	local cat = categories[catname]
	if not cat then return end
	
	for i, rule in ipairs(cat) do
		if rule.ids and rule.operation ~= "NOT" then
			rule.ids[itemid] = nil
		end
	end
	local rule = self:GetExcludeRule(cat,true)
	if not rule.ids then
		rule.ids = {}
	end
	rule.ids[itemid] = true
	--tablet:Refresh("BagginsEditCategories")
	self:RefreshEditWaterfall() 
	self:ForceFullUpdate()
end

function Baggins:GetRuleDefinition(rulename)
	return RuleTypes[rulename] 
end

function Baggins:GetCachedItem(item)
	return slotcache[item]
end
-----------------
-- Slot Counts --
-----------------
function Baggins:CountEmptySlots(bagtype)
	local bag, slot
	local count = 0
	if bagtype and bagtype:match("b") then
		return self:CountEmptyBankSlots(bagtype)
	end
	if bagtype == "k" then
		for slot = 1, GetContainerNumSlots(-2) do
			if not GetContainerItemLink(-2,slot) then
				count = count + 1
			end
		end
		return count
	end
	
	for bag = 0, 4 do
		if bagtype == self:IsSpecialBag(bag) or bagtype == "ALL" then
			for slot = 1, GetContainerNumSlots(bag) do
				if not GetContainerItemLink(bag,slot) then
					count = count + 1
				end
			end
		end
	end
	return count
end

function Baggins:CountSlots(bagtype)
	local bag, slot
	local count = 0
	if bagtype == "b" then
		return self:CountBankSlots()
	end
	if bagtype == "k" then
		for slot = 1, GetContainerNumSlots(-2) do
			count = count + 1
		end
		return count
	end
	
	for bag = 0, 4 do
		if bagtype == self:IsSpecialBag(bag) or bagtype == "ALL" then
			for slot = 1, GetContainerNumSlots(bag) do
				count = count + 1
			end
		end
	end
	return count
end

function Baggins:CountEmptyBankSlots(bagtype)
	local bag, slot
	local count = 0
	for bag = -1, 11 do
		if BagTypes[bag] == 2 and (bagtype == "b" or bagtype == self:IsSpecialBag(bag)) then
			for slot = 1, GetContainerNumSlots(bag) do
				if not GetContainerItemLink(bag,slot) then
					count = count + 1
				end
			end
		end
	end
	return count
end

function Baggins:CountBankSlots()
	local bag, slot
	local count = 0
	for bag = -1, 11 do
		if BagTypes[bag] == 2 then
			for slot = 1, GetContainerNumSlots(bag) do
				count = count + 1
			end
		end
	end
	return count
end

function Baggins:IsBankBag(bag)
	return BagTypes[bag] == 2
end

---------------------
-- PT Set Browser  --
---------------------
function Baggins:BuildPTSetTable()
	if not (pt and self.ptsetsdirty) then return end
	rdel(ptsets.args)
	ptsets.args = new()

	local sets = pt.sets

	for setname in pairs(sets) do
		local workingLevel = ptsets.args
		local oldLevel, oldParent, allowedFlag
		for parent in setname:gmatch("([^%.]+)") do
			if not workingLevel[parent] then
				workingLevel[parent] = new()
				workingLevel[parent].type = "group"
				workingLevel[parent].name = parent
				workingLevel[parent].desc = parent
				workingLevel[parent].args = new()
				allowedFlag = true
			else
				allowedFlag = false
			end
			for k, v in pairs(workingLevel) do
				local kname = k:match("0077ff([^%*]+)")
				if kname == parent then
					rdel(workingLevel[k])
					workingLevel[k] = nil
				end
			end

			oldLevel = workingLevel
			oldParent = parent
			workingLevel = workingLevel[parent].args
		end
		if allowedFlag then
			oldLevel[oldParent].name = oldLevel[oldParent].name
			oldLevel[oldParent].type = "execute"
			oldLevel[oldParent].func = function()
				currentRule.setname = setname
				self:OnRuleChanged()
			end
		end
	end

	local function addSelfSetToOptions(table, name)
		if table.args then
			for k, v in pairs(table.args) do
				local x = name
				if v.args then
					if x then
						x = x .. "." .. k
					else
						x = k
					end
					addSelfSetToOptions(v, x)
				end
			end
			table.args.spacer = new()
			table.args.spacer.type = "header"
			table.args.spacer.name = " "
			table.args.spacer.order = 999
			
			table.args.thisSet = new()
			table.args.thisSet.order = 1000
			table.args.thisSet.type = "execute"
			table.args.thisSet.name = name
			table.args.thisSet.desc = name
			table.args.thisSet.func = function()
				currentRule.setname = name
				self:OnRuleChanged()
			end
		end
	end

	addSelfSetToOptions(ptsets)
	rdel(ptsets.args.spacer)
	ptsets.args.spacer = nil
	rdel(ptsets.args.thisSet)
	ptsets.args.thisSet = nil
	self.ptsetsdirty = false
end




