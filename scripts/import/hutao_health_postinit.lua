AddComponentPostInit("health", function(self, inst)
    local old_SetVal = self.SetVal
    function self:SetVal(val, ...)
        if self.inst:HasTag("hutao") and not self:IsDead() and self.inst.components.constellation and self.inst.components.constellation:GetActivatedLevel() == 6 then
            if (val < self.currenthealth and val < self.maxhealth * 0.25) or val <= 1 then
                if self.inst:constell6_available() then
                    val = math.max(val, 1.1)  --此次伤害不会使其倒下，至于效果写在constell6_available里面
                end
            end
        end
        return old_SetVal(self, val, ...)
    end
end)