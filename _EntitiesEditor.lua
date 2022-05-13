local window = fltk:Fl_Window(0, 0, 1920, 1080, "Entities Editor")
local unitTable = {}
local projectileTable = {}

local rom = assert(io.open("LegoBattles.NDS", "rb"))
local text = rom:read(1825767)
text = string.sub(text, 1824087, 1825766)

local nameTable = {}
local iterator = 1
for i = 1, string.len(text) do
	if (string.sub(text, i, i) == string.char(0x00)) and (iterator > 1) then
		if (i == 1) or (string.sub(text, i - 1, i - 1) ~= string.char(0x00)) then
			iterator = iterator + 1
		end
	elseif (string.sub(text, i, i) ~= string.char(0x00)) then
		if (nameTable[iterator] == nil) then
			nameTable[iterator] = ""
		end
		nameTable[iterator] = nameTable[iterator] .. string.sub(text, i, i)
	end
end
rom:close()
	

local function NothingICantHandle(inp, inp2)
	local inputFile = assert(io.open("testD.bin", "rb"))
	local bytE = inputFile:read("*all")

	local num = tonumber(string.byte(bytE, inp))
	local num2
	if (inp2 ~= nil) then
		num2 = tonumber(string.byte(bytE, inp2))
	end
	inputFile:close()
	
	local hexstr = "0123456789ABCDEF"
	local result = ""
	while num > 0 do
		local n = math.fmod(num, 16)
		result = string.format("%s%s", string.sub(hexstr, n + 1, n + 1), result)
		num = math.floor(num / 16)
	end
	if (string.len(result) == 1) then
		result = string.format("%s%s", "0", result)
	end
	if (string.len(result) == 0) then
		result = "00"
	end

	if (num2 ~= nil) then
		local result2 = ""
		while num2 > 0 do
			local n = math.fmod(num2, 16)
			result2 = string.format("%s%s", string.sub(hexstr, n + 1, n + 1), result2)
			num2 = math.floor(num2 / 16)
		end
		if (string.len(result2) == 1) then
			result2 = string.format("%s%s", "0", result2)
		end
		if (string.len(result2) == 0) then
			result2 = "00"
		end
		return(tonumber(string.format("%s%s", result2, result), 16))
	else
		return(tonumber(result, 16))
	end
end

local function IllHexYou(num)
	local hex = string.format("%02X", num)
	hex = string.char(tonumber(hex, 16))
	return(hex)
end

local function ThisLittleHexIsPayback(num)
	local hex = string.format("%04X", num)

	hex = string.char(tonumber(string.sub(hex, 3, 4), 16), tonumber(string.sub(hex, 1, 2), 16))
	return(hex)
end

local widgetTable = {}

