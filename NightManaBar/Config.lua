local NightManaBar = LibStub("AceAddon-3.0"):GetAddon("NightManaBar")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

local Hours = {}
for i = 0, 23 do
    Hours[i] = i
end

local Minutes = {}
for i = 0, 55, 5 do 
    Minutes[i] = i
end

NightManaBar.options = {
    type = "group",
    name = "NightManaBar",
    handler = NightManaBar,
    args = {
        nightManaBarColor = {
            type = "color",
            name = "Mana Bar Color (Night)",
            order = 20,
            width = "full",
            get = "GetNightManaBarColor",
            set = "SetNightManaBarColor"  
        },
        sunrise = {
            type = "group",
            name = "Sunrise Time",
            order = 30,
            inline = true,
            args = {
                hour = {
                    type = "select",
                    name = "Hour",
                    values = Hours,
                    get = "GetSunriseHour",
                    set = "SetSunriseHour"
                },
                minute = {
                    type = "select",
                    name = "Minute",
                    values = Minutes,
                    get = "GetSunriseMinute",
                    set = "SetSunriseMinute"
                }
            }
        },
        sunset = {
            type = "group",
            name = "Sunset Time",
            order = 40,
            inline = true,
            args = {
                hour = {
                    type = "select",
                    name = "Hour",
                    values = Hours,
                    get = "GetSunsetHour",
                    set = "SetSunsetHour"
                },
                minute = {
                    type = "select",
                    name = "Minute",
                    values = Minutes,
                    get = "GetSunsetMinute",
                    set = "SetSunsetMinute"
                }
            }
        },
        useLocalTime = {
            type = "toggle",
            name = "Use local time",
            desc = "If enabled, use local time instead of server time.",
            order = 50,
            width = "full",
            get = "GetUseLocalTime",
            set = "SetUseLocalTime"
        },
        updateColor = {
            type = "execute",
            name = "Update Color",
            desc = "Click this to manually update the mana bar's color.",
            order = 55,
            func = "UpdateManaBarColor"
        },
        resetHeader = {
            type = "header",
            name = "Reset NightManaBar",
            order = 57
        },
        reset = {
            type = "execute",
            name = "Reset to Defaults",
            desc = "Clicking this button will reset all options to their default values.",
            order = 60,
            confirm = true,
            func = "ResetConfig"
        }
    }
}

NightManaBar.defaults = {
    profile = {
        nightManaBarColor = { r = 100/255, g = 100/255, b = 1.00 },
        sunrise = {
            hour = 5,
            minute = 30
        },
        sunset = {
            hour = 21,
            minute = 0 
        },
        useLocalTime = false,
    }
}

function NightManaBar:RegisterConfig() 
    self.db = AceDB:New("NightManaBarDB", self.defaults)
    
    AceConfig:RegisterOptionsTable("NightManaBar", self.options)
    AceConfigDialog:AddToBlizOptions("NightManaBar")
end


function NightManaBar:ResetConfig(info) 
    self.db:ResetProfile()
    --self:UpdateManaBarColor()
end

-- function NightManaBar:GetDayManaBarColor(info)
--     local color = self.db.profile.dayManaBarColor
--     return color.r, color.g, color.b, 1.0
-- end

-- function NightManaBar:SetDayManaBarColor(info, r, g, b) 
--     self.db.profile.dayManaBarColor = {r=r, g=g, b=b} 
-- end

function NightManaBar:GetNightManaBarColor(info) 
    local color = self.db.profile.nightManaBarColor 
    return color.r, color.g, color.b, 1.0 
end

function NightManaBar:SetNightManaBarColor(info, r, g, b) 
    self.db.profile.nightManaBarColor = {r=r, g=g, b=b}
end

function NightManaBar:GetSunriseHour(info) 
    return self.db.profile.sunrise.hour
end

function NightManaBar:SetSunriseHour(info, value) 
    self.db.profile.sunrise.hour = value 
end

function NightManaBar:GetSunriseMinute(info) 
    return self.db.profile.sunrise.minute 
end

function NightManaBar:SetSunriseMinute(info, value) 
    self.db.profile.sunrise.minute = value 
end

function NightManaBar:GetSunsetHour(info) 
    return self.db.profile.sunset.hour 
end

function NightManaBar:SetSunsetHour(info, value) 
    self.db.profile.sunset.hour = value 
end

function NightManaBar:GetSunsetMinute(info) 
    return self.db.profile.sunset.minute 
end

function NightManaBar:SetSunsetMinute(info, value) 
    self.db.profile.sunset.minute = value 
end

function NightManaBar:GetUseLocalTime(info) 
    return self.db.profile.useLocalTime 
end

function NightManaBar:SetUseLocalTime(info, value) 
    self.db.profile.useLocalTime = value 
end