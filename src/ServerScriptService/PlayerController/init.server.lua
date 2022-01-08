--[[-------------------------------------------------------------------
---------------------- Information & Licensing ------------------------
-----------------------------------------------------------------------

	PROGRAMMER(S): UnlimitedKeeping / Avenze
	OWNER(S): UnlimitedKeeping & Frostcloud Studios
	DETAILS: Controls all aspects around the client : CLIENTSIDED
	LICENSE: Creative Commons Attribution 4.0 International license

--]]-------------------------------------------------------------------
----------------- Variables & Services & Functions --------------------
-----------------------------------------------------------------------

print("[PlayerController]: Starting initialization for Segment #1")

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local coregui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")
local replicated = game:GetService("ReplicatedStorage")
local serverscriptservice = game:GetService("ServerScriptService")
local serverstorage = game:GetService("ServerStorage")
local startergui = game:GetService("StarterGui")
local marketplaceservice = game:GetService("MarketplaceService")
local httpservice = game:GetService("HttpService")
local messagingservice = game:GetService("MessagingService")
local tweenservice = game:GetService("TweenService")

print("[PlayerController]: Finished initialization for Segment #1")

-----------------------------------------------------------------------
------------------------------ Events ---------------------------------
-----------------------------------------------------------------------

print("[PlayerController]: Starting initialization for Segment #2")

local RoSQL = require(script:WaitForChild("RoSQL"))

RoSQL:Connect("e82dd66055f79100b8c711f06e273d37")
RoSQL:SetValue("Avenze", "This is a testing string.")

print("[PlayerController]: Finished initialization for Segment #2")