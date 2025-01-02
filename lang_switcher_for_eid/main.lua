-- Initialize the mod
local LanguageToggleMod = RegisterMod("LanguageToggleMod", 1)

-- Reference to the EID mod
local EID = EID or nil

-- Ensure EID is loaded
if not EID then
    Isaac.ConsoleOutput("EID is not loaded. LanguageToggleMod requires EID to function.\n")
    return
end

-- Define the two languages to toggle between
local languages = {"en_us", "ko_kr"}

-- Keybinds for toggling languages (Customize keys as needed)
local toggleKeys = {Keyboard.KEY_KP_DIVIDE, Keyboard.KEY_X} -- Array of keys to check
local wasKeyPressed = {} -- Tracks the previous state of each key

-- Initialize the wasKeyPressed table for each key
for _, key in ipairs(toggleKeys) do
    wasKeyPressed[key] = false
end

-- Function to change the language in EID
local function toggleLanguage()
    -- Get the current language
    local currentLanguage = EID.Config["Language"]

    -- Toggle between `en_us` and `ko_kr`
    if currentLanguage == languages[1] then
        EID.Config["Language"] = languages[2]
    else
        EID.Config["Language"] = languages[1]
    end

    -- Apply font settings (if applicable) and refresh
    local isFixed = EID:fixDefinedFont(true)
    if isFixed then
        EID:loadFont(EID.modPath .. "resources/font/eid_"..EID.Config["FontType"]..".fnt")
    end

    -- Refresh the UI
	EID.MCM_OptionChanged = true
	EID.RefreshBagTextbox = true 


    -- Provide feedback in the console
    Isaac.ConsoleOutput("EID Language changed to: " .. EID.Config["Language"] .. "\n")
end

-- Input handling
function LanguageToggleMod:onUpdate()
    for _, key in ipairs(toggleKeys) do
        if Input.IsButtonPressed(key, 0) then
            if not wasKeyPressed[key] then
                toggleLanguage()
                wasKeyPressed[key] = true -- Mark the key as pressed
            end
        else
            wasKeyPressed[key] = false -- Reset when the key is released
        end
    end
end

-- Add a callback for input handling
LanguageToggleMod:AddCallback(ModCallbacks.MC_POST_UPDATE, LanguageToggleMod.onUpdate)

-- Optional: Confirm mod loaded successfully
Isaac.ConsoleOutput("LanguageToggleMod loaded successfully. Press 'Numpad /' to toggle between en_us and ko_kr.\n")
