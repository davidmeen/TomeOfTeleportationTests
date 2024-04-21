local AddonFolder = arg[1] or "C:/World of Warcraft/_retail_/Interface/Addons/TomeOfTeleportation/"
dofile("WowMock.lua")
dofile(AddonFolder .. "TeleporterSpell.lua")
dofile(AddonFolder .. "TomeOfTeleportation.lua")
dofile(AddonFolder .. "Spells.lua")
dofile(AddonFolder .. "TomeQuickMenu.lua")


Item_Hearthstone = 6948
Item_Atiesh = 22589
Item_ScrollOfTownPortal = 142543

Toy_TomeOfTownPortal = 142542
Item_DarkPortal = 93672
Item_FireEatersHearthstone = 166746
Item_EternalTravelersHearthstone = 172179
Item_TimewalkersHearthstone = 193588
Item_KirinTorBeacon = 95567

Spell_AstralRecall = 556
Spell_TeleportOrgrimmar = 3567
Spell_PathOfHeartsBane = 424167
Spell_PathOfTheVigilant = 159897
Spell_PathOfArcaneSecrets = 393279
Spell_PathOfTheSettingSun = 131225

Fixture = {}

function Fixture:BeforeTest()
    TeleporterTest_Reset()
    CreateFrame("Frame", "TeleporterFrame")    
    Teleporter_OnAddonLoaded()
    Teleporter_OnLoad()
    WowMock:SetOnUpdate(Teleporter_OnUpdate)
    WowMock:SetLoaded(true)

    TomeOfTele_Options = {}
    TomeOfTele_ShareOptions = false

    TeleporterFrame:SetOnHide(Teleporter_OnHide)

    TeleporterFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    TeleporterFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");
    TeleporterFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
    TeleporterFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
    TeleporterFrame:RegisterEvent("ZONE_CHANGED");
    TeleporterFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
    TeleporterFrame:RegisterEvent("ZONE_CHANGED_INDOORS");
    TeleporterFrame.OnEvent = Teleporter_OnEvent

    TeleporterClose()
end

function Fixture:AfterTest()
    WowMock:DeleteFrames()
end

function Fixture:WaitUntilLoaded()
    print("wait")
    WowMock:Tick(1)
end

function Fixture:TestEquals(v1, v2, text)
    if v1 ~= v2 then
        print(self.name .. " \"" .. text .. "\" failed. " .. tostring(v1) .. " does not equal " .. tostring(v2) .. ".")
        self.result = false
    end
end

function Fixture:TestNotEquals(v1, v2, text)
    if v1 == v2 then
        print(self.name .. " \"" .. text .. "\" failed. " .. tostring(v1) .. " equals " .. tostring(v2) .. ".")
        self.result = false
    end
end

function Fixture:TestEqualsKnownFailure(v1, v2, text)
    if v1 ~= v2 then
        print(self.name .. " \"" .. text .. "\" failed (known bug). " .. tostring(v1) .. " does not equal " .. tostring(v2) .. ".")
        self.result = false
    else
        print(self.name .. " \"" .. text .. "\" expected to fail but didn't.")
    end
end

function Fixture:TestButtonColour(button, colourSetting, message)
    local settingR = TeleporterGetOption(colourSetting .. "R")
    local settingG = TeleporterGetOption(colourSetting .. "G")
    local settingB = TeleporterGetOption(colourSetting .. "B")

    local buttonR, buttonG, buttonB = button.frame.backdrop:GetBackdropColor()

    self:TestEquals(settingR, buttonR, message .. " (R)")
    self:TestEquals(settingG, buttonG, message .. " (G)")
    self:TestEquals(settingB, buttonB, message .. " (B)")
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
dofile("settingstests.lua")

local numSucceeded = 0
local numFailed = 0

for name, testFunction in pairs(Tests) do
    -- TODO: On a switch
    --local runOnly1 = "RandomHearthstoneEnabled_OpenFrameAndWait_SelectedItemDoesNotChange"
    --local runOnly2 = "HaveEquipableItemUnequiped_ClickButtonTwice_ItemIsUsedAndClosesFrameAndUnequips"    
    if not runOnly1 or name == runOnly1 or name == runOnly2 then
        --print(name)

        WowMock:Init()
        local Fixture f = CreateFixture(name)

        f:BeforeTest()
        testFunction(f)
        if f.result then
            numSucceeded = numSucceeded + 1
        else
            numFailed = numFailed + 1
        end
        f:AfterTest()
    end
end

print(numSucceeded .. " succeeded, " .. numFailed .. " failed.")