local AddonFolder = "D:/World of Warcraft/_retail_/Interface/Addons/TomeOfTeleportation/"
dofile("WowMock.lua")
dofile(AddonFolder .. "TomeOfTeleportation.lua")
dofile(AddonFolder .. "Spells.lua")


Item_Hearthstone = 6948

Toy_TomeOfTownPortal = 142542

Spell_AstralRecall = 556
Spell_TeleportOrgrimmar = 3567

Fixture = {}

function Fixture:BeforeTest()
    CreateFrame("Frame", "TeleporterFrame")
    Teleporter_OnAddonLoaded()

    TeleporterClose()
end

function Fixture:TestEquals(v1, v2, text)
    if v1 ~= v2 then
        print(self.name .. " " .. text .. " failed. " .. (v1 or "nil") .. " does not equal " .. (v2 or "nil") .. ".")
        self.result = false
    end
end

function CreateFixture(name)
    local f = {}
    setmetatable(f, {__index=Fixture})
    f.result = true
    f.name = name
    return f
end

local function FindButtons()    
    return WowMock:FindFramesWithTemplate("InsecureActionButtonTemplate")
end

local function FindZoneLabels()
    return WowMock:FindFramesWithPrefix("TeleporterDL")
end

local Tests = 
{    
    ["OneSpellKnown_OpenFrame_OneZoneLabelAndOneButtonDisplayed"] = function(f)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        TeleporterOpenFrame()
        f:TestEquals(#FindButtons(), 1, "There should be 1 button")
        f:TestEquals(#FindZoneLabels(), 1, "There should be 1 zone label")
    end,
    ["TwoSpellsKnown_OpenFrame_TwoZoneLabelsAndTwoButtonDisplayed"] = function(f)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        WowMock:AddSpell(Spell_AstralRecall)
        TeleporterOpenFrame()
        f:TestEquals(#FindButtons(), 2, "There should be 2 buttons")
        f:TestEquals(#FindZoneLabels(), 2, "There should be 2 zone labels")
    end,
    ["OneItemOwned_OpenFrame_OneZoneLabelAndOneButtonDisplayed"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        TeleporterOpenFrame()
        f:TestEquals(#FindButtons(), 1, "There should be 1 button")
        f:TestEquals(#FindZoneLabels(), 1, "There should be 1 zone label")
    end,   
}

local numSucceeded = 0
local numFailed = 0

for name, testFunction in pairs(Tests) do
    WowMock:Init()
    local Fixture f = CreateFixture(name)

    f:BeforeTest()
    testFunction(f)
    if f.result then
        numSucceeded = numSucceeded + 1
    else
        numFailed = numFailed + 1
    end
end

print(numSucceeded .. " succeeded, " .. numFailed .. " failed.")