local function displayProjectiles()
	local internalTable = { "Arrow", "CrossbowBolt", "TBolt", "TBoulder", "TFireball", "BallistaBolt", "SiegeBolt", "Boulder", "OgreBoulder", 
		"Fireball", "ImperialShot", "PirateShot", "TPirateShot", "ICannonBall", "PCannonBall", "Elaser", "ALaster", "TLaser",
		"PlasmaBall", "LaserCannon", "ProjectileSpell", "AirBallistaBolt", "AirFireball", "AirLaster", "Sharkbite", "Gift", "ProjectileNoEffect" }
		
	for i = 1, 15 do
		local a = projectileTable[i]
		local b = {}
		
		fltk.fl_rectf(20, 20 * (i + 2), 15, 15)
		fltk.fl_draw(internalTable[i], 20, 20 * (i + 2))
		
		b.DamageMin = fltk:Fl_Value_Input(40, 20 * (i + 2), 15, 15, "Damage Min")
		b.DamageMin:labelsize(14)
		b.DamageMin:textsize(14)
		b.DamageMin:minimum(0)
		b.DamageMin:maximum(65535)
		b.DamageMin:step(5)
		b.DamageMin:value(a.DamageMin)
		b.DamageMin:show()
		
		b.DamageMax = fltk:Fl_Value_Input(60, 20 * (i + 2), 15, 15, "Damage Max")
		b.DamageMax:labelsize(14)
		b.DamageMax:textsize(14)
		b.DamageMax:minimum(0)
		b.DamageMax:maximum(65535)
		b.DamageMax:step(5)
		b.DamageMax:value(a.DamageMax)
		b.DamageMax:show()
		
		widgetTable[i] = b
	end
	for i = 16, 27 do
		local a = projectileTable[i]
		local b = {}

		fltk.fl_rectf(100, 20 * (i + 2), 15, 15)
		fltk.fl_draw(internalTable[i], 20, 20 * (i - 13))
		
		b.DamageMin = fltk:Fl_Value_Input(120, 20 * (i - 13), 15, 15, "Damage Min")
		b.DamageMin:labelsize(14)
		b.DamageMin:textsize(14)
		b.DamageMin:align(1)
		b.DamageMin:minimum(0)
		b.DamageMin:maximum(65535)
		b.DamageMin:step(5)
		b.DamageMin:value(a.DamageMin)
		
		b.DamageMax = fltk:Fl_Value_Input(140, 20 * (i - 13), 15, 15, "Damage Max")
		b.DamageMax:labelsize(14)
		b.DamageMax:textsize(14)
		b.DamageMax:align(1)
		b.DamageMax:minimum(0)
		b.DamageMax:maximum(65535)
		b.DamageMax:step(5)
		b.DamageMax:value(a.DamageMax)
		
		widgetTable[i] = b
	end
	window:redraw()
end

