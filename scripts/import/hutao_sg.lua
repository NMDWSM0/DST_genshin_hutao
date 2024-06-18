--自定义区域
-- local chargeattack_anim = "action_hutao_chargeattack"
-- local chargeattack_anim_pst = "action_hutao_chargeattack_pst"
-- local eleburst_anim = "action_hutao_eleburst"
-- local eleskill_anim = "action_hutao_eleskill"
local chargeattack_anim = "spearjab"
local chargeattack_anim_pst = "idle_loop"
local eleburst_anim = "atk_pre"
local eleskill_anim = "atk_pre"
local chargeattack_timeout = 32 * FRAMES   --OK
local eleburst_timeout = 75 * FRAMES   --OK
local eleskill_timeout = 39 * FRAMES   --OK
--更改xxxx_anim的名字就播放对应的动画
--更改xxxx_timeout的数值就设置这个动画播放多长时间后自动退出（如果时间比动画短会强退），FRAMES = 1/30秒
--chargeattack是重击，长按F（长按攻击键）触发
--eleburst是元素爆发，默认键位Q，可以自行设置
--eleskill是元素战技，默认键位E，可以自行设置
------------------------------------------------------------

local function ClearCollision(inst)
    local phys = inst.Physics
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.GIANTS)
end

local function RecoverCollision(inst)
    local phys = inst.Physics
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.GIANTS)
end

local no_collide_tags = TUNING.HUTAO_AREASKILLS_NOTAGS
for k, v in pairs({ "NPC_workable", "DIG_workable" }) do
    table.insert(no_collide_tags, v)
end

local function tackletarget(inst, ignores)
    local x, y, z = inst.Transform:GetWorldPosition()
    local angle = inst.Transform:GetRotation() * DEGREES
    local x1 = x + math.cos(angle) * 1
    local z1 = z - math.sin(angle) * 1
    local target = nil
    local targetdist = math.huge
    local targetworkable = nil
    local trample = {}
    for i, v in ipairs(TheSim:FindEntities(x1, 0, z1, 3.75, nil, no_collide_tags, { "_combat" })) do
        if ignores == nil or not ignores[v] then
            local x2, y2, z2 = v.Transform:GetWorldPosition()
            local r = v:GetPhysicsRadius(0)
            local d = 0.75 + r
            if distsq(x1, z1, x2, z2) < d * d then
                d = math.sqrt(distsq(x, z, x2, z2)) - v:GetPhysicsRadius(0)
                if d < targetdist then
                    if v.components.combat ~= nil
                        and v.components.health ~= nil
                        and not v.components.health:IsDead()
                        and inst.components.combat ~= nil
                        and inst.components.combat:IsValidTarget(v) then
                        if v:HasTag("structure") then
                            target = v
                            targetdist = d
                        else
                            table.insert(trample, { inst = v, dist = d })
                        end
                    end
                end
            end
        end
    end

    if target ~= nil then
        if ignores ~= nil then
            ignores[target] = true
        end
    end

    if inst.components.constellation:GetActivatedLevel() >= 2 and #trample > 0 then  --凡是挂血梅香，都刷新血梅香2命效果的加成
        local maxhealth = inst.components.health.maxhealth
        inst.components.combat.external_dmgaddnumber_multipliers:SetModifier(inst, 0.1 * maxhealth, "hutao_constellation2", {atk_key = "elementalskill"})
    end
    for i, v in ipairs(trample) do
        if v.dist < targetdist and
            v.inst:IsValid() and
            v.inst.components.combat ~= nil and
            v.inst.components.health ~= nil and
            not v.inst.components.health:IsDead() and
            inst.components.combat:IsValidTarget(v.inst) then
            if ignores ~= nil then
                ignores[v.inst] = true
            end
            --攻击
            inst.components.combat:DoAttack(v.inst, nil, nil, nil, TUNING.HUTAOSKILL_NORMALATK.CHARGE_ATK_DMG[inst.components.talents:GetTalentLevel(1)])
            --挂血梅香
            if inst.papiliostate then
                local blood_blossom = nil
                if v.inst.children ~= nil then
                    for m, n in pairs(v.inst.children) do
                        if m:HasTag("hutao_blood_blossom") then
                            blood_blossom = m
                            break
                        end
                    end
                end
                if blood_blossom then
                    blood_blossom:AttachTarget(v.inst, inst)
                else
                    blood_blossom = SpawnPrefab("hutao_blood_blossom")
                    blood_blossom:AttachTarget(v.inst, inst)
                end
            end
        end
    end

    return target ~= nil
