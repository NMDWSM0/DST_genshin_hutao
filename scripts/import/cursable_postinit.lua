AddComponentPostInit("cursable", function (self)
    local old_IsCursable = self.IsCursable

    function self:IsCursable(item)
        local inst = self.inst
        if inst.sg and inst.sg:HasStateTag("nocurse") then
            return false
        end
        return old_IsCursable(self, item)
    end

    local old_ApplyCurse = self.ApplyCurse
    function self:ApplyCurse(item, curse)
        if not self:IsCursable(item) then
            return
        end
        old_ApplyCurse(self, item, curse)
    end
end)