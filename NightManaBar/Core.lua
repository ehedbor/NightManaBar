local NightManaBar = LibStub("AceAddon-3.0"):NewAddon("NightManaBar", 
    "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local ManaBars = {
    player = PlayerFrameManaBar, 
    pet = PetFrameManaBar,
    target = TargetFrameManaBar, 
    targettarget = TargetFrameToTManaBar, -- Broken? Changing this color has no effect.
    party1 = PartyMemberFrame1ManaBar, 
    party2 = PartyMemberFrame2ManaBar, 
    party3 = PartyMemberFrame3ManaBar, 
    party4 = PartyMemberFrame4ManaBar
}

function NightManaBar:OnInitialize() 
    self:RegisterConfig()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateManaBarColor")
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "UpdateManaBarColor")
    self:RegisterEvent("UNIT_DISPLAYPOWER", "UpdateManaBarColor")
    self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", "UpdateManaBarColor")
end

function NightManaBar:OnEnable() 
    self:UpdateManaBarColor()
    self.timer = self:ScheduleRepeatingTimer("UpdateManaBarColor", 5)
end

local function GetMinutes(hour, minute)
    return 60 * hour + minute  
end

local function IsTimeBetween(time, start, stop)
    -- See https://stackoverflow.com/questions/35402992/how-to-check-if-current-time-is-between-two-others
    local StartH, StartM = start.hour, start.minute
    local StopH, StopM = stop.hour, stop.minute
    local TestH, TestM = time.hour, time.minute

    -- add 24 hours if endhours < starthours
    if (StopH < StartH) then
        local StopHOrg=StopH
        StopH = StopH + 24
        -- if endhours has increased the currenthour should also increase
        if (TestH <= StopHOrg) then 
            TestH = TestH + 24
        end
    end

    local StartTVal = GetMinutes(StartH, StartM)
    local StopTVal = GetMinutes(StopH, StopM)
    local curTVal = GetMinutes(TestH, TestM)
    return (curTVal >= StartTVal and curTVal <= StopTVal) 
end 

function NightManaBar:UpdateManaBarColor() 
    local isNight = not IsTimeBetween(self:GetCurrentTime(), self.db.profile.sunrise, self.db.profile.sunset)
    for unitid, manaBar in pairs(ManaBars) do
        local _, powerToken = UnitPowerType(unitid)
        if powerToken ~= nil then
            local c = PowerBarColor[powerToken]
            if isNight and powerToken == "MANA" then 
                c = self.db.profile.nightManaBarColor
            end
            manaBar:SetStatusBarColor(c.r, c.g, c.b) 
        end
    end
end

function NightManaBar:GetCurrentTime()
    local datetime = 
        self.db.profile.useLocalTime and date("*t") or date("*t", GetServerTime())
    return { hour = datetime.hour, minute = datetime.min }
end 