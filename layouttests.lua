AddTests(
{    
    ["OneSpellKnown_OpenFrame_OneZoneLabelAndOneButtonDisplayed"] = function(f)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        TeleporterOpenFrame()
        f:TestEquals(#f:FindButtons(), 1, "There should be 1 button")
        f:TestEquals(#f:FindZoneLabels(), 1, "There should be 1 zone label")
    end,
    ["TwoSpellsKnown_OpenFrame_TwoZoneLabelsAndTwoButtonDisplayed"] = function(f)
        WowMock:AddSpell(Spell_TeleportOrgrimmar)
        WowMock:AddSpell(Spell_AstralRecall)
        TeleporterOpenFrame()
        f:TestEquals(#f:FindButtons(), 2, "There should be 2 buttons")
        f:TestEquals(#f:FindZoneLabels(), 2, "There should be 2 zone labels")
    end,
    ["OneItemOwned_OpenFrame_OneZoneLabelAndOneButtonDisplayed"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        TeleporterOpenFrame()
        f:TestEquals(#f:FindButtons(), 1, "There should be 1 button")
        f:TestEquals(#f:FindZoneLabels(), 1, "There should be 1 zone label")
    end,
    ["TwoItemsOwned_OpenFrame_TwoZoneLabelsAndTwoButtonsDisplayed"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        WowMock:AddItem(Item_Atiesh)
        TeleporterOpenFrame()
        f:TestEquals(#f:FindButtons(), 2, "There should be 2 buttons")
        f:TestEquals(#f:FindZoneLabels(), 2, "There should be 2 zone labels")
    end,  
    ["OneToyOwned_OpenFrame_OneZoneLabelAndOneButtonDisplayed"] = function(f)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        TeleporterOpenFrame()
        f:TestEquals(#f:FindButtons(), 1, "There should be 1 button")
        f:TestEquals(#f:FindZoneLabels(), 1, "There should be 1 zone label")
    end, 
    ["MultipleSpellsInZone_OpenFrame_OnlyDisplayZoneOnce"] = function(f)
        WowMock:AddItem(Item_ScrollOfTownPortal)
        WowMock:AddItem(Toy_TomeOfTownPortal)
        WowMock:AddSpell(Spell_AstralRecall)
        WowMock:AddItem(Item_Atiesh)
        TeleporterOpenFrame()
        local buttons = f:FindButtons()
        f:TestEquals(#buttons, 4, "There should be 4 buttons")
        f:TestEquals(#f:FindZoneLabels(), 2, "There should be 2 zone labels")
    end, 
    ["ConsumablesOwned_OpenFrame_CountDisplayedOnButton"] = function(f)
        WowMock:AddItem(Item_ScrollOfTownPortal)
        WowMock:AddItem(Item_ScrollOfTownPortal)
        TeleporterOpenFrame()
        local buttons = f:FindButtons()
        f:TestEquals(#buttons, 1, "There should be 1 button")
        local buttonSettings = TeleporterTest_GetButtonSettingsFromFrame(buttons[1])
        f:TestEquals(buttonSettings.countString:GetText(), 2, "The button should display the correct item count")
    end, 
    ["SpellsOnCooldown_OpenFrame_CooldownTextDisplayedOnButton"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        WowMock:SetItemCooldown(Item_Hearthstone, GetTime() - 15 * 60 * 60, 30 * 60 * 60)

        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:SetItemCooldown(Toy_TomeOfTownPortal, GetTime() - 10 * 60, 30 * 60)

        WowMock:AddSpell(Spell_AstralRecall)
        WowMock:SetSpellCooldown(Spell_AstralRecall, GetTime() - 5, 30)
        
        TeleporterOpenFrame()

        local hearthCooldownString = TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone).cooldownString
        f:TestEquals(hearthCooldownString:GetText(), "15h", "The Hearthstone button should display the correct cooldown")

        local tomeCooldownString = TeleporterTest_GetButtonSettingsFromItemId(Toy_TomeOfTownPortal).cooldownString
        f:TestEquals(tomeCooldownString:GetText(), "20m", "The Tome of Town Portal button should display the correct cooldown")

        local astralRecallCooldownString = TeleporterTest_GetButtonSettingsFromSpellId(Spell_AstralRecall).cooldownString
        f:TestEquals(astralRecallCooldownString:GetText(), "25s", "The Astral Recall button should display the correct cooldown")
    end, 
    ["SpellsOnCooldown_GameTicks_CooldownUpdates"] = function(f)
        WowMock:AddSpell(Spell_AstralRecall)
        WowMock:SetSpellCooldown(Spell_AstralRecall, GetTime() - 5, 30)
        
        TeleporterOpenFrame()

        local astralRecallCooldownString = TeleporterTest_GetButtonSettingsFromSpellId(Spell_AstralRecall).cooldownString
        f:TestEquals(astralRecallCooldownString:GetText(), "25s", "The Astral Recall button should display the correct cooldown before ticking")

        WowMock:Tick(1)
        
        astralRecallCooldownString = TeleporterTest_GetButtonSettingsFromSpellId(Spell_AstralRecall).cooldownString
        f:TestEquals(astralRecallCooldownString:GetText(), "24s", "The Astral Recall button should display the correct cooldown after ticking")
    end, 
    ["SpellsOnCooldown_OpenFrame_CooldownBarWidthIsProportialToTimeRemaining"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        WowMock:SetItemCooldown(Item_Hearthstone, GetTime() - 2, 4)

        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:SetItemCooldown(Toy_TomeOfTownPortal, GetTime() - 3, 4)
        
        TeleporterOpenFrame()

        local hiddenLength = TeleporterGetOption("cooldownBarInset") * 2
        local hearthCooldownLength = TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone).cooldownbar:GetWidth() - hiddenLength
        local tomeCooldownLength = TeleporterTest_GetButtonSettingsFromItemId(Toy_TomeOfTownPortal).cooldownbar:GetWidth() - hiddenLength
        f:TestEquals(hearthCooldownLength / 2, tomeCooldownLength, "Cooldown bar should be proportional to time remaining")
    end, 
    ["TimeWrappedAround_OpenFrame_CooldownBarWidthIsProportialToTimeRemaining"] = function(f)
        WowMock:SetTime(2000)

        WowMock:AddItem(Item_Hearthstone)
        -- Time wrapped 1/4 of way through cooldown. Started at -1000, it's 2000 now, so 3/4 done, i.e. bar is 1/4 length.
        WowMock:SetItemCooldown(Item_Hearthstone, 4294967295 / 1000.0 - 1000, 4000)

        -- Half full bar for comparison.
        WowMock:AddToy(Toy_TomeOfTownPortal)
        WowMock:SetItemCooldown(Toy_TomeOfTownPortal, GetTime() - 2, 4)
        
        TeleporterOpenFrame()

        local hiddenLength = TeleporterGetOption("cooldownBarInset") * 2
        local hearthCooldownLength = TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone).cooldownbar:GetWidth() - hiddenLength
        local tomeCooldownLength = TeleporterTest_GetButtonSettingsFromItemId(Toy_TomeOfTownPortal).cooldownbar:GetWidth() - hiddenLength
        f:TestEquals(hearthCooldownLength, tomeCooldownLength / 2, "Cooldown bar should be proportional to time remaining")
    end, 
    ["CooldownStartedInFuture_OpenFrame_CooldownBarIsHidden"] = function(f)
        -- This happens the first time you query the Death Gate timer if you're not a Death Knight, which only happens if you use /tele debug.
        WowMock:SetTime(2000)

        WowMock:AddItem(Item_Hearthstone)
        WowMock:SetItemCooldown(Item_Hearthstone, 5000, 4000)
        
        TeleporterOpenFrame()

        local hiddenLength = TeleporterGetOption("cooldownBarInset") * 2
        local hearthCooldownLength = TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone).cooldownbar:GetWidth() - hiddenLength
        f:TestEquals(hearthCooldownLength, 0, "Cooldown bar should be hidden")
    end, 
    ["PlayerHasUnloadedItem_OpenFrame_LoadingIsDisplayedUntilItIsLoaded"]  = function(f)
        WowMock:AddItem(Item_DarkPortal)
        WowMock:SetItemLoaded(Item_DarkPortal, false)

        TeleporterOpenFrame()
        
        WowMock:Tick(1)        
        local darkPortalButton = TeleporterTest_GetButtonSettingsFromItemId(Item_DarkPortal)
        f:TestEquals(darkPortalButton.displaySpellName, "<Loading>")

        WowMock:SetItemLoaded(Item_DarkPortal, true)
        WowMock:Tick(1)
        local darkPortalButton = TeleporterTest_GetButtonSettingsFromItemId(Item_DarkPortal)
        f:TestNotEquals(darkPortalButton.displaySpellName, "<Loading>")
    end,
    ["ItemDoesNotExist_OpenFrameThenWait_DoesNotKeepRefreshing"]  = function(f)
        WowMock:SetItemLoaded(Item_DarkPortal, false)
        WowMock:AddItem(Item_Hearthstone)

        TeleporterOpenFrame()
        
        WowMock:Tick(1)
        local buttonFrame1 = TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone)

        WowMock:Tick(1)
        local buttonFrame2 = TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone)

        f:TestEquals(buttonFrame1, buttonFrame2, "Button should not have refreshed")
    end,
})