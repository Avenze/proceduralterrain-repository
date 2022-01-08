local on = true

local plr = game.Players.LocalPlayer

repeat wait() until plr.Character

plr.Character.Humanoid.WalkSpeed = 250
plr.Character.Humanoid.JumpPower = 150

script.Parent.MouseButton1Click:Connect(function()
	if on then
		on = false
		script.Parent.Text = "Speed: OFF"
		
		if plr.Character then
			plr.Character.Humanoid.WalkSpeed = 16
			plr.Character.Humanoid.JumpPower = 50
		end
	else
		on = true
		script.Parent.Text = "Speed: ON"
		
		if plr.Character then
			plr.Character.Humanoid.WalkSpeed = 250
			plr.Character.Humanoid.JumpPower = 150
		end
	end
end)