--初始加载
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local prefabs = {
    --"favoniuslance",
}

local start_inv = {
	--"favoniuslance",
}

local skillkeys = {
    TUNING.ELEMENTALSKILL_KEY,
	TUNING.ELEMENTALBURST_KEY,
}

--------------------------------------------------------------------------
--保存和加载
local function OnBecameHuman(inst, data)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6

	
end

local function OnDeath(inst)
	
end

local function OnDespawn(inst)
	
end

--保存
local function OnSave(inst, data)
	
end

--读取
local function OnLoad(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", OnBecameHuman)
    if not inst:HasTag("playerghost") then
        OnBecameHuman(inst, data)
    end
end

----------------------------------------------------------------------------
--命之座
--一命效果直接写函数里面

local function constellation_func2(inst)
	local maxhealth = inst.components.health.maxhealth
	inst.components.combat.external_dmgaddnumber_multipliers:SetModifier(inst, 0.1 * maxhealth, "hutao_constellation2", {atk_key = "elementalskill"})
	--该数值并不是一尘不变的，在挂血梅香的时候会更改这个数值
end

local function constellation_func3(inst)
	if inst.components.talents == nil then
		return
    end
	inst.components.talents:SetExtensionModifier(2, inst, 3, "hutao_constellation3")
end

local function constellation_func4(inst)
	inst:ListenForEvent("entity_death", function (inst, data)
		if not data or not data.inst then
			return
		end
		local target = data.inst
		local blood_blossom = nil
		if target.children ~= nil then
            for m, n in pairs(target.children) do
                if m:HasTag("hutao_blood_blossom") then
				    blood_blossom = m
				    break
			    end
		    end
		end
		if blood_blossom == nil then
			return
		end
		local x, y, z = inst.Transform:GetWorldPosition()
		local players = TheSim:FindEntities(x, y, z, 20, {"player"}, {"playerghost"})
		for k, v in pairs(players) do
			v.components.combat.external_critical_rate_multipliers:SetModifier(inst, 0.12, "hutao_constellation4")
			v:DoTaskInTime(15, function()
				if v and v.components.combat then
					v.components.combat.external_critical_rate_multipliers:RemoveModifier(inst, "hutao_constellation4")
				end
			end)
		end
	end, TheWorld)
end

local function constellation_func5(inst)
	if inst.components.talents == nil then
		return
    end
	inst.components.talents:SetExtensionModifier(3, inst, 3, "hutao_constellation5")
end

--六命
local function constell6_reget(inst)
	--没有什么特别的
end

local function constell6_available(inst)
	if inst.components.timer:TimerExists("hutao_constellation6_cd") then
		return false
	end
	inst.components.timer:StartTimer("hutao_constellation6_cd", 60)
	--10秒内，胡桃的所有元素抗性和物理抗性提高200%，暴击率提高100%
	inst.components.combat.external_critical_rate_multipliers:SetModifier(inst, 1.00, "hutao_constellation6")
	inst.components.combat.external_pyro_res_multipliers:SetModifier(inst, 2.00, "hutao_constellation6")
	inst.components.combat.external_cryo_res_multipliers:SetModifier(inst, 2.00, "hutao_constellation6")
	inst.components.combat.external_hydro_res_multipliers:SetModifier(inst, 2.00, "hutao_constellation6")
	inst.components.combat.external_electro_res_multipliers:SetModifier(inst, 2.00, "hutao_constellation6")
	inst.components.combat.external_anemo_res_multipliers:SetModifier(inst, 2.00, "hutao_constellation6")
	inst.components.combat.external_geo_res_multipliers:SetModifier(inst, 2.00, "hutao_constellation6")
	inst.components.combat.external_dendro_res_multipliers:SetModifier(inst, 2.00, "hutao_constellation6")
	inst.components.combat.external_physical_res_multipliers:SetModifier(inst, 2.00, "hutao_constellation6")
	--极大提升抗打断
	inst:AddTag("stronggrip")
	inst:AddTag("nohitanim")
	inst.components.pinnable.canbepinned = false
	inst:DoTaskInTime(10, function (inst)
		inst.components.combat.external_critical_rate_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst.components.combat.external_pyro_res_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst.components.combat.external_cryo_res_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst.components.combat.external_hydro_res_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst.components.combat.external_electro_res_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst.components.combat.external_anemo_res_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst.components.combat.external_geo_res_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst.components.combat.external_dendro_res_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst.components.combat.external_physical_res_multipliers:RemoveModifier(inst, "hutao_constellation6")
		inst:RemoveTag("stronggrip")
		inst:RemoveTag("nohitanim")
		inst.components.pinnable.canbepinned = true
	end)
end


----------------------------------------------------------------------------
--天赋

--注意这是一个客机也运行的函数
local function ChargeSGFn(inst)
	if TheWorld.ismastersim then
		local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
		if weapon == nil then
			return "attack"
		end
	else
		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
		if equip == nil then
			return "attack"
		end
	end
	return "hutao_chargeattack"
end

--key和element
local function AttackkeyFn(inst, weapon, target)
    return inst.sg:HasStateTag("chargeattack") and "charge" or "normal"
end

local function StimuliFn(inst, weapon, targ, attackkey)
	if inst.charge_number > 6 and inst.components.constellation:GetActivatedLevel() < 1 and attackkey == "charge" then  --一命不受限制
		return nil
	end
    return inst.papiliostate and 1 or nil
end

--普通攻击倍率
local function NormalATKRateFn(inst, target)
    return TUNING.HUTAOSKILL_NORMALATK.ATK_DMG[inst.components.talents:GetTalentLevel(1)]
end

--重击倍率
local function ChargeATKRateFn(inst, target)  --这个rate其实也没有意义，因为重击攻击方式不在这里
    return TUNING.HUTAOSKILL_NORMALATK.CHARGE_ATK_DMG[inst.components.talents:GetTalentLevel(1)]
end

--
local function CustomAttackFn(inst, target, instancemult, ischarge)
	if ischarge then
		return  --不在这里写攻击，因为重击的攻击方式是类似伍迪的tackle
	end
	inst.components.combat:DoAttack(target, nil, nil, nil, instancemult)
end

local function IgnoreCDFn(attacker, weapon, atk_elements, ele_value, attackkey)
	return atk_elements == 1 and attackkey == "charge" and attacker.papiliostate  --开e重击无视元素附着CD
end

----------------------------------------------------

--元素战技结束
local function elementalskill_exitfn(inst)
	if inst.papiliostate == true then
		inst.papiliostate = false
		inst._papiliostate:set(false)
		-- if inst.components.constellation:GetActivatedLevel() >= 4 then
		-- 	raiseattack(inst)
		-- end
	end
	inst.charge_number = 0
	inst.components.combat.external_atkbonus_multipliers:RemoveModifier(inst, "all_eleskill_atkbonus")
	inst.components.combat:SetRange(TUNING.DEFAULT_ATTACK_RANGE)
	inst:critafterE()
end

--元素战技
local function elementalskillfn(inst)
	if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalskill") then
	    return
	end

	inst:PushEvent("cast_elementalskill")

	inst.papiliostate = true
	inst._papiliostate:set(true)

	-- inst.sg:GoToState("hutao_eleskill")
	inst.charge_number = 0
	local maxhealth = inst.components.health.maxhealth
	local currenthealth = inst.components.health.currenthealth
	inst.components.health:DoDelta(-TUNING.HUTAOSKILL_ELESKILL.HP_COST * currenthealth)
	local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local baseatk = weapon ~= nil and weapon.components.weapon and weapon.components.weapon:GetDamage(inst, inst) or inst.components.combat.defaultdamage
	local atkdelta = TUNING.HUTAOSKILL_ELESKILL.ATK_INCREASE[inst.components.talents:GetTalentLevel(2)] * maxhealth
	inst.components.combat.external_atkbonus_multipliers:SetModifier(inst, math.min(atkdelta, 5 * baseatk), "all_eleskill_atkbonus")
	inst.components.combat:SetRange(TUNING.HUTAO_PAPILIO_ATTACKRANGE)
	inst:DoTaskInTime(TUNING.HUTAOSKILL_ELESKILL.DURATION, function (inst)
		elementalskill_exitfn(inst)
	end)
end

--元素爆发(测试)
local function elementalburstfn(inst)
    if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalburst") then
	    return
	end

	inst:PushEvent("cast_elementalburst", {energycost = TUNING.HUTAOSKILL_ELEBURST.ENERGY, element = 1})
	TheWorld:PushEvent("cast_elementalburst", {energycost = TUNING.HUTAOSKILL_ELEBURST.ENERGY, element = 1})

    --这块以后会被sg替代
	-- inst.sg:GoToState("hutao_eleburst")
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 8, {"_combat"}, TUNING.HUTAO_AREASKILLS_NOTAGS)
	local islow = inst.components.health:GetPercent() <= 0.5
	if inst.components.constellation:GetActivatedLevel() >= 2 and #ents > 0 then  --凡是挂血梅香，都刷新血梅香2命效果的加成
		local maxhealth = inst.components.health.maxhealth
		inst.components.combat.external_dmgaddnumber_multipliers:SetModifier(inst, 0.1 * maxhealth, "hutao_constellation2", {atk_key = "elementalskill"})
	end
	local old_state = inst.components.combat.ignorehitrange
    inst.components.combat.ignorehitrange = true
	local hit_target = 0
	for k, v in pairs(ents) do
		inst.components.combat:DoAttack(v, nil, nil, 1, islow and TUNING.HUTAOSKILL_ELEBURST.LOWHP_DMG[inst.components.talents:GetTalentLevel(3)] or TUNING.HUTAOSKILL_ELEBURST.DMG[inst.components.talents:GetTalentLevel(3)], nil, nil, "elementalburst")
		hit_target = hit_target + 1
		if hit_target <= 5 then
			local gain_per = inst.components.health:GetPercent() <= 0.5 and TUNING.HUTAOSKILL_ELEBURST.LOWHP_REGENERATION[inst.components.talents:GetTalentLevel(3)] or TUNING.HUTAOSKILL_ELEBURST.REGENERATION[inst.components.talents:GetTalentLevel(3)]
			inst.components.health:DoDelta(gain_per * inst.components.health.maxhealth)
		end
		if inst.components.constellation:GetActivatedLevel() >= 2 then  --大招挂血梅香
			local blood_blossom = nil
			if v.children ~= nil then
            	for m, n in pairs(v.children) do
                	if m:HasTag("hutao_blood_blossom") then
				    	blood_blossom = m
				    	break
			    	end
		    	end
			end
			if blood_blossom then
				blood_blossom:AttachTarget(v, inst)
			else
				blood_blossom = SpawnPrefab("hutao_blood_blossom")
				blood_blossom:AttachTarget(v, inst)
			end
		end
	end
	inst.components.combat.ignorehitrange = old_state
