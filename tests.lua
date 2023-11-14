local AddonFolder = "D:/World of Warcraft/_retail_/Interface/Addons/TomeOfTeleportation/"
dofile("WowMock.lua")
dofile(AddonFolder .. "TomeOfTeleportation.lua")
dofile(AddonFolder .. "Spells.lua")


Item_Hearthstone = 6948

Toy_TomeOfTownPortal = 142542

Spell_AstralRecall = 556
Spell_TeleportOrgrimmar = 3567

Fixture = {}

function Fixture:RunTest()
    CreateFrame("Frame", "TeleporterFrame")
    Teleporter_OnAddonLoaded()

    TeleporterClose()

    self.test(self)

    return self.result
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

local Fixture f = CreateFixture("OneSpellKnown_OpenFrame_OneButtonDisplayed")
f.test = function(f)
    WowMock:AddSpell(Spell_TeleportOrgrimmar)
    TeleporterOpenFrame()
    f:TestEquals(#FindButtons(), 1, "There should be 1 button")
end
print(f:RunTest())