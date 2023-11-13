local AddonFolder = "D:/World of Warcraft/_retail_/Interface/Addons/TomeOfTeleportation/"
dofile("WowMock.lua")
dofile(AddonFolder .. "TomeOfTeleportation.lua")
dofile(AddonFolder .. "Spells.lua")

CreateFrame("Frame", "TeleporterFrame")
Teleporter_OnAddonLoaded()

TeleporterOpenFrame()