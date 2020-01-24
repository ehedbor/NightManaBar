local NightManaBar = LibStub("AceAddon-3.0"):GetAddon("NightManaBar")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

local TimeSelectorWidth = 0.333

local Hours = {}
for i = 0, 23 do
    Hours[i] = format("%02d", i)
end

local Minutes = {}
for i = 0, 55, 5 do
    Minutes[i] = format("%02d", i)
end

NightManaBar.options = {
    type = "group",
    name = "NightManaBar",
    handler = NightManaBar,
    args = {
        general = {
            type = "group",
            name = "General",
            args = {
                nightManaBarColor = {
                    type = "color",
                    name = "Mana Bar Color (Night)",
                    order = 1100,
                    width = "full",
                    get = "GetNightManaBarColor",
                    set = "SetNightManaBarColor"
                },
                sunriseLabel = {
                    type = "description",
                    name = "Sunrise Time",
                    order = 2110,
                    fontSize = "medium"
                },
                sunriseHour = {
                    type = "select",
                    name = "Hour",
                    order = 2120,
                    width = TimeSelectorWidth,
                    values = Hours,
                    get = "GetSunriseHour",
                    set = "SetSunriseHour"
                },
                sunriseMinute = {
                    type = "select",
                    name = "Minute",
                    order = 2130,
                    width = TimeSelectorWidth,
                    values = Minutes,
                    get = "GetSunriseMinute",
                    set = "SetSunriseMinute"
                },
                sunsetLabel = {
                    type = "description",
                    name = "Sunset Time",
                    order = 2210,
                    fontSize = "medium"
                },
                sunsetHour = {
                    type = "select",
                    name = "Hour",
                    order = 2220,
                    width = TimeSelectorWidth,
                    values = Hours,
                    get = "GetSunsetHour",
                    set = "SetSunsetHour"
                },
                sunsetMinute = {
                    type = "select",
                    name = "Minute",
                    order = 2230,
                    width = TimeSelectorWidth,
                    values = Minutes,
                    get = "GetSunsetMinute",
                    set = "SetSunsetMinute"
                },
                is24HourMode = {
                    type = "toggle",
                    name = "24 Hour Mode",
                    order = 2310,
                    width = "full",
                    disabled = true,
                    get = function() return true end,
                    set = function() end
                },
                useLocalTime = {
                    type = "toggle",
                    name = "Use Local Time",
                    order = 2320,
                    width = "full",
                    get = "GetUseLocalTime",
                    set = "SetUseLocalTime"
                },
                resetHeader = {type = "header", name = "Reset NightManaBar", order = 3210},
                reset = {
                    type = "execute",
                    name = "Reset to Defaults",
                    desc = "Clicking this button will reset all options to their default values.",
                    order = 3220,
                    confirm = true,
                    func = "ResetConfig"
                }
            }
        }
    }
}

NightManaBar.defaults = {
    profile = {
        nightManaBarColor = {r = 100 / 255, g = 100 / 255, b = 1.00},
        sunrise = {hour = 5, minute = 30},
        sunset = {hour = 21, minute = 0},
        useLocalTime = false
    }
}

function NightManaBar:RegisterConfig()
    self.db = AceDB:New("NightManaBarDB", self.defaults)

    AceConfig:RegisterOptionsTable("NightManaBar", self.options)
    AceConfigDialog:AddToBlizOptions("NightManaBar")

    self.options.args.profiles = AceDBOptions:GetOptionsTable(self.db)
end

function NightManaBar:ResetConfig(info) self.db:ResetProfile() end

function NightManaBar:GetNightManaBarColor(info)
    local color = self.db.profile.nightManaBarColor
    return color.r, color.g, color.b, 1.0
end

function NightManaBar:SetNightManaBarColor(info, r, g, b)
    self.db.profile.nightManaBarColor = {r = r, g = g, b = b}
end

function NightManaBar:GetSunriseHour(info) return self.db.profile.sunrise.hour end
function NightManaBar:SetSunriseHour(info, value) self.db.profile.sunrise.hour = value end
function NightManaBar:GetSunriseMinute(info) return self.db.profile.sunrise.minute end
function NightManaBar:SetSunriseMinute(info, value) self.db.profile.sunrise.minute = value end

function NightManaBar:GetSunsetHour(info) return self.db.profile.sunset.hour end
function NightManaBar:SetSunsetHour(info, value) self.db.profile.sunset.hour = value end
function NightManaBar:GetSunsetMinute(info) return self.db.profile.sunset.minute end
function NightManaBar:SetSunsetMinute(info, value) self.db.profile.sunset.minute = value end

function NightManaBar:GetUseLocalTime(info) return self.db.profile.useLocalTime end
function NightManaBar:SetUseLocalTime(info, value) self.db.profile.useLocalTime = value end
