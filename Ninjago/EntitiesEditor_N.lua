local window = fltk:Fl_Double_Window(0, 0, 4000, 3000, "Entities Editor")
local thisWindow = 1
local unitTable = {}
local projectileTable = {}

local doc = assert(io.open("internal.txt", "rb"))
local text = doc:read()

local nameTable = {}
local iterator = 1
for i = 1, string.len(text) do
	if (string.sub(text, i, i) == "~") then
		if (nameTable[1] ~= nil) and (string.sub(text, i - 1, i - 1) ~= "~") then
			iterator = iterator + 1
		end
	elseif (string.sub(text, i, i) ~= "~") then
		if (nameTable[iterator] == nil) then
			nameTable[iterator] = ""
		end
		nameTable[iterator] = nameTable[iterator] .. string.sub(text, i, i)
	end
end
doc:close()

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

local typeTable = {
	"Base Hero",
	"I Hero",
	"II Hero",
	"Builder",
	"Keep",
	"Mill",
	"Mine",
	"Barracks",
	"Checkpoint",
	"Spawner",
	"Default T",
	"Fire T",
	"Ice T",
	"Lightning T",
	"Earth T",
	"Bridge",
	"Unused",
	"Dragon",
	"Minion",
	"Other"
}
local widgetTable = {}
local switchType = 0

