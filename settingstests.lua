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
})