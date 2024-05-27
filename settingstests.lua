local FullDungeonTeleportName = "Path of Heart's Bane"
local ShortDungeonTeleportName = "Heart's Bane"
local DungeonName = "Waycrest Manor"

local Zone_AstralRecall = "1 Astral Recall"

local Item_NightFaeHearthstone = 180290
local Item_NecrolordHearthstone = 182773
local Item_VenthyrHearthstone = 183716
local Item_KyrianHearthstone = 184353
local Item_ShroudOfCooperation = 63353
local Item_CloakOfCoordination = 65274

local CloakDestination = "Orgrimmar"

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
    ["RandomHearthstoneEnabled_OpenFrameMultipleTimes_SelectedItemIsNotAlwaysTheSame"]  = function(f)
        TomeOfTele_Options["randomHearth"] = true
        WowMock:AddItem(Item_ScrollOfTownPortal)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:AddToy(Item_DarkPortal)
        WowMock:AddToy(Item_FireEatersHearthstone)
        WowMock:AddToy(Item_EternalTravelersHearthstone)
        WowMock:AddToy(Item_TimewalkersHearthstone)

        TeleporterOpenFrame()

        local alwaysSame = true

        WowMock:Tick(1)

        for i = 1, 10, 1 do
            local spell1 = TeleporterTest_GetButtonSettings()[1].spellId
            TeleporterClose()
            WowMock:Tick(1)
            TeleporterOpenFrame()
            local spell2 = TeleporterTest_GetButtonSettings()[1].spellId
            alwaysSame = alwaysSame and spell1 == spell2
        end

        f:TestEquals(alwaysSame, false, "The selected hearthstone should change")
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
            succeeded = succeeded and spell1 == spell2
        end

        local startSpell = TeleporterTest_GetButtonSettings()[1].spellId
        WowMock:SetItemLoaded(Item_TimewalkersHearthstone, true)
        WowMock:Tick(1)
        local endSpell = TeleporterTest_GetButtonSettings()[1].spellId

        succeeded = succeeded and startSpell == endSpell
        f:TestEquals(succeeded, true, "The selected hearthstone should not change")
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
        f:TestEquals("\"" .. button.displaySpellName .. "\"", "\"" .. ShortDungeonTeleportName .. "\"", "Spell name should be truncated")
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
    end,
    ["CloseAfterCastEnabled_ClickSpellButtonAndTimePasses_FrameStaysOpenUntilEnd"] = function(f)
        TomeOfTele_Options["closeAfterCast"] = true
        WowMock:AddSpell(Spell_AstralRecall)

        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(TeleporterFrame:IsVisible(), true, "Frame should be open")
        WowMock:Tick(1)
        f:TestEquals(TeleporterFrame:IsVisible(), false, "Frame should have closed")
    end,
    ["CloseAfterCastEnabled_ClickToyButtonAndTimePasses_FrameStaysOpenUntilEnd"] = function(f)
        TomeOfTele_Options["closeAfterCast"] = true
        WowMock:AddToy(Toy_TomeOfTownPortal)

        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(TeleporterFrame:IsVisible(), true, "Frame should be open")
        WowMock:Tick(1)
        f:TestEquals(TeleporterFrame:IsVisible(), false, "Frame should have closed")
    end,
    ["CloseAfterCastEnabled_ClickItemButtonAndTimePasses_FrameIsClosed"] = function(f)
        TomeOfTele_Options["closeAfterCast"] = true
        WowMock:AddItem(Item_Hearthstone)

        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(TeleporterFrame:IsVisible(), true, "Frame should be open")
        WowMock:Tick(1)
        f:TestEquals(TeleporterFrame:IsVisible(), false, "Frame should have closed")
    end,
    ["AllCovenantsNotEnabledAndRandomHearthEnabled_OpenFrameMultipleTimes_AlwaysSelectOwnCovenant"]  = function(f)
        TomeOfTele_Options["randomHearth"] = true

        WowMock:AddToy(Item_NightFaeHearthstone)
        WowMock:AddToy(Item_NecrolordHearthstone)
        WowMock:AddToy(Item_VenthyrHearthstone)
        WowMock:AddToy(Item_KyrianHearthstone)

        WowMock:SetCovenant(1)  -- Kyrian

        local alwaysCovenant = true

        WowMock:Tick(1)

        for i = 1, 10, 1 do
            TeleporterOpenFrame()
            alwaysCovenant = alwaysCovenant and TeleporterTest_GetButtonSettings()[1].spellId == Item_KyrianHearthstone
            TeleporterClose()
        end

        f:TestEquals(alwaysCovenant, true, "The selected hearthstone should always be from the current covenant")
    end,
    ["AllCovenantsEnabledAndRandomHearthEnabled_OpenFrameMultipleTimes_DontAlwaysSelectOwnCovenant"]  = function(f)
        TomeOfTele_Options["randomHearth"] = true
        TomeOfTele_Options["allCovenants"] = true

        WowMock:AddToy(Item_NightFaeHearthstone)
        WowMock:AddToy(Item_NecrolordHearthstone)
        WowMock:AddToy(Item_VenthyrHearthstone)
        WowMock:AddToy(Item_KyrianHearthstone)

        WowMock:SetCovenant(1)  -- Kyrian

        local alwaysCovenant = true

        WowMock:Tick(1)

        for i = 1, 10, 1 do
            TeleporterOpenFrame()
            alwaysCovenant = alwaysCovenant and TeleporterTest_GetButtonSettings()[1].spellId == Item_KyrianHearthstone
            TeleporterClose()
        end

        f:TestEquals(alwaysCovenant, false, "The selected hearthstone should not always be from the current covenant")
    end,
    ["AllCovenantsNotEnabledAndRandomHearthNotEnabled_OpenFrame_AllCovenantsVisible"]  = function(f)
        WowMock:AddToy(Item_NightFaeHearthstone)
        WowMock:AddToy(Item_NecrolordHearthstone)
        WowMock:AddToy(Item_VenthyrHearthstone)
        WowMock:AddToy(Item_KyrianHearthstone)

        TeleporterOpenFrame()

        f:TestEquals(#TeleporterTest_GetButtonSettings(), 4, "There should be a button for each covenant")
    end,
    ["SpellIsHidden_OpenFrame_HasNoButtonForSpell"] = function(f)
        WowMock:AddSpell(Spell_AstralRecall, "Astral Recall")
        local spell = TeleporterCreateItem(Spell_AstralRecall, Zone_AstralRecall)

        spell:SetHidden()
        TeleporterOpenFrame()

        f:TestEquals(#TeleporterTest_GetButtonSettings(), 0, "There should be no buttons")
    end,
    ["SpellIsHiddenThenVisible_OpenFrame_HasButtonForSpell"] = function(f)
        WowMock:AddSpell(Spell_AstralRecall, "Astral Recall")
        local spell = TeleporterCreateItem(Spell_AstralRecall, Zone_AstralRecall)

        spell:SetHidden()
        spell:SetVisible()
        TeleporterOpenFrame()

        f:TestEquals(#TeleporterTest_GetButtonSettings(), 1, "There should be a button")
    end,
    ["SpellIsNotKnownAndAlwaysVisible_OpenFrame_HasButtonForSpell"] = function(f)
        local spell = TeleporterCreateItem(Spell_AstralRecall, Zone_AstralRecall)

        spell:SetAlwaysVisible()
        TeleporterOpenFrame()

        f:TestEquals(#TeleporterTest_GetButtonSettings(), 1, "There should be a button")
    end,
    ["SpellIsNotKnownAndAlwaysVisibleThenJustVisible_OpenFrame_HasNoButtonForSpell"] = function(f)
        local spell = TeleporterCreateItem(Spell_AstralRecall, Zone_AstralRecall)

        spell:SetAlwaysVisible()
        spell:SetVisible()
        TeleporterOpenFrame()

        f:TestEquals(#TeleporterTest_GetButtonSettings(), 0, "There should not be a button")
    end,
    ["SortByDestination_OpenFrame_SortedCorrectly"] = function(f)
        WowMock:AddToy(Item_NightFaeHearthstone)
        WowMock:AddSpell(Spell_Camp)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        WowMock:AddItem(Item_WormholeGeneratorZandalar)

        TeleporterSetOption("sort", 1)

        TeleporterOpenFrame()

        f:TestEquals(TeleporterTest_GetButtonSettings()[1].spellId, Item_NightFaeHearthstone, "Item 1 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[2].spellId, Spell_Camp, "Item 2 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[3].spellId, Spell_TeleportOrgrimmar, "Item 3 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[4].spellId, Item_WormholeGeneratorZandalar, "Item 4 sorted correctly")
    end,
    ["SortByType_OpenFrame_SortedCorrectly"] = function(f)
        WowMock:AddToy(Item_NightFaeHearthstone)
        WowMock:AddSpell(Spell_Camp)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        WowMock:AddItem(Item_WormholeGeneratorZandalar)

        TeleporterSetOption("sort", 2)

        TeleporterOpenFrame()

        f:TestEquals(TeleporterTest_GetButtonSettings()[1].spellId, Item_NightFaeHearthstone, "Item 1 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[2].spellId, Item_WormholeGeneratorZandalar, "Item 2 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[3].spellId, Spell_Camp, "Item 3 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[4].spellId, Spell_TeleportOrgrimmar, "Item 4 sorted correctly")
    end,
    ["SortCustom_NoCustomisations_SortedCorrectly"] = function(f)
        WowMock:AddToy(Item_NightFaeHearthstone)
        WowMock:AddSpell(Spell_Camp)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        WowMock:AddItem(Item_WormholeGeneratorZandalar)

        TeleporterSetOption("sort", 3)

        TeleporterOpenFrame()

        f:TestEquals(TeleporterTest_GetButtonSettings()[1].spellId, Item_NightFaeHearthstone, "Item 1 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[2].spellId, Spell_Camp, "Item 2 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[3].spellId, Spell_TeleportOrgrimmar, "Item 3 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[4].spellId, Item_WormholeGeneratorZandalar, "Item 4 sorted correctly")
    end,
    ["SortCustom_MoveSpellBefore_SortedCorrectly"] = function(f)
        WowMock:AddToy(Item_NightFaeHearthstone)
        WowMock:AddSpell(Spell_Camp)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        WowMock:AddItem(Item_WormholeGeneratorZandalar)

        TeleporterSetOption("sort", 3)
        TeleporterResetSort()

        local WormholeSpell = TeleporterCreateItem(Item_WormholeGeneratorZandalar, "Zandalar")
        local CampSpell = TeleporterCreateSpell(Spell_Camp, "Camp")
        TeleporterMoveSpellBefore(WormholeSpell, CampSpell)

        TeleporterOpenFrame()

        f:TestEquals(TeleporterTest_GetButtonSettings()[1].spellId, Item_NightFaeHearthstone, "Item 1 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[2].spellId, Item_WormholeGeneratorZandalar, "Item 2 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[3].spellId, Spell_Camp, "Item 3 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[4].spellId, Spell_TeleportOrgrimmar, "Item 4 sorted correctly")
    end,
    ["SortCustom_MoveSpellBelow_SortedCorrectly"] = function(f)
        WowMock:AddToy(Item_NightFaeHearthstone)
        WowMock:AddSpell(Spell_Camp)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        WowMock:AddItem(Item_WormholeGeneratorZandalar)

        TeleporterSetOption("sort", 3)
        TeleporterResetSort()

        local OgrimmarSpell = TeleporterCreateSpell(Spell_TeleportOrgrimmar, "Orgrimmar")
        local CampSpell = TeleporterCreateSpell(Spell_Camp, "Camp")
        TeleporterMoveSpellAfter(CampSpell, OgrimmarSpell)

        TeleporterOpenFrame()

        f:TestEquals(TeleporterTest_GetButtonSettings()[1].spellId, Item_NightFaeHearthstone, "Item 1 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[2].spellId, Spell_TeleportOrgrimmar, "Item 2 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[3].spellId, Spell_Camp, "Item 3 sorted correctly")
        f:TestEquals(TeleporterTest_GetButtonSettings()[4].spellId, Item_WormholeGeneratorZandalar, "Item 4 sorted correctly")
    end,
    ["SingleItem_OverrideZone_IsInRightSection"] = function(f)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)

        local NewZoneName = "Home"

        local spell = TeleporterCreateSpell(Spell_TeleportOrgrimmar, CloakDestination)

        spell:OverrideZoneName(NewZoneName)

        TeleporterOpenFrame()

        f:TestEquals(f:FindZoneLabels()[1]:GetText(), NewZoneName, "The zone name should have changed")
    end,
    ["SingleItem_OverrideZoneThenRevert_IsInRightSection"] = function(f)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)

        local NewZoneName = "Kyrian Home"

        local spell = TeleporterCreateSpell(Spell_TeleportOrgrimmar, CloakDestination)

        spell:OverrideZoneName(NewZoneName)
        spell:OverrideZoneName("")

        TeleporterOpenFrame()

        f:TestEquals(f:FindZoneLabels()[1]:GetText(), CloakDestination, "The zone name should have reset")
    end,
    ["TwoItemsInSameZone_OverrideZoneOfOne_SplitIntoSeparateSections"] = function(f)
        WowMock:AddItem(Item_ShroudOfCooperation)
        WowMock:AddItem(Item_CloakOfCoordination)

        local item = TeleporterCreateItem(Item_ShroudOfCooperation, CloakDestination)
        item:OverrideZoneName("Home")

        TeleporterOpenFrame()
        f:TestEquals(#f:FindZoneLabels(), 2, "The buttons should be in separate zones")
    end,
    ["TwoItemsInSameZone_OverrideZoneOfOneThenSetDefault_AreInSingleSection"] = function(f)
        WowMock:AddItem(Item_ShroudOfCooperation)
        WowMock:AddItem(Item_CloakOfCoordination)

        local item = TeleporterCreateItem(Item_NightFaeHearthstone, CloakDestination)
        item:OverrideZoneName("Home")
        item:OverrideZoneName("")

        TeleporterOpenFrame()

        f:TestEquals(#f:FindZoneLabels(), 1, "The buttons should be in the same zone")
    end,
    ["CustomItemInSettings_ResetGame_NoErrors"] = function(f)
        local Item_CritterHandCannon = 131933
        WowMock:AddToy(Item_CritterHandCannon)

       local extraSpellsAndItems = {
            {
            ["isItem"] = true,
            ["spellId"] = ""..Item_CritterHandCannon,
            ["zone"] = "Black Temple",
            ["toySpell"] = "Critter Shot",
            ["isCustom"] = true,
            ["spellType"] = 1,
            ["itemTexture"] = 331784,
            ["displayDestination"] = "Black Temple",
            ["spellName"] = "Critter Hand Cannon",
            }
        }
        TeleporterSetOption("extraSpellsAndItems", extraSpellsAndItems)

        TeleporterRebuildSpellList()
        TeleporterOpenFrame()

        f:TestEquals(#f:FindButtons(), 1, "There should be 1 button")
    end,
    ["DuplicateItemInSettings_OpenFrame_OnlyShownOnce"] = function(f)
        WowMock:AddToy(Item_NightFaeHearthstone)

        local extraSpellsAndItems = {
             {
             ["isItem"] = true,
             ["spellId"] = ""..Item_NightFaeHearthstone,
             ["zone"] = "0 Hearth",
             ["toySpell"] = "Hearthstone",
             ["isCustom"] = true,
             ["spellType"] = 1,
             ["itemTexture"] = 0,
             ["displayDestination"] = "0 Hearth",
             ["spellName"] = "Night Fae Hearthstone",
             }
         }
         TeleporterSetOption("extraSpellsAndItems", extraSpellsAndItems)

         TeleporterRebuildSpellList()
         TeleporterOpenFrame()

         f:TestEquals(#f:FindButtons(), 1, "There should be 1 button")
     end,
})

-- No test for seasonOnly because it keeps changing. I'll add one if I find an API to query it