local assets =
{
    Asset("ANIM", "anim/hutao_blood_blossom.zip")
}

local function doattack(inst)
    if inst.target == nil or inst.owner == nil or not inst.target.components.combat or not inst.owner:HasTag("hutao") or inst.owner:HasTag("playerghost") then
        if inst.task then
            inst.task:Cancel()
        end
        inst.task = nil
        inst:Remove()
        return
    end

    local mult = TUNING.HUTAOSKILL_ELESKILL.BLD_BLSM_DMG[inst.owner.components.talents:GetTalentLevel(2)]
    local old_state = inst.owner.components.combat.ignorehitrange
	inst.owner.components.combat.ignorehitrange = true
    inst.owner.components.combat:DoAttack(inst.target, nil, nil, 1, mult, nil, nil, "elementalskill")
    inst.owner.components.combat.ignorehitrange = old_state
end

local function OnTimerDone(inst, data)
    if data and data.name == "hutao_blood_blossom" then
        if inst.task then
            inst.task:Cancel()
        end
        inst.task = nil
        inst:Remove()
    end
end

local function AttachTarget(inst, target, owner)
    if target == nil or owner == nil or not target.components.combat or not owner:HasTag("hutao") or owner:HasTag("playerghost") then
        return
    end
    if inst.target == target then
        inst.components.timer:SetTimeLeft("hutao_blood_blossom", TUNING.HUTAOSKILL_ELESKILL.BLD_BLSM_DURATION)
        return
    end
    inst.owner = owner
    inst.target = target

    inst.components.timer:StartTimer("hutao_blood_blossom", TUNING.HUTAOSKILL_ELESKILL.BLD_BLSM_DURATION)
    inst.task = inst:DoPeriodicTask(4, doattack)

    if target.components.combat and target.components.combat.hiteffectsymbol ~= nil and target.AnimState:BuildHasSymbol(target.components.combat.hiteffectsymbol) then
        target:AddChild(inst)
        inst.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
    else
        target:AddChild(inst)
        inst.Transform:SetPosition(0, 1.8, 0)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("hutao_blood_blossom")
    inst.AnimState:SetBuild("hutao_blood_blossom")
    inst.AnimState:PlayAnimation("anim", true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("NOBLOCK")
    inst:AddTag("hutao_blood_blossom")

    inst.entity:SetPristine()
    inst.persist = false

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("timer")

    inst.owner = nil
    inst.target = nil

    inst.AttachTarget = AttachTarget

    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end


return Prefab("hutao_blood_blossom", fn, assets)