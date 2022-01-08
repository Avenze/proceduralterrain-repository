while wait(0.07) do
	script.Parent.Text = "FPS: " .. 1 / game:GetService("RunService").RenderStepped:Wait()
end