local module = {}

function module.EncodeValue(Val) -- Please ignore this ugly code. It's really hard to detect what roblox data type is in-putted.
	if Val == nil then
		return "nil"
	elseif type(Val) == "string" then
		return string.format("%q", Val) -- The most useful thing EVER. Turn string into quote.
	elseif type(Val) == "number" then
		if Val == math.huge then
			return "math.huge"
		else
			return tostring(Val)
		end
	elseif type(Val) == "table" then
		local Values = {}
		for i,v in pairs(Val) do
			Values[#Values+1] = "["..module.EncodeValue(i).."]="..module.EncodeValue(v)
		end
		return "{"..table.concat(Values,",").."}"
	elseif type(Val) == "boolean" then
		return tostring(Val)
	elseif pcall(function() return Val.Lerp ~= nil end) and not pcall(function() return Val.ClassName end) then
		return "Vector3.new("..tostring(Val)..")"
	elseif pcall(function() return Val.inverse ~= nil end) and not pcall(function() return Val.ClassName end) then
		return "CFrame.new("..tostring(Val)..")"
	elseif pcall(function() return Val.Color ~= nil and Val.r ~= nil and Val.b ~= nil and Val.g ~= nil end) and not pcall(function() return Val.ClassName end) then
		return "BrickColor.new('"..tostring(Val).."')"
	elseif pcall(function() return Val.r ~= nil and Val.b ~= nil and Val.g ~= nil end) and not pcall(function() return Val.ClassName end) then
		print(Val)
		return "Color3.new("..tostring(Val)..")"
	elseif pcall(function() Instance.new("ArcHandles").Axes = Val end) then -- Only way to check for Axes. q.q
		local X,Y,Z
		X = Val.X == true and "Enum.Axis.X" or "false"
		Y = Val.Y == true and "Enum.Axis.Y" or "false"
		Z = Val.Z == true and "Enum.Axis.Z" or "false"
		return "Axes.new("..X..","..Y..","..Z..")"
	elseif tostring(Val):sub(1,5) == "Enum." and not pcall(function() return Val.ClassName end) then
		return tostring(Val)
	elseif pcall(function() return Val.Origin end) and pcall(function() return Val.Direction end) and not pcall(function() return Val.ClassName end) then
		local Start = tostring(Val):sub(2,tostring(Val):find("}")-1)
		local End = tostring(Val):sub(tostring(Val):find("}")+4,#tostring(Val)-1)
		return "Ray.new(Vector3.new("..Start.."),Vector3.new("..End.."))"
	elseif pcall(function() return Val.Size end) and pcall(function() return Val.CFrame end) and not pcall(function() return Val.ClassName end) and tostring(Val) == tostring(Val.CFrame).."; "..tostring(Val.Size) then
		return "Region3.new(Vector3.new("..tostring((Val.CFrame-Val.Size/2).p).."),Vector3.new("..tostring((Val.CFrame+Val.Size/2).p).."))"
	elseif pcall(function() return Val.x end) and pcall(function() return Val.y end) and pcall(function() return Val.z end) and not pcall(function() return Val.ClassName end) then
		return "Vector3int16.new("..tostring(Val)..")"
	elseif pcall(function() return Val.X.Scale end) and pcall(function() return Val.Y.Scale end) and not pcall(function() return Val.ClassName end) then
		return "UDim2.new("..Val.X.Scale..","..Val.X.Offset..","..Val.Y.Scale..","..Val.Y.Offset..")"
	elseif pcall(function() return Val.Scale end) and pcall(function() return Val.Offset end) and not pcall(function() return Val.ClassName end) then
		return "UDim.new("..Val.Scale..","..Val.Offset..")"
	elseif pcall(function() return Val.X end) and pcall(function() return Val.Y end) and pcall(function() return Val.magnitude end) and not pcall(function() return Val.ClassName end) then
		return "Vector2.new("..Val.X..","..Val.Y..")"
	elseif pcall(function() return Val.x end) and pcall(function() return Val.y end) and not pcall(function() return Val.ClassName end) then
		return "Vector2int16.new("..Val.x..","..Val.y..")"
	elseif not pcall(function() return Val.ClassName end) then -- Region2int16 has no known properties. q.q
		local Start = tostring(Val):sub(1,tostring(Val):find(";")-1)
		local End = tostring(Val):sub(tostring(Val):find(";")+2,#tostring(Val))
		print("return Region3int16.new(Vector3int16.new("..Start.."),Vector3int16.new("..End.."))")
		local func = loadstring("return Region3int16.new(Vector3int16.new("..Start.."),Vector3int16.new("..End.."))")
		if func and func() ~= nil then
			return "Region3int16.new(Vector3int16.new("..Start.."),Vector3int16.new("..End.."))"
		else
			error("INVALID DATA TYPE "..tostring(Val))
		end
	else
		error("INVALID DATA TYPE "..tostring(Val))
	end
end

function module.GetType(Val) -- I'll add more later.
	if Val == nil then
		return "NIL"
	elseif type(Val) == "string" then
		return "STR"
	elseif type(Val) == "number" then
		return "NUM"
	elseif type(Val) == "table" then
		return "TAB"
	elseif type(Val) == "boolean" then
		return "BOL"
	elseif pcall(function() return Val.Lerp ~= nil end) and not pcall(function() return Val.ClassName end) then
		return "VEC3"
	elseif pcall(function() return Val.inverse ~= nil end) and not pcall(function() return Val.ClassName end) then
		return "CFR"
	elseif pcall(function() return Val.Color ~= nil and Val.r ~= nil and Val.b ~= nil and Val.g ~= nil end) and not pcall(function() return Val.ClassName end) then
		return "BCOL"
	elseif pcall(function() return Val.r ~= nil and Val.b ~= nil and Val.g ~= nil end) and not pcall(function() return Val.ClassName end) then
		return "CLR3"
	elseif pcall(function() Instance.new("ArcHandles").Axes = Val end) then -- Only way to check for Axes. q.q
		return "AXS"
	elseif tostring(Val):sub(1,5) == "Enum." and not pcall(function() return Val.ClassName end) then
		return "ENM"
	elseif pcall(function() return Val.Origin end) and pcall(function() return Val.Direction end) and not pcall(function() return Val.ClassName end) then
		return "RAY"
	elseif pcall(function() return Val.Size end) and pcall(function() return Val.CFrame end) and not pcall(function() return Val.ClassName end) and tostring(Val) == tostring(Val.CFrame).."; "..tostring(Val.Size) then
		return "REG3"
	elseif pcall(function() return Val.x end) and pcall(function() return Val.y end) and pcall(function() return Val.z end) and not pcall(function() return Val.ClassName end) then
		return "V316"
	elseif pcall(function() return Val.X.Scale end) and pcall(function() return Val.Y.Scale end) and not pcall(function() return Val.ClassName end) then
		return "UDM2"
	elseif pcall(function() return Val.Scale end) and pcall(function() return Val.Offset end) and not pcall(function() return Val.ClassName end) then
		return "UDM"
	elseif pcall(function() return Val.X end) and pcall(function() return Val.Y end) and pcall(function() return Val.magnitude end) and not pcall(function() return Val.ClassName end) then
		return "VEC2"
	elseif pcall(function() return Val.x end) and pcall(function() return Val.y end) and not pcall(function() return Val.ClassName end) then
		return "V216"
	elseif not pcall(function() return Val.ClassName end) then -- Region2int16 has no known properties. q.q
		local Start = tostring(Val):sub(1,tostring(Val):find(";")-1)
		local End = tostring(Val):sub(tostring(Val):find(";")+2,#tostring(Val))
		local func = loadstring("return Region3int16.new(Vector3int16.new("..Start.."),Vector3int16.new("..End.."))")
		if func and func() ~= nil then
			return "R316"
		else
			error("[ RBXDatabase ] Unable to encode data type.",2)
		end
	else
		error("[ RBXDatabase ] Unable to encode data type.",2)
	end
end

return module
