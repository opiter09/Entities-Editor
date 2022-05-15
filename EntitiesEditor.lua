local window = fltk:Fl_Double_Window(0, 0, 4000, 3000, "Entities Editor")
local thisWindow = 1
local unitTable = {}
local projectileTable = {}

local rom = assert(io.open("LegoBattles.NDS", "rb"))
local text = rom:read(1825767)
text = string.sub(text, 1824087, 1825766)

local nameTable = {}
local iterator = 1
for i = 1, string.len(text) do
	if (string.byte(string.sub(text, i, i)) == 0) then
		if (nameTable[1] ~= nil) and (string.byte(string.sub(text, i - 1, i - 1)) ~= 0) then
			iterator = iterator + 1
		end
	elseif (string.byte(string.sub(text, i, i)) ~= 0) then
		if (nameTable[iterator] == nil) then
			nameTable[iterator] = ""
		end
		nameTable[iterator] = nameTable[iterator] .. string.sub(text, i, i)
	end
end
rom:close()
--for i = 1, #nameTable do
	--print(string.format("%s", nameTable[i]))
--end
--print(table.maxn(nameTable))
--castle, mill, mine, farm, barracks, factory, t1, t2, t3, ship
missingTable = {
	[3] = "[K] Builder",
	[11] = "Castle",
	[13] = "[K] Mine",
	[14] = "Farm",
	[15] = "[K] Barracks",
	[16] = "Special Factory",
	[17] = "[K] Tower I",
	[23] = "[W] Builder",
	[30] = "[W] Transport Ship",
	[33] = "[W] Mine",
	[37] = "[W] Tower I",
	[38] = "[W] Tower II",
	[39] = "[W] Tower III",
	[40] = "[W] Shipyard",
	[49] = "[P] Builder",
	[56] = "[P] Transport Ship",
	[58] = "[P] Lumber Shack",
	[63] = "[P] Tower I",
	[64] = "[P] Tower II",
	[65] = "[P] Tower III",
	[66] = "[P] Shipyard",
	[69] = "[I] Builder",
	[74] = "[I] Battleship",
	[76] = "[I] Transport Ship",
	[78] = "[I] Lumber Mill",
	[79] = "[I] Mine",
	[81] = "[I] Barracks",
	[83] = "[I] Tower I",
	[84] = "[I] Tower II",
	[85] = "[I] Tower II",
	[86] = "[I] Shipyard",
	[96] = "[E] Builder",
	[103] = "[E] Transport Ship",
	[108] = "[E] Barracks",
	[110] = "[E] Tower I",
	[111] = "[E] Tower II",
	[112] = "[E] Tower III",
	[113] = "[E] Shipyard",
	[116] = "[A] Builder",
	[123] = "[A] Transport Ship",
	[125] = "[A] Harvester",
	[126] = "[A] Well Cap",
	[133] = "[A] Shipyard"
}
for i = 1, 140 do
	if (missingTable[i] ~= nil) then
		table.insert(nameTable, i, missingTable[i])
	end
end
nameTable[10] = "[K] Transport Ship"
nameTable[12] = "[K] Lumber Mill"
nameTable[18] = "[K] Tower II"
nameTable[19] = "[K] Tower III"
nameTable[20] = "[K] Shipyard"
nameTable[32] = "[W] Lumber Shack"
nameTable[54] = "[P] Battleship"
nameTable[105] = "[E] Harvester"
nameTable[106] = "[E] Well Cap"
nameTable[130] = "Spire I"

local conqName
if (nameTable[60] == "Storehouse") then
	nameTable[94] = "Gemma"
	nameTable[95] = "Biff"
	conqName = "Ancient Wolf"
else
	conqName = "Conquistador"
end

