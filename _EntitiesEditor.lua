local window = fltk:Fl_Window(0, 0, 1920, 1080, "Entities Editor")
local unitTable = {}
local projectileTable = {}

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

	local part1 = string.char(tonumber(string.sub(hex, 3, 4), 16))
	local part2 = string.char(tonumber(string.sub(hex, 1, 2), 16))

	hex = string.format("%s%s", part1, part2)
	return(hex)
end

local switchType = 0
local function switchCallback(w)
	switchType = w:user_data()
	--print(switchType)
end

local function saveCallback(w)
	local out = assert(io.open("testD.bin", "rb"))
	local reading = out:read("*all")
	for i = 0, 181 do
		local a = unitTable[i + 1]
		local base = i * 124 + 5
		reading = string.sub(reading, 1, base + 5) .. ThisLittleHexIsPayback(a.ID) .. string.sub(reading, base + 8, string.len(reading))
		reading = string.sub(reading, 1, base + 13) .. ThisLittleHexIsPayback(a.Speed) .. string.sub(reading, base + 16, string.len(reading))
		reading = string.sub(reading, 1, base + 24) .. IllHexYou(a.LandFlag) .. string.sub(reading, base + 26, string.len(reading))
		reading = string.sub(reading, 1, base + 25) .. IllHexYou(a.WaterFlag) .. string.sub(reading, base + 27, string.len(reading))		
		reading = string.sub(reading, 1, base + 93) .. IllHexYou(a.Type) .. string.sub(reading, base + 95, string.len(reading))
		reading = string.sub(reading, 1, base + 95) .. ThisLittleHexIsPayback(a.BuildCost) .. string.sub(reading, base + 98, string.len(reading))
		reading = string.sub(reading, 1, base + 97) .. ThisLittleHexIsPayback(a.BuildTime) .. string.sub(reading, base + 100, string.len(reading))
		reading = string.sub(reading, 1, base + 99) .. ThisLittleHexIsPayback(a.Health) .. string.sub(reading, base + 102, string.len(reading))
		reading = string.sub(reading, 1, base + 101) .. ThisLittleHexIsPayback(a.Mana) .. string.sub(reading, base + 104, string.len(reading))
		reading = string.sub(reading, 1, base + 103) .. ThisLittleHexIsPayback(a.ProjectileID) .. string.sub(reading, base + 106, string.len(reading))
		reading = string.sub(reading, 1, base + 105) .. ThisLittleHexIsPayback(a.AttackMin) .. string.sub(reading, base + 108, string.len(reading))
		local diff = math.max(a.AttackMax - a.AttackMin, 0)
		reading = string.sub(reading, 1, base + 107) .. ThisLittleHexIsPayback(diff) .. string.sub(reading, base + 110, string.len(reading))
		for j = 1, 5 do
			reading = string.sub(reading, 1, base + 114 + j) .. IllHexYou(a.Powers[j]) .. string.sub(reading, base + 116 + j, string.len(reading))
		end
	end
	for i = 0, 26 do
		local a = projectileTable[i + 1]
		local base = i * 117 + 22577
		reading = string.sub(reading, 1, base) .. ThisLittleHexIsPayback(a.ID) .. string.sub(reading, base + 3, string.len(reading))
		reading = string.sub(reading, 1, base + 104) .. ThisLittleHexIsPayback(a.DamageMin) .. ThisLittleHexIsPayback(a.DamageMax) ..
		ThisLittleHexIsPayback(a.DamageMin) .. ThisLittleHexIsPayback(a.DamageMax) .. string.sub(reading, base + 113, string.len(reading))
	end
	out:close()
	out = assert(io.open("testD.bin", "wb"))
	out:write(reading)
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
menuBar:add("Buildings/Wall", nil, switchCallback, "Wall")
menuBar:add("Buildings/Bridge", nil, switchCallback, "Bridge")
menuBar:add("Projectiles", nil, switchCallback, "Projectiles")

local function quit_callback(object)
	window:hide()
end
local quitButton = fltk:Fl_Button(1485, 0, 50, 25, "Exit")
quitButton:callback(quit_callback)

--[[test = 0
varTable = {}

for i = 1, 20 do
	if (i <= test) then
		a = {}

		fltk.fl_rectf(20, 20 * i, 15, 15)
		fltk.fl_draw(string.format("name%s", i), 20, 20 * i)

		lightzpos = fltk:Fl_Value_Input(0, 0, 0, 0, "")
		lightzpos:label("Z")
		lightzpos:resize(230, 41, 66, 22)
		lightzpos:labelsize(14)
		lightzpos:align(1)
		lightzpos:minimum(-1000)
		lightzpos:maximum(1000)
		lightzpos:step(0.4)
		lightzpos:value(1)
		lightzpos:textsize(14)

		lightChoice = fltk:Fl_Choice(0, 0, 0, 0, "")
		lightChoice:label("Light")
		lightChoice:resize(5, 343, 80, 20)
		lightChoice:down_box(fltk.FL_BORDER_BOX)
		lightChoice:labelsize(14)
		lightChoice:align(1)
		lightChoice:textsize(14)

		for j = 1, 8, 1 do
			lightChoice:add(j)
		end
		lightChoice:value(0)
		
		varTable[i] = a
	end
end]]--

for i = 0, 181 do 
	local a = {}
	local base = i * 124 + 5
	a.ID = NothingICantHandle(base + 6, base + 7)
	a.Speed = NothingICantHandle(base + 14, base + 15)
	a.LandFlag = NothingICantHandle(base + 25)
	a.WaterFlag = NothingICantHandle(base + 26)
	a.Type = NothingICantHandle(base + 94)
	a.BuildCost = NothingICantHandle(base + 96, base + 97)
	a.BuildTime = NothingICantHandle(base + 98, base + 99)
	a.Health = NothingICantHandle(base + 100, base + 101)
	a.Mana = NothingICantHandle(base + 102, base + 103)
	a.ProjectileID = NothingICantHandle(base + 104, base + 105)
	a.AttackMin = NothingICantHandle(base + 106, base + 107)
	a.AttackMax = a.AttackMin + NothingICantHandle(base + 108, base + 109)
	a.Powers = {
		NothingICantHandle(base + 116),
		NothingICantHandle(base + 117),
		NothingICantHandle(base + 118),
		NothingICantHandle(base + 119),
		NothingICantHandle(base + 120)
	}
	unitTable[i + 1] = a
	print(a.ID)
end
for i = 0, 26 do
	local a = {}
	local base = i * 117 + 22577
	a.ID = NothingICantHandle(base + 1, base + 2)
	a.DamageMin = NothingICantHandle(base + 105, base + 106)
	a.DamageMax = NothingICantHandle(base + 107, base + 108)
	projectileTable[i + 1] = a
end

window:show()
Fl:run()