local module = {}

local scale = _G.Scale
local biomeScale = _G.BiomeScale
local globalSeed = _G.Seed

local amplitude = 2.5
local frequency = 0.6
local octaves = 9

function module.GetNoise(posX, posZ, scaleX, scaleZ, octavess, seed) -- Generates a perlin noise value, more octaves, more detail.
	local totalNoise = 0
	
	local amp = amplitude
	local fre = frequency
	
	for i = 1, octavess do
		totalNoise = totalNoise + (amp * math.noise(seed, fre * (posX / scaleX), fre * (posZ / scaleZ))) -- Add's new values over old ones so the detail is increased. The amplitude and frequency is smaller as you can imagine, Boulders > Rocks > Pebbles > Dirt, right?
		
		fre = fre * 2.0
		amp = amp / 2.0
	end
	
	return totalNoise
end

function module.GetTerrain(posX, posZ) -- Use's the function above this to get the noise value and use's it to determine height and material of the terrain like grass or sand
	local noise, material
	
	noise = module.GetNoise(posX, posZ, scale.X, scale.Z, octaves, globalSeed + 916245)
	
	local e = math.abs(noise * scale.Y)
	local m = math.abs(module.GetNoise(posX, posZ, biomeScale.X, biomeScale.Z, 2, globalSeed + 5738578)) * 100 -- I add the random values so that the biome's are a bit more random
	
	local snowThresholdAdd = (math.noise(globalSeed + 692762, posX / 35, posZ / 35) * 12)
	
	local threshold = 48 + (math.noise(globalSeed + 286861, posX / 35, posZ / 35) * 4) -- Beach / River / Lake / Ocean
	
	if e < threshold then -- Less than this height? Sand and water!
		material = Enum.Material.Sand
		
		e = e / math.pow(threshold / e, 1.06)
	elseif e < threshold + 70 then -- Less than this height? All the biomes! Except mountainous stuff...
		if m < 18 then
			material = Enum.Material.LeafyGrass
		elseif m < 500 then
			material = Enum.Material.Grass
		else
			material = Enum.Material.Limestone
		end
	elseif e < threshold + 110 - snowThresholdAdd then -- Just mountainous heights and maybe some high altitude forest...
		if m < 80 then
			material = Enum.Material.Slate
		else
			material = Enum.Material.Grass
		end
		
		e = e * math.pow(e / (threshold + 70), 1.24)
	else -- Snowy tops of mountains
		material = Enum.Material.Snow
		
		e = e * math.pow(e / (threshold + 70), 1.24)
	end
	
	return e, material -- After the hard work, it tell's the main script the height and material
end

return module