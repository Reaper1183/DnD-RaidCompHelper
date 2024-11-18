function()
    -- Initialize counters for DPS, Healers, and Tanks in the raid group
    local meleeDpsCount = 0
    local rangedDpsCount = 0
    local healCount = 0
    local tankCount = 0
    
    -- Classes with ranged DPS specializations
    local rangedClasses = {
        HUNTER = true,
        MAGE = true,
        PRIEST = true,
        WARLOCK = true,
        EVOKER = true
    }

    -- Update counts for raid group
    for i = 1, GetNumGroupMembers() do
        local unit = "raid" .. i
        if UnitExists(unit) then
            -- Get the role assigned to the unit (TANK, HEALER, DAMAGER)
            local role = UnitGroupRolesAssigned(unit)
            local _, class = UnitClass(unit)

            if role == "DAMAGER" then
                if class == 'SHAMAN' then
                    local specId = GetInspectSpecialization(unit)
                    if specId == 262 then -- Elemental
                        rangedDpsCount = rangedDpsCount + 1
                    elseif specId == 263 then -- Enhancement
                        meleeDpsCount = meleeDpsCount + 1
                    else
                        -- Default if spec ID is not available
                        meleeDpsCount = meleeDpsCount + 1
                    end
                elseif class == 'PALADIN' then
                    local specId = GetInspectSpecialization(unit)
                    if specId == 70 then -- Retribution
                        meleeDpsCount = meleeDpsCount + 1
                    else
                        -- Default if spec ID is not available
                        meleeDpsCount = meleeDpsCount + 1
                    end
                elseif rangedClasses[class] then
                    rangedDpsCount = rangedDpsCount + 1
                else
                    meleeDpsCount = meleeDpsCount + 1
                end
            elseif role == "HEALER" then
                healCount = healCount + 1
            elseif role == "TANK" then
                tankCount = tankCount + 1
            end
        end
    end

    -- Return the combined result or any specific data you want to show (this could be displayed in custom text)
    return string.format("Tanks: %d\nMelee DPS: %d\nRanged DPS: %d\nHealers: %d", tankCount, meleeDpsCount, rangedDpsCount, healCount)
end

-- Trigger Function
function(event)
    if event == "ROLE_COUNT_UPDATE" then
        -- Handle role count updates for your raid
        print("Role Count Updated!")
    end
    return true
end

-- Register relevant events to update role counts
local frame = CreateFrame("Frame")
frame:RegisterEvent("RAID_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("INSPECT_READY")
frame:SetScript("OnEvent", function(_, event)
    WeakAuras.ScanEvents("ROLE_COUNT_UPDATE")
end)