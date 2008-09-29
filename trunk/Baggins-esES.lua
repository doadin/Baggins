local L = AceLibrary("AceLocale-2.2"):new("Baggins")


L:RegisterTranslations("esES", function()
	return {
		--itemtypes, these must match the Type and SubType returns from GetItemInfo for the ItemType rule to work
		["Armor"] = "Armadura",
			["Cloth"] = "Tela",
			["Idols"] = "Ídolos",
			["Leather"] = "Cuero",
			["Librams"] = "Tratados",
			["Mail"] = "Malla",
			["Miscellaneous"] = "Misceláneo",
			["Shields"] = "Escudos",
			["Totems"] = "Tótems",
			["Plate"] = "Placas",
		["Consumable"] = "Consumible",
		["Container"] = "Contenedor",
			["Bag"] = "Bolsa",
			["Enchanting Bag"] = "Bolsa de encantamiento",
			["Engineering Bag"] = "Bolsa de ingeniería",
			["Herb Bag"] = "Bolsa de hierbas",
			["Soul Bag"] = "Bolsa de almas",
		["Key"] = "Llave",
		["Miscellaneous"] = "Misceláneo",
			["Junk"] = "Basura",
		["Reagent"] = "Componente",
		["Recipe"] = "Receta",
			["Alchemy"] = "Alquimia",
			["Blacksmithing"] = "Herrería",
			["Book"] = "Libro",
			["Cooking"] = "Cocina",
			["Enchanting"] = "Encantamiento",
			["Engineering"] = "Ingeniería",
			["First Aid"] = "Primeros auxilios",
			["Leatherworking"] = "Peletería",
			["Tailoring"] = "Sastrería",
		["Projectile"] = "Proyectil",
			["Arrow"] = "Flecha",
			["Bullet"] = "Bala",
		["Quest"] = "Misión",
		["Quiver"] = "Carcaj",
			["Ammo Pouch"] = "Bolsa de munición",
			["Quiver"] = "Carcaj",
		["Trade Goods"] = "Objeto comerciable",
			["Devices"] = "Aparatos",
			["Explosives"] = "Explosivos",
			["Parts"] = "Partes",
			["Gems"] = "Gemas",
		["Weapon"] = "Arma",
			["Bows"] = "Arcos",
			["Crossbows"] = "Ballestas",
			["Daggers"] = "Dagas",
			["Guns"] = "Armas de fuego",
			["Fishing Pole"] = "Cañas de pescar",
			["Fist Weapons"] = "Armas de puño",
			["Miscellaneous"] = "Miscelánea",
			["One-Handed Axes"] = "Hachas de una mano",
			["One-Handed Maces"] = "Mazas de una mano",
			["One-Handed Swords"] = "Espadas de una mano",
			["Polearms"] = "Armas de asta",
			["Staves"] = "Bastones",
			["Thrown"] = "Armas arrojadizas",
			["Two-Handed Axes"] = "Hachas de dos manos",
			["Two-Handed Maces"] = "Mazas de dos manos",
			["Two-Handed Swords"] = "Espadas de dos manos",
			["Wands"] = "Varitas",
		--end of localizations needed for rules to work	
		
	
		["Baggins"] = "Baggins",
		["Toggle All Bags"] = "Activar todas las bolsas",
		["Columns"] = "Columnas",
		["Number of Columns shown in the bag frames"] = "Número de columnas mostradas en la ventana de bolsas",
		["Layout"] = "Diseño",
		["Layout of the bag frames."] = "Diseño de la ventana de bolsas.",
		["Automatic"] = "Automático",
		["Automatically arrange the bag frames as the default ui does"] = "Ordenar automáticamente la ventana de bolsas como hace la UI por defecto",
		["Manual"] = "Manual",
		["Each bag frame can be positioned manually."] = "Cada ventana de bolsa puede ser posicionada manualmente.",
		["Show Section Title"] = "Mostrar título de sección",
		["Show a title on each section of the bags"] = "Mostrar un título en cada sección de las bolsas",
		["Sort"] = "Ordenar",
		["How items are sorted"] = "Cómo se ordenan los objetos",
		["Quality"] = "Calidad",
		["Items are sorted by quality."] = "Los objetos son ordenados según su calidad.",
		["Name"] = "Nombre",
		["Items are sorted by name."] = "Los objetos son ordenados según sunombre.",
		["Hide Empty Sections"] = "Esconder secciones vacías",
		["Hide sections that have no items in them."] = "Esconde secciones que no tienen objetos en ellas.",
		["Hide Default Bank"] = "Esconder el banco por defecto",
		["Hide the default bank window."] = "Esconde la ventana de banco por defecto",
		["FuBar Text"] = "Texto FuBar",
		["Options for the text shown on fubar"] = "Opciones para el texto mostrado en fubar",
		["Show empty bag slots"] = "Mostrar el número de huecos vacíos en bolsas",
		["Show used bag slots"] = "Mostrar el número de huecos usados en bolsas",
		["Show Total bag slots"] = "Mostrar el número de huecos totales en bolsas",
		["Combine Counts"] = "Combinar cuentas",
		["Show only one count with all the seclected types included"] = "Muestra una sola cuenta con todos los tipos seleccionados incluidos",
		["Show Ammo Bags Count"] = "Mostrar cuenta de munición",
		["Show Soul Bags Count"] = "Mostrar cuenta de almas",
		["Show Specialty Bags Count"] = "Mostrar la cuenta de bolsas especializadas",
		["Show Specialty (profession etc) Bags Count"] = "Mostrar la cuenta de bolsas especializadas (profesión etc)",
		["Set Layout Bounds"]= "Marcar límites al diseño",
		["Shows a frame you can drag and size to set where the bags will be placed when Layout is automatic"] = "Muestra una ventana que puedes arrastrar y cambiar de tamaño para elegir donde se mostrarán las bolsas cuando el Diseño sea automático",
		["Lock"] = "Bloquear",
		["Locks the bag frames making them unmovable"] = "Bloquea la ventana de bolsas para hacerlas inamovibles",
		["Shrink Width"] = "Estrechar anchura",
		["Shrink the bag's width to fit the items contained in them"] = "Estrecha el ancho de la bolsa para que encajen los objetos contenidos en ella",
		["Compress"] = "Comprimir",
		["Compress Multiple stacks into one item button"] = "Comprimir varias pilas en un solo botón para el objeto",
		["Compress All"] = "Comprimir todo",
		["Show all items as a single button with a count on it"] = "Muestra todos los objetos en un único botón con su cuenta en él",
		["Compress Empty Slots"] = "Comprimir huecos vacíos",
		["Show all empty slots as a single button with a count on it"] = "Muestra todos los huecos vacios en un único botón con su cuenta en él",
		["Compress Soul Shards"] = "Comprimir gemas de almas",
		["Show all soul shards as a single button with a count on it"] = "Muestra todas las gemas de almas en un único botón con su cuenta en él",
		["Compress Ammo"] = "Comprimir munición",
		["Show all ammo as a single button with a count on it"] = "Muestra toda la munición en un único botón con su cuenta en él",
		["Quality Colors"]= "Colorear calidad",
		["Color item buttons based on the quality of the item"] = "Colorea los botones de los objetos según su calidad como objeto",
		["Enable"] = "Activar",
		["Enable quality coloring"] = "Activar coloreado por calidad",
		["Color Threshold"] = "Umbral del color",
		["Only color items of this quality or above"] = "Colorea solo objetos de esta calidad o superior",
		["Color Intensity"] = "Intensidad del color",
		["Intensity of the quality coloring"] = "Intensidad del coloreado por calidad",
		["Edit Bags"] = "Editar bolsas",
		["Edit the Bag Definitions"] = "Editar definiciones de bolsa",
		["Edit Categories"] = "Editar categorías",
		["Edit the Category Definitions"] = "Editar definiciones de categoría",
		["Load Profile"] = "Cargar perfil",
		["Load a built-in profile: NOTE: ALL Custom Bags will be lost and any edited built in categories will be lost."] = "Carga un perfil incorporado. NOTA: TODAS las bolsas personalizadas se perderán y cualquier categoría editada se perderá.",
		["Default"] = "Por defecto",
		["A default set of bags sorting your inventory into categories"] = "Un conjunto de bolsas ordenan tu inventario en categorías",
		["All in one"] = "Todo en uno",
		["A single bag containing your whole inventory, sorted by quality"] = "Una sola bolsa contiene todo tu inventario, ordenado por calidad",
		["Scale"] = "Escalar",
		["Scale of the bag frames"] = "Escalado de la ventana de bolsas",
		--bagtypes
		["Backpack"] = "Mochila",
		["Bag1"] = "Bolsa1",
		["Bag2"] = "Bolsa2",
		["Bag3"] = "Bolsa3",
		["Bag4"] = "Bolsa4",
		["Bank Frame"] = "Ventana de banco",
		["Bank Bag1"] = "Bolsa de banco1",
		["Bank Bag2"] = "Bolsa de banco2",
		["Bank Bag3"] = "Bolsa de banco3",
		["Bank Bag4"] = "Bolsa de banco4",
		["Bank Bag5"] = "Bolsa de banco5",
		["Bank Bag6"] = "Bolsa de banco6",
		["Bank Bag7"] = "Bolsa de banco7",
		["KeyRing"] = "Llavero",
		
		--qualoty names
		["Poor"] = "Pobre",
		["Common"] = "Común",
		["Uncommon"] = "No Común",
		["Rare"] = "Raro",
		["Epic"] = "Épico",
		["Legendary"] = "Legendario",
		["Artifact"] = "Artefacto",
		
		["None"] = "Ninguno",
		["All"] = "Todo",
		
		["Item Type"] = "Tipo de objeto",
		["Filter by Item type and sub-type as returned by GetItemInfo"] = "Filtra por tipo de objeto y subtipo según devuelve GetItemInfo",
		["ItemType - "] = "Tipo de objeto - ",
		["Item Type Options"] = "Opciones de tipo de objeto",
		["Item Subtype"] = "Subtipo de objeto",

		["Container Type"] = "Tipo de contenedor",
		["Filter by the type of container the item is in."] = "Filtra según el tipo de contenedor en el que se aloja el objeto",
		["Container : "] = "Contenedor: ",
		["Container Type Options"] = "Opciones de tipo de contenedor",

		["Item ID"] = "ID Objeto",
		["Filter by ItemID, this can be a space delimited list or ids to match."] = "Filtra por ID Objeto, puede ser una lista separada por espacios o ids que concuerden.",
		["ItemIDs "] = "IDs de Objeto ",
		["ItemID Options"] = "Opciones de ID de objeto",
		["Item IDs (space seperated list)"] = "IDs de objeto (lista separada por espacios)",
		["New"] = "Nuevo",
		["Current IDs, click to remove"] = "IDs actuales, clic para eliminar",
		
		["Filter by the bag the item is in"] = "Filtra según la bolsa en la que se aloja el objeto",
		["Bag "] = "Bolsa ",
		["Bag Options"] = "Opciones de bolsa",
		["Ignore Empty Slots"] = "Ignorar huecos vacíos",
		
		["Item Name"] = "Nombre del objeto",
		["Filter by Name or partial name"] = "Filtrar por nombre o nombre parcial",
		["Name: "] = "Nombre: ",
		["Item Name Options"] = "Opciones de nombre de objeto",
		["String to Match"] = "Nombre a concordar",
		
		["PeriodicTable Set"] = "Conjunto PeriodicTable",
		["Filter by PeriodicTable Set"] = "Filtrar por conjunto PeriodicTable",
		["Periodic Table Set Options"] = "Opciones de conjunto PeriodicTable",
		["Set"] = "Conjunto",
		
		["Empty Slots"] = "Huecos vacíos",
		["Empty bag slots"] = "Huecos vacíos en bolsas",
		
		["Ammo Bag"] = "Bolsa de munición",
		["Items in an ammo pouch or quiver"] = "Objetos en bolsa de munición o carcaj",
		["Ammo Bag Slots"] = "Huecos de bolsa de munición",
		
		["Quality"] = "Calidad",
		["Filter by Item Quality"] = "Filtrar por calidad de objeto",
		["Quality Options"] = "Opciones de calidad",
		["Comparison"] = "Comparación",
		
		["Equip Location"] = "Localización del equipo",
		["Filter by Equip Location as returned by GetItemInfo"] = "Filtrar por localización de equipo según devuelve GetItemInfo",
		
		["Equip Location Options"] = "Opciones de licalización de equipo",
		["Location"] = "Localización",
		
		["Unfiltered Items"] = "Objetos sin filtrar",
		["Matches all items that arent matched by any other bag, NOTE: this should be the only rule in a category, others will be ignored"] = "Muestra todos los objetos que no aparecerán en ninguna de las otras bolsas, NOTA: ésta debería ser la única regla en una categoría, las otras serán ignoradas",
		["Unfiltered"] = "Sin filtrar",
		
		["Bind"] = "Ligar",
		["Filter based on if the item binds, or if it is already bound"] = "Filtra según como se liga el objeto, o si ya está ligado",
		["Bind *unset*"] = "Ligado *sin poner*",
		["Unbound"] = "Sin ligar",
		["Bind Options"] = "Opciones de ligado",
		["Bind Type"] = "Tipo de ligado",
		["Binds on pickup"] = "Se liga al recogerlo",
		["Binds on equip"] = "Se liga al equiparlo",
		["Binds on use"] = "Se liga al usarlo",
		["Soulbound"] = "Ligado",

		["Tooltip"] = "Tooltip",
		["Filter based on text contained in its tooltip"] = "Filtrar según el texto contenido en su tooltip",
		["Tooltip Options"] = "Opciones de tooltip",
		
		["ItemID: "] = "ID objeto: ",
		["Item Type: "] = "Tipo de objeto: ",
		["Item Subtype: "] = "Subtipo de objeto",
		
		["Click a bag to toggle it. Shift-click to move it up. Alt-click to move it down"] = "Clic en una bolsa para (des)activarla. Mayús-Clic para desplazarla hacia arriba. Alt-Clic para desplazarla hacia abajo",
		
		["Bags"] = "Bolsas",
		["Options"] = "Opciones",
		["Open With All"] = "Abrir con todo",
		["Bank"] = "Banco",
		["Sections"] = "Secciones",
		["Categories"] = "Categorías",
		["Add Category"] = "Añadir categoría",
		["New Section"] = "Nueva sección",
		["New Bag"] = "Nueva bolsa",
		["Close"] = "Cerrar",
		["Click on an entry to open. Shift-Click to move up. Alt-Click to move down. Ctrl-Click to delete."] = "Clic en una entrada para abrir. Mayús-Clic para desplazarla hacia arriba. Alt-Clic para desplazarla hacia abajo. Ctrl-Clic para eliminar.",
		["Rules"] = "Reglas",
		["New Rule"] = "Nueva regla",
		["Add Rule"] = "Añadir regla",
		["New Category"] = "Nueva categoría",
		["Apply"] = "Aplicar",
		["Click on an entry to open. Ctrl-Click to delete."] = "Clic en una entrada para abrir. Ctrl-Clic para borrar.",
		
		["Editing Rule"] = "Editando regla",
		["Type"] = "Tipo",
		["Select a rule type to create the rule"] = "Selecciona un tipo de regla para crear la regla",
		["Operation"] = "Operación",
		["AND"] = "Y",
		["OR"] = "O",
		["NOT"] = "NO",
		
		["Baggins - New Bag"] = "Baggins - Nueva Bolsa",
		["Baggins - New Section"] = "Baggins - Nueva Sección",
		["Baggins - New Category"] = "Baggins - Nueva Categoría",
		["Accept"] = "Aceptar",
		["Cancel"] = "Cancelar",
		
		["Are you sure you want to delete this Bag? this cannot be undone"] = "¿Estás seguro de que quieres borrar esta Bolsa? Esta acción no puede deshacerse",
		["Are you sure you want to delete this Section? this cannot be undone"] = "¿Estás seguro de que quieres borrar esta Sección? Esta acción no puede deshacerse",
		["Are you sure you want to remove this Category? this cannot be undone"] = "¿Estás seguro de que quieres eliminar esta Categoría? Esta acción no puede deshacerse",
		["Are you sure you want to remove this Rule? this cannot be undone"] = "¿Estás seguro de que quieres eliminar esta Regla? Esta acción no puede deshacerse",
		["Delete"] = "Eliminar",
		["Cancel"] = "Cancelar",
		
		["That category is in use by one or more bags, you cannot delete it."] = "Esa categoría está en uso por una o más bolsas, no puedes eliminarla.",
		["A category with that name already exists."] = "Ya existe una categoría con ese nombre.",
		
		["Drag to Move\nRight-Click to Close"] = "Arrastra para mover\nClic derecho para cerrar",
		["Drag to Size"] = "Arrastra para tamaño",
		
		["Previous "] = "Anterior ",
		["Next "] = "Siguiente ",
		
		["All In One"] = "Todo en uno",
		["Bank All In One"] = "Banco todo en uno",
		["Bank Bags"] = "Bolsas del banco",
		
		["Equipment"] = "Equipo",
		["Weapons"] = "Armas",
		["Quest Items"] = "Objetos de misión",
		["Consumables"] = "Consumibles",
		["Water"] = "Agua",
		["Food"] = "Comida",
		["FirstAid"] = "Primeros auxílios",
		["Potions"] = "Pociones",
		["Scrolls"] = "Pergaminos",
		["Misc"] = "Miscelánea",
		["Misc Consumables"] = "Otros consumibles",

		["Mats"] = "Materiales",
		["Tradeskill Mats"] = "Materiales de profesiones",
		["Gathered"] = "Recogidos",
		["BankBags"] = "Bolsas de banco",
		["Ammo"] = "Munición",
		["AmmoBag"] = "Bolsa de munición",
		["SoulShards"] = "Gemas de Almas",
		["SoulBag"] = "Bolsa de Almas",
		["Other"] = "Otros",
		["Trash"] = "Basura",
		["TrashEquip"] = "Equipo Basura",
		["Empty"] = "Vacío",
		["Bank Equipment"] = "Equipo en Banco",
		["Bank Quest"] = "Misión en Banco",
		["Bank Consumables"] = "Consumibles en Banco",
		["Bank Trade Goods"] = "Objetos comerciales en Banco",
		["Bank Other"] = "Otros en Banco",
		
		["Add To Category"] = "Añadir a categoría",
		["Exclude From Category"] = "Excluir de categoría",
		["Item Info"] = "Información del objeto",
		["Use"] = "Usar",
			["Use/equip the item rather than bank/sell it"] = "Usar/equipar el objeto en vez de banco/venderlo",
		["Quality: "] = "Calidad: ",
		["Level: "] = "Nivel: ",
		["MinLevel: "] = "Niv. mínimo: ",
		["Stack Size: "] = "Tamaño de pila: ",
		["Equip Location: "] = "Localización de Equipo: ",
		["Periodic Table Sets"] = "Conjuntos de PeriodicTable",
		
		["Highlight New Items"] = "Resaltar objetos nuevos",
		["Add *New* to new items, *+++* to items that you have gained more of."] = "Añade *Nuevo* a los objetos nuevos, *+++* a los objetos que han aumentado su número.",
		["Reset New Items"] = "Reiniciar objetos nuevos",
		["Resets the new items highlights."] = "Reinicia los resaltados sobre los objetos nuevos.",
		["*New*"] = "*Nuevo*",
		
		["Hide Duplicate Items"] = "Esconder objetos duplicados",
		["Prevents items from appearing in more than one section/bag."] = "Previene que los objetos aparezcan en más de una sección/bolsa.",
		
		["Optimize Section Layout"] = "Optimizar el diseño de sección",
		["Change order and layout of sections in order to save display space."] = "Cambia el orden y diseño de las secciones para ahorrar espacio en pantalla.",
		
		["All In One Sorted"]= "Todo en uno ordenado",
		["A single bag containing your whole inventory, sorted into categories"]= "Una sola bolsa conteniendo todo tu inventario, ordenado por categorías",
		
		["Compress Stackable Items"]= "Comprime objetos apilables",
		["Show stackable items as a single button with a count on it"]= "Muestra los objetos apilables como un solo botón con una cuenta en él",

		["Appearance and layout"]= "Apariencia y diseño",
		["Bags"]= "Bolsas",
		["Bag display and layout settings"]= "Opciones de pantalla y diseño de bolsas",
		["Layout Type"]= "Tipo de diseño",
		["Sets how all bags are laid out on screen."]= "Determina cómo se mostrarán todas las bolsas en pantalla.",
		["Shrink bag title"]= "Encoger título de bolsa",
		["Mangle bag title to fit to content width"]= "Reduce el título de la bolsa para encajar al ancho del contenido",
		["Sections"]= "Secciones",
		["Bag sections display and layout settings."]= "Opciones de pantalla y diseño de las secciones de bolsas",
		["Items"]= "Objetos",
		["Item display settings"]= "Opciones de pantalla de objetos",
		["Bag Skin"]= "Piel de la bolsa",
		["Select bag skin"]= "Selecciona piel de la bolsa",
		
		["Compress bag contents"]= "Comprimir contenido de bolsa",
		["Split %d"]= "Separar %d",
		["Split_tooltip"] = "Clic para separar objetos según la barra deslizadora\ny automáticamente colocar en un hueco vacío.",
		
		["PT3 LoD Modules"] = "Módulos PT3 LoD",
		["Choose PT3 LoD Modules to load at startup, Will load immediately when checked"] = "Elige Módulos PT3 LoD para cargar al inicio, Cargarán inmediatamente cuando se marque",
		["Load %s at Startup"] = "Cargar %s al inicio",
		
		["Disable Compression Temporarily"] = "Deshabilitar compresión temporalmente",
		["Disabled Item Compression until the bags are closed."] = "Compresión de objetos deshabilitada hasta que se cierren las bolsas.",
		
		["Always Resort"] = "Reordenar siempre",
		["Keeps Items sorted always, this will cause items to jump around when selling etc."] = "Mantiene siempre los objetos ordenados, esto causará que los objetos 'salten' al vender etc.",
		
		["Force Full Refresh"] = "Forzar refresco total",
		["Forces a Full Refresh of item sorting"] = "Fuerza un refresco total respecto a la ordenación de objetos",
		
		["Override Default Bags"] = "Anular bolsas por defecto",
		["Baggins will open instead of the default bags"] = "Baggins se abrirá en lugar de las bolsas por defecto",
		["Sort New First"] = "Ordena *nuevos* primero",
		["Sorts New Items to the beginning of sections"] = "Coloca los objetos nuevos al principio de las secciones",
		["New Items"] = "Nuevos objetos",
		
		["Items that match another category"] = "Objetos que coinciden en otra categoría",
		["Category Options"] = "Opciones de categoría",
		["Category"] = "Categoría",
		
		["Layout Anchor"] = "Anclar diseño",
		["Sets which corner of the layout bounds the bags will be anchored to."] = "Determina a que esquina de la pantalla se anclarán de las bolsas",
		["Top Right"] = "Arriba a la derecha",
		["Top Left"] = "Arriba a la izquierda",
		["Bottom Right"] = "Abajo a la derecha",
		["Bottom Left"] = "Abajo a la izquierda",
		
		["Show Money On Bag"] = "Mostrar dinero en bolsa",
		["Which Bag to Show Money On"] = "En qué bolsa mostrar el dinero",
		
		["User Defined"] = "Definido por usuario",
		["Load a User Defined Profile"] = "Carga un perfil definido por usuario",
		["Save Profile"] = "Salvar perfil",
		["Save a User Defined Profile"] = "Guarda un perfil definido por usuario",
		["New"] = "Nuevo",
		["Create a new Profile"] = "Crear un nuevo perfil",
		["Delete Profile"] = "Borrar perfil",
		["Delete a User Defined Profile"] = "Borra un perfil definido por usuario",
		["Save"] = "Guardar",
		["Load"] = "Cargar",
		["Delete"] = "Borrar",
		
		["Config Window"] = "Ventana de configuración",
		["Opens the Waterfall Config window"] = "Abre la ventana de Cascada de configuración",
		["Bag/Category Config"] = "Configuración Bolsa/Categoría",
		["Opens the Waterfall Config window"] = "Abre la ventana de Cascada de configuración",
		["Rename / Reorder"] = "Renombrar / Reordenar",
		["From Profile"] = "Desde perfil",
		["User"] = "Usuario",
		["Copy From"] = "Copiar desde",
		["Edit"] = "Editar",
		["Automatically open at auction house"] = "Abrir automáticamente Casa de Subastas",
		["Create"] = "Crear",
		["Bag Priority"] = "Prioridad de bolsas",
		["Section Priority"] = "Prioridad de secciones",
		
		["Allow Duplicates"] = "Permitir duplicados",
		["Import Sections From"] = "Importar secciones desde",

	}
	
end)
