local AddonFolder = "D:/World of Warcraft/_retail_/Interface/Addons/TomeOfTeleportation/"
dofile("WowMock.lua")
dofile(AddonFolder .. "TomeOfTeleportation.lua")
dofile(AddonFolder .. "Spells.lua")


Item_Hearthstone = 6948
Item_Atiesh = 22589
Item_ScrollOfTownPortal = 142543

Toy_TomeOfTownPortal = 142542

Spell_AstralRecall = 556
Spell_TeleportOrgrimmar = 3567


Fixture = {}

function Fixture:BeforeTest()
    CreateFrame("Frame", "TeleporterFrame")
    Teleporter_OnAddonLoaded()
    WowMock:SetOnUpdate(Teleporter_OnUpdate)

    TeleporterClose()
end

function Fixture:TestEquals(v1, v2, text)
    if v1 ~= v2 then
        print(self.name .. " \"" .. text .. "\" failed. " .. tostring(v1) .. " does not equal " .. tostring(v2) .. ".")
        self.result = false
    end
end

function Fixture:FindButtons()    
    return WowMock:FindFramesWithTemplate("InsecureActionButtonTemplate")
end

function Fixture:FindZoneLabels()
    return WowMock:FindFramesWithPrefix("TeleporterDL")
end

function CreateFixture(name)
    local f = {}
    setmetatable(f, {__index=Fixture})
    f.result = true
    f.name = name
    return f
end


local Tests = {}

function AddTests(tests)
    for name, func in pairs(tests) do
        if Tests[name] then
            print("Duplicate test name " .. name)
        end
        Tests[name] = func
    end
end

dofile("layouttests.lua")
dofile("interactiontests.lua")

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