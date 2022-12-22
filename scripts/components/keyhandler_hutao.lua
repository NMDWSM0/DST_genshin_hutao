local function IsHUDScreen(inst) 
	local defaultscreen = false 
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name  and type(TheFrontEnd:GetActiveScreen().name) == "string"  and TheFrontEnd:GetActiveScreen().name == "HUD" then 
		defaultscreen = true 
	end 
	return defaultscreen 
end  

local KeyHandler_Hutao = Class(function(self, inst)
	self.inst = inst
	self.paused = false
	self.enabled = true 
	self.ticktime = 0
	self.skillkeys = {}
end)

function KeyHandler_Hutao:SetSkillKeys(keys)
    self.skillkeys = keys
end

function KeyHandler_Hutao:SetEnabled(enable)
	self.enabled = enable
end 

function KeyHandler_Hutao:CanTrigger()
	return self.enabled and IsHUDScreen(self.inst) and (self.inst.sg == nil or not self.inst.sg:HasStateTag("dead"))
	and self.inst.components.playercontroller:IsEnabled()
end 


function KeyHandler_Hutao:IsKeyDownForOtherSkills(key)
	-- if self:IsKeyDown(400) or self:IsKeyDown(401) or self:IsKeyDown(402)  --ctrl,shift,alt
	-- 	or self:IsKeyDown(304) or self:IsKeyDown(306) or self:IsKeyDown(308)
	-- 	or self:IsKeyDown(303) or self:IsKeyDown(305) or self:IsKeyDown(307) then
	-- 		return true
	-- end
	if TheInput:IsKeyDown(KEY_CTRL) or TheInput:IsKeyDown(KEY_CTRL) or TheInput:IsKeyDown(KEY_ALT) then
		return true
	end

	return false 
end

function KeyHandler_Hutao:HandleRPC(Rpc, clientfn, restrict, key)
	local x,y,z = ( TheInput:GetWorldPosition() or Vector3(0,0,0) ):Get()
	local entity = TheInput:GetWorldEntityUnderMouse()
	local Namespace = Rpc.Namespace
	local Action = Rpc.Action
	if restrict then
	    -- if self:IsKeyDownForOtherSkills(key) then
	    --     return
		-- end
	end
	if clientfn then 
		clientfn(self.inst, x, y, z, entity)
	end	
	SendModRPCToServer(MOD_RPC[Namespace][Action], x, y, z, entity)
end 

function KeyHandler_Hutao:AddActionListener(Key, Rpc, keytype, clientfn, restrict)
	local keyevent = keytype or "keyup"
	
	if keyevent == "keyup" then
		TheInput:AddKeyUpHandler(Key, function()
			if self.inst == ThePlayer then
				if self:CanTrigger()  and not ThePlayer:HasTag("playerghost") and not (ThePlayer.components.health and ThePlayer.components.health:IsDead()) then
					self:HandleRPC(Rpc, clientfn, restrict, Key)
				end
			end	
		end)
	else
		TheInput:AddKeyDownHandler(Key, function()
			if self.inst == ThePlayer then
				if self:CanTrigger()  and not ThePlayer:HasTag("playerghost") and not (ThePlayer.components.health and ThePlayer.components.health:IsDead()) then
					self:HandleRPC(Rpc, clientfn, restrict, Key)
				end
			end	
		end)
	end
end

return KeyHandler_Hutao