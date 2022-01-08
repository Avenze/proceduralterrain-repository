--[[-------------------------------------------------------------------
---------------------- Information & Licensing ------------------------
-----------------------------------------------------------------------

	PROGRAMMER(S): UnlimitedKeeping / Avenze
	OWNER(S): UnlimitedKeeping & Frostcloud Studios
	DETAILS: This is the official API module for the RoSQL database manager!
	LICENSE: Creative Commons Attribution 4.0 International license

--]]-------------------------------------------------------------------
----------------- Variables & Services & Functions --------------------
-----------------------------------------------------------------------

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local coregui = game:GetService("CoreGui")
local lighting = game:GetService("Lighting")
local replicated = game:GetService("ReplicatedStorage")
local serverscriptservice = game:GetService("ServerScriptService")
local serverstorage = game:GetService("ServerStorage")
local startergui = game:GetService("StarterGui")
local httpservice = game:GetService("HttpService")

-- /*/ Dependencies
local EssentialsLibrary = require(script.Libraries:WaitForChild("EssentialsLibrary"))

-- /*/ Variables & Functions
local CurrentConnection, CurrentDatabase = "", ""
local API = {}

local function out(text)
	print("[RoSQL]: " .. text)
end

-----------------------------------------------------------------------
------------------------- Public Functions ----------------------------
-----------------------------------------------------------------------

function API.Connect(_self, ApiKey)
	if (CurrentConnection ~= "") and (CurrentConnection ~= nil) then
		error("[ RBXDatabase ] Failed to connect; connection already established!", 2)
	else
		local Query = {
			["ApiKey"] = ApiKey;
		}
		local Response = httpservice:JSONDecode(httpservice:PostAsync("http://94.254.64.114:5567/projects/rosql/API/".."connect.php", httpservice:JSONEncode(Query), "TextPlain"))
		if (Response.succ == false) then
			error("[ RBXDatabase ] "..Response.error, 2)
		else
			out("Established connection to RoSQL.")
			CurrentConnection = ApiKey
			return true
		end
	end
end

function API.GetValue(_self, Key)
	if (CurrentConnection == "") or (CurrentConnection == nil) then
		error("[ RBXDatabase ] Failed to get value; no connection established!", 2)
	else
		local Query = {
			["ApiKey"] = CurrentConnection,
			["Key"] = Key,
		}
		local Response = httpservice:JSONDecode(httpservice:PostAsync("http://94.254.64.114/projects/rosql/API/".."get.php", httpservice:JSONEncode(Query), "TextPlain"))
		if (Response.succ == true) then
			return EssentialsLibrary.DecodeValue(Response.data.DataValue,Response.data.DataType)
		else
			return nil -- Data key doesn't exist, so return nil.
		end
	end
end

function API.GetAllData(_self)
	if (CurrentConnection == "") or (CurrentConnection == nil) then
		error("[ RBXDatabase ] Failed to get value; no connection established!", 2)
	else
		local Query = {
			["ApiKey"] = CurrentConnection,
		}
		local Response = httpservice:JSONDecode(httpservice:PostAsync("http://94.254.64.114/projects/rosql/API/".."dump.php", httpservice:JSONEncode(Query), "TextPlain"))
		if (Response.succ == true) then
			local New = {}
			for i,v in pairs(Response.data) do
				New[v.DataKey] = EssentialsLibrary.DecodeValue(v.DataValue,v.DataType)
			end
			return New -- Return table of all data that exists.
		else
			error("[ RBXDatabase ] "..Response.error, 2)
		end
	end
end

function API.SetValue(_self, Key, Value)
	if (CurrentConnection == "") or (CurrentConnection == nil) then
		error("[ RBXDatabase ] Failed to set value; no connection established!", 2)
	else
		local Query = {
			["ApiKey"] = CurrentConnection,
			["Key"] = Key,
			["Value"] = EssentialsLibrary.EncodeValue(Value),
			["DataType"] = EssentialsLibrary.GetType(Value),
		}
		local Response = httpservice:JSONDecode(httpservice:PostAsync("http://94.254.64.114/projects/rosql/API/".."set.php", httpservice:JSONEncode(Query), "TextPlain"))
		if (Response.succ == true) then
			return true
		else
			error("[ RBXDatabase ] "..Response.error, 2)
		end
	end
end

function API.UpdateValue(_self, Key, Func)
	if (CurrentConnection == "") or (CurrentConnection == nil) then
		error("[RoSQL]: Failed to update value; no connection established!", 2)
	else
		local Query = {
			["ApiKey"] = CurrentConnection,
			["Key"] = Key,
		}
		local Response = httpservice:JSONDecode(httpservice:PostAsync("http://94.254.64.114/projects/rosql/API/".."updateget.php", httpservice:JSONEncode(Query), "TextPlain"))
		if (Response.succ == true) then
			local StartTime = tick()
			local NewValue = Func(EssentialsLibrary.DecodeValue(Response.data.DataValue,Response.data.DataType))
			if tick()-StartTime < 23 then
				Query = {
					["ApiKey"] = CurrentConnection,
					["Key"] = Key,
					["Value"] = EssentialsLibrary.EncodeValue(NewValue),
					["DataType"] = EssentialsLibrary.GetType(NewValue),
				}
				Response = httpservice:JSONDecode(httpservice:PostAsync("http://94.254.64.114/projects/rosql/API/".."updateset.php", httpservice:JSONEncode(Query), "TextPlain"))
				if (Response.succ == true) then
					return true
				else
					error("[RoSQL]: "..Response.error, 2)
				end
			else
				error("[RoSQL]: Update timeout; data upload aborted.", 2)
			end
		else
			error("[RoSQL]: "..Response.error, 2)
		end
	end
end
	
function API.DeleteValue(_self, Key)
	if (CurrentConnection == "") or (CurrentConnection == nil) then
		error("[RoSQL]: Failed to delete value; no connection established!", 2)
	else
		local Query = {
			["ApiKey"] = CurrentConnection,
			["Key"] = Key,
		}
		local Response = httpservice:JSONDecode(httpservice:PostAsync("http://94.254.64.114/projects/rosql/API/".."delete.php", httpservice:JSONEncode(Query), "TextPlain"))
		if (Response.succ == true) then
			return true
		else
			error("[RoSQL]: "..Response.error, 2)
		end
	end
end

return API