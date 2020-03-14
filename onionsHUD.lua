--
-- Variables
--

-- Window
local onion_window = gui.Tab(gui.Reference("Settings"), 'onion_window', "Onion's HUD")

-- Groupboxes
local onion_window_groupbox_1 = gui.Groupbox(onion_window, 'Gradient Settings', 15, 15)
local onion_window_groupbox_2 = gui.Groupbox(onion_window, 'HUD Settings', 15, 295)

-- Checkboxes
local onion_gradient_enabled = gui.Checkbox(onion_window_groupbox_1, 'onion_gradient_enabled', 'Enabled', true)
local onion_gradient_vertical = gui.Checkbox(onion_window_groupbox_1, 'onion_gradient_vertical', 'Vertical Gradient (Clowns Only)', false)
local onion_hud_enabled = gui.Checkbox(onion_window_groupbox_2, 'onion_hud_enabled', 'Enabled', true)
local onion_hud_position_dynamic = gui.Checkbox(onion_window_groupbox_2, 'onion_hud_position_dynamic', 'Dynamic HUD Position', true)
local onion_hud_position_drag = gui.Checkbox(onion_window_groupbox_2, 'onion_hud_position_drag', 'Draggable HUD (W.I.P)', false)

-- Sliders
local onion_gradient_height = gui.Slider(onion_window_groupbox_1,'onion_gradient_height', 'Gradient Height', 5, 1, 20)
local onion_hud_position_x = gui.Slider(onion_window_groupbox_2,'onion_hud_position_x', 'X Offset', 15, 0, 75)
local onion_hud_position_y = gui.Slider(onion_window_groupbox_2,'onion_hud_position_y', 'Y Offset', 15, 0, 75)

-- Comboboxs
local onion_hud_position = gui.Combobox(onion_window_groupbox_2,'onion_hud_position', 'HUD Position', "Top Right", "Top Left", "Bottom Right", "Bottom Left")
local onion_hud_style = gui.Combobox(onion_window_groupbox_2,'onion_hud_style', 'HUD Style', "Sypher", "Skeet", "Onetap")

-- Color Pickers
local onion_gradient_col_1 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_1', 'Gradient Color 1', 59, 175, 222, 255)
local onion_gradient_col_2 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_2', 'Gradient Color 2', 202, 70, 205, 255)
local onion_gradient_col_3 = gui.ColorPicker(onion_window_groupbox_1,'onion_gradient_col_3', 'Gradient Color 3', 201, 227, 58, 255)
local onion_hud_color_backcolor = gui.ColorPicker(onion_window_groupbox_2,'onion_hud_color_backcolor', 'HUD Backcolor', 43, 43, 43, 255)
local onion_hud_color_bordercolor = gui.ColorPicker(onion_window_groupbox_2,'onion_hud_color_bordercolor', 'HUD Border Color', 0, 183, 255, 255)
local onion_hud_color_text = gui.ColorPicker(onion_window_groupbox_2,'onion_hud_color_text', 'HUD Text Color', 255, 255, 255, 255)

-- Options
local onion_window_groupbox_3 = gui.Groupbox(onion_window_groupbox_2, 'HUD Options', 0, 415)
local onion_hud_options_username = gui.Checkbox(onion_window_groupbox_3, 'onion_hud_options_username', 'Username', true)
local onion_hud_options_ping = gui.Checkbox(onion_window_groupbox_3, 'onion_hud_options_ping', 'Ping', true)
local onion_hud_options_server = gui.Checkbox(onion_window_groupbox_3, 'onion_hud_options_server', 'Server', true)
local onion_hud_options_velocity = gui.Checkbox(onion_window_groupbox_3, 'onion_hud_options_velocity', 'Velocity', true)
local onion_hud_options_tickrate = gui.Checkbox(onion_window_groupbox_3, 'onion_hud_options_tickrate', 'Tickrate', true)

-- Fonts
local textFont = draw.CreateFont( "Tahoma", 18 )

