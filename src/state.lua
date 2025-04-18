--- Global state management module
local love = require("love")

local state = {
	applicationName = "Aesthetic",

	-- Screen dimensions are set in `src/main.lua`
	screenWidth = 0,
	screenHeight = 0,

	fonts = {
		header = love.graphics.getFont(),
		body = love.graphics.getFont(),
		caption = love.graphics.getFont(),
	},
	selectedFont = "Inter", -- Default selected font
	previousScreen = "menu", -- Default screen to return to after color picker
	glyphs_enabled = true, -- Default value for glyphs enabled

	-- RGB lighting related settings
	rgbMode = "Solid", -- Default RGB lighting mode
	rgbBrightness = 5, -- Default RGB brightness (1-10)
	rgbSpeed = 5, -- Default RGB speed (1-10)
	themeApplied = false, -- Whether the theme has been applied

	activeColorContext = "background", -- Default color context (which color context will be modified by color picker)
	colorContexts = {}, -- Centralized color contexts storage
}

-- Color defaults to initialize contexts with
local colorDefaults = {
	background = "#1E40AF", -- Default background color
	foreground = "#DBEAFE", -- Default foreground color
	rgb = "#1E40AF", -- Default RGB lighting color
}

-- Helper function to get or create a color context
-- This enables scalable state management for multiple color buttons
function state.getColorContext(contextKey)
	if not state.colorContexts[contextKey] then
		-- Initialize a new context with default values
		state.colorContexts[contextKey] = {
			-- HSV state
			hsv = {
				hue = 0,
				sat = 1,
				val = 1,
				focusSquare = false,
				cursor = { svX = nil, svY = nil, hueY = nil },
			},
			-- Hex state
			hex = {
				input = "",
				selectedButton = { row = 1, col = 1 },
			},
			-- Palette state
			palette = {
				selectedRow = 0,
				selectedCol = 0,
				scrollY = 0,
			},
			-- The current hex color value
			currentColor = colorDefaults[contextKey] or "#000000", -- Default to known default or black
		}
	end
	return state.colorContexts[contextKey]
end

-- Helper function to get the current color value for a context
function state.getColorValue(contextKey)
	local context = state.getColorContext(contextKey)
	return context.currentColor
end

-- Helper function to set the current color value for a context
function state.setColorValue(contextKey, colorValue)
	local context = state.getColorContext(contextKey)
	context.currentColor = colorValue
	return colorValue
end

-- Initialize default contexts
state.getColorContext("background")
state.getColorContext("foreground")
state.getColorContext("rgb")

return state
