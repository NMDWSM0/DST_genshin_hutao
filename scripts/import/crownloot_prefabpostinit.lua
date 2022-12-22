AddPrefabPostInitAny(function(inst)
    if not inst.components.lootdropper then
	    return
	end
	
    if not inst.components.combat then
	    return
	end
	
    local tags = {"dragonfly", "beequeen", "klaus", "alterguardian_phase3", "toadstool", --[["stalker_atrium",]] "minotaur", "crabking"}

    for k, v in pairs(tags) do
        if inst.prefab == v or inst:HasTag(v) then
            inst.components.lootdropper:AddChanceLoot("crown_of_insight", 1)
        end
    end
	
    if inst.prefab == "stalker_atrium" then
        local old_fn = inst.components.lootdropper.lootsetupfn
        local function new_fn(lootdropper)
            old_fn(lootdropper)
            if lootdropper.inst.atriumdecay then
                --lootdropper:AddChanceLoot("shadowheart", 1)
            else
                inst.components.lootdropper:AddChanceLoot("crown_of_insight", 1)
            end
        end
        inst.components.lootdropper:SetLootSetupFn(new_fn)
    end
end)