local function saveCallback(w)
	if (switchType ~= 0) and (widgetTable ~= nil) then
		for k, v in pairs(widgetTable) do
			if (switchType ~= "Projectiles") then
				for key, value in pairs(unitTable) do
					if (v.ID == value.ID) then
						value.Speed = v.Speed:value()
						value.LandFlag = v.LandFlag:value()
						value.WaterFlag = v.WaterFlag:value()
						value.TreeCrossFlag = v.TreeCrossFlag:value()
						value.BuildingHitFlag = v.BuildingHitFlag:value()
						value.BoundaryCrossFlag = v.BoundaryCrossFlag:value()
						value.HitboxSize = v.HitboxSize:value()
						if (typeTable[v.Type:value() + 1] == "Other") then
							if (value.Type ~= 255) then
								value.TypeDiff = "True"
							else
								value.TypeDiff = "False"
							end
							value.Type = 255
						else
							if (value.Type ~= v.Type:value()) then
								value.TypeDiff = "True"
							else
								value.TypeDiff = "False"
							end
							value.Type = v.Type:value()
						end
						value.BuildCost = v.BuildCost:value()
						value.BuildTime = v.BuildTime:value()
						value.Health = v.Health:value()
						value.Mana = v.Mana:value()
						if (v.ProjectileID:value() == 18) then
							value.ProjectileID = 65535
						else
							value.ProjectileID = v.ProjectileID:value() + 154
						end
						value.AttackMin = v.AttackMin:value()
						value.AttackMax = v.AttackMax:value()
						value.AttackWaitTime = v.AttackWaitTime:value()
						value.Range = v.Range:value()
						value.Power1 = v.Power1:value()
						value.Power2 = v.Power2:value()
					end
				end
			end
		end
		if (switchType == "Projectiles") then
			for i = 1, 18 do
				projectileTable[i].DamageMin = widgetTable[i].DamageMin:value()
				projectileTable[i].DamageMax = math.max(widgetTable[i].DamageMax:value(), widgetTable[i].DamageMin:value())
			end
		end
	end

	local out = assert(io.open("testD.bin", "rb"))
	local reading = out:read("*all")
	for i = 0, 153 do
		local a = unitTable[i + 1]
		local base = i * 128
		reading = string.sub(reading, 1, base + 8) .. ThisLittleHexIsPayback(a.ID) .. string.sub(reading, base + 11, string.len(reading))
		reading = string.sub(reading, 1, base + 17) .. IllHexYou(a.Speed) .. string.sub(reading, base + 19, string.len(reading))
		reading = string.sub(reading, 1, base + 23) .. IllHexYou(a.BoatAntiFlag) .. string.sub(reading, base + 25, string.len(reading))		
		reading = string.sub(reading, 1, base + 24) .. IllHexYou(a.LandFlag) .. string.sub(reading, base + 26, string.len(reading))
		reading = string.sub(reading, 1, base + 25) .. IllHexYou(a.WaterFlag) .. string.sub(reading, base + 27, string.len(reading))
		reading = string.sub(reading, 1, base + 26) .. IllHexYou(a.TreeCrossFlag) .. string.sub(reading, base + 28, string.len(reading))
		reading = string.sub(reading, 1, base + 27) .. IllHexYou(a.BuildingHitFlag) .. string.sub(reading, base + 29, string.len(reading))
		reading = string.sub(reading, 1, base + 28) .. IllHexYou(a.BoundaryCrossFlag) .. string.sub(reading, base + 30, string.len(reading))
		reading = string.sub(reading, 1, base + 29) .. IllHexYou(a.BridgeFlag) .. string.sub(reading, base + 31, string.len(reading))
		reading = string.sub(reading, 1, base + 30) .. IllHexYou(a.HitboxSize) .. string.sub(reading, base + 32, string.len(reading))

		reading = string.sub(reading, 1, base + 92) .. IllHexYou(a.Type) .. string.sub(reading, base + 94, string.len(reading))
		reading = string.sub(reading, 1, base + 94) .. ThisLittleHexIsPayback(a.BuildCost) .. string.sub(reading, base + 97, string.len(reading))
		reading = string.sub(reading, 1, base + 96) .. ThisLittleHexIsPayback(a.BuildTime) .. string.sub(reading, base + 99, string.len(reading))
		reading = string.sub(reading, 1, base + 102) .. ThisLittleHexIsPayback(a.Health) .. string.sub(reading, base + 105, string.len(reading))
		reading = string.sub(reading, 1, base + 104) .. ThisLittleHexIsPayback(a.Mana) .. string.sub(reading, base + 107, string.len(reading))
		reading = string.sub(reading, 1, base + 108) .. ThisLittleHexIsPayback(a.ProjectileID) .. string.sub(reading, base + 111, string.len(reading))
		reading = string.sub(reading, 1, base + 110) .. ThisLittleHexIsPayback(a.AttackMin) .. string.sub(reading, base + 113, string.len(reading))
		local diff = math.max(a.AttackMax - a.AttackMin, 0)
		reading = string.sub(reading, 1, base + 112) .. ThisLittleHexIsPayback(diff) .. string.sub(reading, base + 115, string.len(reading))
		reading = string.sub(reading, 1, base + 115) .. IllHexYou(a.AttackWaitTime) .. string.sub(reading, base + 117, string.len(reading))
		reading = string.sub(reading, 1, base + 118) .. IllHexYou(a.Range) .. string.sub(reading, base + 120, string.len(reading))
		for j = 1, 2 do
			reading = string.sub(reading, 1, base + 121 + j) .. IllHexYou(a[string.format("Power%s", j)]) .. string.sub(reading, base + 123 + j, string.len(reading))
		end
	end
	for i = 0, 18 do
		local a = projectileTable[i + 1]
		local base = i * 112
		reading = string.sub(reading, 1, base + 19932) .. ThisLittleHexIsPayback(a.DamageMin) .. ThisLittleHexIsPayback(a.DamageMax) ..
		ThisLittleHexIsPayback(a.DamageMin) .. ThisLittleHexIsPayback(a.DamageMax) .. string.sub(reading, base + 19941, string.len(reading))
	end
	out:close()
	out = assert(io.open("testD.bin", "wb"))
	out:write(reading)
	out:close()
	fltk.fl_message("Save Complete!")
end

local function quitCallback(w)
	if (thisWindow == 1) then
		window:hide()
		return
	elseif (thisWindow == 2) then
		windowII:hide()
	end
end

local windowII

