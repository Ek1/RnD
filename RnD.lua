RnD = {
	TITLE = "Reserach and development",	-- Not codereview friendly but enduser friendly version of the add-on's name
	AUTHOR = "Ek1",
	DESCRIPTION = "To help research item traits and develop character skills according to users plan.",
	VERSION = "1035.221012",
	VARIABLEVERSION = "35",
	LIECENSE = "CC BY-SA 4.0 = Creative Commons Attribution-ShareAlike 4.0 International License",
	URL = "https://github.com/Ek1/RnD",
}
local ADDON = "RnD"	-- Variable used to refer to this add-on. Codereview friendly.

local Settings = {	-- default settings

}



-- Lets fire up the add-on by registering for events and loading variables
function RnD.Initialize()
--	EVENT_MANAGER:RegisterForEvent(ADDON, EVENT_PLAYER_ACTIVATED, RnD.EVENT_PLAYER_ACTIVATED)

	Settings   = ZO_SavedVars:NewAccountWide("RnD_Settings", 1, nil, Settings, GetWorldName() )	-- Load settings

end

-- Here the magic starts
function RnD.EVENT_ADD_ON_LOADED(_, loadedAddOnName)
  if loadedAddOnName == ADDON then
		--	Seems it is our time to shine so lets stop listening load trigger, load saved variables and initialize the add-on
		EVENT_MANAGER:UnregisterForEvent(ADDON, EVENT_ADD_ON_LOADED)

		RnD.Initialize()
  end
end



-- LAM stuff
local LAM	= LibAddonMenu2
local saveData	= RnDSettings
local panelName	= "RnD-Panel"

local panelData = {
	type = "panel",
	name = ADDON,
	displayName = RnD.TITLE,
	author = RnD.AUTHOR,
	version = RnD.VERSION,
--	slashCommand = "/RnD",	--(optional) will register a keybind to open to this panel
	registerForRefresh = true,	--boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
	registerForDefaults = true,	--boolean (optional) (will set all options controls back to default values)
	text = RnD.DESCRIPTION,
}
local panel = LAM:RegisterAddonPanel(panelName, panelData)

local optionsData = {
	[1] = {
			type = "description",
			--title = "My Title",	--(optional)
			title = nil,	--(optional)
			text = RnD.DESCRIPTION,
			width = "full",	--or "half" (optional)
			registerForRefresh = true, --boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
		},
	[2] = {
		type = "divider",
	},
	[3] = {
		type = "checkbox",
		name = "Refresh event EXP buffs",
		default = true,
		getFunc = function() return RnDSettings.keepEventBuffsOn end,
		setFunc = function(value) RnDSettings.keepEventBuffsOn = value end,
	},
	[4] = {
		type = "slider",
		name = "Threshold in minutes when to refresh event buff",
		disabled = function() return not RnDSettings.keepEventBuffsOn end,
		tooltip = "If there less minutes left in characters event Exp buff than the given value, the add-on tries to refresh it.",
		min = 0,
		max = 105,	-- 15 mins seems to be the idle check time and we don't want to create anti-idle add-on
		default = 60,
		getFunc = function() return RnDSettings.eventBuffsThreshold end,
		setFunc = function(value) RnDSettings.eventBuffsThreshold = value end,
	},
}
LAM:RegisterOptionControls(panelName, optionsData)

-- Registering for the add-on loading loop
EVENT_MANAGER:RegisterForEvent(ADDON, EVENT_ADD_ON_LOADED, RnD.EVENT_ADD_ON_LOADED)