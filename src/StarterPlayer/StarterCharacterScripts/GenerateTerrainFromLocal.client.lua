local waitBeforeGeneration = game.ReplicatedStorage:WaitForChild("WaitBeforeGeneration")
local value = waitBeforeGeneration.Value

waitBeforeGeneration.Changed:Connect(function()
	value = waitBeforeGeneration.Value
end)

while wait(value) do
	game.ReplicatedStorage.GenerateTerrain:FireServer(Vector3.new(script.Parent.Head.Position.X, 0, script.Parent.Head.Position.Z))
end