local function displayProjectiles()
	local internalTable = { "Arrow", "Shuriken", "GoldShuriken", "DarkShuriken", "CannonBall", "Laser", "EnergyBullet", "Dynamite",
		"Maraca", "Present", "Snowball", "Spear", "Bullet", "Lightning", "Rock", "Fire", "Ice", "Flail" }

	for i = 1, 9 do
		local a = projectileTable[i]
		local b = {}
		
		fltk:Fl_Button(20, 45 * (i + 2) - 90, 130, 25, internalTable[i])
		
		b.DamageMin = fltk:Fl_Value_Input(240, 45 * (i + 2) - 90, 50, 25, "Damage Min")
		b.DamageMin:labelsize(14)
		b.DamageMin:textsize(14)
		b.DamageMin:minimum(0)
		b.DamageMin:maximum(65535)
		b.DamageMin:step(5)
		b.DamageMin:value(a.DamageMin)
		
		b.DamageMax = fltk:Fl_Value_Input(390, 45 * (i + 2) - 90, 50, 25, "Damage Max")
		b.DamageMax:labelsize(14)
		b.DamageMax:textsize(14)
		b.DamageMax:minimum(0)
		b.DamageMax:maximum(65535)
		b.DamageMax:step(5)
		b.DamageMax:value(a.DamageMax)
		
		widgetTable[i] = b
	end
	for i = 10, 18 do
		local a = projectileTable[i]
		local b = {}

		fltk:Fl_Button(560, 45 * (i - 7) - 90, 130, 25, internalTable[i])
		
		b.DamageMin = fltk:Fl_Value_Input(780, 45 * (i - 7) - 90, 50, 25, "Damage Min")
		b.DamageMin:labelsize(14)
		b.DamageMin:textsize(14)
		b.DamageMin:minimum(0)
		b.DamageMin:maximum(65535)
		b.DamageMin:step(5)
		b.DamageMin:value(a.DamageMin)
		
		b.DamageMax = fltk:Fl_Value_Input(930, 45 * (i - 7) - 90, 50, 25, "Damage Max")
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
		["H_Base"] = 0,
		["H_LevelOne"] = 1,
		["H_LevelTwo"] = 2,
		["E_H_Base"] = 0,
		["E_H_LevelOne"] = 1,
		["E_H_LevelTwo"] = 2,
		["S_H_Base"] = 0,
		["S_H_LevelOne"] = 1,
		["S_H_LevelTwo"] = 2,
		["Builders"] = 3,
		["Keep"] = 4,
		["Mill"] = 5,
		["Mine"] = 6,
		["Barracks"] = 7,
		["T_Default"] = 10,
		["T_Fire"] = 11,
		["T_Ice"] = 12,
		["T_Lightning"] = 13,
		["T_Earth"] = 14,
		["Dragons"] = 17,
		["Minions"] = 18,
		["Extras"] = -1
	}
	switchType = w:user_data()
	
	if (thisWindow == 1) then
		windowII = fltk:Fl_Double_Window(0, 0, 4000, 3000, "Entities Editor")
	elseif (thisWindow == 2) then
		window = fltk:Fl_Double_Window(0, 0, 4000, 3000, "Entities Editor")
	end
	local menuBar = fltk:Fl_Menu_Bar(0, 0, 750, 25)

	menuBar:add("Save", nil, saveCallback)
	menuBar:add("Heroes/Base", nil, switchCallback, "H_Base")
	menuBar:add("Heroes/Level I", nil, switchCallback, "H_LevelOne")
	menuBar:add("Heroes/Level II", nil, switchCallback, "H_LevelTwo")
	menuBar:add("E_Heroes/Base", nil, switchCallback, "E_H_Base")
	menuBar:add("E_Heroes/Level I", nil, switchCallback, "E_H_LevelOne")
	menuBar:add("E_Heroes/Level II", nil, switchCallback, "E_H_LevelTwo")
	menuBar:add("S_Heroes/Base", nil, switchCallback, "S_H_Base")
	menuBar:add("S_Heroes/Level I", nil, switchCallback, "S_H_LevelOne")
	menuBar:add("S_Heroes/Level II", nil, switchCallback, "S_H_LevelTwo")
	menuBar:add("Builders", nil, switchCallback, "Builders")
	menuBar:add("Dragons", nil, switchCallback, "Dragons")
	menuBar:add("Minions", nil, switchCallback, "Minions")
	menuBar:add("Buildings/Keep", nil, switchCallback, "Keep")
	menuBar:add("Buildings/Mill", nil, switchCallback, "Mill")
	menuBar:add("Buildings/Mine", nil, switchCallback, "Mine")
	menuBar:add("Buildings/Barracks", nil, switchCallback, "Barracks")
	menuBar:add("Towers/Default", nil, switchCallback, "T_Default")
	menuBar:add("Towers/Fire", nil, switchCallback, "T_Fire")
	menuBar:add("Towers/Ice", nil, switchCallback, "T_Ice")
	menuBar:add("Towers/Lightning", nil, switchCallback, "T_Lightning")
	menuBar:add("Towers/Earth", nil, switchCallback, "T_Earth")
	menuBar:add("Extras", nil, switchCallback, "Extras")
	menuBar:add("Projectiles", nil, switchCallback, "Projectiles")
	
	local quitButton = fltk:Fl_Button(1485, 0, 50, 25, "Exit")
	quitButton:callback(quitCallback)

	if (switchType == "Projectiles") then
		displayProjectiles()
		return
	end

	tempPeople = {}
	for i = 1, #unitTable do
		if (unitTable[i].Type == typeMapping[switchType]) then
			if (string.sub(switchType, 1, 2) == "H_") then
				if (unitTable[i].ID < 79) then
					tempPeople[#tempPeople + 1] = unitTable[i]
				end
			elseif (string.sub(switchType, 1, 2) == "E_") then
				if (unitTable[i].ID >= 79) and (unitTable[i].ID < 129) then
					tempPeople[#tempPeople + 1] = unitTable[i]
				end
			elseif (string.sub(switchType, 1, 2) == "S_") then
				if (unitTable[i].ID >= 129) then
					tempPeople[#tempPeople + 1] = unitTable[i]
				end			
			else
				tempPeople[#tempPeople + 1] = unitTable[i]
			end
		end
	end
	
	table.sort(tempPeople, function(k1, k2) return k1.ID < k2.ID end)

	if (switchType == "Extras") then
		for i = 1, #unitTable do
			if (unitTable[i].Type == 8) or (unitTable[i].Type == 9) or (unitTable[i].Type == 15) or (unitTable[i].Type == 16) then
				tempPeople[#tempPeople + 1] = unitTable[i]
			end
		end
	end

	local index = 1
	for k, v in pairs(tempPeople) do
		index = index + 1
		local button = fltk:Fl_Button(0, 45 * (index + 2) - 135, 130, 25, nameTable[v.ID + 1])
	end
	local group = fltk:Fl_Scroll(140, 25, 1400, 750, "")
	group:box(fltk.FL_THIN_UP_BOX)
	
	local check = 1
	for k, v in pairs(tempPeople) do
		check = check + 1
		yPosition = 45 * (check + 2) - 135
		local a = v
		local b = {}
		local theValue = "???"
		local theTable = {}
		
		b.FakeButton = fltk:Fl_Button(135, yPosition, 0, 25, "")

		local tpos = 185
		
		b.Speed = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Speed")
		b.Speed:minimum(0)
		b.Speed:maximum(255)
		b.Speed:step(5)
		b.Speed:value(a.Speed)
		
		tpos = tpos + 100
		b.LandFlag = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Land")
		b.LandFlag:down_box(fltk.FL_BORDER_BOX)
		b.LandFlag:labelsize(14)
		b.LandFlag:textsize(14)
		theTable = { "Off", "On" }
		for j = 1, #theTable do
			b.LandFlag:add(theTable[j])
		end
		b.LandFlag:value(a.LandFlag)
		
		tpos = tpos + 100
		b.WaterFlag = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Water")
		b.WaterFlag:down_box(fltk.FL_BORDER_BOX)
		b.WaterFlag:labelsize(14)
		b.WaterFlag:textsize(14)
		theTable = { "Off", "On" }
		for j = 1, #theTable do
			b.WaterFlag:add(theTable[j])
		end
		b.WaterFlag:value(a.WaterFlag)
		
		tpos = tpos + 100
		b.TreeCrossFlag = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Trees")
		b.TreeCrossFlag:down_box(fltk.FL_BORDER_BOX)
		b.TreeCrossFlag:labelsize(14)
		b.TreeCrossFlag:textsize(14)
		theTable = { "Off", "On" }
		for j = 1, #theTable do
			b.TreeCrossFlag:add(theTable[j])
		end
		b.TreeCrossFlag:value(a.TreeCrossFlag)
		
		tpos = tpos + 150
		b.BuildingHitFlag = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Hits Buildings")
		b.BuildingHitFlag:down_box(fltk.FL_BORDER_BOX)
		b.BuildingHitFlag:labelsize(14)
		b.BuildingHitFlag:textsize(14)
		theTable = { "Off", "On" }
		for j = 1, #theTable do
			b.BuildingHitFlag:add(theTable[j])
		end
		b.BuildingHitFlag:value(a.BuildingHitFlag)
		
		tpos = tpos + 165
		b.BoundaryCrossFlag = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Crosses Terrain")
		b.BoundaryCrossFlag:down_box(fltk.FL_BORDER_BOX)
		b.BoundaryCrossFlag:labelsize(14)
		b.BoundaryCrossFlag:textsize(14)
		theTable = { "Off", "On" }
		for j = 1, #theTable do
			b.BoundaryCrossFlag:add(theTable[j])
		end
		b.BoundaryCrossFlag:value(a.BoundaryCrossFlag)

		tpos = tpos + 130
		b.HitboxSize = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Hitbox Size")
		b.HitboxSize:labelsize(14)
		b.HitboxSize:textsize(14)
		b.HitboxSize:minimum(0)
		b.HitboxSize:maximum(255)
		b.HitboxSize:step(5)
		b.HitboxSize:value(a.HitboxSize)
		
		tpos = tpos + 100
		b.Type = fltk:Fl_Choice(tpos, yPosition, 75, 25, "Type")
		b.Type:down_box(fltk.FL_BORDER_BOX)
		b.Type:labelsize(14)
		b.Type:textsize(14)
		theTable = typeTable
		for j = 1, #theTable do
			b.Type:add(theTable[j])
		end
		if (a.Type == 255) then
			b.Type:value(19)
		else
			b.Type:value(a.Type)
		end
		
		tpos = tpos + 160
		b.BuildCost = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Build Cost")
		b.BuildCost:labelsize(14)
		b.BuildCost:textsize(14)
		b.BuildCost:minimum(0)
		b.BuildCost:maximum(65535)
		b.BuildCost:step(5)
		b.BuildCost:value(a.BuildCost)
		
		tpos = tpos + 135
		b.BuildTime = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Build Time")
		b.BuildTime:labelsize(14)
		b.BuildTime:textsize(14)
		b.BuildTime:minimum(0)
		b.BuildTime:maximum(65535)
		b.BuildTime:step(5)
		b.BuildTime:value(a.BuildTime)
		
		tpos = tpos + 110
		b.Health = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Health")
		b.Health:labelsize(14)
		b.Health:textsize(14)
		b.Health:minimum(0)
		b.Health:maximum(65535)
		b.Health:step(5)
		b.Health:value(a.Health)
		
		tpos = tpos + 105
		b.Mana = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Mana")
		b.Mana:labelsize(14)
		b.Mana:textsize(14)
		b.Mana:minimum(0)
		b.Mana:maximum(65535)
		b.Mana:step(5)
		b.Mana:value(a.Mana)
		
		tpos = tpos + 130
		b.ProjectileID = fltk:Fl_Choice(tpos, yPosition, 80, 25, "Projectile")
		b.ProjectileID:down_box(fltk.FL_BORDER_BOX)
		b.ProjectileID:labelsize(14)
		b.ProjectileID:textsize(14)
		theTable = { "Arrow", "Shuriken", "GoldShuriken", "DarkShuriken", "CannonBall", "Laser", "EnergyBullet", "Dynamite",
		"Maraca", "Present", "Snowball", "Spear", "Bullet", "Lightning", "Rock", "Fire", "Ice", "Flail", "NONE" }
		for j = 1, #theTable do
			b.ProjectileID:add(theTable[j])
		end
		if (a.ProjectileID == 65535) then
			b.ProjectileID:value(18)
		else
			b.ProjectileID:value(a.ProjectileID - 154)
		end

		tpos = tpos + 165
		b.AttackMin = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Attack Min")
		b.AttackMin:labelsize(14)
		b.AttackMin:textsize(14)
		b.AttackMin:minimum(0)
		b.AttackMin:maximum(65535)
		b.AttackMin:step(5)
		b.AttackMin:value(a.AttackMin)
		
		tpos = tpos + 140
		b.AttackMax = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Attack Max")
		b.AttackMax:labelsize(14)
		b.AttackMax:textsize(14)
		b.AttackMax:minimum(0)
		b.AttackMax:maximum(65535)
		b.AttackMax:step(5)
		b.AttackMax:value(a.AttackMax)
		
		tpos = tpos + 160
		b.AttackWaitTime = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Attack Interval")
		b.AttackWaitTime:labelsize(14)
		b.AttackWaitTime:textsize(14)
		b.AttackWaitTime:minimum(0)
		b.AttackWaitTime:maximum(255)
		b.AttackWaitTime:step(5)
		b.AttackWaitTime:value(a.AttackWaitTime)
		
		tpos = tpos + 115
		b.Range = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Range")
		b.Range:labelsize(14)
		b.Range:textsize(14)
		b.Range:minimum(0)
		b.Range:maximum(255)
		b.Range:step(5)
		b.Range:value(a.Range)
		
		for j = 1, 2 do
			b[string.format("Power%s", j)] = fltk:Fl_Choice(tpos - 25 + j * 140, yPosition, 75, 25, string.format("Power%s", j))
			b[string.format("Power%s", j)]:down_box(fltk.FL_BORDER_BOX)
			b[string.format("Power%s", j)]:labelsize(14)
			b[string.format("Power%s", j)]:textsize(14)
			theTable = {
				"NONE",
				"Army Heal",
				"Armor Powerup",
				"Arrow Volley",
				"Artillery",
				"Attack Powerup",
				"Balloon Animal Attack",
				"Boulder Toss",
				"Burn Out",
				"Charge",
				"Charm",
				"Cleanse",
				"Cluster Bomb",
				"Crab Swarm",
				"Dead Eye",
				"Dispel",
				"ESP Attack",
				"Evil Eye",
				"Fiery Touch",
				"Fire Works",
				"Flash Bang",
				"Grenade",
				"Group Heal",
				"Joust",
				"Blueprint Missing Name!",
				"Lightning Bolt",
				"Magic Steal",
				"Meteor Shower",
				"Mining Buff",
				"Ninja Attack",
				"Pierce",
				"Possess",
				"Projectile Attack",
				"Quicksand",
				"Rally Cry",
				"Ravage",
				"Roar",
				"Scorpion Swarm",
				"Screech",
				"Silence",
				"Siren",
				"Slap",
				"Space Laser",
				"Speed Buff",
				"Sp. Blizzard",
				"Sp. Brush Fire",
				"Sp. Chain Lightning",
				"Sp. Deep Freeze",
				"Sp. Dust Storm",
				"Sp. Earthquake",
				"Sp. Electroshock",
				"Sp. Fire Ring",
				"Sp. Helping Hand",
				"Sp. Target Attack",
				"Stealth",
				"Stone Skin",
				"Third Eye",
				"Tracking",
				"Triple Attack",
				"Triple Shot",
				"Vision Plus"
			}
			for x, y in pairs(theTable) do
				b[string.format("Power%s", j)]:add(theTable[x])
			end
			b[string.format("Power%s", j)]:value(a[string.format("Power%s", j)])
		end

		for key, value in pairs(b) do
			group:add(value)
		end
		b.ID = a.ID
		widgetTable[check] = b
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

for i = 0, 153 do 
	local a = {}
	local base = i * 128
	a.TypeDiff = "False"
	a.ID = NothingICantHandle(base + 9, base + 10)
	a.Speed = NothingICantHandle(base + 18)
	a.BoatAntiFlag = NothingICantHandle(base + 24)
	a.LandFlag = NothingICantHandle(base + 25)
	a.WaterFlag = NothingICantHandle(base + 26)
	a.TreeCrossFlag = NothingICantHandle(base + 27)
	a.BuildingHitFlag = NothingICantHandle(base + 28)
	a.BoundaryCrossFlag = NothingICantHandle(base + 29)
	a.BridgeFlag = NothingICantHandle(base + 30)
	a.HitboxSize = NothingICantHandle(base + 31)
	a.Type = NothingICantHandle(base + 93)
	a.BuildCost = NothingICantHandle(base + 95, base + 96)
	a.BuildTime = NothingICantHandle(base + 97, base + 98)
	a.Health = NothingICantHandle(base + 103, base + 104)
	a.Mana = NothingICantHandle(base + 105, base + 106)
	a.ProjectileID = NothingICantHandle(base + 109, base + 110)
	a.AttackMin = NothingICantHandle(base + 111, base + 112)
	a.AttackMax = a.AttackMin + NothingICantHandle(base + 113, base + 114)
	a.AttackWaitTime = NothingICantHandle(base + 116)
	a.Range = NothingICantHandle(base + 119)
	a.Power1 = NothingICantHandle(base + 123)
	a.Power2 = NothingICantHandle(base + 124)
	unitTable[i + 1] = a
end
for i = 0, 18 do
	projectileTable[i + 1] = {}
	local base = i * 112
	projectileTable[i + 1].ID = NothingICantHandle(base + 19837, base + 19838)
	projectileTable[i + 1].DamageMin = NothingICantHandle(base + 19937, base + 19938)
	projectileTable[i + 1].DamageMax = NothingICantHandle(base + 19939, base + 19940)
end

local menuBar = fltk:Fl_Menu_Bar(0, 0, 750, 25)

menuBar:add("Save", nil, saveCallback)
menuBar:add("Heroes/Base", nil, switchCallback, "H_Base")
menuBar:add("Heroes/Level I", nil, switchCallback, "H_LevelOne")
menuBar:add("Heroes/Level II", nil, switchCallback, "H_LevelTwo")
menuBar:add("E_Heroes/Base", nil, switchCallback, "E_H_Base")
menuBar:add("E_Heroes/Level I", nil, switchCallback, "E_H_LevelOne")
menuBar:add("E_Heroes/Level II", nil, switchCallback, "E_H_LevelTwo")
menuBar:add("S_Heroes/Base", nil, switchCallback, "S_H_Base")
menuBar:add("S_Heroes/Level I", nil, switchCallback, "S_H_LevelOne")
menuBar:add("S_Heroes/Level II", nil, switchCallback, "S_H_LevelTwo")
menuBar:add("Builders", nil, switchCallback, "Builders")
menuBar:add("Dragons", nil, switchCallback, "Dragons")
menuBar:add("Minions", nil, switchCallback, "Minions")
menuBar:add("Buildings/Keep", nil, switchCallback, "Keep")
menuBar:add("Buildings/Mill", nil, switchCallback, "Mill")
menuBar:add("Buildings/Mine", nil, switchCallback, "Mine")
menuBar:add("Buildings/Barracks", nil, switchCallback, "Barracks")
menuBar:add("Towers/Default", nil, switchCallback, "T_Default")
menuBar:add("Towers/Fire", nil, switchCallback, "T_Fire")
menuBar:add("Towers/Ice", nil, switchCallback, "T_Ice")
menuBar:add("Towers/Lightning", nil, switchCallback, "T_Lightning")
menuBar:add("Towers/Earth", nil, switchCallback, "T_Earth")
menuBar:add("Extras", nil, switchCallback, "Extras")
menuBar:add("Projectiles", nil, switchCallback, "Projectiles")

local quitButton = fltk:Fl_Button(1485, 0, 50, 25, "Exit")
quitButton:callback(quitCallback)
	
window:show()
Fl:run()