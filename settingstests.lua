local FullDungeonTeleportName = "Path of Heart's Bane"
local ShortDungeonTeleportName = " Heart's Bane"    -- Bug! This shouldn't have the space.
local DungeonName = "Waycrest Manor"

local function AddItemsOfEachType()
    WowMock:AddItem(Item_ScrollOfTownPortal, nil, "Scroll of Town Portal")
    WowMock:AddItem(Item_ScrollOfTownPortal, nil, "Scroll of Town Portal")
    WowMock:AddItem(Item_Atiesh, nil, "Atiesh Greatstaff of the Guardian")
    WowMock:AddToy(Toy_TomeOfTownPortal, nil, "Tome of Town Portal")
    WowMock:AddSpell(Spell_AstralRecall, "Astral Recall")
    WowMock:AddSpell(Spell_PathOfHeartsBane, FullDungeonTeleportName)
end

AddTests(
{ 
    ["RandomHearthstoneEnabled_OpenFrame_OnlyOneHearthstoneShown"]  = function(f)
        TomeOfTele_Options["randomHearth"] = true
        WowMock:AddItem(Item_ScrollOfTownPortal)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:AddToy(Item_DarkPortal)
        WowMock:AddToy(Item_FireEatersHearthstone)
        WowMock:AddToy(Item_EternalTravelersHearthstone)
        WowMock:AddToy(Item_TimewalkersHearthstone)

        TeleporterOpenFrame()
        f:TestEquals(#f:FindButtons(), 1, "There should be 1 button")
        f:TestEquals(#f:FindZoneLabels(), 1, "There should be 1 zone label")
    end,
    ["RandomHearthstoneEnabled_OpenFrame_AstralRecallShownSeparately"]  = function(f)
        TomeOfTele_Options["randomHearth"] = true
        WowMock:AddItem(Item_ScrollOfTownPortal)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:AddToy(Item_DarkPortal)
        WowMock:AddToy(Item_FireEatersHearthstone)
        WowMock:AddToy(Item_EternalTravelersHearthstone)
        WowMock:AddToy(Item_TimewalkersHearthstone)
        WowMock:AddSpell(Spell_AstralRecall)

        TeleporterOpenFrame()
        f:TestEquals(#f:FindButtons(), 2, "There should be 2 buttons")
        f:TestEquals(#f:FindZoneLabels(), 1, "There should be 1 zone label")
    end,
    ["RandomHearthstoneEnabled_OpenFrameBeforeFullyLoaded_OnlyOneHearthstoneShown"]  = function(f)
        TomeOfTele_Options["randomHearth"] = true
        WowMock:AddItem(Item_ScrollOfTownPortal)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:AddToy(Item_DarkPortal)
        WowMock:AddToy(Item_FireEatersHearthstone)
        WowMock:AddToy(Item_EternalTravelersHearthstone)
        WowMock:AddToy(Item_TimewalkersHearthstone)

        WowMock:SetLoaded(false)

        TeleporterOpenFrame()
        f:TestEquals(#f:FindButtons(), 1, "There should be 1 button")
    end,
    ["RandomHearthstoneEnabled_OpenFrameAndWait_SelectedItemDoesNotChange"]  = function(f)
        TomeOfTele_Options["randomHearth"] = true
        WowMock:AddItem(Item_ScrollOfTownPortal)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:AddToy(Item_DarkPortal)
        WowMock:AddToy(Item_FireEatersHearthstone)
        WowMock:AddToy(Item_EternalTravelersHearthstone)
        WowMock:AddToy(Item_TimewalkersHearthstone)

        TeleporterOpenFrame()

        local succeeded = true

        WowMock:Tick(1)

        -- This is random, so need to repeat the test multiple times to be certain
        for i = 1, 10, 1 do
            local spell1 = TeleporterTest_GetButtonSettings()[1].spellId
            WowMock:Tick(1)
            local spell2 = TeleporterTest_GetButtonSettings()[1].spellId
            succeeded = succeeded and spell1 == spell2
        end        
        
        f:TestEquals(succeeded, true, "The selected hearthstone should not change")
    end,
    ["RandomHearthstoneEnabled_OpenFrameWhileSomeSpellsUnloaded_SelectedItemDoesNotChange"]  = function(f)
        TomeOfTele_Options["randomHearth"] = true
        WowMock:AddItem(Item_ScrollOfTownPortal)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:AddToy(Item_DarkPortal)
        WowMock:AddToy(Item_FireEatersHearthstone)
        WowMock:AddToy(Item_EternalTravelersHearthstone)
        WowMock:AddToy(Item_TimewalkersHearthstone)

        WowMock:SetItemLoaded(Item_Atiesh, false)

        TeleporterOpenFrame()

        local succeeded = true

        -- This is random, so need to repeat the test multiple times to be certain
        for i = 1, 10, 1 do
            local spell1 = TeleporterTest_GetButtonSettings()[1].spellId
            WowMock:Tick(1)
            local spell2 = TeleporterTest_GetButtonSettings()[1].spellId
            succeeded = succeded and spell1 == spell2
        end        
        
        local startSpell = TeleporterTest_GetButtonSettings()[1].spellId
        WowMock:SetItemLoaded(Item_TimewalkersHearthstone, true)        
        WowMock:Tick(1)
        local endSpell = TeleporterTest_GetButtonSettings()[1].spellId

        succeeded = succeded and startSpell == endSpell
        f:TestEqualsKnownFailure(succeeded, true, "The selected hearthstone should not change")
    end,
    ["HideItemsEnabled_OpenFrame_DoesNotShowItems"]  = function(f)
        TomeOfTele_Options["hideItems"] = true
        AddItemsOfEachType()

        TeleporterOpenFrame()

        f:TestEquals(#f:FindButtons(), 2, "Correct number of buttons should be visible")
        f:TestEquals(TeleporterTest_GetButtonSettingsFromItemId(Item_ScrollOfTownPortal), nil, "Consumable should not be visible")
        f:TestEquals(TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh), nil, "Item should not be visible")
        f:TestEquals(TeleporterTest_GetButtonSettingsFromItemId(Toy_TomeOfTownPortal), nil, "Toy should not be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromSpellId(Spell_AstralRecall), nil, "Spell should be visible")        
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromSpellId(Spell_PathOfHeartsBane), nil, "Dungeon spell should be visible")        
    end,
    ["HideConsumablesEnabled_OpenFrame_DoesNotShowConsumables"]  = function(f)
        TomeOfTele_Options["hideConsumable"] = true
        AddItemsOfEachType()

        TeleporterOpenFrame()

        f:TestEquals(#f:FindButtons(), 4, "Correct number of buttons should be visible")
        f:TestEquals(TeleporterTest_GetButtonSettingsFromItemId(Item_ScrollOfTownPortal), nil, "Consumable should not be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh), nil, "Item should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromItemId(Toy_TomeOfTownPortal), nil, "Toy should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromSpellId(Spell_AstralRecall), nil, "Spell should be visible")        
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromSpellId(Spell_PathOfHeartsBane), nil, "Dungeon spell should be visible")        
    end,
    ["HideSpellsEnabled_OpenFrame_DoesNotShowSpells"]  = function(f)
        TomeOfTele_Options["hideSpells"] = true
        AddItemsOfEachType()

        TeleporterOpenFrame()

        f:TestEquals(#f:FindButtons(), 4, "Correct number of buttons should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromItemId(Item_ScrollOfTownPortal), nil, "Consumable should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh), nil, "Item should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromItemId(Toy_TomeOfTownPortal), nil, "Toy should be visible")
        f:TestEquals(TeleporterTest_GetButtonSettingsFromSpellId(Spell_AstralRecall), nil, "Spell should not be visible")        
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromSpellId(Spell_PathOfHeartsBane), nil, "Dungeon spell should be visible")        
    end,
    ["HideChallengeEnabled_OpenFrame_DoesNotShowDungeonSpells"]  = function(f)
        TomeOfTele_Options["hideChallenge"] = true
        AddItemsOfEachType()

        TeleporterOpenFrame()

        f:TestEquals(#f:FindButtons(), 4, "Correct number of buttons should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromItemId(Item_ScrollOfTownPortal), nil, "Consumable should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh), nil, "Item should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromItemId(Toy_TomeOfTownPortal), nil, "Toy should be visible")
        f:TestNotEquals(TeleporterTest_GetButtonSettingsFromSpellId(Spell_AstralRecall), nil, "Spell should be visible")        
        f:TestEquals(TeleporterTest_GetButtonSettingsFromSpellId(Spell_PathOfHeartsBane), nil, "Dungeon spell should not be visible")        
    end,
    ["KnowDungeonSpell_OpenFrame_NameIsTruncated"] = function(f)
        WowMock:AddSpell(Spell_PathOfHeartsBane, FullDungeonTeleportName)
        
        TeleporterOpenFrame()

        local button = TeleporterTest_GetButtonSettingsFromSpellId(Spell_PathOfHeartsBane)
        f:TestEquals(button.displaySpellName, ShortDungeonTeleportName, "Spell name should be truncated")
    end,
    ["ShowDungeonNamesEnabled_OpenFrame_NameIsTruncated"] = function(f)
        TomeOfTele_Options["showDungeonNames"] = true
        WowMock:AddSpell(Spell_PathOfHeartsBane, FullDungeonTeleportName)
        
        TeleporterOpenFrame()

        local button = TeleporterTest_GetButtonSettingsFromSpellId(Spell_PathOfHeartsBane)
        f:TestEquals(button.displaySpellName, DungeonName, "Should display dungeon name")
    end,
    ["GroupDungeonsDisabled_OpenFrame_EachDungeonIsInItsOwnSection"] = function(f)
        WowMock:AddSpell(Spell_PathOfHeartsBane)
        WowMock:AddSpell(Spell_PathOfTheVigilant)
        WowMock:AddSpell(Spell_PathOfArcaneSecrets)
        WowMock:AddSpell(Spell_PathOfTheSettingSun)

        TeleporterOpenFrame()

        f:TestEquals(#f:FindZoneLabels(), 4, "Each spell should have its own section")
    end,
    ["GroupDungeonsEnabled_OpenFrame_EachDungeonIsInItsOwnSection"] = function(f)
        TomeOfTele_Options["groupDungeons"] = true

        WowMock:AddSpell(Spell_PathOfHeartsBane)
        WowMock:AddSpell(Spell_PathOfTheVigilant)
        WowMock:AddSpell(Spell_PathOfArcaneSecrets)
        WowMock:AddSpell(Spell_PathOfTheSettingSun)

        TeleporterOpenFrame()

        f:TestEquals(#f:FindZoneLabels(), 1, "Spells should be grouped")
    end,
    ["GroupDungeonsEnabledWithNonDungeonSpells_OpenFrame_OnlyDungeonSpellsAreGrouped"] = function(f)
        TomeOfTele_Options["groupDungeons"] = true

        WowMock:AddSpell(Spell_PathOfHeartsBane)
        WowMock:AddSpell(Spell_PathOfTheVigilant)
        WowMock:AddSpell(Spell_PathOfArcaneSecrets)
        WowMock:AddSpell(Spell_PathOfTheSettingSun)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)

        TeleporterOpenFrame()

        f:TestEquals(#f:FindZoneLabels(), 2, "Only dungeon spells should be grouped")
    end, 
    ["SpellHasZoneRestrictionAndPlayerInWrongZone_OpenFrame_SpellIsNotVisible"] = function(f)
        WowMock:AddItem(Item_KirinTorBeacon)
        WowMock:SetMap(100)

        TeleporterOpenFrame()

        f:TestEquals(#f.FindButtons(), 0, "Button should not be visible")
    end,
    ["SpellHasZoneRestrictionAndPlayerInRightZone_OpenFrame_SpellIsVisible"] = function(f)
        WowMock:AddItem(Item_KirinTorBeacon)
        WowMock:SetMap(504) -- MapIDIsleOfThunder in Spells.lua

        TeleporterOpenFrame()

        f:TestEquals(#f.FindButtons(), 1, "Button should be visible")
    end,
    ["ShowInWrongZoneEnabledAndPlayerInWrongZone_OpenFrame_SpellIsNotVisible"] = function(f)
        TomeOfTele_Options["showInWrongZone"] = true
        WowMock:AddItem(Item_KirinTorBeacon)
        WowMock:SetMap(100)

        TeleporterOpenFrame()

        f:TestEquals(#f.FindButtons(), 1, "Button should be visible")
    end
})

-- No test for seasonOnly because it keeps changing. I'll add one if I find an API to query it