local unequippedR = TeleporterGetOption("unequipedColourR")
local unequippedG = TeleporterGetOption("unequipedColourG")
local unequippedB = TeleporterGetOption("unequipedColourB")

local cooldownColourR = TeleporterGetOption("cooldownColourR")
local cooldownColourG = TeleporterGetOption("cooldownColourG")
local cooldownColourB = TeleporterGetOption("cooldownColourB")

local readyColourR = TeleporterGetOption("readyColourR")
local readyColourG = TeleporterGetOption("readyColourG")
local readyColourB = TeleporterGetOption("readyColourB")


AddTests(
{    
    ["ItemIsEquippable_EquipItemWhileFrameIsOpen_ButtonColourChanges"] = function(f)
        WowMock:AddItem(Item_Atiesh)
        WowMock:SetEquippable(Item_Atiesh, "INVTYPE_2HWEAPON")
        TeleporterOpenFrame()

        local backdrop = TeleporterTest_GetButtonSettingsFromItemId(Item_Atiesh).frame.backdrop
        
        local initialR, initialG, initialB = backdrop:GetBackdropColor()

        f:TestEquals(initialR, unequippedR, "Button should have the unequipped red channel")
        f:TestEquals(initialG, unequippedG, "Button should have the unequipped green channel")
        f:TestEquals(initialB, unequippedB, "Button should have the unequipped blue channel")

        WowMock:EquipItem(Item_Atiesh)
        WowMock:Tick(1)

        local endR, endG, endB = backdrop:GetBackdropColor()

        f:TestEquals(endR, readyColourR, "Button should have the equipped red channel")
        f:TestEquals(endG, readyColourG, "Button should have the equipped green channel")
        f:TestEquals(endB, readyColourB, "Button should have the equipped blue channel")

    end,
    ["SpellIsOnCooldown_GoesOffCooldown_ButtonColourChanges"] = function(f)
        WowMock:AddItem(Item_Hearthstone)
        WowMock:SetItemCooldown(Item_Hearthstone, GetTime() - 4.5, 5)

        TeleporterOpenFrame()

        local backdrop = TeleporterTest_GetButtonSettingsFromItemId(Item_Hearthstone).frame.backdrop
        
        local initialR, initialG, initialB = backdrop:GetBackdropColor()

        f:TestEquals(initialR, cooldownColourR, "Button should have the cooldown red channel")
        f:TestEquals(initialG, cooldownColourG, "Button should have the cooldown green channel")
        f:TestEquals(initialB, cooldownColourB, "Button should have the cooldown blue channel")

        WowMock:Tick(1)

        local endR, endG, endB = backdrop:GetBackdropColor()

        f:TestEquals(endR, readyColourR, "Button should have the ready red channel")
        f:TestEquals(endG, readyColourG, "Button should have the ready green channel")
        f:TestEquals(endB, readyColourB, "Button should have the ready blue channel")
    end,
})