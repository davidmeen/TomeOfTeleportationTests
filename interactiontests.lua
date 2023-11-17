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
    end
})