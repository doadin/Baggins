local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):NewLocale("Baggins", "frFR")
if not L then return end

--[[ Ugly quite ASCII-safe translation table :)
   `a : \195\160    `e : \195\168    ^i : \195\174    ^o : \195\180   `u : \195\185
   'a : \195\161    'e : \195\169    ¨i : \195\175    ¨o : \195\182   ^u : \195\187
   ^a : \195\162    ^e : \195\170                     oe : \197\147   ¨u : \195\188
   ¨a : \195\164    ¨e : \195\171
   ae : \195\166

   ,c : \195\167
--]]

--itemtypes, these must match the Type and SubType returns from GetItemInfo for the ItemType rule to work
L["Armor"] = "Armure"
    L["Cloth"] = "Tissu"
    L["Idols"] = "Idoles"
    L["Leather"] = "Cuir"
    L["Librams"] = "Librams"
    L["Mail"] = "Mailles"
    L["Miscellaneous"] = "Divers"
    L["Shields"] = "Boucliers"
    L["Totems"] = "Totems"
    L["Plate"] = "Plaques"
L["Consumable"] = "Consommables"
L["Container"] = "Conteneur"
    L["Bag"] = "Conteneur"
    L["Enchanting Bag"] = "Sac d'enchanteur"
    L["Engineering Bag"] = "Sac d'ing\195\169nieur"
    L["Herb Bag"] = "Sac d'herbes"
    L["Soul Bag"] = "Sac d'\195\162me"
L["Key"] = "Cl\195\169"
L["Miscellaneous"] = "Divers"
    L["Junk"] = "Camelote"
L["Reagent"] = "Composant"
L["Recipe"] = "Recette"
    L["Alchemy"] = "Alchimie"
    L["Blacksmithing"] = "Forge"
    L["Book"] = "Livre"
    L["Cooking"] = "Cuisine"
    L["Enchanting"] = "Enchantement"
    L["Engineering"] = "Ing\195\169nierie"
    L["First Aid"] = "Secourisme"
    L["Leatherworking"] = "Travail du cuir"
    L["Tailoring"] = "Couture"
L["Projectile"] = "Projectile"
    L["Arrow"] = "Fl\195\168che"
    L["Bullet"] = "Balle"
L["Quest"] = "Qu\195\170te"
L["Quiver"] = "Carquois"
    L["Ammo Pouch"] = "Giberne"
    L["Quiver"] = "Carquois"
L["Trade Goods"] = "Artisanat"
    L["Devices"] = "Appareils"
    L["Explosives"] = "Explosifs"
    L["Parts"] = "El\195\169ments"
--      ["Gems"] = "Gemmes"
L["Weapon"] = "Arme"
    L["Bows"] = "Arcs"
    L["Crossbows"] = "Arbal\195\168tes"
    L["Daggers"] = "Dagues"
    L["Guns"] = "Fusils"
    L["Fishing Pole"] = "Canne \195\160 p\195\170che"
    L["Fist Weapons"] = "Armes de pugilat"
    L["Miscellaneous"] = "Divers"
    L["One-Handed Axes"] = "Haches \195\160 une main"
    L["One-Handed Maces"] = "Maces \195\160 une main"
    L["One-Handed Swords"] = "Ep\195\169es \195\160 une main"
    L["Polearms"] = "Armes d'hast"
    L["Staves"] = "B\195\162tons"
    L["Thrown"] = "Armes de jet"
    L["Two-Handed Axes"] = "Haches \195\160 deux mains"
    L["Two-Handed Maces"] = "Maces \195\160 deux mains"
    L["Two-Handed Swords"] = "Ep\195\169es \195\160 deux mains"
    L["Wands"] = "Baguettes"
--		--end of localizations needed for rules to work

--L["Baggins"] = true
L["Toggle All Bags"] = "Baculer tous les sacs"
L["Columns"] = "Colonnes"
L["Number of Columns shown in the bag frames"] = "Nombre de colonnes affich\195\169es dans les sacs"
L["Layout"] = "Disposition"
L["Layout of the bag frames."] = "Disposition des sacs"
L["Automatic"] = "Automatique"
L["Automatically arrange the bag frames as the default ui does"] = "Arrange automatiquement les sacs comme le fait Blizzard"
L["Manual"] = "Manuelle"
L["Each bag frame can be positioned manually."] = "Chaque sac peut \195\170tre positionn\195\169 manuellement."
L["Show Section Title"] = "Afficher les titres de section"
L["Show a title on each section of the bags"] = "Affiche un titre pour chaque section des sacs"
L["Sort"] = "Tri"
L["How items are sorted"] = "M\195\169thode de tri des objets"
L["Quality"] = "Qualit\195\169"
L["Items are sorted by quality."] = "Les objets sont tri\195\169s par qualit\195\169"
L["Name"] = "Nom"
L["Items are sorted by name."] = "Les objets sont tri\195\169s par nom."
L["Hide Empty Sections"] = "Cacher les sections vides"
L["Hide sections that have no items in them."] = "Cache les sections qui ne comportent aucun objet"
L["Hide Default Bank"] = "Cacher la banque originale"
L["Hide the default bank window."] = "Cache la fenêtre de banque originale."
L["FuBar Text"] = "Texte FuBar"
L["Options for the text shown on fubar"] = "Options du texte affich\195\169 dans FuBar"
L["Show empty bag slots"] = "Afficher l'espace libre"
L["Show used bag slots"] = "Afficher l'espace utilis\195\169"
L["Show Total bag slots"] = "Afficher l'espace total"
L["Combine Counts"] = "Comptes combin\195\169s"
L["Show only one count with all the seclected types included"] = "N'affiche qu'un seul compte combinant tous les types indiqu\195\169s"
L["Show Ammo Bags Count"] = "Compter les munitions"
L["Show Soul Bags Count"] = "Compter les fragments d'\195\162me"
L["Show Specialty Bags Count"] = "Compter le contenu des sacs de profession"
L["Show Specialty (profession etc) Bags Count"] = "Compte le contenu des sacs de profession"
L["Set Layout Bounds"]= "D\195\169finir les limites de placements"
L["Shows a frame you can drag and size to set where the bags will be placed when Layout is automatic"] =
            "Affiche un cadre mobile et redimensionnable pour indiquer o\195\185 les sacs seront plac\195\169s en mode automatique"
L["Lock"] = "Verrouiler les sacs"
L["Locks the bag frames making them unmovable"] = "Verrouiler les sacs qu'ils ne puissent plus \195\170tre d\195\169plac\195\169s"
L["Shrink Width"] = "R\195\169duire la largeur"
L["Shrink the bag's width to fit the items contained in them"] = "Adapte la largeur des sacs \195\160 leur contenu"
L["Compress"] = "Affichage compact"
L["Compress Multiple stacks into one item button"] = "Affiche toutes les piles d'un m\195\170me objet en un seul bouton"
L["Compress All"] = "Tout compacter"
L["Show all items as a single button with a count on it"] = "Regroupe tous les objets"
L["Compress Empty Slots"] = "Compacter les emplacements vides"
L["Show all empty slots as a single button with a count on it"] = "Regroupe les emplacements vides"
L["Compress Soul Shards"] = "Compacter les fragment d'\195\162mes"
L["Show all soul shards as a single button with a count on it"] = "Regroupe les fragments d'\195\162mes"
L["Compress Ammo"] = "Compacter les munitions"
L["Show all ammo as a single button with a count on it"] = "Regroupe les munitions"
L["Quality Colors"]= "Coloration par qualit\195\169"
L["Color item buttons based on the quality of the item"] = "Colore les boutons selon la qualit\195\169 des objets"
L["Enable"] = "Activer"
L["Enable quality coloring"] = "Activer la coloration par qualit\195\169"
L["Color Threshold"] = "Seuil de coloration"
L["Only color items of this quality or above"] = "Ne colore que les objets au-dessus de ce seuil"
L["Color Intensity"] = "Intensit\195\169 de coloration"
L["Intensity of the quality coloring"] = "Intensit\195\169 de la coloration par qualit\195\169"
L["Edit Bags"] = "Editer les sacs"
L["Edit the Bag Definitions"] = "Edite les d\195\169finitions des sacs"
L["Edit Categories"] = "Editer les cat\195\169gories"
L["Edit the Category Definitions"] = "Edite les d\195\169finitions des cat\195\169gories"
L["Load Profile"] = "Charger un profil"
L["Load a built-in profile: NOTE: ALL Custom Bags will be lost and any edited built in categories will be lost."] =
            "Charge un profil pr\195\169d\195\169fini. NOTE: TOUS les sacs personnalis\195\169s et cat\195\169gories modifi\195\169es seront perdus."
L["Default"] = "D\195\169faut"
L["A default set of bags sorting your inventory into categories"] = "Un ensemble de sacs par d\195\169faut, triant votre inventaire en cat\195\169gories"
L["All in one"] = "Tout en un"
L["A single bag containing your whole inventory, sorted by quality"] = "Un seul contenant tout l'inventaire, tri\195\169 par qualit\195\169"
L["Scale"] = "Echelle"
L["Scale of the bag frames"] = "Echelle d'affichage des sacs"
--		--bagtypes
L["Backpack"] = "Sac \195\160 dos"
L["Bag 1"] = "Sac n\194\1761"
L["Bag 2"] = "Sac n\194\1762"
L["Bag 3"] = "Sac n\194\1763"
L["Bag 4"] = "Sac n\194\1764"
L["Bag 5"] = "Sac n\194\1765"
L["Bank Frame"] = "Contenu de la banque"
L["Bank Bag 1"] = "Sac de banque n\194\1761"
L["Bank Bag 2"] = "Sac de banque n\194\1762"
L["Bank Bag 3"] = "Sac de banque n\194\1763"
L["Bank Bag 4"] = "Sac de banque n\194\1764"
L["Bank Bag 5"] = "Sac de banque n\194\1765"
L["Bank Bag 6"] = "Sac de banque n\194\1766"
L["Bank Bag 7"] = "Sac de banque n\194\1767"
L["Reagent Bank"] = true
L["KeyRing"] = "Trouseau de cl\195\169s"

        --qualoty names
L["Poor"] = "Mauvais"
L["Common"] = "Commun"
L["Uncommon"] = "Inhabituel"
L["Rare"] = "Rare"
L["Epic"] = "Epique"
L["Legendary"] = "L\195\169gendaire"
L["Artifact"] = "Artefact"

L["None"] = "Aucun"
L["All"] = "Tous"

L["Item Type"] = "Type d'objet"
L["Filter by Item type and sub-type as returned by GetItemInfo"] = "Filtre sur le type et sous-type d'objets"
L["ItemType - "] = "Type d'objet - "
L["Item Type Options"] = "Choix de types d'objet"
L["Item Subtype"] = "Sous-type d'objet"

L["Container Type"] = "Type de sac"
L["Filter by the type of container the item is in."] = "Filtre sur le type de contenant"
L["Container : "] = "Sac"
L["Container Type Options"] = "Choix de types de sacs"

L["Item ID"] = "Identifiants d'objets"
L["Filter by ItemID, this can be a space delimited list or ids to match."] =
            "Filter par identifiant d'objets; cela peut-\195\170tre une liste d'identifiants s\195\169par\195\169s par des espaces"
L["ItemIDs "] = "Identifiants "
L["ItemID Options"] = "Choix d'identifiants"
L["Item IDs (space seperated list)"] = "Indentifiants, s\195\169par\195\169s par des espaces"

L["Bag "] = "Sac "
L["Filter by the bag the item is in"] = "Filtre sur le sac contenant les objets"
L["Bag Options"] = "Choix de sacs"
L["Ignore Empty Slots"] = "Ignorer les emplacements vides"

L["Item Name"] = "Nom d'objet"
L["Filter by Name or partial name"] = "Filtre sur nom ou partie du nom"
L["Name: "] = "Nom: "
L["Item Name Options"] = "Choix du nom"
L["String to Match"] = "Cha\195\174ne \195\160 rechercher"

L["PeriodicTable Set"] = "Ensemble PeriodicTable"
L["Filter by PeriodicTable Set"] = "Filtre sur un ensemble 'PeriodicTable'"
L["Periodic Table Set Options"] = "Choix d'ensembles PeriodicTable"
L["Set"] = "Ensembe"

L["Empty Slots"] = "Espace vide"
L["Empty bag slots"] = "Emplacements de sac vides"

L["Ammo Bag"] = "Sac de munitions"
L["Items in an ammo pouch or quiver"] = "Objets dans un sac de munition"
L["Ammo Bag Slots"] = "Emplacements de sac de munition"

L["Quality"] = "Qualit\195\169"
L["Filter by Item Quality"] = "Filtre sur la qualit\195\169"
L["Quality Options"] = "Choix de qualit\195\169s"
L["Comparison"] = "Comparaison"

L["Location"] = "Place d'\195\169quipement"
L["Filter by Equip Location as returned by GetItemInfo"] =
            "Filtre sur l'emplacement qu'occupera l'objet sur votre personnage"
L["Equip Location"] = "Place d'\195\169quipement"
L["Equip Location Options"] = "Choix de places d'\195\169quipement"

L["Unfiltered Items"] = "Objets non-filtr\195\169s"
L["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"] =
            "Regroupe tous les items qui ne vont pas ailleurs. NOTE: cela doit \195\170tre la seule r\195\168gle de la cat\195\169gorie, les autres seront ignor\195\169es"
L["Unfiltered"] = "Non-filtr\195\169"

L["Bind"] = "Lien"
L["Filter based on if the item binds, or if it is already bound"] =
            "Filtre sur la fa\195\167on dont un objet est li\195\169 (ou pas)"
L["Bind *unset*"] = "Lien ind\195\169fini"
L["Unbound"] = "Non-li\195\169"
L["Bind Options"] = "Choix de type de liens"
L["Bind Type"] = "Type de lien"
        -- Globalstring ["Binds on pickup"] = "Li\195\169 quand ramass\195\169"
        -- Globalstring ["Binds on equip"] = "Li\195\169 quand \195\169quip\195\169"
        -- Globalstring ["Binds on use"] = "Li\195\169 quand utilis\195\169"

L["ItemID: "] = "Identifiant d'objet: "
L["Item Type: "] = "Type d'objet: "
L["Item Subtype: "] = "Sous-type d'objet: "

L["Click a bag to toggle it. Shift-click to move it up. Alt-click to move it down"] =
            "Cliquer sur un sac pour l'afficher/cacher. Shift+clic pour le remonter. Alt+clic pour le descendre."

L["Bags"] = "Sacs"
L["Options"] = "Options"
L["Open With All"] = "Ouvrir avec tous"
L["Bank"] = "Banque"
L["Sections"] = "Sections"
L["Categories"] = "Cat\195\169gories"
L["Add Category"] = "Ajouter une cat\195\169gorie"
L["New Section"] = "Nouvelle section"
L["New Bag"] = "Nouveau sac"
L["Close"] = "Fermer"
L["Click on an entry to open. Shift-Click to move up. Alt-Click to move down. Ctrl-Click to delete."] =
            "Cliquer sur une entr\195\169e pour l'ouvrir. Shift+clic pour monter. Alt+clic pour descendre. Ctrl+clic pour supprimer."
L["Rules"] = "R\195\168gles"
L["New Rule"] = "Nouvelle r\195\168gle"
L["Add Rule"] = "Ajouter une r\195\168gle"
L["New Category"] = "Nouvelle cat\195\169gorie"
L["Apply"] = "Appliquer"
L["Click on an entry to open. Ctrl-Click to delete."] = "Cliquer sur une entr\195\169e pour l'ouvrir. Ctrl+clic pour supprimer."

L["Editing Rule"] = "Edition de r\195\168gle"
L["Type"] = "Type"
L["Select a rule type to create the rule"] = "S\195\169lectionnez un type de r\195\168gle ou cr\195\169er une r\195\168gle"
L["Operation"] = "Operation"
L["AND"] = "ET"
L["OR"] = "OU"
L["NOT"] = "NON"

L["Baggins - New Bag"] = "Baggins - nouveau sac"
L["Baggins - New Section"] = "Baggins - nouvelle section"
L["Baggins - New Category"] = "Baggins - nouvelle cat\195\169gorie"
L["Accept"] = "Accepter"
L["Cancel"] = "Annuler"

L["Are you sure you want to delete this Bag? this cannot be undone"] =
            "Etes-vous s\195\187r de vouloir supprimer ce sac ? Il est impossible d'annuler"
L["Are you sure you want to delete this Section? this cannot be undone"] =
            "Etes-vous s\195\187r de vouloir supprimer cette section ? Il est impossible d'annuler"
L["Are you sure you want to remove this Category? this cannot be undone"] =
            "Etes-vous s\195\187r de vouloir supprimer cette cat\195\169gorie ? Il est impossible d'annuler"
L["Are you sure you want to remove this Rule? this cannot be undone"] =
            "Etes-vous s\195\187r de vouloir supprimer cette r\195\168gle ? Il est impossible d'annuler"
L["Delete"] = "Supprimer"
--L["Cancel"] = true, -- Duplciate

L["That category is in use by one or more bags, you cannot delete it."] =
            "Cette cat\195\169gorie est utilis\195\169 par un ou plusieurs sacs, vous ne pouvez pas la supprimer"
L["A category with that name already exists."] =
            "Une cat\195\169gorie avec ce nom existe d\195\169j\195\160"

L["Drag to Move\nRight-Click to Close"] = "Tirer pour d\195\169placer\nClic droit pour fermer"
L["Drag to Size"] = "Tirer pour dimensionner"

L["Previous "] = "Pr\195\169cedent "
L["Next "] = "Suivant "

--L["All In One"] = true, -- Duplicate
L["Bank All In One"] = "Banque tout-en-un"
L["Bank Bags"] = "Sacs de banque"

L["Equipment"] = "Equipement"
L["Weapons"] = "Armes"
L["Quest Items"] = "Objets de qu\195\170te"
L["Consumables"] = "Consommables"
L["Water"] = "Boisson"
L["Food"] = "Nourriture"
L["FirstAid"] = "Secourisme"
L["Potions"] = "Potions"
L["Scrolls"] = "Parchemins"
L["Misc"] = "Divers"
L["Misc Consumables"] = "Consommables divers"

L["Mats"] = "Mat\195\169riaux"
L["Tradeskill Mats"] = "Mat\195\169riaux d'artisanat"
L["Gathered"] = "R\195\169colte"
L["BankBags"] = "Sacs de banque"
L["Ammo"] = "Munition"
L["AmmoBag"] = "Sac de munition"
L["SoulShards"] = "Fragments d'\195\162mes"
L["SoulBag"] = "Sac de Fragments d'\195\162mes"
L["Other"] = "Autre"
L["Trash"] = "Camelote"
L["TrashEquip"] = "Camelote - \195\169quipement"
L["Empty"] = "Vide"
L["Bank Equipment"] = "Banque - \195\169quipement"
L["Bank Quest"] = "Banque - objets de qu\195\170te"
L["Bank Consumables"] = "Banque - consommables"
L["Bank Trade Goods"] = "Banque - Artisanat"
L["Bank Other"] = "Banque - divers"

L["Highlight New Items"] = "Indiquer les nouveaux objets"
L["Add *New* to new items, *+++* to items that you have gained more of."] =
            "Ajoute *N* sur les nouveaux objets et *+++* sur ceux dont vous avez gagn\195\169 de nouveaux exemplaires."
L["Reset New Items"] = "R\195\160Z noveaux objets"
L["Resets the new items highlights."] = "Remets \195\160 z\195\169ro les indicateurs de nouveaux objets."
L["*New*"] = "*N*"

L["Add To Category"] = "Ajouter \195\160 une cat\195\169gorie"
L["Exclude From Category"] = "Exclure d'une cat\195\169gorie"
L["Item Info"] = "Informations"
L["Quality: "] = "Qualit\195\169: "
L["Item Level: "] = "Niveau: "
L["Required Level: "] = "Niveau requis: "
L["Stack Size: "] = "Taille de pile: "
L["Equip Location: "] = ""
L["Periodic Table Sets"] = ""

L["Hide Duplicate Items"] = "Cacher les doublons"
L["Prevents items from appearing in more than one section/bag."] =
            "Evite d'afficher les m\195\170mes objets dans plus d'un(e) section/sac."

L["Optimize Section Layout"] = "Optimiser la disposition des sections"
L["Change order and layout of sections in order to save display space."] =
            "Change l'ordre et la disposition des sections pour \195\169conomiser l'espace d'affichage"

L["Show Bank Controls On Bag"] = true
L["Which Bag to Show Bank Controls On"] = true

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
