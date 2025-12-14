local Spell_TeleportDalaran = 53140
local Item_BandOfTheKirinTor = 40586
local Item_JainasLocket = 52251
local Item_CrusadersTabard = 46874
local Spell_TeleportExodar = 32271
local Item_RelicOfKarabor = 118663

local function AddSearchTestSpells()
    WowMock:AddSpell(Spell_TeleportDalaran, "Teleport: Dalaran")
    WowMock:AddItem(Item_BandOfTheKirinTor, "Band of the Kirin Tor")
    WowMock:AddItem(Item_JainasLocket, "Jaina's Locket")
    WowMock:AddItem(Item_CrusadersTabard, "Crusader's Tabard")
    WowMock:AddSpell(Spell_TeleportExodar, "Teleport: Exodar")
    WowMock:AddItem(Item_RelicOfKarabor, "Relic of Karabor")
end

AddTests(
{
    ["MultipleSpellsKnown_SearchForName_OnlyShowSpellsWithName"]  = function(f)
        AddSearchTestSpells()

        TeleporterOpenFrame()
        TeleporterTest_UpdateSearch("teleport")
        WowMock:Tick(1)

        local ids = TeleportTest_GetVisibleIds()
        f:TestEquals(ids.count, 2, "There should be 2 buttons")
        f:TestEquals(ids[Spell_TeleportDalaran], true, "Correct spells should be visible")
        f:TestEquals(ids[Spell_TeleportExodar], true, "Correct spells should be visible")
    end,
    ["MultipleSpellsKnown_SearchThenClearSearch_ShowAllSpells"]  = function(f)
        AddSearchTestSpells()

        TeleporterOpenFrame()
        TeleporterTest_UpdateSearch("teleport")
        WowMock:Tick(1)
        TeleporterTest_UpdateSearch("")
        WowMock:Tick(1)

        local ids = TeleportTest_GetVisibleIds()
        f:TestEquals(ids.count, 6, "There should be 6 buttons")
    end,
    ["MultipleSpellsKnown_SearchForZone_OnlyShowSpellsInZone"]  = function(f)
        AddSearchTestSpells()

        TeleporterOpenFrame()
        TeleporterTest_UpdateSearch("Dalaran")
        WowMock:Tick(1)

        local ids = TeleportTest_GetVisibleIds()
        f:TestEquals(ids.count, 3, "There should be 3 buttons")
        f:TestEquals(ids[Spell_TeleportDalaran], true, "Correct spells should be visible")
        f:TestEquals(ids[Item_BandOfTheKirinTor], true, "Correct spells should be visible")
        f:TestEquals(ids[Item_JainasLocket], true, "Correct spells should be visible")
    end,
    ["MultipleSpellsKnown_SearchForExpansion_OnlyShowSpellsInExpansion"]  = function(f)
        AddSearchTestSpells()

        TeleporterOpenFrame()
        TeleporterTest_UpdateSearch("Wrath of the Lich King")
        WowMock:Tick(1)

        local ids = TeleportTest_GetVisibleIds()
        f:TestEquals(ids.count, 4, "There should be 4 buttons")
        f:TestEquals(ids[Spell_TeleportDalaran], true, "Correct spells should be visible")
        f:TestEquals(ids[Item_BandOfTheKirinTor], true, "Correct spells should be visible")
        f:TestEquals(ids[Item_JainasLocket], true, "Correct spells should be visible")
        f:TestEquals(ids[Item_CrusadersTabard], true, "Correct spells should be visible")
    end,
    ["MultipleSpellsKnown_SearchForContinent_OnlyShowSpellsInContinent"]  = function(f)
        AddSearchTestSpells()

        TeleporterOpenFrame()
        TeleporterTest_UpdateSearch("Northrend")
        WowMock:Tick(1)

        local ids = TeleportTest_GetVisibleIds()
        f:TestEquals(ids.count, 4, "There should be 4 buttons")
        f:TestEquals(ids[Spell_TeleportDalaran], true, "Correct spells should be visible")
        f:TestEquals(ids[Item_BandOfTheKirinTor], true, "Correct spells should be visible")
        f:TestEquals(ids[Item_JainasLocket], true, "Correct spells should be visible")
        f:TestEquals(ids[Item_CrusadersTabard], true, "Correct spells should be visible")
    end,
})