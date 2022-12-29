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

-- local function constellation_func2(inst)
-- 	inst.components.combat:SetDefenseIgnoreFn(function(inst, target, weapon, atk_elements, attackkey)
-- 		return attackkey == "elementalburst" and 0.6 or 0
-- 	end)
-- end

-- local function constellation_func3(inst)
-- 	if inst.components.talents == nil then
-- 		return
--     end
-- 	inst.components.talents:SetExtensionModifier(3, inst, 3, "raiden_constellation3")
-- end

-- local function raiseattack(inst)   --这个是4命效果，非常驻所以写这里就可以了
-- 	local x, y, z = inst.Transform:GetWorldPosition()
-- 	local players = TheSim:FindEntities(x, y, z, 20, {"player"}, {"playerghost"})
-- 	for k, v in pairs(players) do
-- 		v.components.combat.external_atk_multipliers:SetModifier(inst, 0.3, "raiden_constellation4")
-- 		v:DoTaskInTime(10, function()
-- 			v.components.combat.external_atk_multipliers:RemoveModifier(inst, "raiden_constellation4")
-- 		end)
-- 	end
-- end

-- local function constellation_func5(inst)
-- 	if inst.components.talents == nil then
-- 		return
--     end
-- 	inst.components.talents:SetExtensionModifier(2, inst, 3, "raiden_constellation3")
-- end

-- local function decreasecd(inst, player)	  --这个是6命效果，非常驻所以写这里就可以了
-- 	player.components.elementalcaster:LeftTimeDelta("elementalburst", 1)
-- end

----------------------------------------------------------------------------
--天赋

--注意这是一个客机也运行的函数
local function ChargeSGFn(inst)
	-- if TheWorld.ismastersim then
	-- 	local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
	-- 	if weapon == nil then
	-- 		return "attack"
	-- 	end
	-- else
	-- 	local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
	-- 	if equip == nil then
	-- 		return "attack"
	-- 	end
	-- end
	-- return inst.burststate and "raiden_chargeattack" or "chargeattack"
	return "chargeattack"
end

--key和element
local function AttackkeyFn(inst, weapon, target)
    return inst.sg:HasStateTag("chargeattack") and "charge" or "normal"
end

local function StimuliFn(inst, weapon, targ, attackkey)
    return 1
end

--普通攻击倍率
local function NormalATKRateFn(inst, target)
    return TUNING.HUTAOSKILL_NORMALATK.ATK_DMG[inst.components.talents:GetTalentLevel(1)] 
end

--重击倍率
local function ChargeATKRateFn(inst, target)
    return TUNING.HUTAOSKILL_NORMALATK.CHARGE_ATK_DMG[inst.components.talents:GetTalentLevel(1)] 
end

--
local function CustomAttackFn(inst, target, instancemult, ischarge)
	-- if ischarge and inst.burststate then
	-- 	local x, y, z = target.Transform:GetWorldPosition()
	-- 	local ents = TheSim:FindEntities(x, y, z, 2.5, {"_combat"}, TUNING.RAIDEN_AREASKILLS_NOTAGS)
	-- 	local old_state = inst.components.combat.ignorehitrange
    --     inst.components.combat.ignorehitrange = true
    --     for k, v in pairs(ents) do 
    --         inst.components.combat:DoAttack(v, nil, nil, nil, instancemult) 
    --     end
    --     inst.components.combat.ignorehitrange = old_state
	-- else
	-- 	inst.components.combat:DoAttack(target, nil, nil, nil, instancemult)
	-- end
	inst.components.combat:DoAttack(target, nil, nil, nil, instancemult)
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

	-- inst:DoTaskInTime(14 * FRAMES, function(inst) giveeye(inst) end)

	-- inst.sg:GoToState("hutao_eleskill")
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

end

--固有天赋（充能转雷伤）
-- local function ElectroBonusChange(inst)
-- 	local rechargeover100 = inst.components.energyrecharge:GetEnergyRecharge() - 1
--     local electrobonus = math.max(0.4 * rechargeover100, 0)
-- 	inst.components.combat.external_electro_multipliers:SetModifier(inst, electrobonus, "all_talent1_base")
-- end

