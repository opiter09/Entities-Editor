local window = fltk:Fl_Double_Window(0, 0, 4000, 3000, "Entities Editor")
local thisWindow = 1
local unitTable = {}
local projectileTable = {}

screenWidth = Fl:w()
screenHeight = Fl:h()

local doc = assert(io.open("namesTilde.txt", "rb"))
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
	local inputFile = assert(io.open(arg[1], "rb"))
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
local typeTable = {
	"Hero",
	"Builder",
	"Melee",
	"Ranged",
	"Mounted",
	"Transport",
	"Special",
	"Castle",
	"Lumber Mill",
	"Mine",
	"Farm",
	"Barracks",
	"Factory",
	"Tower I",
	"Tower II",
	"Tower III",
	"Shipyard",
	"Bridge",
	"Gate",
	"Wall",
	"Other"
}
local widgetTable = {}
local switchType = 0

local function saveCallback(w)
	if (switchType ~= 0) and (widgetTable ~= nil) then
		for k, v in pairs(widgetTable) do
			if ((switchType ~= "Projectiles1") and (switchType ~= "Projectiles2")) then
				for key, value in pairs(unitTable) do
					if (v.ID == value.ID) then
						if (speedTable[v.Speed:value() + 1] == "NONE") then
							value.Speed = 65535
						else
							value.Speed = tonumber(string.sub(speedTable[v.Speed:value() + 1], 1, 3))
						end
						value.LandFlag = v.LandFlag:value()
						value.WaterFlag = v.WaterFlag:value()
						value.TreeCrossFlag = v.TreeCrossFlag:value()
						value.HitboxSize = v.HitboxSize:value()
						value.UninteractableFlag = v.UninteractableFlag:value()
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
						if (v.ProjectileID:value() == 25) then
							value.ProjectileID = 65535
						else
							value.ProjectileID = v.ProjectileID:value() + 182
							v.AttackMin:value(0)
							v.AttackMax:value(0)
						end
						value.AttackMin = v.AttackMin:value()
						v.AttackMax:value(math.max(v.AttackMax:value(), v.AttackMin:value()))
						value.AttackMax = v.AttackMax:value()
						value.MineAmount = v.MineAmount:value()
						value.AttackWaitTime = v.AttackWaitTime:value()
						value.Range = v.Range:value()
						value.Priority = v.Priority:value()
						value.FogDispel = v.FogDispel:value()
						value.Power1 = v.Power1:value()
						if (v.Power1:value() == 34) then
							value.Power1 = 255
						end
						value.Power2 = v.Power2:value()
						if (v.Power2:value() == 34) then
							value.Power2 = 255
						end
						value.Power3 = v.Power3:value()
						if (v.Power3:value() == 34) then
							value.Power3 = 255
						end
						value.Power4 = v.Power4:value()
						if (v.Power4:value() == 34) then
							value.Power4 = 255
						end
						value.Power5 = v.Power5:value()
						if (v.Power5:value() == 34) then
							value.Power5 = 255
						end
					end
				end
			end
		end
		if ((switchType == "Projectiles1") or (switchType == "Projectiles2")) then
			if (switchType == "Projectiles1") then
				col = 0
			else
				col = 1
			end

			for i = 1, (13 - col) do
				projectileTable[i + (13 * col)].Unknown1 = widgetTable[i].Unknown1:value()
				projectileTable[i + (13 * col)].Unknown2 = widgetTable[i].Unknown2:value()
				projectileTable[i + (13 * col)].Constant1 = widgetTable[i].Constant1:value()
				projectileTable[i + (13 * col)].Arc = widgetTable[i].Arc:value() + 6
				projectileTable[i + (13 * col)].OverWalls1 = widgetTable[i].OverWalls1:value()
				projectileTable[i + (13 * col)].Constant2 = widgetTable[i].Constant2:value()
				projectileTable[i + (13 * col)].Piercing = widgetTable[i].Piercing:value()
				projectileTable[i + (13 * col)].Constant3 = widgetTable[i].Constant3:value()
				projectileTable[i + (13 * col)].OverTrees = widgetTable[i].OverTrees:value()
				projectileTable[i + (13 * col)].OverBuildings = widgetTable[i].OverBuildings:value()
				projectileTable[i + (13 * col)].Constant4 = widgetTable[i].Constant4:value()
				projectileTable[i + (13 * col)].OverUnits = widgetTable[i].OverUnits:value()
				projectileTable[i + (13 * col)].OverWalls2 = widgetTable[i].OverWalls2:value()
				projectileTable[i + (13 * col)].Constant5 = widgetTable[i].Constant5:value()
				projectileTable[i + (13 * col)].Explosive = widgetTable[i].Explosive:value()

				projectileTable[i + (13 * col)].DamageMin1 = widgetTable[i].DamageMin1:value()
				widgetTable[i].DamageMax1:value(math.max(widgetTable[i].DamageMax1:value(), widgetTable[i].DamageMin1:value()))
				projectileTable[i + (13 * col)].DamageMax1 = widgetTable[i].DamageMax1:value()

				projectileTable[i + (13 * col)].DamageMin2 = widgetTable[i].DamageMin2:value()
				widgetTable[i].DamageMax2:value(math.max(widgetTable[i].DamageMax2:value(), widgetTable[i].DamageMin2:value()))
				projectileTable[i + (13 * col)].DamageMax2 = widgetTable[i].DamageMax2:value()
			end
		end
	end

	local out = assert(io.open(arg[1], "rb"))
	local reading = out:read("*all")
	for i = 0, 181 do
		local a = unitTable[i + 1]
		local base = i * 124
		reading = string.sub(reading, 1, base + 8) .. ThisLittleHexIsPayback(a.ID) .. string.sub(reading, base + 11, string.len(reading))
		reading = string.sub(reading, 1, base + 16) .. ThisLittleHexIsPayback(a.Speed) .. string.sub(reading, base + 19, string.len(reading))
		local leTable = { 3, 2, 3, 4, 3, 6, 5, 7, 0, 8, 0, 7, 7, 4, 4, 4, 7, 0, 0, 10 }
		leTable[256] = 255
		if (a.ID == 27) then
			reading = string.sub(reading, 1, base + 24) .. IllHexYou(4) .. string.sub(reading, base + 26, string.len(reading))
		elseif (a.ID < 129) or (a.TypeDiff == "True") then
			reading = string.sub(reading, 1, base + 24) .. IllHexYou(leTable[a.Type + 1]) .. string.sub(reading, base + 26, string.len(reading))
		end
		if (a.WaterFlag == 1) and (a.LandFlag == 0) then
			a.BoatAntiFlag = 0
		end
		if (a.WaterFlag == 1) and (a.LandFlag == 1) and (a.Speed ~= 65535) then
			a.BoundaryCrossFlag = 1
			a.BuildingHitFlag = 0
		elseif (a.Speed ~= 65535) then
			a.BoundaryCrossFlag = 0
			a.BuildingHitFlag = 1		
		end
		reading = string.sub(reading, 1, base + 26) .. IllHexYou(a.BoatAntiFlag) .. string.sub(reading, base + 28, string.len(reading))		
		reading = string.sub(reading, 1, base + 27) .. IllHexYou(a.LandFlag) .. string.sub(reading, base + 29, string.len(reading))
		reading = string.sub(reading, 1, base + 28) .. IllHexYou(a.WaterFlag) .. string.sub(reading, base + 30, string.len(reading))
		reading = string.sub(reading, 1, base + 29) .. IllHexYou(a.TreeCrossFlag) .. string.sub(reading, base + 31, string.len(reading))
		reading = string.sub(reading, 1, base + 30) .. IllHexYou(a.BuildingHitFlag) .. string.sub(reading, base + 32, string.len(reading))
		reading = string.sub(reading, 1, base + 31) .. IllHexYou(a.BoundaryCrossFlag) .. string.sub(reading, base + 33, string.len(reading))
		if (a.Type == 17) or (a.Type == 18) then
			a.BridgeFlag = 1
		else
			a.BridgeFlag = 0
		end
		reading = string.sub(reading, 1, base + 32) .. IllHexYou(a.BridgeFlag) .. string.sub(reading, base + 34, string.len(reading))
		reading = string.sub(reading, 1, base + 33) .. IllHexYou(a.HitboxSize) .. string.sub(reading, base + 35, string.len(reading))
		reading = string.sub(reading, 1, base + 37) .. IllHexYou(a.UninteractableFlag) .. string.sub(reading, base + 39, string.len(reading))

		reading = string.sub(reading, 1, base + 96) .. IllHexYou(a.Type) .. string.sub(reading, base + 98, string.len(reading))
		reading = string.sub(reading, 1, base + 98) .. ThisLittleHexIsPayback(a.BuildCost) .. string.sub(reading, base + 101, string.len(reading))
		reading = string.sub(reading, 1, base + 100) .. ThisLittleHexIsPayback(a.BuildTime) .. string.sub(reading, base + 103, string.len(reading))
		reading = string.sub(reading, 1, base + 102) .. ThisLittleHexIsPayback(a.Health) .. string.sub(reading, base + 105, string.len(reading))
		reading = string.sub(reading, 1, base + 104) .. ThisLittleHexIsPayback(a.Mana) .. string.sub(reading, base + 107, string.len(reading))
		reading = string.sub(reading, 1, base + 106) .. ThisLittleHexIsPayback(a.ProjectileID) .. string.sub(reading, base + 109, string.len(reading))
		reading = string.sub(reading, 1, base + 108) .. ThisLittleHexIsPayback(a.AttackMin) .. string.sub(reading, base + 111, string.len(reading))
		local diff = math.max(a.AttackMax - a.AttackMin, 0)
		reading = string.sub(reading, 1, base + 110) .. ThisLittleHexIsPayback(diff) .. string.sub(reading, base + 113, string.len(reading))
		reading = string.sub(reading, 1, base + 112) .. IllHexYou(a.MineAmount) .. string.sub(reading, base + 114, string.len(reading))
		reading = string.sub(reading, 1, base + 113) .. IllHexYou(a.AttackWaitTime) .. string.sub(reading, base + 115, string.len(reading))
		reading = string.sub(reading, 1, base + 115) .. IllHexYou(a.Range) .. string.sub(reading, base + 117, string.len(reading))
		reading = string.sub(reading, 1, base + 116) .. IllHexYou(a.Priority) .. string.sub(reading, base + 118, string.len(reading))
		reading = string.sub(reading, 1, base + 117) .. IllHexYou(a.FogDispel) .. string.sub(reading, base + 119, string.len(reading))
		for j = 1, 5 do
			reading = string.sub(reading, 1, base + 118 + j) .. IllHexYou(a[string.format("Power%s", j)]) .. string.sub(reading, base + 120 + j, string.len(reading))
		end
	end
	for i = 0, 24 do
		local a = projectileTable[i + 1]
		local base = i * 116
		reading = string.sub(reading, 1, base + 22584) .. IllHexYou(a.Unknown1) .. string.sub(reading, base + 22586, string.len(reading))
		reading = string.sub(reading, 1, base + 22585) .. IllHexYou(a.Unknown2) .. string.sub(reading, base + 22587, string.len(reading))
		reading = string.sub(reading, 1, base + 22592) .. IllHexYou(a.Constant1) .. string.sub(reading, base + 22594, string.len(reading))
		reading = string.sub(reading, 1, base + 22593) .. IllHexYou(a.Arc) .. string.sub(reading, base + 22595, string.len(reading))
		reading = string.sub(reading, 1, base + 22669) .. IllHexYou(a.OverWalls1) .. string.sub(reading, base + 22671, string.len(reading))
		reading = string.sub(reading, 1, base + 22670) .. IllHexYou(a.Constant2) .. string.sub(reading, base + 22672, string.len(reading))
		reading = string.sub(reading, 1, base + 22671) .. IllHexYou(a.Piercing) .. string.sub(reading, base + 22673, string.len(reading))
		reading = string.sub(reading, 1, base + 22672) .. IllHexYou(a.Constant3) .. string.sub(reading, base + 22674, string.len(reading))
		reading = string.sub(reading, 1, base + 22673) .. IllHexYou(a.OverTrees) .. string.sub(reading, base + 22675, string.len(reading))
		reading = string.sub(reading, 1, base + 22674) .. IllHexYou(a.OverBuildings) .. string.sub(reading, base + 22676, string.len(reading))
		reading = string.sub(reading, 1, base + 22675) .. IllHexYou(a.Constant4) .. string.sub(reading, base + 22677, string.len(reading))
		reading = string.sub(reading, 1, base + 22676) .. IllHexYou(a.OverUnits) .. string.sub(reading, base + 22678, string.len(reading))
		reading = string.sub(reading, 1, base + 22677) .. IllHexYou(a.OverWalls2) .. string.sub(reading, base + 22679, string.len(reading))
		reading = string.sub(reading, 1, base + 22678) .. IllHexYou(a.Constant5) .. string.sub(reading, base + 22680, string.len(reading))
		reading = string.sub(reading, 1, base + 22679) .. IllHexYou(a.Explosive) .. string.sub(reading, base + 22681, string.len(reading))
		reading = string.sub(reading, 1, base + 22680) .. ThisLittleHexIsPayback(a.DamageMin1) .. ThisLittleHexIsPayback(a.DamageMax1) ..
		ThisLittleHexIsPayback(a.DamageMin2) .. ThisLittleHexIsPayback(a.DamageMax2) .. string.sub(reading, base + 22689, string.len(reading))
	end
	out:close()
	out = assert(io.open(arg[1], "wb"))
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

