local Spell_VisitHome = 1233637
local Spell_Return = 1270311

local Zone_OrcHouses = 2351
local Zone_HumanHouses = 2352

local HumanHouse =
{
    ["plotID"] = 12,
    ["houseName"] = "12 Alliance Street",
    ["ownerName"] = "Anduin",
    ["plotCost"] = 1000,
    ["neighborhoodName"] = "Alliance Street",
    ["neighborhoodGUID"] = "Neighourhood-1-2-3-4-ABCD",
    ["houseGUID"] = "Housing-4-3-2-1-DCBA",
    ["mapID"] = Zone_HumanHouses
}

local OrcHouse =
{
    ["plotID"] = 4,
    ["houseName"] = "4 Horde Lane",
    ["ownerName"] = "Thrall",
    ["plotCost"] = 1000,
    ["neighborhoodName"] = "Horde Lane",
    ["neighborhoodGUID"] = "Neighourhood-5-6-7-8-DEF0",
    ["houseGUID"] = "Housing-8-7-6-5-0FED",
    ["mapID"] = Zone_OrcHouses
}

AddTests(
{
    ["PlayerHasNoHouses_OpenFrame_NoButtons"]  = function(f)
        WowMock:AddSpell(Spell_VisitHome)
        TeleporterOpenFrame()
        WowMock:Tick(1)

        f:TestEquals(#f:FindButtons(), 0, "There should be 0 buttons")
        f:TestEquals(#f:FindZoneLabels(), 0, "There should be 0 zone labels")
    end,
    ["PlayerHasOneHouse_OpenFrame_OneButton"]  = function(f)
        WowMock:AddSpell(Spell_VisitHome)
        WowMock:SetHouses({OrcHouse});
        TeleporterOpenFrame()
        WowMock:Tick(1)

        f:TestEquals(#f:FindButtons(), 1, "There should be 1 button")
        f:TestEquals(#f:FindZoneLabels(), 1, "There should be 1 zone label")
    end,
    ["PlayerHasTwoHouses_OpenFrame_TwoButtons"]  = function(f)
        WowMock:AddSpell(Spell_VisitHome)
        WowMock:SetHouses({OrcHouse, HumanHouse});
        TeleporterOpenFrame()
        WowMock:Tick(1)

        f:TestEquals(#f:FindButtons(), 2, "There should be 2 buttons")
        f:TestEquals(#f:FindZoneLabels(), 1, "There should be 1 zone label")
    end,
    ["NoHousingAPI_OpenFrame_NoButtons"]  = function(f)
        OldCHousing = C_Housing
        C_Housing = nil

        WowMock:AddSpell(Spell_VisitHome)
        TeleporterOpenFrame()
        WowMock:Tick(1)

        f:TestEquals(#f:FindButtons(), 0, "There should be 0 buttons")
        f:TestEquals(#f:FindZoneLabels(), 0, "There should be 0 zone labels")

        C_Housing = OldCHousing
    end,
})