local temp = {}
for i = 1, #nameTable do
	if (i < 41) or ((i > 46) and (i < 87)) or ((i > 93) and (i < 134)) then
		temp[#temp + 1] = nameTable[i]
	end
end
nameTable = temp

local newNames = { "Wall", "BridgeSmallH", "BridgeSmallV", "BridgeMediumH", "BridgeMediumV", "BridgeLargeH", "BridgeLargeV", "GateH", "GateV",
	"SpacePoliceCaptain", "Space Police", "SpacePoliceCruiser", "SpacePoliceBase", "SpaceCriminalLeader", "Space Criminal",
	"SpaceCriminalHotrod", "SpaceCriminalBase", "Falvour", "Robot", "SpaceCrimShipColor", "CrashedSupplyPod", "Crashed Mothership", "Meteorite",
	"Crashed Transport", "Ancient Structure", "King Kahuka", "Islander", "Tiki Golem", "Islander Temple", "Ninja Master", "Ninja",
	"Ninja Flying Ship", "Ninja Temple", "Monkey", "Trader Ship", "Shark", "Shipwreck Water", "Shipwreck Beach", "Forgotten Temple",
	"Abandoned Outpost", "Hermitage", "Dwarf King", "Dwarf", "Dwarf Glider", "Dwarf Hall", "Troll King", "Troll", "Troll Blimp", "Troll Hall",
	"Wolf", "Stonehenge", "Cairn", "Church", "Ruined Tower", "Ruined Castle", "Forestman", "Ghost", "Sheriff", conqName, "Agent Chase",
	"Classic Space", "Santa" }
for i = 1, #newNames do
	table.insert(nameTable, #nameTable + 1, newNames[i])
end
--print(table.maxn(nameTable))

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

local speedTable = { "273 (1)", "341 (1)", "375 (2)", "410 (2)", "444 (2)", "478 (3)", "546 (3)", "614 (3)", "683 (4)", "819 (5)", "853 (5)", "956 (5)", "NONE" }
local typeTable = { "Hero", "Builder", "Melee", "Ranged", "Mounted", "Transport", "Special", "Castle", "Lumber Mill", "Mine", "Farm", "Barracks", "Factory",
	"Tower I", "Tower II", "Tower III", "Shipyard", "Bridge", "Gate", "Wall", "Other" }
local widgetTable = {}
local switchType = 0

local function saveCallback(w)
	local internalTable = { "Arrow", "CrossbowBolt", "TBolt", "TBoulder", "TFireball", "BallistaBolt", "SiegeBolt", "Boulder", "OgreBoulder", 
		"Fireball", "ImperialShot", "PirateShot", "TPirateShot", "ICannonBall", "PCannonBall", "Elaser", "ALaser", "TLaser",
		"PlasmaBall", "LaserCannon", "ProjectileSpell", "AirBallistaBolt", "AirFireball", "AirLaser", "Sharkbite", "Gift", "ProjNoEffect" }

	if (switchType ~= 0) and (widgetTable ~= nil) then
		for k, v in pairs(widgetTable) do
			if (switchType ~= "Projectiles") then
				for key, value in pairs(unitTable) do
					if (v.ID == value.ID) then
						if (speedTable[v.Speed:value() + 1] == "NONE") then
							value.Speed = 65535
						else
							value.Speed = tonumber(string.sub(speedTable[v.Speed:value() + 1], 1, 3))
						end
						value.LandFlag = v.LandFlag:value()
						value.WaterFlag = v.WaterFlag:value()
						if (typeTable[v.Type:value() + 1] == "Other") then
							value.Type = 255
						else
							value.Type = v.Type:value()
						end
						value.BuildCost = v.BuildCost:value()
						value.BuildTime = v.BuildTime:value()
						value.Health = v.Health:value()
						value.Mana = v.Mana:value()
						if (v.ProjectileID:value() == 27) then
							value.ProjectileID = 65535
						else
							value.ProjectileID = v.ProjectileID:value() + 182
						end
						value.AttackMin = v.AttackMin:value()
						value.AttackMax = v.AttackMax:value()
						value.Power1 = v.Power1:value()
						value.Power2 = v.Power2:value()
						value.Power3 = v.Power3:value()
						value.Power4 = v.Power4:value()
						value.Power5 = v.Power5:value()
					end
				end
			end
		end
		if (switchType == "Projectiles") then
			for i = 1, 27 do
				projectileTable[i].DamageMin = widgetTable[i].DamageMin:value()
				projectileTable[i].DamageMax = widgetTable[i].DamageMax:value()
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
			reading = string.sub(reading, 1, base + 117 + j) .. IllHexYou(a[string.format("Power%s", j)]) .. string.sub(reading, base + 119 + j, string.len(reading))
		end
	end
	for i = 0, 26 do
		local a = projectileTable[i + 1]
		local base = i * 116
		reading = string.sub(reading, 1, base + 22680) .. ThisLittleHexIsPayback(a.DamageMin) .. ThisLittleHexIsPayback(a.DamageMax) ..
		ThisLittleHexIsPayback(a.DamageMin) .. ThisLittleHexIsPayback(a.DamageMax) .. string.sub(reading, base + 22689, string.len(reading))
	end
	out:close()
	out = assert(io.open("testD.bin", "wb"))
	out:write(reading)
	out:close()
	fltk.fl_message("Save Complete!")
end

local function quit_callback(w)
	if (thisWindow == 1) then
		window:hide()
		return
	elseif (thisWindow == 2) then
		windowII:hide()
	end
end

local windowII

local function displayProjectiles()
	local internalTable = { "Arrow", "CrossbowBolt", "TBolt", "TBoulder", "TFireball", "BallistaBolt", "SiegeBolt", "Boulder", "OgreBoulder", 
		"Fireball", "ImperialShot", "PirateShot", "TPirateShot", "ICannonBall", "PCannonBall", "Elaser", "ALaser", "TLaser",
		"PlasmaBall", "LaserCannon", "ProjectileSpell", "AirBallistaBolt", "AirFireball", "AirLaser", "Sharkbite", "Gift", "ProjectileNoEffect" }

	for i = 1, 14 do
		local a = projectileTable[i]
		local b = {}
		
		fltk:Fl_Button(20, 30 * (i + 2), 130, 25, internalTable[i])
		
		b.DamageMin = fltk:Fl_Value_Input(240, 30 * (i + 2), 50, 25, "Damage Min")
		b.DamageMin:labelsize(14)
		b.DamageMin:textsize(14)
		b.DamageMin:minimum(0)
		b.DamageMin:maximum(65535)
		b.DamageMin:step(5)
		b.DamageMin:value(a.DamageMin)
		
		b.DamageMax = fltk:Fl_Value_Input(390, 30 * (i + 2), 50, 25, "Damage Max")
		b.DamageMax:labelsize(14)
		b.DamageMax:textsize(14)
		b.DamageMax:minimum(0)
		b.DamageMax:maximum(65535)
		b.DamageMax:step(5)
		b.DamageMax:value(a.DamageMax)
		
		widgetTable[i] = b
	end
	for i = 15, 27 do
		local a = projectileTable[i]
		local b = {}

		fltk:Fl_Button(460, 30 * (i -12), 130, 25, internalTable[i])
		
		b.DamageMin = fltk:Fl_Value_Input(680, 30 * (i - 12), 50, 25, "Damage Min")
		b.DamageMin:labelsize(14)
		b.DamageMin:textsize(14)
		b.DamageMin:minimum(0)
		b.DamageMin:maximum(65535)
		b.DamageMin:step(5)
		b.DamageMin:value(a.DamageMin)
		
		b.DamageMax = fltk:Fl_Value_Input(830, 30 * (i - 12), 50, 25, "Damage Max")
		b.DamageMax:labelsize(14)
		b.DamageMax:textsize(14)
		b.DamageMax:minimum(0)
		b.DamageMax:maximum(65535)
		b.DamageMax:step(5)
		b.DamageMax:value(a.DamageMax)
		
		b.ID = a.ID
		widgetTable[i] = b
	end
	if (thisWindow == 1) then
		windowII:show()
		window:hide()
		thisWindow = 2
		return
	elseif (thisWindow == 2) then
		window:show()
		windowII:hide()
		thisWindow = 1
	end
end

local tempPeople = {}
local function switchCallback(w)
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
		["Tower 3"] = 15,
		["Extras"] = -1
	}
	switchType = w:user_data()
	
	if (thisWindow == 1) then
		windowII = fltk:Fl_Double_Window(0, 0, 4000, 3000, "Entities Editor")
	elseif (thisWindow == 2) then
		window = fltk:Fl_Double_Window(0, 0, 4000, 3000, "Entities Editor")
	end
	local menuBar = fltk:Fl_Menu_Bar(0, 0, 600, 25)

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
	menuBar:add("Extras", nil, switchCallback, "Extras")
	menuBar:add("Projectiles", nil, switchCallback, "Projectiles")
	
	local quitButton = fltk:Fl_Button(1485, 0, 50, 25, "Exit")
	quitButton:callback(quit_callback)
	
	local group = fltk:Fl_Scroll(0, 70, 1535, 650, "")
	group:box(fltk.FL_THIN_UP_BOX)

	if (switchType == "Projectiles") then
		displayProjectiles()
		return
	end

	tempPeople = {}
	for i = 1, #unitTable do
		if (unitTable[i].Type == typeMapping[switchType]) then
			if (unitTable[i].BuildCost > 1) then
				tempPeople[#tempPeople + 1] = unitTable[i]
			end
		end
	end
	
	table.sort(tempPeople, function(k1, k2) return k1.ID < k2.ID end)

	local holding = {}
	if (switchType == "Main Factions") then
		local check = 1
		for k, v in pairs(tempPeople) do
			if (check <= 12) then
				holding[#holding + 1] = v
				check = check + 1
			end
		end
		tempPeople = holding
	elseif (switchType == "Side Factions") then
		local check = 1
		for k, v in pairs(tempPeople) do
			check = check + 1
			if (check > 13) then
				holding[#holding + 1] = v
			end
		end
		tempPeople = holding
	end

	holding = {}
	if (switchType == "Tier 1") then
		for k, v in pairs(tempPeople) do
			if ((math.fmod(math.abs(v.ID - 6), 20)) == 0) then
				holding[#holding + 1] = v
			end
			tempPeople = holding
		end
	elseif (switchType == "Tier 2") then
		for k, v in pairs(tempPeople) do
			if ((math.fmod(math.abs(v.ID - 7), 20)) == 0) or (v.ID > 122) then
				holding[#holding + 1] = v
			end
			tempPeople = holding
		end
	elseif (switchType == "Tier 3") then
		for k, v in pairs(tempPeople) do
			if ((math.fmod(math.abs(v.ID - 8), 20)) == 0) then
				holding[#holding + 1] = v
			end
			tempPeople = holding
		end
	end
	
	if (switchType == "Extras") then
		for i = 1, #unitTable do
			if (unitTable[i].Type > 16) or (unitTable[i].BuildCost <= 1) then
				tempPeople[#tempPeople + 1] = unitTable[i]
			end
		end
	end

	local check = 1	
	for k, v in pairs(tempPeople) do
		if (check <= 20) then
			check = check + 1
			local a = v
			local b = {}
			local theValue = "???"
			local theTable = {}
			b.Button = fltk:Fl_Button(0, 30 * (check + 2), 130, 25, nameTable[a.ID + 1])
			
			b.Speed = fltk:Fl_Choice(185, 30 * (check + 2), 75, 25, "Speed")
			b.Speed:down_box(fltk.FL_BORDER_BOX)
			b.Speed:labelsize(14)
			b.Speed:textsize(14)
			theTable = speedTable
			for j = 1, #theTable do
				b.Speed:add(theTable[j])
				if (a.Speed == tonumber(string.sub(theTable[j], 1, 3))) then
					theValue = j - 1
				end
			end
			if (a.Speed == 65535) then
				theValue = 12
			end
			b.Speed:value(theValue)
			
			b.LandFlag = fltk:Fl_Choice(300, 30 * (check + 2), 50, 25, "Land")
			b.LandFlag:down_box(fltk.FL_BORDER_BOX)
			b.LandFlag:labelsize(14)
			b.LandFlag:textsize(14)
			theTable = { "Off", "On" }
			for j = 1, #theTable do
				b.LandFlag:add(theTable[j])
			end
			b.LandFlag:value(a.LandFlag)
			
			b.WaterFlag = fltk:Fl_Choice(400, 30 * (check + 2), 50, 25, "Water")
			b.WaterFlag:down_box(fltk.FL_BORDER_BOX)
			b.WaterFlag:labelsize(14)
			b.WaterFlag:textsize(14)
			theTable = { "Off", "On" }
			for j = 1, #theTable do
				b.WaterFlag:add(theTable[j])
			end
			b.WaterFlag:value(a.WaterFlag)
			
			b.Type = fltk:Fl_Choice(500, 30 * (check + 2), 75, 25, "Type")
			b.Type:down_box(fltk.FL_BORDER_BOX)
			b.Type:labelsize(14)
			b.Type:textsize(14)
			theTable = typeTable
			for j = 1, #theTable do
				b.Type:add(theTable[j])
			end
			if (a.Type == 255) then
				b.Type:value(20)
			else
				b.Type:value(a.Type)
			end
			
			b.BuildCost = fltk:Fl_Value_Input(625, 30 * (check + 2), 50, 25, "B Cost")
			b.BuildCost:labelsize(14)
			b.BuildCost:textsize(14)
			b.BuildCost:minimum(0)
			b.BuildCost:maximum(65535)
			b.BuildCost:step(5)
			b.BuildCost:value(a.BuildCost)
			
			b.BuildTime = fltk:Fl_Value_Input(725, 30 * (check + 2), 50, 25, "B Time")
			b.BuildTime:labelsize(14)
			b.BuildTime:textsize(14)
			b.BuildTime:minimum(0)
			b.BuildTime:maximum(65535)
			b.BuildTime:step(5)
			b.BuildTime:value(a.BuildTime)
			
			b.Health = fltk:Fl_Value_Input(825, 30 * (check + 2), 50, 25, "Health")
			b.Health:labelsize(14)
			b.Health:textsize(14)
			b.Health:minimum(0)
			b.Health:maximum(65535)
			b.Health:step(5)
			b.Health:value(a.Health)
			
			b.Mana = fltk:Fl_Value_Input(925, 30 * (check + 2), 50, 25, "Mana")
			b.Mana:labelsize(14)
			b.Mana:textsize(14)
			b.Mana:minimum(0)
			b.Mana:maximum(65535)
			b.Mana:step(5)
			b.Mana:value(a.Mana)
			
			b.ProjectileID = fltk:Fl_Choice(1025, 30 * (check + 2), 80, 25, "Proj")
			b.ProjectileID:down_box(fltk.FL_BORDER_BOX)
			b.ProjectileID:labelsize(14)
			b.ProjectileID:textsize(14)
			theTable = { "Arrow", "CrossbowBolt", "TBolt", "TBoulder", "TFireball", "BallistaBolt", "SiegeBolt", "Boulder", "OgreBoulder", 
			"Fireball", "ImperialShot", "PirateShot", "TPirateShot", "ICannonBall", "PCannonBall", "Elaser", "ALaser", "TLaser",
			"PlasmaBall", "LaserCannon", "ProjectileSpell", "AirBallistaBolt", "AirFireball", "AirLaser", "Sharkbite", "Gift", "ProjectileNoEffect", "NONE"}
			for j = 1, #theTable do
				b.ProjectileID:add(theTable[j])
			end
			b.ProjectileID:value(a.ProjectileID - 182)
			if (a.ProjectileID == 65535) then
				b.ProjectileID:value(27)
			end

			b.AttackMin = fltk:Fl_Value_Input(1175, 30 * (check + 2), 50, 25, "Attack Min")
			b.AttackMin:labelsize(14)
			b.AttackMin:textsize(14)
			b.AttackMin:minimum(0)
			b.AttackMin:maximum(65535)
			b.AttackMin:step(5)
			b.AttackMin:value(a.AttackMin)
			
			b.AttackMax = fltk:Fl_Value_Input(1300, 30 * (check + 2), 50, 25, "Attack Max")
			b.AttackMax:labelsize(14)
			b.AttackMax:textsize(14)
			b.AttackMax:minimum(0)
			b.AttackMax:maximum(65535)
			b.AttackMax:step(5)
			b.AttackMax:value(a.AttackMax)
			
			for j = 1, 5 do
				b[string.format("Power%s", j)] = fltk:Fl_Choice(1275 + j * 135, 30 * (check + 2), 75, 25, string.format("Power%s", j))
				b[string.format("Power%s", j)]:down_box(fltk.FL_BORDER_BOX)
				b[string.format("Power%s", j)]:labelsize(14)
				b[string.format("Power%s", j)]:textsize(14)
				theTable = { "NONE", "Unit Heal [100]", "UnitHeal [100]", "Nothing", "Unit Speed Boost", "Area Speed Boost", "Unit Damage Boost",
					"Area Damage Boost", "Unit Armor Boost", "Area Armor Boost", "Forest Spawn", "Crystal Cache", "Jungle Growth", "Earthquake",
					"Fireball", "Lightning", "Thunder Hammer", "Mining Buff", "Roar", "Logging Buff", "Monkey Swarm", "Crab Swarm", "Coconut Storm",
					"Artillery", "Trade Winds", "Arrow Volley", "Teleport", "EMP", "Space Laser", "ESP", "Tracking", "Cluster Bomb", "Hot Wire",
					"Unit Heal [500]" }
				for x, y in pairs(theTable) do
					b[string.format("Power%s", j)]:add(theTable[x])
				end
				b[string.format("Power%s", j)]:value(a[string.format("Power%s", j)])
			end

			b.Button2 = fltk:Fl_Button(2040, 30 * (check + 2), 130, 25, nameTable[a.ID + 1])

			for key, value in pairs(b) do
				group:add(value)
			end
			b.ID = a.ID
			widgetTable[check] = b
		end
	end
	if (thisWindow == 1) then
		windowII:show()
		window:hide()
		thisWindow = 2
		return
	elseif (thisWindow == 2) then
		window:show()
		windowII:hide()
		thisWindow = 1
	end
end

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
	a.Power1 = NothingICantHandle(base + 119)
	a.Power2 = NothingICantHandle(base + 120)
	a.Power3 = NothingICantHandle(base + 121)
	a.Power4 = NothingICantHandle(base + 122)
	a.Power5 = NothingICantHandle(base + 123)
	unitTable[i + 1] = a
end
for i = 0, 26 do
	projectileTable[i + 1] = {}
	local base = i * 116
	projectileTable[i + 1].ID = NothingICantHandle(base + 22577, base + 22578)
	projectileTable[i + 1].DamageMin = NothingICantHandle(base + 22681, base + 22682)
	projectileTable[i + 1].DamageMax = NothingICantHandle(base + 22683, base + 22684)
	--print(a.ID)
end

local menuBar = fltk:Fl_Menu_Bar(0, 0, 600, 25)

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
menuBar:add("Extras", nil, switchCallback, "Extras")
menuBar:add("Projectiles", nil, switchCallback, "Projectiles")

local quitButton = fltk:Fl_Button(1485, 0, 50, 25, "Exit")
quitButton:callback(quit_callback)
	
window:show()
Fl:run()