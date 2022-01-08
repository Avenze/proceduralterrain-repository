math.randomseed(tick())

-- Configuration and Variables ---------------------------------------

local seed = math.random()

local chunkSize = 8 -- Radius in 4 studs
local renderDistance = game.ReplicatedStorage.RenderDistance.Value -- Radius in chunks

local scale = Vector3.new(1500, 70, 1500) -- Scale of the terrain
local biomeScale = Vector3.new(2800, 0, 2800) -- Biome scale of the terrain, useless for now

-- Set's global variables to be used by other scripts

_G.Scale = scale
_G.Seed = seed
_G.TreeRarity = 1000 -- Lower = Rarer
_G.CactusRarity = 200 -- Lower = Rarer
_G.BiomeScale = biomeScale

local terrainModule = require(script.TerrainModule) -- TerrainModule
local objectPlacementModule = require(script.ObjectPlacementModule) -- ObjectPlacementModule

local chunks = {} -- Store's the chunks' positions

-- Main Script -------------------------------------------------------

local function chunkExists(chunkX, chunkZ) -- Check's if a chunk exists
	if not chunks[chunkX] then
		chunks[chunkX] = {}
	end
	
	return chunks[chunkX][chunkZ]
end

local function roundTo(number, roundToNumber) -- Give it a value and it'll round it to the target's multiple, e.g 12 goes to 8, 17 goes to 16.
	return number - (number % roundToNumber)
end

local function mountLayer(posX, posZ, height, material)
	local thing = coroutine.create(function()
		workspace.Terrain:FillBlock(CFrame.new(posX + 2, 43.75, posZ + 2), Vector3.new(4, 31.5, 4), Enum.Material.Water) -- Water layer of terrain
		workspace.Terrain:FillBlock(CFrame.new(posX + 2, height, posZ + 2), Vector3.new(4, 40, 4), material) -- The actual terrain, grass, snow, etc.
		
		if material == Enum.Material.Grass or material == Enum.Material.LeafyGrass then -- If it's grass, plant a tree!
			wait(2) -- Wait's for the terrain to load in before placing a tree
			
			objectPlacementModule.PlaceTree(posX, posZ, height, material) -- Call's 'ObjectPlacementModule' to determine if a tree get's planted here or not.
		elseif material == Enum.Material.Limestone then
			wait(2)
			
			objectPlacementModule.PlaceCactus(posX, posZ, height, material) -- Call's 'ObjectPlacementModule' to determine if a cactus get's planted here or not.
		end
	end)
	
	coroutine.resume(thing)
end

local function makeChunk(posX, posZ) -- Makes a chunk
	for x = -chunkSize, chunkSize do
		for z = -chunkSize, chunkSize do
			local height, material = terrainModule.GetTerrain(posX + (x * 4), posZ + (z * 4)) -- Call's 'TerrainModule' for a height and material
			
			mountLayer((x * 4) + posX, (z * 4) + posZ, height + 5, material) -- Actually adds the terrain into the world based on the height and material
		end
	end
end

local function checkSurroundings(position) -- Chooses the chunks around the player that are not loaded, and load them
	-- If you want the render distance to be bigger, go to ReplicatedStorage > RenderDistance > Value, I recommend 6 - 22, lower for studio testing
	
	local roundedX = roundTo(position.X, 64)
	local roundedZ = roundTo(position.Z, 64)
	
	for x = -renderDistance, renderDistance do
		for z = -renderDistance, renderDistance do
			local chunkX = (x * chunkSize * 8) + roundedX
			local chunkZ = (z * chunkSize * 8) + roundedZ
				
			if not chunkExists(chunkX, chunkZ) then
				chunks[chunkX][chunkZ] = true -- Marks the loaded chunks so new generations don't generate new chunks over these existing ones
				makeChunk(chunkX, chunkZ) -- Makes a chunk at a location
			end
		end
	end
end

game.ReplicatedStorage.GenerateTerrain.OnServerEvent:Connect(function(plr, position) -- When the player requests for generation, it'll generate, it's stored in StarterPlayer > StarterCharacterScripts > GenerateTerrainFromLocal
	checkSurroundings(position)
end)

game.ReplicatedStorage.RenderDistance.Changed:Connect(function() -- When the render distance value is changed in-game, this script will realise and make changes
	renderDistance = game.ReplicatedStorage.RenderDistance.Value
end)