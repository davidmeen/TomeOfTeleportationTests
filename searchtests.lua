local Spell_TeleportDalaran = 53140
local Item_BandOfTheKirinTor = 40586
local Item_JainasLocket = 52251
local Item_CrusadersTabard = 46874
local Spell_TeleportExodar = 32271
local Item_RelicOfKarabor = 118663

local Zone_Dalaran = 125
local Zone_Orgrimmar = 85

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
    -- UI tests
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


    ------------------------------------------------------
    -- TeleporterSearch class tests
    -- Simple search
    ["TeleporterSearch_StringInName_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("teleport")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearch_StringNotInName_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("portal")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,

    -- Search name
    ["TeleporterSearchName_StringInName_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("name:teleport")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchName_StringNotInName_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("name:portal")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchName_StringInZoneButNotInName_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Ruby Slippers"
        local search = TeleporterSearch.Create("name:dalaran")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,

    -- Search zone
    ["TeleporterSearchZone_StringInZone_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Ruby Slippers"
        local search = TeleporterSearch.Create("zone:Dalaran")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchZone_StringNotInZone_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Ruby Slippers"
        local search = TeleporterSearch.Create("zone:Orgrimmar")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchName_StringInNameButNotInZone_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Orgrimmar", Zone_Orgrimmar)
        spell.spellName = "Teleport: Not Dalaran"
        local search = TeleporterSearch.Create("zone:dalaran")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchZone_StringInParentZone_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Ruby Slippers"
        local search = TeleporterSearch.Create("zone:Northrend")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,

    -- Search expansion
    ["TeleporterSearchExpansion_StringInExpansion_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Ruby Slippers"
        spell.expansion = 7
        local search = TeleporterSearch.Create("expansion:Legion")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchExpansion_StringNotInExpansion_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Ruby Slippers"
        spell.expansion = 7
        local search = TeleporterSearch.Create("expansion:Midnight")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,

    -- Search dungeon
    ["TeleporterSearchDungeon_StringInDungeon_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell.spellName = "Path of the Stormwind Dungeon"
        spell.dungeon = "Stormwind Stockades"
        local search = TeleporterSearch.Create("dungeon:Stockades")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchDungeon_StringNotInDungeon_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell.spellName = "Path of the Stormwind Dungeon"
        spell.dungeon = "Stormwind Stockades"
        local search = TeleporterSearch.Create("dungeon:Ragefire")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,

    -- Search type
    ["TeleporterSearchType_SearchSpellForSpell_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        local search = TeleporterSearch.Create("type:spell")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchType_SearchItemForSpell_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateItem(spellID)
        local search = TeleporterSearch.Create("type:spell")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchType_SearchItemForItem_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateItem(spellID)
        local search = TeleporterSearch.Create("type:item")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchType_SearchSpellForItem_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        local search = TeleporterSearch.Create("type:item")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchType_SearchDungeonForDungeon_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateDungeonSpell(spellID, 0, 0)
        local search = TeleporterSearch.Create("type:dungeon")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchType_SearchNormalSpellForDungeon_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        local search = TeleporterSearch.Create("type:dungeon")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchType_SearchRaidForRaid_Matches"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateRaidSpell(spellID, 0, 0)
        local search = TeleporterSearch.Create("type:raid")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchType_SearchNormalSpellForRaid_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        local search = TeleporterSearch.Create("type:raid")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,

    -- Ops

    -- Not
    ["TeleporterSearchNot_SearchNameInString_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("not (Teleport)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchNot_SearchNameNotInString_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("not (Teleaport)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchNot_SearchCorrectType_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateItem(spellID)
        local search = TeleporterSearch.Create("not (type:item)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchNot_SearchIncorrectType_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateItem(spellID)
        local search = TeleporterSearch.Create("not (type:spell)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,

    -- Or
    ["TeleporterSearchOr_SearchNameInFirstString_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Dalaran) or (Silvermoon)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchOr_SearchNameInSecondString_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Silvermoon) or (Dalaran)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchOr_SearchNameInBothStrings_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Teleport) or (Dalaran)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchOr_SearchNameInNeitherString_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Silvermoon) or (Orgrimmar)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,

    -- And
    ["TeleporterSearchAnd_SearchNameInFirstString_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Dalaran) and (Silvermoon)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchOr_SearchNameInSecondString_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Silvermoon) and (Dalaran)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchOr_SearchNameInBothStrings_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Teleport) and (Dalaran)")
        f:TestFalse(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchOr_SearchNameInNeitherString_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Silvermoon) and (Orgrimmar)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,

    -- Or Not
    ["TeleporterSearchOrNot_SearchNameInFirstString_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Dalaran) or not (Silvermoon)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchOr_SearchNameInSecondString_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Silvermoon) or not (Dalaran)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchOr_SearchNameInBothStrings_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Teleport) or not (Dalaran)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchOr_SearchNameInNeitherString_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Silvermoon) or not (Orgrimmar)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,

    -- And Not
    ["TeleporterSearchAndNot_SearchNameInFirstString_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Dalaran) and not (Silvermoon)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchAndNot_SearchNameInSecondString_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Silvermoon) and not (Dalaran)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearcAndNot_SearchNameInBothStrings_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Teleport) and not (Dalaran)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchAndNot_SearchNameInNeitherString_DoesNotMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(Silvermoon) and not (Orgrimmar)")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,

    -- Parantheses
    ["TeleporterSearchAndOr_SearchWithParanthesesOnLeft_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("((zone:Dalaran) and (zone:Orgrimmar)) or (name:Teleport)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
    ["TeleporterSearchAndOr_SearchWithParanthesesOnRight_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        local search = TeleporterSearch.Create("(zone:Dalaran) and ((zone:Orgrimmar) or (name:Teleport))")
        f:TestFalse(search:MatchSpell(spell), "Spell should not pass search")
    end,
    ["TeleporterSearchAndOr_SearchWithParanthesesOnLeft_DoesMatch"] = function(f)
        local spellID = 100
        local spell = TeleporterCreateSpell(spellID)
        spell:SetZone("Dalaran", Zone_Dalaran)
        spell.spellName = "Teleport: Dalaran"
        -- Left to right ordering, so this should be equivalent to ((zone:Dalaran) and (zone:Orgrimmar)) or (name:Teleport)
        local search = TeleporterSearch.Create("(zone:Dalaran) and (zone:Orgrimmar) or (name:Teleport)")
        f:TestTrue(search:MatchSpell(spell), "Spell should pass search")
    end,
})