local switchType = 0
local tempPeople = {}
local function switchCallback(w)
	if (table.maxn(widgetTable) ~= 0) then
		for i = 1, #widgetTable do
			for k, v in pairs(widgetTable[i]) do
				v:hide()
			end
		end
	end
	widgetTable = {}

	local typeMapping = {
		["Main Factions"] = 0,
		["Side Factions"] = 0,
		["Builders"] = 1,
		["Melee"] = 2,
		["Ranged"] = 3,
		["Mounted"] = 4,
		["Tier 1"] = 6,
		["Tier 2"] = 6,
		["Tier 3"] = 6,
		["Transport"] = 5,
		["Castle"] = 7,
		["Farm"] = 10,
		["Mine"] = 9,
		["Lumber Mill"] = 8,
		["Barracks"] = 11,
		["Factory"] = 12,
		["Shipyard"] = 16,
		["Tower 1"] = 13,
		["Tower 2"] = 14,
		["Tower 3"] = 15
	}
	switchType = w:user_data()
	--print(switchType)
	if (switchType == "Projectiles") then
		displayProjectiles()
		return
	end
	tempPeople = {}
	for i = 1, 182 do
		if (unitTable[i].Type == typeMapping[switchType]) then
			tempPeople[#tempPeople + 1] = unitTable[i]
		end
	end
	table.sort(tempPeople, function(k1, k2) return k1.ID < k2.ID end)

	if (switchType == "Main Heroes") then
		for i = 13, #tempPeople do
			table.remove(tempPeople, i)
		end
	elseif (switchType == "Side Heroes") then
		for i = 1, 12 do
			table.remove(tempPeople, i)
		end
	end

	if (switchType == "Tier 1") then
		for i = 1, #tempPeople do
			if ((math.fmod(math.abs(tempPeople[i].ID - 6), 17)) ~= 0) then
				table.remove(tempPeople[i])
			end
		end
	elseif (switchType == "Tier 2") then
		for i = 1, #tempPeople do
			if ((math.fmod(math.abs(tempPeople[i].ID - 7), 17)) ~= 0) and (tempPeople[i].ID < 94) then
				table.remove(tempPeople[i])
			end
		end
	elseif (switchType == "Tier 3") then
		for i = 1, #tempPeople do
			if ((math.fmod(math.abs(tempPeople[i].ID - 8), 17)) ~= 0) then
				table.remove(tempPeople[i])
			end
		end
	end
	
	for i = 1, #tempPeople do
		if	(i <= 15) then
			local a = tempPeople[i]
			local b = {}
			local theValue = "???"
			local theTable = {}

			fltk.fl_rectf(20, 20 * (i + 2), 15, 15)
			fltk.fl_draw(nameTable[a.ID + 1], 20, 20 * (i + 2))
			
			b.Speed = fltk:Fl_Choice(40, 20 * (i + 2), 15, 15, "Speed")
			b.Speed:down_box(fltk.FL_BORDER_BOX)
			b.Speed:labelsize(14)
			b.Speed:textsize(14)
			theTable = { "341 (1)", "375 (2)", "410(2)", "444 (2)", "478 (3)", "546 (3)", "614 (3)", "683 (4)", "819 (5)", "853 (5)" }
			for j = 1, #theTable do
				b.Speed:add(theTable[i])
				if (a.Speed == tonumber(string.sub(theTable[i], 1, 3))) then
					theValue = theTable[i]
				end
			end
			b.Speed:value(theValue)
			
			b.LandFlag = fltk:Fl_Choice(60, 20 * (i + 2), 15, 15, "Walk on Land")
			b.LandFlag:down_box(fltk.FL_BORDER_BOX)
			b.LandFlag:labelsize(14)
			b.LandFlag:textsize(14)
			theTable = { "Off (0)", "On (1)" }
			for j = 1, #theTable do
				b.LandFlag:add(theTable[i])
			end
			theValue = theTable[a.LandFlag + 1]
			b.LandFlag:value(theValue)
			
			b.WaterFlag = fltk:Fl_Choice(80, 20 * (i + 2), 15, 15, "Walk on Water")
			b.WaterFlag:down_box(fltk.FL_BORDER_BOX)
			b.WaterFlag:labelsize(14)
			b.WaterFlag:textsize(14)
			theTable = { "Off (0)", "On (1)" }
			for j = 1, #theTable do
				b.WaterFlag:add(theTable[i])
			end
			theValue = theTable[a.WaterFlag + 1]
			b.WaterFlag:value(theValue)
			
			b.Type = fltk:Fl_Choice(100, 20 * (i + 2), 15, 15, "Type")
			b.Type:down_box(fltk.FL_BORDER_BOX)
			b.Type:labelsize(14)
			b.Type:textsize(14)
			theTable = { "Hero", "Builder", "Melee", "Ranged", "Mounted", "Transport", "Special",
				"Castle", "Lumber Mill", "Mine", "Farm", "Barracks", "Factory", "Tower I", "Tower II",
				"Tower III", "Shipyard" }
			for j = 1, #theTable do
				b.Type:add(theTable[i])
			end
			theValue = theTable[a.Type + 1]
			b.Type:value(theValue)
			
			b.BuildCost = fltk:Fl_Value_Input(120, 20 * (i + 2), 15, 15, "Build Cost")
			b.BuildCost:labelsize(14)
			b.BuildCost:textsize(14)
			b.BuildCost:minimum(0)
			b.BuildCost:maximum(65535)
			b.BuildCost:step(5)
			b.BuildCost:value(a.BuildCost)
			
			b.BuildTime = fltk:Fl_Value_Input(140, 20 * (i + 2), 15, 15, "Build Time")
			b.BuildTime:labelsize(14)
			b.BuildTime:textsize(14)
			b.BuildTime:minimum(0)
			b.BuildTime:maximum(65535)
			b.BuildTime:step(5)
			b.BuildTime:value(a.BuildTime)
			
			b.Health = fltk:Fl_Value_Input(160, 20 * (i + 2), 15, 15, "Health")
			b.Health:labelsize(14)
			b.Health:textsize(14)
			b.Health:minimum(0)
			b.Health:maximum(65535)
			b.Health:step(5)
			b.Health:value(a.Health)
			
			b.Mana = fltk:Fl_Value_Input(180, 20 * (i + 2), 15, 15, "Mana")
			b.Mana:labelsize(14)
			b.Mana:textsize(14)
			b.Mana:minimum(0)
			b.Mana:maximum(65535)
			b.Mana:step(5)
			b.Mana:value(a.Mana)
			
			b.ProjectileID = fltk:Fl_Choice(200, 20 * (i + 2), 15, 15, "Projectile")
			b.ProjectileID:down_box(fltk.FL_BORDER_BOX)
			b.ProjectileID:labelsize(14)
			b.ProjectileID:textsize(14)
			theTable = { "Arrow", "CrossbowBolt", "TBolt", "TBoulder", "TFireball", "BallistaBolt", "SiegeBolt", "Boulder", "OgreBoulder", 
			"Fireball", "ImperialShot", "PirateShot", "TPirateShot", "ICannonBall", "PCannonBall", "Elaser", "ALaster", "TLaser",
			"PlasmaBall", "LaserCannon", "ProjectileSpell", "AirBallistaBolt", "AirFireball", "AirLaster", "Sharkbite", "Gift", "ProjectileNoEffect" }
			for j = 1, #theTable do
				b.ProjectileID:add(theTable[i])
			end
			theValue = theTable[a.ProjectileID - 181]
			b.ProjectileID:value(theValue)
			
			b.AttackMin = fltk:Fl_Value_Input(220, 20 * (i + 2), 15, 15, "Attack Min")
			b.AttackMin:labelsize(14)
			b.AttackMin:textsize(14)
			b.AttackMin:minimum(0)
			b.AttackMin:maximum(65535)
			b.AttackMin:step(5)
			b.AttackMin:value(a.AttackMin)
			
			b.AttackMax = fltk:Fl_Value_Input(240, 20 * (i + 2), 15, 15, "Attack Max")
			b.AttackMax:labelsize(14)
			b.AttackMax:textsize(14)
			b.AttackMax:minimum(0)
			b.AttackMax:maximum(65535)
			b.AttackMax:step(5)
			b.AttackMax:value(a.AttackMax)
			
			for j = 1, 5 do
				b[string.format("Power%s", j)] = fltk:Fl_Choice(240 + j * 20, 20 * (i + 2), 15, 15, string.format("Power %s", j))
				b[string.format("Power%s", j)]:down_box(fltk.FL_BORDER_BOX)
				b[string.format("Power%s", j)]:labelsize(14)
				b[string.format("Power%s", j)]:textsize(14)
				theTable = { "NONE", "Unit Heal [100]", "Unit Heal [100]", "Unit Speed Boost", "Area Speed Boost", "Unit Damage Boost",
					"Area Damage Boost", "Unit Armor Boost", "Area Armor Boost", "Forest Spawn", "Crystal Cache", "Jungle Growth", "Earthquake",
					"Fireball", "Lightning", "Thunder Hammer", "Mining Buff", "Roar", "Logging Buff", "Monkey Swarm", "Crab Swarm", "Coconut Storm",
					"Artillery", "Trade Winds", "Arrow Volley", "Teleport", "EMP", "Space Laser", "ESP", "Tracking", "Cluster Bomb", "Hot Wire",
					"Unit Heal [500]" }
				for k = 1, #theTable do
					b[string.format("Power%s", j)]:add(theTable[k])
				end
				theValue = theTable[a.Powers[j] + 1]
				b[string.format("Power%s", j)]:value(theValue)
			end
			
			widgetTable[i] = b
		end
		window:redraw()
	end
end

local function saveCallback(w)
	if (table.maxn(tempPeople) ~= 0) then
		for i = 1, #tempPeople do
			if (switchType ~= "Projectiles") then
				unitTable[tempPeople[i].ID + 1] = tempPeople[i]
			else
				projectileTable[tempPeople[i].ID - 181] = tempPeople[i]
			end
		end
	end

	local out = assert(io.open("testD.bin", "rb"))
	local reading = out:read("*all")
	for i = 0, 181 do
		local a = unitTable[i + 1]
		local base = i * 124
		reading = string.sub(reading, 1, base + 8) .. ThisLittleHexIsPayback(a.ID) .. string.sub(reading, base + 11, string.len(reading))
		reading = string.sub(reading, 1, base + 16) .. ThisLittleHexIsPayback(a.Speed) .. string.sub(reading, base + 19, string.len(reading))
		reading = string.sub(reading, 1, base + 27) .. IllHexYou(a.LandFlag) .. string.sub(reading, base + 29, string.len(reading))
		reading = string.sub(reading, 1, base + 28) .. IllHexYou(a.WaterFlag) .. string.sub(reading, base + 30, string.len(reading))	
		if ((a.LandFlag == 0) or (a.WaterFlag == 0)) and (a.Speed ~= 65535) then
			if (string.sub(reading, base + 30, base + 32) == string.char(0x00, 0x01, 0x00)) or (string.sub(reading, base + 30, base + 32) == string.char(0x01, 0x00, 0x01)) then
				reading = string.sub(reading, 1, base + 29) .. string.char(0x00, 0x01, 0x00) .. string.sub(reading, base + 33, string.len(reading))
			end
		elseif (a.LandFlag == 1) and (a.WaterFlag == 1) and (a.Speed ~= 65535) then
			if (string.sub(reading, base + 30, base + 32) == string.char(0x00, 0x01, 0x00)) or (string.sub(reading, base + 30, base + 32) == string.char(0x01, 0x00, 0x01)) then
				reading = string.sub(reading, 1, base + 29) .. string.char(0x01, 0x00, 0x01) .. string.sub(reading, base + 33, string.len(reading))
			end
		end
		reading = string.sub(reading, 1, base + 96) .. IllHexYou(a.Type) .. string.sub(reading, base + 98, string.len(reading))
		reading = string.sub(reading, 1, base + 98) .. ThisLittleHexIsPayback(a.BuildCost) .. string.sub(reading, base + 101, string.len(reading))
		reading = string.sub(reading, 1, base + 100) .. ThisLittleHexIsPayback(a.BuildTime) .. string.sub(reading, base + 103, string.len(reading))
		reading = string.sub(reading, 1, base + 102) .. ThisLittleHexIsPayback(a.Health) .. string.sub(reading, base + 105, string.len(reading))
		reading = string.sub(reading, 1, base + 104) .. ThisLittleHexIsPayback(a.Mana) .. string.sub(reading, base + 107, string.len(reading))
		reading = string.sub(reading, 1, base + 106) .. ThisLittleHexIsPayback(a.ProjectileID) .. string.sub(reading, base + 109, string.len(reading))
		reading = string.sub(reading, 1, base + 108) .. ThisLittleHexIsPayback(a.AttackMin) .. string.sub(reading, base + 111, string.len(reading))
		local diff = math.max(a.AttackMax - a.AttackMin, 0)
		reading = string.sub(reading, 1, base + 110) .. ThisLittleHexIsPayback(diff) .. string.sub(reading, base + 113, string.len(reading))
		for j = 1, 5 do
			reading = string.sub(reading, 1, base + 117 + j) .. IllHexYou(a.Powers[j]) .. string.sub(reading, base + 119 + j, string.len(reading))
		end
	end
	for i = 0, 26 do
		local a = projectileTable[i + 1]
		local base = i * 116
		reading = string.sub(reading, 1, base + 22576) .. ThisLittleHexIsPayback(a.ID) .. string.sub(reading, base + 22579, string.len(reading))
		reading = string.sub(reading, 1, base + 22680) .. ThisLittleHexIsPayback(a.DamageMin) .. ThisLittleHexIsPayback(a.DamageMax) ..
		ThisLittleHexIsPayback(a.DamageMin) .. ThisLittleHexIsPayback(a.DamageMax) .. string.sub(reading, base + 22689, string.len(reading))
	end
	out:close()
	out = assert(io.open("testD.bin", "wb"))
	out:write(reading)
	out:close()
	fltk.fl_message("Save Complete!")
end

local menuBar = fltk:Fl_Menu_Bar(0, 0, 550, 25)

menuBar:add("Save", nil, saveCallback)
menuBar:add("Heroes/Main Factions", nil, switchCallback, "Main Factions")
menuBar:add("Heroes/Side Factions", nil, switchCallback, "Side Factions")
menuBar:add("Builders", nil, switchCallback, "Builders")
menuBar:add("Barracks/Melee", nil, switchCallback, "Melee")
menuBar:add("Barracks/Ranged", nil, switchCallback, "Ranged")
menuBar:add("Barracks/Mounted", nil, switchCallback, "Mounted")
menuBar:add("Special/Tier 1", nil, switchCallback, "Tier 1")
menuBar:add("Special/Tier 2", nil, switchCallback, "Tier 2")
menuBar:add("Special/Tier 3", nil, switchCallback, "Tier 3")
menuBar:add("Transport", nil, switchCallback, "Transport")
menuBar:add("Buildings/Castle", nil, switchCallback, "Castle")
menuBar:add("Buildings/Farm", nil, switchCallback, "Farm")
menuBar:add("Buildings/Lumber Mill", nil, switchCallback, "Lumber Mill")
menuBar:add("Buildings/Mine", nil, switchCallback, "Mine")
menuBar:add("Buildings/Barracks", nil, switchCallback, "Barracks")
menuBar:add("Buildings/Factory", nil, switchCallback, "Factory")
menuBar:add("Buildings/Shipyard", nil, switchCallback, "Shipyard")
menuBar:add("Buildings/Tower 1", nil, switchCallback, "Tower 1")
menuBar:add("Buildings/Tower 2", nil, switchCallback, "Tower 2")
menuBar:add("Buildings/Tower 3", nil, switchCallback, "Tower 3")
menuBar:add("Projectiles", nil, switchCallback, "Projectiles")

local function quit_callback(object)
	window:hide()
end
local quitButton = fltk:Fl_Button(1485, 0, 50, 25, "Exit")
quitButton:callback(quit_callback)

for i = 0, 181 do 
	local a = {}
	local base = i * 124
	a.ID = NothingICantHandle(base + 9, base + 10)
	a.Speed = NothingICantHandle(base + 17, base + 18)
	a.LandFlag = NothingICantHandle(base + 28)
	a.WaterFlag = NothingICantHandle(base + 29)
	a.Type = NothingICantHandle(base + 97)
	a.BuildCost = NothingICantHandle(base + 99, base + 100)
	a.BuildTime = NothingICantHandle(base + 101, base + 102)
	a.Health = NothingICantHandle(base + 103, base + 104)
	a.Mana = NothingICantHandle(base + 105, base + 106)
	a.ProjectileID = NothingICantHandle(base + 107, base + 108)
	a.AttackMin = NothingICantHandle(base + 109, base + 110)
	a.AttackMax = a.AttackMin + NothingICantHandle(base + 111, base + 112)
	a.Powers = {
		NothingICantHandle(base + 119),
		NothingICantHandle(base + 120),
		NothingICantHandle(base + 121),
		NothingICantHandle(base + 122),
		NothingICantHandle(base + 123)
	}
	unitTable[i + 1] = a
	--print(a.ID)
end
for i = 0, 26 do
	local a = {}
	local base = i * 116
	a.ID = NothingICantHandle(base + 22577, base + 22578)
	a.DamageMin = NothingICantHandle(base + 22681, base + 22682)
	a.DamageMax = NothingICantHandle(base + 22683, base + 22684)
	projectileTable[i + 1] = a
	--print(a.ID)
end

window:show()
Fl:run()