local function displayProjectiles(col)
	local internalTable = { "Arrow", "CrossbowBolt", "TBolt", "TBoulder", "TFireball", "BallistaBolt", "SiegeBolt", "Boulder", "OgreBoulder", 
		"Fireball", "ImperialShot", "PirateShot", "TPirateShot", "ICannonBall", "PCannonBall", "Elaser", "ALaser", "PlasmaBall",
		"LaserCannon", "ProjectileSpell", "AirBallistaBolt", "AirFireball", "AirLaser", "Gift", "ProjectileNoEffect" }
	for i = 1, (13 - col) do
		fltk:Fl_Button(0, 45 * (i + 3) - 135, 130, 25, internalTable[(i + (col * 13))])
	end
		
	local group = fltk:Fl_Scroll(140, 25, 1400, math.floor(screenHeight * 0.92), "")
	group:box(fltk.FL_THIN_UP_BOX)
	
	local check = 1
	for i = 1, (13 - col) do
		local a = projectileTable[(i + (col * 13))]
		local b = {}
		
		check = check + 1
		yPosition = 45 * (check + 2) - 135
		b.FakeButton = fltk:Fl_Button(135, yPosition, 0, 25, "")
		local tpos = 220
		
		b.Unknown1 = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Unknown 1")
		b.Unknown1:labelsize(14)
		b.Unknown1:textsize(14)
		b.Unknown1:minimum(0)
		b.Unknown1:maximum(255)
		b.Unknown1:step(5)
		b.Unknown1:value(a.Unknown1)
		
		tpos = tpos + 140
		b.Unknown2 = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Unknown 2")
		b.Unknown2:labelsize(14)
		b.Unknown2:textsize(14)
		b.Unknown2:minimum(0)
		b.Unknown2:maximum(255)
		b.Unknown2:step(5)
		b.Unknown2:value(a.Unknown2)
		
		tpos = tpos + 140
		b.Constant1 = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Constant 1")
		b.Constant1:labelsize(14)
		b.Constant1:textsize(14)
		b.Constant1:minimum(0)
		b.Constant1:maximum(255)
		b.Constant1:step(5)
		b.Constant1:value(a.Constant1)
		
		tpos = tpos + 100
		b.Arc = fltk:Fl_Choice(tpos, yPosition, 100, 25, "Arc")
		b.Arc:down_box(fltk.FL_BORDER_BOX)
		b.Arc:labelsize(14)
		b.Arc:textsize(14)
		theTable = { "Straight", "Unknown", "Lob" }
		for j = 1, #theTable do
			b.Arc:add(theTable[j])
			if (a.Arc == (j + 5)) then
				theValue = j - 1
			end
		end
		b.Arc:value(theValue)
		
		tpos = tpos + 200
		b.OverWalls1 = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Over Walls 1")
		b.OverWalls1:down_box(fltk.FL_BORDER_BOX)
		b.OverWalls1:labelsize(14)
		b.OverWalls1:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.OverWalls1:add(theTable[j])
		end
		b.OverWalls1:value(a.OverWalls1)
		
		tpos = tpos + 150
		b.Constant2 = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Constant 2")
		b.Constant2:down_box(fltk.FL_BORDER_BOX)
		b.Constant2:labelsize(14)
		b.Constant2:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.Constant2:add(theTable[j])
		end
		b.Constant2:value(a.Constant2)
		
		tpos = tpos + 140
		b.Piercing = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Piercing")
		b.Piercing:down_box(fltk.FL_BORDER_BOX)
		b.Piercing:labelsize(14)
		b.Piercing:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.Piercing:add(theTable[j])
		end
		b.Piercing:value(a.Piercing)
		
		tpos = tpos + 150
		b.Constant3 = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Constant 3")
		b.Constant3:down_box(fltk.FL_BORDER_BOX)
		b.Constant3:labelsize(14)
		b.Constant3:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.Constant3:add(theTable[j])
		end
		b.Constant3:value(a.Constant3)
		
		tpos = tpos + 160
		b.OverTrees = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Over Trees")
		b.OverTrees:down_box(fltk.FL_BORDER_BOX)
		b.OverTrees:labelsize(14)
		b.OverTrees:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.OverTrees:add(theTable[j])
		end
		b.OverTrees:value(a.OverTrees)
		
		tpos = tpos + 180
		b.OverBuildings = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Over Buildings")
		b.OverBuildings:down_box(fltk.FL_BORDER_BOX)
		b.OverBuildings:labelsize(14)
		b.OverBuildings:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.OverBuildings:add(theTable[j])
		end
		b.OverBuildings:value(a.OverBuildings)
		
		tpos = tpos + 160
		b.Constant4 = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Constant 4")
		b.Constant4:down_box(fltk.FL_BORDER_BOX)
		b.Constant4:labelsize(14)
		b.Constant4:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.Constant4:add(theTable[j])
		end
		b.Constant4:value(a.Constant4)
		
		tpos = tpos + 140
		b.OverUnits = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Over Units")
		b.OverUnits:down_box(fltk.FL_BORDER_BOX)
		b.OverUnits:labelsize(14)
		b.OverUnits:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.OverUnits:add(theTable[j])
		end
		b.OverUnits:value(a.OverUnits)
		
		tpos = tpos + 160
		b.OverWalls2 = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Over Walls 2")
		b.OverWalls2:down_box(fltk.FL_BORDER_BOX)
		b.OverWalls2:labelsize(14)
		b.OverWalls2:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.OverWalls2:add(theTable[j])
		end
		b.OverWalls2:value(a.OverWalls2)
		
		tpos = tpos + 140
		b.Constant5 = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Constant 5")
		b.Constant5:down_box(fltk.FL_BORDER_BOX)
		b.Constant5:labelsize(14)
		b.Constant5:textsize(14)
		theTable = { "On", "Off" }
		for j = 1, #theTable do
			b.Constant5:add(theTable[j])
		end
		b.Constant5:value(a.Constant5)

		tpos = tpos + 140
		b.Explosive = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Explosive")
		b.Explosive:down_box(fltk.FL_BORDER_BOX)
		b.Explosive:labelsize(14)
		b.Explosive:textsize(14)
		theTable = { "Off", "On" }
		for j = 1, #theTable do
			b.Explosive:add(theTable[j])
		end
		b.Explosive:value(a.Explosive)
		
		tpos = tpos + 160
		b.DamageMin1 = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Damage Min 1")
		b.DamageMin1:labelsize(14)
		b.DamageMin1:textsize(14)
		b.DamageMin1:minimum(0)
		b.DamageMin1:maximum(65535)
		b.DamageMin1:step(5)
		b.DamageMin1:value(a.DamageMin1)
		
		tpos = tpos + 160
		b.DamageMax1 = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Damage Max 1")
		b.DamageMax1:labelsize(14)
		b.DamageMax1:textsize(14)
		b.DamageMax1:minimum(0)
		b.DamageMax1:maximum(65535)
		b.DamageMax1:step(5)
		b.DamageMax1:value(a.DamageMax1)
		
		tpos = tpos + 160
		b.DamageMin2 = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Damage Min 2")
		b.DamageMin2:labelsize(14)
		b.DamageMin2:textsize(14)
		b.DamageMin2:minimum(0)
		b.DamageMin2:maximum(65535)
		b.DamageMin2:step(5)
		b.DamageMin2:value(a.DamageMin2)
		
		tpos = tpos + 160
		b.DamageMax2 = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Damage Max 2")
		b.DamageMax2:labelsize(14)
		b.DamageMax2:textsize(14)
		b.DamageMax2:minimum(0)
		b.DamageMax2:maximum(65535)
		b.DamageMax2:step(5)
		b.DamageMax2:value(a.DamageMax2)
		
		b.FakeButton2 = fltk:Fl_Button(tpos + 150 + math.floor((3 + (1536 - screenWidth) / 55) * 140), yPosition, 0, 25, "")
		
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
		["Holding"] = 6,
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
	menuBar:add("Special/Holding", nil, switchCallback, "Holding")
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
	menuBar:add("Projectiles/Part 1", nil, switchCallback, "Projectiles1")
	menuBar:add("Projectiles/Part 2", nil, switchCallback, "Projectiles2")
	
	local quitButton = fltk:Fl_Button(screenWidth - 50, 0, 50, 25, "Exit")
	quitButton:callback(quitCallback)

	if (switchType == "Projectiles1") then
		displayProjectiles(0)
		return
	end
	
	if (switchType == "Projectiles2") then
		displayProjectiles(1)
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
		for k, v in pairs(tempPeople) do
			if (v.ID <= 128) then
				holding[#holding + 1] = v
			end
		end
		tempPeople = holding
	elseif (switchType == "Side Factions") then
		for k, v in pairs(tempPeople) do
			if (v.ID > 128) then
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
	elseif (switchType == "Holding") then
		for k, v in pairs(tempPeople) do
			if ((math.fmod(math.abs(v.ID - 6), 20)) ~= 0) and ((math.fmod(math.abs(v.ID - 7), 20)) ~= 0) then
				if (v.ID <= 122) and ((math.fmod(math.abs(v.ID - 8), 20)) ~= 0) then
					holding[#holding + 1] = v
				end
			end
		end
		tempPeople = holding
	end
	
	if (switchType == "Extras") then
		for i = 1, #unitTable do
			if (unitTable[i].Type > 16) or (unitTable[i].BuildCost <= 1) then
				tempPeople[#tempPeople + 1] = unitTable[i]
			end
		end
	end

	local index = 1
	for k, v in pairs(tempPeople) do
		index = index + 1
		local button = fltk:Fl_Button(0, 45 * (index + 2) - 135, 130, 25, nameTable[v.ID + 1])
	end
	local group = fltk:Fl_Scroll(140, 25, 1400, math.floor(screenHeight * 0.92), "")
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
		
		b.Speed = fltk:Fl_Choice(tpos, yPosition, 75, 25, "Speed")
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

		tpos = tpos + 120
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

		tpos = tpos + 130
		b.HitboxSize = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Hitbox Size")
		b.HitboxSize:labelsize(14)
		b.HitboxSize:textsize(14)
		b.HitboxSize:minimum(0)
		b.HitboxSize:maximum(255)
		b.HitboxSize:step(5)
		b.HitboxSize:value(a.HitboxSize)
		
		tpos = tpos + 160
		b.UninteractableFlag = fltk:Fl_Choice(tpos, yPosition, 50, 25, "Uninteractable")
		b.UninteractableFlag:down_box(fltk.FL_BORDER_BOX)
		b.UninteractableFlag:labelsize(14)
		b.UninteractableFlag:textsize(14)
		theTable = { "Off", "On" }
		for j = 1, #theTable do
			b.UninteractableFlag:add(theTable[j])
		end
		b.UninteractableFlag:value(a.UninteractableFlag)
		
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
			b.Type:value(20)
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
		b.Mana = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Magic")
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
		theTable = { "Arrow", "CrossbowBolt", "TBolt", "TBoulder", "TFireball", "BallistaBolt", "SiegeBolt", "Boulder", "OgreBoulder", 
		"Fireball", "ImperialShot", "PirateShot", "TPirateShot", "ICannonBall", "PCannonBall", "Elaser", "ALaser", "PlasmaBall",
		"LaserCannon", "ProjectileSpell", "AirBallistaBolt", "AirFireball", "AirLaser", "Gift", "ProjectileNoEffect", "NONE" }
		for j = 1, #theTable do
			b.ProjectileID:add(theTable[j])
		end
		b.ProjectileID:value(a.ProjectileID - 182)
		if (a.ProjectileID == 65535) then
			b.ProjectileID:value(25)
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
		
		tpos = tpos + 150
		b.MineAmount = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Mine Payout")
		b.MineAmount:labelsize(14)
		b.MineAmount:textsize(14)
		b.MineAmount:minimum(0)
		b.MineAmount:maximum(255)
		b.MineAmount:step(5)
		b.MineAmount:value(a.MineAmount)
		
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
		
		tpos = tpos + 130
		b.Priority = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "AI Priority")
		b.Priority:labelsize(14)
		b.Priority:textsize(14)
		b.Priority:minimum(0)
		b.Priority:maximum(255)
		b.Priority:step(5)
		b.Priority:value(a.Priority)
		
		tpos = tpos + 165
		b.FogDispel = fltk:Fl_Value_Input(tpos, yPosition, 50, 25, "Defogged Area")
		b.FogDispel:labelsize(14)
		b.FogDispel:textsize(14)
		b.FogDispel:minimum(0)
		b.FogDispel:maximum(255)
		b.FogDispel:step(5)
		b.FogDispel:value(a.FogDispel)
		
		for j = 1, 5 do
			b[string.format("Power%s", j)] = fltk:Fl_Choice(tpos - 25 + j * 140, yPosition, 75, 25, string.format("Power%s", j))
			b[string.format("Power%s", j)]:down_box(fltk.FL_BORDER_BOX)
			b[string.format("Power%s", j)]:labelsize(14)
			b[string.format("Power%s", j)]:textsize(14)
			theTable = { "NONE", "Unit Heal [100]", "UnitHeal [100]", "Nothing", "Unit Speed Boost", "Area Speed Boost", "Unit Damage Boost",
				"Area Damage Boost", "Unit Armor Boost", "Area Armor Boost", "Forest Spawn", "Crystal Cache", "Jungle Growth", "Earthquake",
				"Fireball", "Lightning", "Thunder Hammer", "Mining Buff", "Roar", "Logging Buff", "Monkey Swarm", "Crab Swarm", "Coconut Storm",
				"Artillery", "Trade Winds", "Arrow Volley", "Teleport", "EMP", "Space Laser", "ESP", "Tracking", "Cluster Bomb", "Hot Wire",
				"Unit Heal [500]", "Unit Heal [Broken]" }
			for x, y in pairs(theTable) do
				b[string.format("Power%s", j)]:add(theTable[x])
			end
			b[string.format("Power%s", j)]:value(a[string.format("Power%s", j)])
			if (a[string.format("Power%s", j)] == 255) then
				b[string.format("Power%s", j)]:value(34)
			end
		end

		b.FakeButton2 = fltk:Fl_Button(tpos + 150 + math.floor((3 + (1536 - screenWidth) / 55) * 140), yPosition, 0, 25, "")

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

for i = 0, 181 do 
	local a = {}
	local base = i * 124
	a.TypeDiff = "False"
	a.ID = NothingICantHandle(base + 9, base + 10)
	a.Speed = NothingICantHandle(base + 17, base + 18)
	a.SideGraphic = NothingICantHandle(base + 25)
	a.BoatAntiFlag = NothingICantHandle(base + 27)
	a.LandFlag = NothingICantHandle(base + 28)
	a.WaterFlag = NothingICantHandle(base + 29)
	a.TreeCrossFlag = NothingICantHandle(base + 30)
	a.BuildingHitFlag = NothingICantHandle(base + 31)
	a.BoundaryCrossFlag = NothingICantHandle(base + 32)
	a.BridgeFlag = NothingICantHandle(base + 33)
	a.HitboxSize = NothingICantHandle(base + 34)
	a.UninteractableFlag = NothingICantHandle(base + 38)
	a.Type = NothingICantHandle(base + 97)
	a.BuildCost = NothingICantHandle(base + 99, base + 100)
	a.BuildTime = NothingICantHandle(base + 101, base + 102)
	a.Health = NothingICantHandle(base + 103, base + 104)
	a.Mana = NothingICantHandle(base + 105, base + 106)
	a.ProjectileID = NothingICantHandle(base + 107, base + 108)
	a.AttackMin = NothingICantHandle(base + 109, base + 110)
	a.AttackMax = a.AttackMin + NothingICantHandle(base + 111, base + 112)
	a.MineAmount = NothingICantHandle(base + 113)
	a.AttackWaitTime = NothingICantHandle(base + 114)
	a.Range = NothingICantHandle(base + 116)
	a.Priority = NothingICantHandle(base + 117)
	a.FogDispel = NothingICantHandle(base + 118)
	a.Power1 = NothingICantHandle(base + 120)
	a.Power2 = NothingICantHandle(base + 121)
	a.Power3 = NothingICantHandle(base + 122)
	a.Power4 = NothingICantHandle(base + 123)
	a.Power5 = NothingICantHandle(base + 124)
	unitTable[i + 1] = a
end
for i = 0, 24 do
	projectileTable[i + 1] = {}
	local base = i * 116
	projectileTable[i + 1].ID = NothingICantHandle(base + 22577, base + 22578)
	projectileTable[i + 1].Unknown1 = NothingICantHandle(base + 22585)
	projectileTable[i + 1].Unknown2 = NothingICantHandle(base + 22586)
	projectileTable[i + 1].Constant1 = NothingICantHandle(base + 22593)
	projectileTable[i + 1].Arc = NothingICantHandle(base + 22594)
	projectileTable[i + 1].OverWalls1 = NothingICantHandle(base + 22670)
	projectileTable[i + 1].Constant2 = NothingICantHandle(base + 22671)
	projectileTable[i + 1].Piercing = NothingICantHandle(base + 22672)
	projectileTable[i + 1].Constant3 = NothingICantHandle(base + 22673)
	projectileTable[i + 1].OverTrees = NothingICantHandle(base + 22674)
	projectileTable[i + 1].OverBuildings = NothingICantHandle(base + 22675)
	projectileTable[i + 1].Constant4 = NothingICantHandle(base + 22676)
	projectileTable[i + 1].OverUnits = NothingICantHandle(base + 22677)
	projectileTable[i + 1].OverWalls2 = NothingICantHandle(base + 22678)
	projectileTable[i + 1].Constant5 = NothingICantHandle(base + 22679)
	projectileTable[i + 1].Explosive = NothingICantHandle(base + 22680)
	projectileTable[i + 1].DamageMin1 = NothingICantHandle(base + 22681, base + 22682)
	projectileTable[i + 1].DamageMax1 = NothingICantHandle(base + 22683, base + 22684)
	projectileTable[i + 1].DamageMin2 = NothingICantHandle(base + 22685, base + 22686)
	projectileTable[i + 1].DamageMax2 = NothingICantHandle(base + 22687, base + 22688)
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
menuBar:add("Special/Holding", nil, switchCallback, "Holding")
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
menuBar:add("Projectiles/Part 1", nil, switchCallback, "Projectiles1")
menuBar:add("Projectiles/Part 2", nil, switchCallback, "Projectiles2")

local quitButton = fltk:Fl_Button(screenWidth - 50, 0, 50, 25, "Exit")
quitButton:callback(quitCallback)
	
window:show()
Fl:run()