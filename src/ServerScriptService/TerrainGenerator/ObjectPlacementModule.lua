math.randomseed(tick() * math.random(-100000, 100000))

--[[-------------------------------------------------------------------
---------------------- Information & Licensing ------------------------
-----------------------------------------------------------------------

	PROGRAMMER(S): UnlimitedKeeping / Avenze
	OWNER(S): UnlimitedKeeping & Frostcloud Studios
	DETAILS: Oahu's Advanced Weather functions!
	LICENSE: Creative Commons Attribution 4.0 International license

--]]-------------------------------------------------------------------
---------------------------- Variables --------------------------------
-----------------------------------------------------------------------

local functions = {}
local library = {}

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

-- /*/ Dependencies
local noiseModule = require(script.Parent.TerrainModule)

local globalSeed = _G.Seed
local treeRarity = _G.TreeRarity
local cactusRarity = _G.CactusRarity

-----------------------------------------------------------------------
---------------------------- Functions --------------------------------
-----------------------------------------------------------------------

function functions.getSurfacePosition(posX, posZ)
	local origin = Vector3.new(posX, 500, posZ)
	local target = Vector3.new(posX, -100, posZ)
	
	local ray = Ray.new(origin, (target - origin).Unit * 750) -- Makes a ray and get's the position on the surface to place the object on
	
	local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, workspace.Objects:GetChildren(), false, true)
		
	return pos
end

function functions.PlaceTree(posX, posZ, elevation, material)
	local rand = math.random(1, (treeRarity + (noiseModule.GetNoise(posX + 816352, posZ + 937623, 750, 750, 1, globalSeed + 195723) * (treeRarity / 2)) + (elevation / 2)) + 180) -- Calculate's the chance a tree will be spawned here
	
	if rand <= 3 then -- If the outcome is 1, this'll place an object. A tree for now
		-- Makes a tree
		
		local tree
		
		if material == Enum.Material.Grass then
			local randomNumber = math.random(1, 6)
			tree = serverstorage.Objects.NormalTrees:GetChildren()[randomNumber]:Clone()
		elseif material == Enum.Material.LeafyGrass then
			local randomNumber = math.random(1, 6)
			tree = serverstorage.Objects.NormalTrees:GetChildren()[randomNumber]:Clone()
		end
		
		tree.Parent = workspace.Objects
		
		local surfacePos = functions.getSurfacePosition(posX, posZ)
		
		tree:SetPrimaryPartCFrame(CFrame.new(surfacePos + Vector3.new(0, 17, 0)) * CFrame.Angles(math.rad(math.random(-80, 80) / 10), math.rad(math.random(-3600, 3600) / 10), math.rad(math.random(-80, 80) / 10))) -- Set's the tree's position and rotate's it a bit for realism
 		
		-- Makes the tree look unique, that's all this does
		
		tree.Leaves.Color = Color3.fromRGB(math.random(140, 160), math.random(180, 220), math.random(100, 120))
		tree.Trunk.Color = Color3.fromRGB(math.random(145, 165), math.random(130, 150), math.random(85, 105))
		
		-- Random sizes
		
		local sizeMultiplier = math.random(800, 1400) / 1000
		tree.Leaves.CFrame = tree.Leaves.CFrame * CFrame.new(0, ((tree.Leaves.Size.Y * sizeMultiplier) - tree.Leaves.Size.Y) / 2, 0)
		tree.Leaves.Size = tree.Leaves.Size * Vector3.new(1, sizeMultiplier, 1)
	end
end
	
function functions.PlaceCactus(posX, posZ, elevation, material)
	local rand = math.random(1, (cactusRarity + (math.abs(noiseModule.GetNoise(posX, posZ, 750, 750, 1, globalSeed + 916521) * (cactusRarity / 2)))) + 50)
	
	if rand == 1 then
		local surfacePos = functions.getSurfacePosition(posX, posZ) -- Get's surface position
		
		local cactus = game.ServerStorage.Objects.Cactus:Clone()
		cactus.Parent = workspace.Objects
		cactus:SetPrimaryPartCFrame(CFrame.new(surfacePos) * CFrame.Angles(math.rad(math.random(-80, 80) / 10), math.rad(math.random(-3600, 3600) / 10), math.rad(math.random(-80, 80) / 10)))
		
		-- Makes the cactus look unique
		
		local cactusColor = math.random(75, 105)
		
		cactus.Cactus.Color = Color3.fromRGB(120, math.random(140, 155), 135)
		cactus.Spikes.Color = Color3.fromRGB(cactusColor, cactusColor, cactusColor)
		
		-- Random sizes
		
		local sizeMultiplier = math.random(900, 1400) / 1000
		
		cactus.Cactus.CFrame = cactus.Cactus.CFrame * CFrame.new(0, ((cactus.Cactus.Size.Y * sizeMultiplier) - cactus.Cactus.Size.Y) / 2, 0)
		cactus.Spikes.CFrame = cactus.Spikes.CFrame * CFrame.new(0, ((cactus.Spikes.Size.Y * sizeMultiplier) - cactus.Spikes.Size.Y) / 2, 0)
		
		cactus.Cactus.Size = cactus.Cactus.Size * Vector3.new(1, sizeMultiplier, 1)
		cactus.Spikes.Size = cactus.Spikes.Size * Vector3.new(1, sizeMultiplier, 1)
	end
end

return functions