game.Players.PlayerAdded:Connect(function(plr)
	plr.Chatted:Connect(function(msg)
		if string.lower(msg) == "c/spawncar" then
			local car = game.ServerStorage.CommandObjects.Car:Clone()
			car.Parent = workspace
			car:SetPrimaryPartCFrame(CFrame.new(plr.Character.Head.Position) * CFrame.new(0, 0, -50) + Vector3.new(0, 20, 0))
		end
	end)
end)