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
                nightColorLabel = {
                    type = "header",
                    name = "Night Colors",
                    order = 1000
                },
                nightManaBarColor = {
                    type = "color",
                    name = "Mana",
                    order = 1100,
                    width = "full",
                    get = function(info) return NightManaBar:GetColor("mana") end,
                    set = function(info, r, g, b) return NightManaBar:SetColor("mana", r, g, b) end
                },
                nightRageBarColor = {
                    type = "color",
                    name = "Rage",
                    order = 1200,
                    width = "full",
                    get = function(info) return NightManaBar:GetColor("rage") end,
                    set = function(info, r, g, b) return NightManaBar:SetColor("rage", r, g, b) end
                },
                nightEnergyBarColor = {
                    type = "color",
                    name = "Energy",
                    order = 1300,
                    width = "full",
                    get = function(info) return NightManaBar:GetColor("energy") end,
                    set = function(info, r, g, b) return NightManaBar:SetColor("energy", r, g, b) end
                },
                timeLabel = {
                    type = "header",
                    name = "Time",
                    order = 2000
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
                    get = function(info) return NightManaBar:GetTime("sunrise", "hour") end,
                    set = function(info, v) return NightManaBar:SetTime("sunrise", "hour", v) end
                },
                sunriseMinute = {
                    type = "select",
                    name = "Minute",
                    order = 2130,
                    width = TimeSelectorWidth,
                    values = Minutes,
                    get = function(info) return NightManaBar:GetTime("sunrise", "minute") end,
                    set = function(info, v) return NightManaBar:SetTime("sunrise", "minute", v) end
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
                    get = function(info) return NightManaBar:GetTime("sunset", "hour") end,
                    set = function(info, v) return NightManaBar:SetTime("sunset", "hour", v) end
                },
                sunsetMinute = {
                    type = "select",
                    name = "Minute",
                    order = 2230,
                    width = TimeSelectorWidth,
                    values = Minutes,
                    get = function(info) return NightManaBar:GetTime("sunset", "minute") end,
                    set = function(info, v) return NightManaBar:SetTime("sunset", "minute", v) end
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
                resetHeader = {
                    type = "header",
                    name = "Reset NightManaBar", 
                    order = 3000
                },
                reset = {
                    type = "execute",
                    name = "Reset to Defaults",
                    desc = "Clicking this button will reset all options to their default values.",
                    order = 3100,
                    confirm = true,
                    func = "ResetConfig"
                }
            }
        }
    }
}

NightManaBar.defaults = {
    profile = {
        color = {
            mana =   {r = 0.4, g = 0.4, b = 1.0},
            rage =   {r = 1.0, g = 0.0, b = 0.0},
            energy = {r = 1.0, g = 1.0, b = 0.0}
        },
        sunrise = {hour = 07, minute = 30},
        sunset =  {hour = 21, minute = 00},
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

function NightManaBar:GetColor(powerType) 
    self:Print("GetColor: " .. powerType)
    for k,v in pairs(self.db.profile.color) do
        local s = ""
        for k, v in pairs(self.db.profile.color[k]) do
            s = s .. k .. "=" .. v .. ", " 
        end
        self:Print(k .. ": " .. s)
    end
    
    local c = self.db.profile.color[powerType]
    return c.r, c.g, c.b, 1.0
end

function NightManaBar:SetColor(powerType, r, g, b) 
    self:Print("SetColor: " .. powerType .."("..r..", " ..g..", " ..b..")")

    self.db.profile.color[powerType] = {r = r, g = g, b = b}
end

function NightManaBar:GetTime(timeOfDay, timePeriod)
    return self.db.profile[timeOfDay][timePeriod]
end

function NightManaBar:SetTime(timeOfDay, timePeriod, value) 
    self.db.profile[timeOfDay][timePeriod] = value
end

function NightManaBar:GetUseLocalTime(info) return self.db.profile.useLocalTime end
function NightManaBar:SetUseLocalTime(info, value) self.db.profile.useLocalTime = value end