end

--固有天赋（低血量增加火伤）
local function HealthChange(inst)
	if inst.components.health:GetPercent() <= 0.5 then
		inst.components.combat.external_pyro_multipliers:SetModifier(inst, 0.33, "all_talent5_pyrobonus")
	else
		inst.components.combat.external_pyro_multipliers:RemoveModifier(inst, "all_talent5_pyrobonus")
	end
end

--固有天赋（e结束增加暴击率）
local function CritRateAfterE(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = TheSim:FindEntities(x, y, z, 20, {"player"}, {"playerghost"})
	for k, v in pairs(players) do
		v.components.combat.external_critical_rate_multipliers:SetModifier(inst, 0.12, "hutao_eleskill_exit")
		v:DoTaskInTime(8, function()
			if v and v.components.combat then
				v.components.combat.external_critical_rate_multipliers:RemoveModifier(inst, "hutao_eleskill_exit")
			end
		end)
	end
end

--生活天赋（有概率获得额外的75%新鲜度的菜品）
local function AdditionalCuisine(inst, data)
	
end

local function OnTimerDone(inst, data)
	if data and data.name == "hutao_constellation6" then
		constell6_reget(inst)
	end
end

--技能RPC

AddModRPCHandler("hutao", "elementalskill", elementalskillfn)
AddModRPCHandler("hutao", "elementalburst", elementalburstfn)

----------------------------------------------------------------------------

local common_postinit = function(inst) 

	inst.MiniMapEntity:SetIcon( "hutao.tex" )  --还没改
	
	--标签
	inst:AddTag("hutao")
	inst:AddTag("Pyro")
	inst:AddTag("genshin_character")

	--会被genshin_core读取的有关信息
	--
	inst.character_description = STRINGS.CHARACTER_DESCRIPTIONS.hutao
	--命之座相关信息
	inst.constellation_path = "images/ui/constellation_hutao"
	inst.constellation_positions = TUNING.HUTAO_CONSTELLATION_POSITION
	inst.constellation_decription = TUNING.HUTAO_CONSTELLATION_DESC
	inst.constellation_starname = "hutao_constellation_star"
	--天赋相关信息
    inst.talents_path = "images/ui/talents_hutao"
	inst.talents_number = 6
	inst.talents_ingredients = TUNING.HUTAO_TALENTS_INGREDIENTS
	inst.talents_description = TUNING.HUTAO_TALENTS_DESC
	inst.talents_attributes = {
		value = {
			TUNING.HUTAOSKILL_NORMALATK,
			TUNING.HUTAOSKILL_ELESKILL,
			TUNING.HUTAOSKILL_ELEBURST,
		},
		text = {
			TUNING.HUTAOSKILL_NORMALATK_TEXT,
			TUNING.HUTAOSKILL_ELESKILL_TEXT,
			TUNING.HUTAOSKILL_ELEBURST_TEXT,
		},
		keysort = {
			TUNING.HUTAOSKILL_NORMALATK_SORT,
			TUNING.HUTAOSKILL_ELESKILL_SORT,
			TUNING.HUTAOSKILL_ELEBURST_SORT,
		},
	}
	--资料相关信息
	inst.genshin_profile_addition = {
		STRINGS.CHARACTER_BIOS.hutao[3],
		STRINGS.CHARACTER_BIOS.hutao[4],
	}
	
	--添加显示血量组件和键位设置器
	
	inst:AddComponent("keyhandler_hutao")
	inst.components.keyhandler_hutao:SetSkillKeys(skillkeys)
	--释放
	inst.components.keyhandler_hutao:AddActionListener(TUNING.ELEMENTALSKILL_KEY, {Namespace = "hutao", Action = "elementalskill"}, "keyup", nil, false)
	inst.components.keyhandler_hutao:AddActionListener(TUNING.ELEMENTALBURST_KEY, {Namespace = "hutao", Action = "elementalburst"}, "keyup", nil, false)

    ----------------------------------------------------------------------------
    --状态
    inst.papiliostate = false
	--限制0命的重击次数
	inst.charge_number = 0
	--网络变量
	inst._papiliostate = net_bool(inst.GUID, "hutao._papiliostate", "statedirty")
	--不是主机
	if not TheWorld.ismastersim then
		inst:ListenForEvent("statedirty", function(inst)
			inst.papiliostate = inst._papiliostate:value()
		end)
	end
	----------------------------------------------------------------------------
	inst.chargesgname = ChargeSGFn

	inst:DoPeriodicTask(0, function(inst) inst.AnimState:Show("HAIR_HAT") end)
end

local master_postinit = function(inst)

	inst.soundsname = "willow"

    --计数
	-- inst.gaincount = 0
	-- inst.resolve_stack = 0
	
	--energyrecharge和talents会在playerpostinit里面添加，但是却比这里更晚？？太怪了，得重新加
    --添加元素充能
    inst:AddComponent("energyrecharge")
	inst.components.energyrecharge:SetMax(TUNING.HUTAOSKILL_ELEBURST.ENERGY)

	--设置元素战技和元素爆发施放
	inst:AddComponent("elementalcaster")
	inst.components.elementalcaster:SetElementalSkill(TUNING.HUTAOSKILL_ELESKILL.CD)
	inst.components.elementalcaster:SetElementalBurst(TUNING.HUTAOSKILL_ELEBURST.CD, TUNING.HUTAOSKILL_ELEBURST.ENERGY)

	--天赋
	inst:AddComponent("talents")

	--命之座
	inst:AddComponent("constellation")
	--1命效果不写在这里
	inst.components.constellation:SetLevelFunc(2, constellation_func2)
	inst.components.constellation:SetLevelFunc(3, constellation_func3)
	inst.components.constellation:SetLevelFunc(4, constellation_func4)
	inst.components.constellation:SetLevelFunc(5, constellation_func5)

	--添加其他组件
	inst:AddComponent("entitytracker")
	
    --设置三维
	inst.components.health:SetMaxHealth(TUNING.HUTAO_HEALTH)
	inst.components.hunger:SetMax(TUNING.HUTAO_HUNGER)
	inst.components.sanity:SetMax(TUNING.HUTAO_SANITY)

	--设置其他属性
	inst.components.combat:SetDefaultDamage(TUNING.HUTAO_BASEATK)
	inst.components.combat.damagemultiplier = 1
	inst.components.combat.critical_damage = 0.884

	-- inst.components.foodaffinity:AddFoodtypeAffinity(FOODTYPE.GOODIES, 1.33)

	inst.components.combat:SetOverrideAttackkeyFn(AttackkeyFn)
	inst.components.combat:SetOverrideStimuliFn(StimuliFn)
	inst.components.combat:SetIgnoreCDFn(IgnoreCDFn)
	
    --监听器
	inst:ListenForEvent("healthdelta", HealthChange)
	-- inst:ListenForEvent("damagecalculated", RestoreEnergy)
	-- inst:ListenForEvent("builditem", RefundIngredients)
	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("timerdone", OnTimerDone)
	--
	
	--函数
	inst.OnDespawn = OnDespawn
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
    inst.OnNewSpawn = OnLoad

	inst.normalattackdmgratefn = NormalATKRateFn
	inst.chargeattackdmgratefn = ChargeATKRateFn

	inst.customattackfn = CustomAttackFn
	inst.critafterE = CritRateAfterE
	inst.elementalskill_exitfn = elementalskill_exitfn
	inst.constell6_available = constell6_available

	OnBecameHuman(inst)
    
end

return MakePlayerCharacter("hutao", prefabs, assets, common_postinit, master_postinit, start_inv)