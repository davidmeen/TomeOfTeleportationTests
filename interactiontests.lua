AddTests(
{    
    ["ItemIsEquippable_EquipItemWhileFrameIsOpen_ButtonColourChanges"] = function(f)
        WowMock:AddItem(Item_Atiesh)
        WowMock:SetEquippable(Item_Atiesh, "INVTYPE_2HWEAPON")
        TeleporterOpenFrame()

        f:TestButtonColour(TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh), "unequipedColour", "Button should have the unequipped colour")

        WowMock:EquipItem(Item_Atiesh)
        WowMock:Tick(1)

        f:TestButtonColour(TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh), "readyColour", "Button should have the ready colour")

    end,
    ["SpellIsOnCooldown_GoesOffCooldown_ButtonColourChanges"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        WowMock:SetItemCooldown(Item_Hearthstone, GetTime() - 4.5, 5)

        TeleporterOpenFrame()

        f:TestButtonColour(TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone), "cooldownColour", "Button should have the cooldown colour")

        WowMock:Tick(1)

        f:TestButtonColour(TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone), "readyColour", "Button should have the ready colour")
        
    end,
    ["HaveItem_ClickButton_ItemIsUsedAndClosesFrame"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        
        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(WowMock:IsUsingItem(Item_Hearthstone), true, "Should be using hearthstone")
    end,
    ["HaveItem_ClickButtonAndTimePasses_FrameIsClosed"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        
        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(TeleporterFrame:IsVisible(), true, "Frame should be open")
        WowMock:Tick(1)
        f:TestEquals(TeleporterFrame:IsVisible(), false, "Frame should have closed")
    end,
    ["HaveSpell_ClickButton_SpellIsUsed"] = function(f)
        WowMock:AddSpell(Spell_AstralRecall)
        
        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(WowMock:IsUsingSpell(Spell_AstralRecall), true, "Should be using Astral Recall")
    end,
    ["HaveSpell_ClickButtonAndTimePasses_FrameIsClosed"] = function(f)
        WowMock:AddSpell(Spell_AstralRecall)
        
        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(TeleporterFrame:IsVisible(), true, "Frame should be open")
        WowMock:Tick(1)
        f:TestEquals(TeleporterFrame:IsVisible(), false, "Frame should have closed")
    end,
    ["HaveToy_ClickButton_ToyIsUsed"] = function(f)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        
        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(WowMock:IsUsingSpell(GetItemSpell(Toy_TomeOfTownPortal)), true, "Should be using Tome of Town Portal")
    end,
    ["HaveToy_ClickButtonAndTimePasses_FrameIsClosed"] = function(f)
        WowMock:AddToy(Toy_TomeOfTownPortal)
        
        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(TeleporterFrame:IsVisible(), true, "Frame should be open")
        WowMock:Tick(1)
        f:TestEquals(TeleporterFrame:IsVisible(), false, "Frame should have closed")
    end,
    ["HaveEquipableItemUnequiped_ClickButton_ItemIsEquiped"] = function(f)
        WowMock:AddItem(Item_Atiesh)
        WowMock:SetEquippable(Item_Atiesh, "INVTYPE_2HWEAPON")
        
        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(IsEquippedItem(Item_Atiesh), true, "Should have equipped Atiesh")
        f:TestEquals(WowMock:IsUsingItem(Item_Atiesh), false, "Should not be using Atiesh")
    end,
    ["HaveEquipableItemEquiped_ClickButton_ItemIsUsed"] = function(f)
        WowMock:AddItem(Item_Atiesh)
        WowMock:SetEquippable(Item_Atiesh, "INVTYPE_2HWEAPON")
        WowMock:SetEquipped(Item_Atiesh)
        
        TeleporterOpenFrame()

        WowMock:ClickFrame(f:FindButtons()[1])

        f:TestEquals(WowMock:IsUsingItem(Item_Atiesh), true, "Should be using Atiesh")
    end,
    ["HaveEquipableItemUnequiped_ClickButtonTwice_ItemIsUsedAndClosesFrameAndUnequips"] = function(f)
        
        WowMock:AddItem(Item_Atiesh)
        WowMock:SetEquippable(Item_Atiesh, "INVTYPE_2HWEAPON")
        
        f:TestEquals(IsEquippedItem(Item_Atiesh), false, "Should not have equipped Atiesh")
        
        TeleporterOpenFrame()
        
        WowMock:ClickFrame(f:FindButtons()[1])
        f:TestEquals(WowMock:IsUsingItem(Item_Atiesh), false, "Should not be using Atiesh")
        WowMock:Tick(1)
        
        WowMock:ClickFrame(f:FindButtons()[1])        
        f:TestEquals(WowMock:IsUsingItem(Item_Atiesh), true, "Should be using Atiesh")

        WowMock:Tick(1)
        f:TestEquals(IsEquippedItem(Item_Atiesh), false, "Should not have equipped Atiesh")
        f:TestEquals(TeleporterFrame:IsVisible(), false, "Frame should have closed")
    end,
    ["HaveTwoWeaponsEquipped_ClickButtonForTwoHandedWeaponThenClose_PlacedBackInBagAndOriginalWeaponsAreEquipped"] = function(f)
        -- Not real item IDs.
        local Item_MainHand = 1000
        local Item_OffHand = 10001
        WowMock:AddItem(Item_MainHand)
        WowMock:AddItem(Item_OffHand)
        WowMock:SetEquippable(Item_MainHand, "INVTYPE_2HWEAPON")
        WowMock:SetEquippable(Item_OffHand, "INVTYPE_HOLDABLE")
        WowMock:EquipItem(Item_MainHand)
        WowMock:EquipItem(Item_OffHand)

        local BagIndex = 2
        WowMock:AddItem(Item_Atiesh, BagIndex)
        WowMock:SetEquippable(Item_Atiesh, "INVTYPE_2HWEAPON")
        f:TestEquals(WowMock:BagContains(Item_Atiesh, BagIndex), true, "Atiesh should be in bag 2")
                
        TeleporterOpenFrame()
        
        WowMock:ClickFrame(f:FindButtons()[1])
        f:TestEquals(IsEquippedItem(Item_Atiesh), true, "Should have equipped Atiesh")
        f:TestEquals(IsEquippedItem(Item_MainHand), false, "Should have unequipped main hand")
        f:TestEquals(IsEquippedItem(Item_OffHand), false, "Should have unequipped off hand")
        -- Should be in a different bag, but the mock isn't accurate enough.
        f:TestEquals(WowMock:BagContains(Item_MainHand, 0), true, "Main hand should have been placed in a bag")
        f:TestEquals(WowMock:BagContains(Item_OffHand, 0), true, "Off hand should have been placed in a bag")
        WowMock:Tick(1)
        
        TeleporterClose()  
        f:TestEquals(IsEquippedItem(Item_Atiesh), false, "Should have unequipped Atiesh")
        f:TestEquals(IsEquippedItem(Item_MainHand), true, "Should have equipped main hand")
        f:TestEqualsKnownFailure(IsEquippedItem(Item_OffHand), true, "Should have equipped off hand")
        f:TestEquals(WowMock:BagContains(Item_Atiesh, BagIndex), true, "Atiesh should have been placed back in its original bag")
    end,
    ["AllSpellsLoaded_EquippableItemButtonClickedThenWait_ItemStaysEquipped"]  = function(f)
        WowMock:AddItem(Item_Atiesh)
        WowMock:SetEquippable(Item_Atiesh, "INVTYPE_2HWEAPON")

        TeleporterOpenFrame()
        
        WowMock:Tick(1)
        local atieshButton = TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh)
        WowMock:ClickFrame(atieshButton.frame)
        f:TestEquals(IsEquippedItem(Item_Atiesh), true, "Should have equipped Atiesh")
        WowMock:Tick(1)
        f:TestEquals(IsEquippedItem(Item_Atiesh), true, "Should have equipped Atiesh")
    end,
    ["NotAllSpellsLoaded_EquippableItemButtonClicked_ItemStaysEquipped"]  = function(f)
        WowMock:AddItem(Item_Atiesh)
        WowMock:SetEquippable(Item_Atiesh, "INVTYPE_2HWEAPON")

        WowMock:SetItemLoaded(Item_DarkPortal, false)

        TeleporterOpenFrame()
        
        WowMock:Tick(1)
        local atieshButton = TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh)
        WowMock:ClickFrame(atieshButton.frame)
        f:TestEquals(IsEquippedItem(Item_Atiesh), true, "Should have equipped Atiesh")
        WowMock:Tick(1)
        f:TestEqualsKnownFailure(IsEquippedItem(Item_Atiesh), true, "Should have equipped Atiesh")
    end,
})