-- Misc Variables
local scrW, scrH = 0, 0
local initialize = false
local mouseX, mouseY = 0, 0
local localplayer
local username = ""
local ping = ""
local server = ""
local maxVelocity
local curVelocity
local playerResources
local curTime = "12:00"
local map
local tick

--
-- Misc Functions
--

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function getPropFloat(lp, wat)
    return lp:GetPropFloat("localdata", wat)
end

local function getPropInt(lp, wat)
    return lp:GetPropInt("localdata", wat)
end

--
-- Drawing Functions
--

function drawFilledRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.FilledRect(x, y, x + width, y + height)
end

function drawOutlineRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.OutlinedRect(x, y, x + width, y + height)
end

function drawRoundedFilledRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.RoundedRectFill(x, y, x + width, y + height)
end

function drawRoundedOutlineRect(r, g, b, a, x, y, width, height)
	draw.Color(r, g, b, a)
	draw.RoundedRect(x, y, x + width, y + height)
end

function drawText(r, g, b, a, x, y, font, str)
	draw.Color(r, g, b, a)
	draw.SetFont(font)
	draw.Text(x, y, str)
end

function drawCenteredText(r, g, b, a, x, y, font, str)
	draw.Color(r, g, b, a)
	draw.SetFont(font)
	local textW, textH = draw.GetTextSize(str)
	draw.Text(x - (textW / 2), y - (textH / 2), str)
end

function drawGradient( color1, color2, x, y, w, h, vertical )
	local r2, g2, b2 = color1[1], color1[2], color1[3]
	local r, g, b = color2[1], color2[2], color2[3]
	
    drawFilledRect( r2, g2, b2, 255, x, y, w, h )

    if vertical then
        for i = 1, h do
            local a = i / h * 255
            drawFilledRect( r, g, b, a, x, y + i, w, 1)
        end
    else
        for i = 1, w do
            local a = i / w * 255
            drawFilledRect( r, g, b, a, x + i, y, 1, h)
        end
    end
end

function drawOutlineGradient( outlineColor, color1, color2, x, y, w, h, vertical, thickness )
	local r, g, b, a = outlineColor[1], outlineColor[2], outlineColor[3], outlineColor[4]

	drawFilledRect(r, g, b, a, x, y, w, h)
	drawGradient( color1, color2, x + thickness, y + thickness, w - (thickness * 2), h - (thickness * 2), vertical )
end

--
-- HUD Drawing Functions
--

function drawHUDBar()
	local hudPosition = onion_hud_position:GetValue()
	local hudStyle = onion_hud_style:GetValue()
	local x, y = 0, 0
	local r, g, b, a = onion_hud_color_text:GetValue()
	local backR, backG, backB, backA = onion_hud_color_backcolor:GetValue()
	local borderR, borderG, borderB, borderA = onion_hud_color_bordercolor:GetValue()
	local hudString = ""
	local hudText = " | "
	
	--if (onion_hud_options_time:GetValue() == true) then
		
	--end
	
	if (onion_hud_options_username:GetValue() == true) then
		if (username ~= "") then hudString = hudString .. username .. hudText end
	end
	
	if (onion_hud_options_ping:GetValue() == true) then
		if (ping ~= "") then hudString = hudString .. ping .. hudText end
	end
	
	if (onion_hud_options_server:GetValue() == true) then
		if (server ~= "") then hudString = hudString .. server .. hudText end
	end
	
	if (onion_hud_options_velocity:GetValue() == true) then
		if (curVelocity ~= 0) then hudString = hudString .. curVelocity .. " m/s" .. hudText end
	end
	
	if (onion_hud_options_tickrate:GetValue() == true) then
		if (tick ~= "") then hudString = hudString .. tick .. hudText end
	end
	
	hudString = hudString .. curTime
	
	draw.Color(r, g, b, a)
	draw.SetFont(textFont)
	local textW, textH = draw.GetTextSize(hudString)
	local hudW, hudH = textW + 20, textH + 10
	
	-- Set HUD Position
	if (hudPosition == 0) then
		if (onion_hud_position_dynamic:GetValue() == true) then
			if (onion_gradient_enabled:GetValue() == true) then
				y = y + onion_gradient_height:GetValue()
			end
		end
		
		y = y + onion_hud_position_y:GetValue()
		x = scrW - (onion_hud_position_x:GetValue() + hudW)
	elseif (hudPosition == 1) then
		if (onion_hud_position_dynamic:GetValue() == true) then
			if (onion_gradient_enabled:GetValue() == true) then
				y = y + onion_gradient_height:GetValue()
			end
		end	
		
		y = y + onion_hud_position_y:GetValue()
		x = onion_hud_position_x:GetValue()
	elseif (hudPosition == 3) then
		y = ((scrH - hudH) - onion_hud_position_y:GetValue())
		x = onion_hud_position_x:GetValue()
	else
		y = ((scrH - hudH) - onion_hud_position_y:GetValue())
		x = scrW - (onion_hud_position_x:GetValue() + hudW)
	end
	
	
	-- Draw the HUD
	if (hudStyle == 0) then
		drawFilledRect(borderR, borderG, borderB, borderA, x, y, hudW, 2)
		drawFilledRect(backR, backG, backB, backA, x, y + 2, hudW, hudH - 2)
		drawCenteredText(r, g, b, a, x + (hudW / 2), (y + 1) + ((hudH - 2) / 2), textFont, hudString)
	elseif (hudStyle == 1) then
		
	else
		
	end
