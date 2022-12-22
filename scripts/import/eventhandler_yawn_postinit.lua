local function newyawneventhandler(sg)
    if sg.events["yawn"] == nil then
	    return
    end

	local old_yawnfn = sg.events["yawn"].fn
	sg.events["yawn"].fn = function(inst, data)
	    if inst.sg:HasStateTag("noyawn") then
            return
        end
        old_yawnfn(inst, data)
	end
end

local function newyawneventhandler_client(sg)
    if sg.events["yawn"] == nil then
	    return
    end

	local old_yawnfn = sg.events["yawn"].fn
	sg.events["yawn"].fn = function(inst, data)
	    if inst.sg:HasStateTag("noyawn") then
            return
        end
        old_yawnfn(inst, data)
	end
end

AddStategraphPostInit("wilson", newyawneventhandler)
AddStategraphPostInit("wilson_client", newyawneventhandler_client)