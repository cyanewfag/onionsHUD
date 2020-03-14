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

-- Fonts
local textFont = draw.CreateFont( "Tahoma", 16 )

-- Misc Variables
local scrW, scrH = 0, 0
local initialize = false
local mouseX, mouseY = 0, 0

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

	
	-- Set HUD Position
	if (hudPosition == 0) then
		
	elseif (hudPosition == 1) then
		
	elseif (hudPosition == 2) then
		
	else
		
	end
	
	
	-- Draw the HUD
	if (hudStyle == 0) then
		
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
end

function drawMenu()
	if (onion_gradient_enabled:GetValue() == true) then
		local a, b, c, d = onion_gradient_col_1:GetValue()
		local e, f, g, h = onion_gradient_col_2:GetValue()
		local i, j, k, l = onion_gradient_col_3:GetValue()
	
		drawGradient( { a, b, c, d }, { e, f, g, h }, 0, 0, draw.GetScreenSize() / 2, onion_gradient_height:GetValue(), onion_gradient_vertical:GetValue() );
		drawGradient( { e, f, g, h }, { i, j, k, l }, draw.GetScreenSize() / 2,  0 , draw.GetScreenSize() / 2 , onion_gradient_height:GetValue(), onion_gradient_vertical:GetValue());
	end
	
	drawHUDBar()
end

--
-- Callbacks
--

callbacks.Register('Draw', gatherVariables);
callbacks.Register('Draw', drawMenu);
