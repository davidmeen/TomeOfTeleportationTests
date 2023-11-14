WowMock = {}

-- Mocks for libraries used by the plug-in
MockIconLib = {}
function MockIconLib:Register()
end

MockBrokerLib = {}
function MockBrokerLib:NewDataObject()
    return {}
end

LibStub = {}
function LibStub:GetLibrary(major, silent)
    if major == "LibDataBroker-1.1" then
        return MockBrokerLib
    elseif major == "LibDBIcon-1.0" then
        return MockIconLib
    end
end
setmetatable(LibStub, { __call = LibStub.GetLibrary })

-- Utilities
tinsert = table.insert

function GetTime()
    return WowMock.time
end

function date()
    local d = {}
    return d
end

function getglobal(name)
    return _G[name]
end


-- WowMock object
function WowMock:Init()
    self.inCombat = false
    self.knownItems = {}
    self.knownSpells = {}
    self.knownToys = {}
    self.time = 0
    self.loaded = true
    self.currentMap = 0
    self.grouped = false

    self.itemTypes = {}
    self.itemSubTypes = {}
    self.itemEquipLoc = {}
    self.itemCounts = {}

    self.completedQuests = {}

    self.frames = {}
end

function WowMock:SetInCombat(b)
    self.InCombat = b
end

function WowMock:SetLoaded(b)
    self.loaded = b;
end

function WowMock:AddSpell(spellId)
    self.knownSpells[spellId] = true
end

function WowMock:AddItem(itemId)
    self.knownItems[itemId] = true
    if self.itemCounts[itemId] then 
        self.itemCounts[itemId] = self.itemCounts[itemId] + 1
    else
        self.itemCounts[itemId] = 1
    end
end

function WowMock:FindFramesWithTemplate(template)
    local r = {}
    for index, frame in ipairs(self.frames) do
        if frame.template == template then
            tinsert(r, frame)
        end
    end
    return r
end

function WowMock:FindFramesWithPrefix(prefix)
    local r = {}
    for index, frame in ipairs(self.frames) do
        if frame.name and string.find(frame.name, prefix) then
            tinsert(r, frame)
        end
    end
    return r
end


WowMock:Init()

-- Versioning

function GetBuildInfo()
    return 100000, 100000, "", 100000
end

-- Fonts

GameFontNormal = {}
function GameFontNormal:GetFont()
    return "font.ttf"
end

-- Map
C_Map = {}
function C_Map:GetMapInfo(mapID)
    return mapID, "Zone", 3, 0, 0
end

function C_Map:GetAreaInfo(mapID)
    return "zone"
end

function C_Map:GetBestMapForUnit()
    return WowMock.currentMap
end

-- Unit
function UnitAffectingCombat()
    return WowMock.inCombat
end

function GetBindLocation()
    return "Inn"
end

function IsInGroup()
    return WowMock.grouped
end

function UnitClass()
    return WowMock.unitClass
end

-- Frame
Frame = {}
UISpecialFrames = {}

function Frame:Construct()
end

function Frame:GetEffectiveScale()
    return 1
end

function Frame:SetFrameStrata(strata)
    self.strata = strata
end

function Frame:ClearAllPoints()
    self.points = {}
end

function Frame:SetPoint(name, ...)
    self.points[name] = ...
end

function Frame:SetAllPoints(other)
    self.points = other.points
end

function Frame:GetName()
    return self.name
end

function Frame:CreateTexture()
    local tex = CreateFrame("Texture", nil, self)
    return tex
end

function Frame:SetTexture(texture)
    self.texture = texture;
end

function Frame:SetWidth(w)
    self.width = w
end

function Frame:SetHeight(h)
    self.height = h
end

function Frame:SetFont(font)
    self.font = font;
end

function Frame:SetText(text)
    self.text = text;
end

function Frame:CreateFontString(name, drawLayer, templateName)
    local template
    local f = CreateFrame("FontString", name, self, templateName)
    f.drawLayer = drawLayer    
    return f
end

function Frame:RegisterForDrag()
end

function Frame:SetScript()
end

function Frame:SetMovable()
end

function Frame:EnableMouse()
end

function Frame:Show()
    self.visible = true
end

function Frame:Hide()
    self.visible = false
end

function Frame:ApplyBackdrop()
end

function Frame:SetBackdropColor(r, g, b, a)
    self.backgroundR = r
    self.backgroundG = g
    self.backgroundB = b
    self.backgroundA = a
end

function Frame:RegisterForClicks()
end

function Frame:SetAttribute()
end

function Frame:SetJustifyH()
end

function Frame:SetJustifyV()
end

function CreateFrame(frameType, name, parent, template, id)
    local frame = {}
    frame.frameType = frameType
    if template then
        setmetatable(frame, {__index=_G[template]})
    else
        setmetatable(frame, {__index=Frame})
    end
    if name then
        _G[name] = frame
    end
    frame.name = name
    frame.parent = parent
    frame.id = id
    frame.points = {}
    frame.template = template

    if not frame.Construct then print(template) end

    frame:Construct()

    tinsert(WowMock.frames, frame)

    return frame
end

CreateFrame("Frame", "UIParent")
CreateFrame("FontString", "FontString")
CreateFrame("FontString", "GameFontNormalSmall", nil, "FontString")
CreateFrame("Button", "UIPanelButtonTemplate")
CreateFrame("Button", "InsecureActionButtonTemplate")
CreateFrame("Frame", "BackdropTemplate")

function UIPanelButtonTemplate:Construct()
    self:CreateFontString(self.name.."Text", nil, "GameFontNormalSmall")
end

function GameFontNormalSmall:GetStringWidth()
    if self.text then
        return string.len(self.text) * 8
    else   
        return 0
    end
end

-- Items
function GetItemInfo(itemId)
    if WowMock.loaded then
        return "Item" .. itemId, "itemLink" .. itemId, 3, 0, 0, WowMock.itemTypes[itemId], WowMock.itemSubTypes[itemId], 1, WowMock.itemEquipLoc[itemId], "tex"..itemId, 0, itemId, itemId, 1, 10, 0, false
    else
        return nil
    end
end

function GetItemCount(itemId)
    return WowMock.itemCounts[itemId] or 0
end

-- Spells
function GetSpellInfo(spellId)
    if WowMock.loaded then
        return "Spell"..spellId, nil, "icon"..spellId, 1.5, 0, 0, spellId, "icon"..spellId
    else
        return nil
    end
end

function IsSpellKnown(spellId)
    return WowMock.knownSpells[spellId] or false
end

function GetSpellCooldown(spellId)
    return 0
end

-- Quests
C_QuestLog = {}
function C_QuestLog:IsQuestFlaggedCompleted(questId)
    return WowMock.completedQuests[questId] or false
end

-- Container
C_Container = {}

function C_Container:GetItemCooldown(itemId)
    return 0
end

function IsEquippableItem(itemId)
    return false
end