local WowMock = {}

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
local Frames = {}
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
    return name
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

    frame:Construct()

    tinsert(Frames, frame)

    return frame
end

CreateFrame("Frame", "UIParent")
CreateFrame("FontString", "GameFontNormalSmall")
CreateFrame("Button", "UIPanelButtonTemplate")

function UIPanelButtonTemplate:Construct()
    self:CreateFontString(self.name.."Text", nil, "GameFontNormalSmall")
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

-- Quests
C_QuestLog = {}
function C_QuestLog:IsQuestFlaggedCompleted(questId)
    return WowMock.completedQuests[questId] or false
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
end

function WowMock:SetInCombat(b)
    self.InCombat = b
end

function WowMock:SetLoaded(b)
    self.loaded = b;
end


WowMock:Init()