--固有天赋（开大回能）
-- local function RestoreEnergy(inst, data)
-- 	if data.attackkey ~= "elementalburst" or inst.gaincount > 5 or inst:HasTag("") then
--         return
-- 	end
--     local rechargeover100 = inst.components.energyrecharge:GetEnergyRecharge() - 1
--     local gainbonus = math.max(0.6 * rechargeover100, 0)
-- 	local x, y, z = inst.Transform:GetWorldPosition()
--     local players = TheSim:FindEntities(x, y, z, 20, {"player"})
-- 	for k, v in pairs(players) do
-- 		if v.components.energyrecharge then
-- 			v.components.energyrecharge:DoDelta((1 + gainbonus) * TUNING.RAIDENSKILL_ELEBURST.ENERGY_GAIN[inst.components.talents:GetTalentLevel(3)])
-- 		end
-- 		if inst.components.constellation:GetActivatedLevel() >= 6 and v.components.elementalcaster then
-- 			decreasecd(inst, v)
-- 		end
-- 	end
-- 	inst.gaincount = inst.gaincount + 1
-- end

--生活天赋（返还单手剑和长柄武器50%材料）
-- local function RefundIngredients(inst, data)
-- 	local recipe = data.recipe
-- 	if recipe == nil then
-- 		return
-- 	end
	
-- 	local issword_or_polearm = false
-- 	for k, v in pairs(TUNING.POLEARM_WEAPONS) do
-- 		if v == recipe.name then
-- 			issword_or_polearm = true
-- 			break
-- 		end
-- 	end
-- 	for k, v in pairs(TUNING.SWORD_WEAPONS) do
-- 		if v == recipe.name then
-- 			issword_or_polearm = true
-- 			break
-- 		end
-- 	end
-- 	if not issword_or_polearm then
-- 		return
-- 	end

-- 	for k, v in pairs(recipe.ingredients) do
-- 		if v.amount > 0 then
-- 			local amt = math.max(1, RoundBiasedUp(v.amount * inst.components.builder.ingredientmod))
-- 			local refund_amt = math.floor(amt / 2)
-- 			for i = 1, refund_amt do
-- 				local item = SpawnPrefab(v.type)
-- 				if item ~= nil then
-- 					inst.components.inventory:GiveItem(item)
-- 				end
-- 			end
-- 		end
-- 	end
-- end

--技能RPC

AddModRPCHandler("hutao", "elementalskill", elementalskillfn)
AddModRPCHandler("hutao", "elementalburst", elementalburstfn)

----------------------------------------------------------------------------

local common_postinit = function(inst) 

	inst.MiniMapEntity:SetIcon( "raiden_shogun.tex" )  --还没改
	
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
	-- inst.components.constellation:SetLevelFunc(2, constellation_func2)
	-- inst.components.constellation:SetLevelFunc(3, constellation_func3)
	-- inst.components.constellation:SetLevelFunc(5, constellation_func5)

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

	inst.components.combat.overrideattackkeyfn = AttackkeyFn
	inst.components.combat.overridestimulifn = StimuliFn
	
    --监听器
	-- inst:ListenForEvent("energyrecharge_change", ElectroBonusChange)
	-- inst:ListenForEvent("damagecalculated", RestoreEnergy)
	-- inst:ListenForEvent("builditem", RefundIngredients)
	inst:ListenForEvent("death", OnDeath)
	--
	
	--函数
	inst.OnDespawn = OnDespawn
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
    inst.OnNewSpawn = OnLoad

	inst.normalattackdmgratefn = NormalATKRateFn
	inst.chargeattackdmgratefn = ChargeATKRateFn

	inst.customattackfn = CustomAttackFn

	-- inst.elementalburst_exit = elementalburst_exitfn

	OnBecameHuman(inst)
    
end

return MakePlayerCharacter("hutao", prefabs, assets, common_postinit, master_postinit, start_inv)