end

--重击
local hutao_chargeattack = State{
    name = "hutao_chargeattack",
    tags = { "chargeattack", "attack", "notalking", "nointerrupt", "abouttoattack", "autopredict" },

    onenter = function(inst)
        if inst.components.combat:InCooldown() then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
        end
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation(chargeattack_anim, false)
        inst.SoundEmitter:PlaySound("hutao_sound/sesound/hutao_chargeattack")

        inst.sg:SetTimeout(chargeattack_timeout)
        inst.sg.statemem.targets = {}
        if target ~= nil then
            inst.components.combat:BattleCry()
            if target:IsValid() then
                inst:FacePoint(target:GetPosition())
                inst.sg.statemem.attacktarget = target
                inst.sg.statemem.retarget = target
            end
        end
    end,

    onupdate = function(inst)
        if tackletarget(inst, inst.sg.statemem.targets) then
            inst.sg.statemem.stopping = true
            inst.Physics:Stop()
        end
    end,

    timeline =
    {
        TimeEvent(2 * FRAMES, function(inst)
            -- inst.SoundEmitter:PlaySound("hutao_sound/sesound/hutao_chargeattack")
        end),

        TimeEvent(4 * FRAMES, function(inst)
            -- local x, y, z = inst.Transform:GetWorldPosition()
            -- local facingangle = inst.Transform:GetRotation() * DEGREES
	        -- local facedirection = Vector3(math.cos(-facingangle), 0, math.sin(-facingangle))
            inst.components.playercontroller:Enable(false)
            ClearCollision(inst)
            inst.sg.statemem.collisioncleared = true

            -- local dis = 0
            -- inst.DashTask = inst:DoPeriodicTask(FRAMES, function ()
            --     
            -- end)
            inst.Physics:SetMotorVel(0.6, 0, 0)
        end),

        TimeEvent(5 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(3, 0, 0)
            end
        end),
        TimeEvent(6 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(6, 0, 0)
            end
        end),
        TimeEvent(7 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(9, 0, 0)
            end
        end),
        TimeEvent(8 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(15, 0, 0)
            end
        end),
        TimeEvent(9 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(16.2, 0, 0)
            end
        end),
        TimeEvent(10 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(16.8, 0, 0)
            end
        end),
        TimeEvent(12 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(16.2, 0, 0)
            end
        end),
        TimeEvent(13 * FRAMES, function(inst)
            inst.components.playercontroller:Enable(true)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(14.4, 0, 0)
            end
        end),
        TimeEvent(14 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(12, 0, 0)
            end
        end),
        TimeEvent(15 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(10.8, 0, 0)
            end
        end),
        TimeEvent(16 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(9, 0, 0)
            end
        end),

        TimeEvent(17 * FRAMES, function(inst)
            -- inst.DashTask:Cancel()
            inst.AnimState:PlayAnimation(chargeattack_anim_pst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(7, 0, 0)
            end
        end),

        TimeEvent(18 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(5, 0, 0)
            end
        end),
        TimeEvent(19 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(3, 0, 0)
            end
        end),
        TimeEvent(20 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(2, 0, 0)
            end
        end),
        TimeEvent(21 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(1.5, 0, 0)
            end
        end),
        TimeEvent(22 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(1, 0, 0)
            end
        end),
        TimeEvent(23 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(0.5, 0, 0)
            end
        end),
        TimeEvent(26 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(0.2, 0, 0)
            end
        end),

        TimeEvent(28 * FRAMES, function(inst)
            inst.components.locomotor:Stop()
            RecoverCollision(inst)
            inst.sg.statemem.collisioncleared = false
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        -- EventHandler("animqueueover", function(inst)
        --     if inst.AnimState:AnimDone() then
        --         inst.sg:GoToState("idle")
        --     end
        -- end),
    },

    onexit = function(inst)
        -- if inst.DashTask ~= nil then
        --     inst.DashTask:Cancel()
        -- end
        inst.components.playercontroller:Enable(true)
        if inst.sg.statemem.targets and inst.papiliostate then
            inst.charge_number = inst.charge_number + 1
            --第1和6次重击恢复能量，每次随机(2~3)*3能量
            if inst.charge_number == 1 or inst.charge_number == 6 then
                local num = math.random() < 0.5 and 3 or 2
                inst.components.energyrecharge:GainEnergy(num * 3)
            end
        end
        if inst.sg.statemem.collisioncleared then
            RecoverCollision(inst)
        end
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
    end,
}

local hutao_chargeattack_client = State{
    name = "hutao_chargeattack",
    tags = {"chargeattack", "attack", "notalking", "nointerrupt", "abouttoattack" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        if inst.replica.combat ~= nil then
            if inst.replica.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
            inst.replica.combat:StartAttack()
        end
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
        end
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation(chargeattack_anim, false)

        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil and buffaction.target:IsValid() then
                inst:FacePoint(buffaction.target:GetPosition())
                inst.sg.statemem.attacktarget = buffaction.target
                inst.sg.statemem.retarget = buffaction.target
            end
        end

        inst.sg:SetTimeout(chargeattack_timeout)
    end,

    timeline =
    {
        TimeEvent(4 * FRAMES, function(inst)
            inst.components.playercontroller:Enable(false)
            inst.Physics:SetMotorVel(0.6, 0, 0)
        end),

        TimeEvent(5 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(3, 0, 0)
            end
        end),
        TimeEvent(6 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(6, 0, 0)
            end
        end),
        TimeEvent(7 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(9, 0, 0)
            end
        end),
        TimeEvent(8 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(15, 0, 0)
            end
        end),
        TimeEvent(9 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(16.2, 0, 0)
            end
        end),
        TimeEvent(10 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(16.8, 0, 0)
            end
        end),
        TimeEvent(12 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(16.2, 0, 0)
            end
        end),
        TimeEvent(13 * FRAMES, function(inst)
            inst.components.playercontroller:Enable(true)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(14.4, 0, 0)
            end
        end),
        TimeEvent(14 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(12, 0, 0)
            end
        end),
        TimeEvent(15 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(10.8, 0, 0)
            end
        end),
        TimeEvent(16 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(9, 0, 0)
            end
        end),

        TimeEvent(17 * FRAMES, function(inst)
            -- inst.DashTask:Cancel()
            inst.AnimState:PlayAnimation(chargeattack_anim_pst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(7, 0, 0)
            end
        end),

        TimeEvent(18 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(5, 0, 0)
            end
        end),
        TimeEvent(19 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(3, 0, 0)
            end
        end),
        TimeEvent(20 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(2, 0, 0)
            end
        end),
        TimeEvent(21 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(1.5, 0, 0)
            end
        end),
        TimeEvent(22 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(1, 0, 0)
            end
        end),
        TimeEvent(23 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(0.5, 0, 0)
            end
        end),
        TimeEvent(26 * FRAMES, function(inst)
            if not inst.sg.statemem.stopping then
                inst.Physics:SetMotorVel(0.2, 0, 0)
            end
        end),

        TimeEvent(28 * FRAMES, function(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        -- EventHandler("animqueueover", function(inst)
        --     if inst.AnimState:AnimDone() then
        --         inst.sg:GoToState("idle")
        --     end
        -- end),
    },

    onexit = function(inst)
        -- if inst.DashTask ~= nil then
        --     inst.DashTask:Cancel()
        -- end
        inst.components.playercontroller:Enable(true)
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
}

--------------------------------------------------------------------------	
--元素爆发
local hutao_eleburst = State{
    name = "hutao_eleburst",
    tags = { "attack", "notalking", "nointerrupt", "noyawn", "nosleep", "nofreeze", "nocurse", "temp_invincible", "no_gotootherstate", "pausepredict" },
    
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleburst_anim)
        inst.AnimState:OverrideSymbol("swap_object", "action_hutao_eleburst", "swap_object")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item == nil then
            inst.AnimState:Show("ARM_CARRY")
		    inst.AnimState:Hide("ARM_NORMAL")
        end

        inst.SoundEmitter:PlaySound("hutao_sound/sesound/hutao_eleburst")

        inst.sg:SetTimeout(eleburst_timeout)
    end,
    
    timeline=
    {   
        TimeEvent(0 * FRAMES, function(inst) 
            local x, y, z = inst.Transform:GetWorldPosition()
	        local ents = TheSim:FindEntities(x, y, z, 6, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
	        local mindist = 6
	        local mintarget = nil
	        if ents ~= nil then
		        for k, v in pairs(ents) do
			        local dist = Vector3(x, y, z):Dist(inst:GetPosition())
			        if dist < mindist then
				        mindist = dist
				        mintarget = v
			        end
		        end
	        end
	        if mintarget ~= nil then
                inst:ForceFacePoint(Point(mintarget.Transform:GetWorldPosition()))
	        end
        end),

        TimeEvent(34 * FRAMES, function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local facingangle = inst.Transform:GetRotation() * DEGREES
            local fx = SpawnPrefab("raiden_eleburst_fx")
            fx.Transform:SetPosition(x + math.cos(-facingangle) * 2.5, 1.5, z + math.sin(-facingangle) * 2.5)
            fx.Transform:SetRotation(inst.Transform:GetRotation())
        end),
        
        TimeEvent(46 * FRAMES, function(inst) 
            inst:ShakeCamera(CAMERASHAKE.FULL, 0.15, 0.03, 0.3)

            local x, y, z = inst.Transform:GetWorldPosition()
	        local ents = TheSim:FindEntities(x, y, z, 6, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
            local work_ents = TheSim:FindEntities(x, y, z, 6, {"plant"})
            local bloombombs = TheSim:FindEntities(x, y, z, 6, {"bloombomb"}, {"isexploding", "istracing"})
            local facingangle = inst.Transform:GetRotation() * DEGREES
	        local facedirection = Vector3(math.cos(-facingangle), 0, math.sin(-facingangle))

            local old_state = inst.components.combat.ignorehitrange
            inst.components.combat.ignorehitrange = true
            for k, v in pairs(ents) do
                local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
                if targetdirection:Dot(facedirection) > 0 then   
                    inst.components.combat:DoAttack(v, nil, nil, 4, TUNING.RAIDENSKILL_ELEBURST.DMG[inst.components.talents:GetTalentLevel(3)] + inst.resolve_stack * TUNING.RAIDENSKILL_ELEBURST.RESOLVE_BONUS[inst.components.talents:GetTalentLevel(3)], "elementalburst") 
                end
            end
            inst.components.combat.ignorehitrange = old_state

            for k, v in pairs(work_ents) do
                local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
                if targetdirection:Dot(facedirection) > 0 and v.components.workable and v.components.workable.action == ACTIONS.CHOP then   
                    v.components.workable:Destroy(inst)
                end
            end

            for k, v in pairs(bloombombs) do
                local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
	        	if targetdirection:Dot(facedirection) > 0 then
	        		v:Hyperbloom(inst)
	        	end
            end
        end),

        TimeEvent(50 * FRAMES, function(inst) 
            inst.sg:RemoveStateTag("pausepredict")
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("noyawn")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end),

    },

    events=
    {
        EventHandler("animqueueover", function(inst) 
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")                                    
        end),
    },  

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")	   
        inst.components.playercontroller:Enable(true)         		
    end,
    
    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:OverrideSymbol("swap_object", "swap_musouisshin", "swap_object")
            inst.components.combat:SetRange(TUNING.RAIDEN_BURST_ATTACKRANGE)
        elseif inst:HasTag("raiden_shogun") then
            inst:elementalburst_exit()
        else
            inst.AnimState:ClearOverrideSymbol("swap_object")
		    inst.AnimState:Hide("ARM_CARRY")
		    inst.AnimState:Show("ARM_NORMAL")
        end
        inst.components.playercontroller:Enable(true)
    end,               
}

local hutao_eleburst_client = State{
    name = "hutao_eleburst",
    tags = { "attack", "notalking", "nointerrupt", "noyawn", "nosleep", "nofreeze", "nocurse", "temp_invincible", "no_gotootherstate" },	
    
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()	
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleburst_anim)

        inst.sg:SetTimeout(eleburst_timeout)
    end,
    
    timeline=
    {   
        TimeEvent(46 * FRAMES, function(inst) 
            inst:ShakeCamera(CAMERASHAKE.FULL, 0.15, 0.03, 0.3)
        end),

        TimeEvent(50 * FRAMES, function(inst) 
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("noyawn")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end),
    },

    events=
    {
        EventHandler("animqueueover", function(inst) 
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")                                    
        end),
    },  

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")	   
        inst.components.playercontroller:Enable(true)         		
    end,
    
    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        inst.components.playercontroller:Enable(true)
    end,               
}

--元素战技
local hutao_eleskill = State{
    name = "hutao_eleskill",
    tags = { "attack", "notalking", "nointerrupt", "nosleep", "nofreeze", "nocurse", "temp_invincible", "no_gotootherstate", "pausepredict" },	
    
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleskill_anim)
        inst.sg:SetTimeout(eleskill_timeout)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_NORMAL")
		    inst.AnimState:Hide("ARM_CARRY")
        end

        inst.SoundEmitter:PlaySound("hutao_sound/sesound/hutao_eleskill")

        inst:AddTag("stronggrip")
    end,
    
    timeline=
    {   
        TimeEvent(0 * FRAMES, function(inst) 
            local x, y, z = inst.Transform:GetWorldPosition()
	        local ents = TheSim:FindEntities(x, y, z, 5, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
	        local mindist = 5
	        local mintarget = nil
	        if ents ~= nil then
		        for k, v in pairs(ents) do
			        local dist = Vector3(x, y, z):Dist(inst:GetPosition())
			        if dist < mindist then
				        mindist = dist
				        mintarget = v
			        end
		        end
	        end
	        if mintarget ~= nil then
                inst:FacePoint(Point(mintarget.Transform:GetWorldPosition()))
	        end
            local facingangle = inst.Transform:GetRotation() * DEGREES
            local fx = SpawnPrefab("raiden_eleskill_fx")
            fx.Transform:SetPosition(x + math.cos(-facingangle) * 2.5, 1.5, z + math.sin(-facingangle) * 2.5)
        end),

        TimeEvent(7 * FRAMES, function(inst) 
            local x, y, z = inst.Transform:GetWorldPosition()
	        local ents = TheSim:FindEntities(x, y, z, 5, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
            local bloombombs = TheSim:FindEntities(x, y, z, 5, {"bloombomb"}, {"isexploding", "istracing"})
	        local mindist = 5
	        local mintarget = nil
	        local facingangle = inst.Transform:GetRotation() * DEGREES
	        local facedirection = Vector3(math.cos(-facingangle), 0, math.sin(-facingangle))
	        if ents ~= nil then
		        for k, v in pairs(ents) do
			        local dist = Vector3(x, y, z):Dist(inst:GetPosition())
			        if dist < mindist then
				        mindist = dist
				        mintarget = v
			        end
		        end
	        end
	        if mintarget ~= nil then
                inst.components.energyrecharge:GainEnergy(3) --一个同色球
                inst:FacePoint(Point(mintarget.Transform:GetWorldPosition()))
		        facedirection = (mintarget:GetPosition() - Vector3(x, y, z)):Normalize()
                local old_state = inst.components.combat.ignorehitrange
				inst.components.combat.ignorehitrange = true
---@diagnostic disable-next-line: param-type-mismatch
                for k, v in pairs(ents) do
			        local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
			        if targetdirection:Dot(facedirection) >= 1/3 then
				        inst.components.combat:DoAttack(v, nil, nil, 4, TUNING.RAIDENSKILL_ELESKILL.DMG[inst.components.talents:GetTalentLevel(2)], "elementalskill")
			        end
		        end
                inst.components.combat.ignorehitrange = old_state
	        end

            for k, v in pairs(bloombombs) do
                local targetdirection = (v:GetPosition() - Vector3(x, y, z)):Normalize()
	        	if targetdirection:Dot(facedirection) >= 1/3 then
	        		v:Hyperbloom(inst)
	        	end
            end
        end),

        TimeEvent(10 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("pausepredict")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end)
    },

    events=
    {
        EventHandler("animqueueover", function(inst) 
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")                                    
        end),
    },  

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")	   
        inst.components.playercontroller:Enable(true)    		
    end,
    
    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_CARRY")
		    inst.AnimState:Hide("ARM_NORMAL")
        end
        inst.sg:RemoveStateTag("attack")
        inst:RemoveTag("stronggrip")
        inst.components.playercontroller:Enable(true)
    end,               
}

local hutao_eleskill_client = State{
    name = "hutao_eleskill",
    tags = { "attack", "notalking", "nointerrupt", "nosleep", "nofreeze", "nocurse", "temp_invincible", "no_gotootherstate" },	
    
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.components.locomotor:Clear()
        inst:ClearBufferedAction()	
        inst.components.playercontroller:Enable(false)
        inst.AnimState:PlayAnimation(eleskill_anim)

        inst.sg:SetTimeout(eleskill_timeout)
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_NORMAL")
		    inst.AnimState:Hide("ARM_CARRY")
        end
    end,
    
    timeline=
    {   
        TimeEvent(10 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("nosleep")
            inst.sg:RemoveStateTag("nofreeze")
            inst.sg:RemoveStateTag("nocurse")
            inst.sg:RemoveStateTag("temp_invincible")
            inst.sg:RemoveStateTag("notalking")
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.components.playercontroller:Enable(true)
        end)
    },

    events=
    {
        EventHandler("animqueueover", function(inst) 
            inst.sg:RemoveStateTag("no_gotootherstate")
            inst.sg:GoToState("idle")                                    
        end),
    },  

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("no_gotootherstate")
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")	   
        inst.components.playercontroller:Enable(true)         		
    end,
    
    onexit = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        local item = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if item ~= nil then
            inst.AnimState:Show("ARM_CARRY")
		    inst.AnimState:Hide("ARM_NORMAL")
        end
        inst.sg:RemoveStateTag("attack")
        inst.components.playercontroller:Enable(true)
    end,               
}

--------------------------------------------------------------------------
--添加sg
local function SGWilsonPostInit(sg)
    sg.states["hutao_chargeattack"] = hutao_chargeattack
    sg.states["hutao_eleburst"] = hutao_eleburst
    sg.states["hutao_eleskill"] = hutao_eleskill
end

local function SGWilsonClientPostInit(sg)
    sg.states["hutao_chargeattack"] = hutao_chargeattack_client
    sg.states["hutao_eleburst"] = hutao_eleburst_client
    sg.states["hutao_eleskill"] = hutao_eleskill_client
end

AddStategraphState("SGwilson", hutao_chargeattack)
AddStategraphState("SGwilson", hutao_eleburst)
AddStategraphState("SGwilson", hutao_eleskill)

AddStategraphState("SGwilson_client", hutao_chargeattack_client)
AddStategraphState("SGwilson_client", hutao_eleburst_client)
AddStategraphState("SGwilson_client", hutao_eleskill_client)

AddStategraphPostInit("wilson", SGWilsonPostInit)
AddStategraphPostInit("wilson_client", SGWilsonClientPostInit)

-- 这个不需要了，直接加nohitanim全抗打断
-- AddStategraphPostInit("wilson", function(sg)
--     --雷电将军重击期间提升抗打断能力
-- 	if sg.events and sg.events.attacked then
-- 		local old_attacked = sg.events.attacked.fn
-- 		sg.events.attacked.fn = function(inst, data)
-- 			if inst.sg and inst.sg:HasStateTag("nointerrupt") and inst.sg:HasStateTag("chargeattack") and inst:HasTag("raiden_shogun") then
--                 return
--             end
--             return old_attacked(inst, data)
--         end
-- 	end
-- end)

-- AddGlobalClassPostConstruct("stategraph", "StateGraphInstance", function (self)
--     local old_GoToState = self.GoToState
--     function self:GoToState(...)
--         if self.tags and self.tags["no_gotootherstate"] then
--             print("Try to goto another state while in an unchanging state")
--             return
--         end
--         old_GoToState(self, ...)
--     end
-- end)