end

--
-- Drawing Functions
--

function gatherVariables()
	if (initialize == false) then
		initialize = true
		scrW, scrH = draw.GetScreenSize()
	end
	
	mouseX, mouseY = input.GetMousePos()
	localPlayer = entities.GetLocalPlayer()
	playerResources = entities.GetPlayerResources()
	-- curTime = os.clock()
	
	if (onion_hud_enabled:GetValue() == true) then
		if (localPlayer ~= nil) then
			local vX, vY = 0, 0
		
		    ping = playerResources:GetPropInt("m_iPing", localPlayer:GetIndex()) .. ' ms'
            tick = client.GetConVar("sv_maxcmdrate") .. ' tick'
			username = client.GetPlayerNameByIndex(client.GetLocalPlayerIndex())
			maxVelocity = client.GetConVar("sv_maxvelocity")
			vX, vY = getPropFloat(localPlayer, 'm_vecVelocity[0]'), getPropFloat(localPlayer, 'm_vecVelocity[1]')
			curVelocity = math.floor(math.min(10000, math.sqrt(vX * vX + vY * vY) + 0.5))
			
			map = engine.GetMapName()
			if (engine.GetServerIP() == "loopback") then
				server = "localhost"
			elseif string.find(engine.GetServerIP(), "A") then
				server = "valve"
			else
				server = engine.GetServerIP()
			end
		else
			maxVelocity = 1
			curVelocity = 0
			username = ""
			tick = ""
			ping = ""
			server = ""
			map = ""
		end
	end
end

function drawHUD()
	if (onion_gradient_enabled:GetValue() == true) then
		local a, b, c, d = onion_gradient_col_1:GetValue()
		local e, f, g, h = onion_gradient_col_2:GetValue()
		local i, j, k, l = onion_gradient_col_3:GetValue()
	
		drawGradient( { a, b, c, d }, { e, f, g, h }, 0, 0, draw.GetScreenSize() / 2, onion_gradient_height:GetValue(), onion_gradient_vertical:GetValue() );
		drawGradient( { e, f, g, h }, { i, j, k, l }, draw.GetScreenSize() / 2,  0 , draw.GetScreenSize() / 2 , onion_gradient_height:GetValue(), onion_gradient_vertical:GetValue());
	end
	
	if (onion_hud_enabled:GetValue() == true) then
		drawHUDBar()
	end
end

--
-- Callbacks
--

callbacks.Register('Draw', gatherVariables);
callbacks.Register('Draw', drawHUD);
