window = fltk:Fl_Window(0, 0, 1920, 1080, "Entities Editor")

function NothingICan'tHandle(num, num2)
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
			result2 = string.format("%s%s", string.sub(hexstr2, n + 1, n + 1), result2)
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

function I'llHexYou(num)
	local hex = string.format("%X", tostring(num))
	if (string.len(hex) == 1) then
		hex = string.format(%s%s, "0", hex)
	end
	if (string.len(hex) == 0) then
		hex = "00"
	end
	return(hex)
end

function ThisLittleHexIsPayback(num)
	local hex = string.format("%X", tostring(num))
	if (string.len(hex) == 3) then
		hex = string.format(%s%s, "0", hex)
	end
	if (string.len(hex) == 2) then
		hex = string.format(%s%s, "00", hex)
	end
	if (string.len(hex) == 1) then
		hex = string.format(%s%s, "000", hex)
	end
	if (string.len(hex) == 0) then
		hex = "0000"
	end
	hex = string.format("%s%s", string.sub(hex, 3, 4), string.sub(hex, 1, 2))
	return(hex)
end

function saveCallback(w)
end

function switchCallback(w)
	local switchType = 0
	switchType = w:user_data()
	--print(switchType)
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

function quit_callback(object)
	window:hide()
end
quitButton = fltk:Fl_Button(1485, 0, 50, 25, "Exit")
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

window:show()
Fl:run()