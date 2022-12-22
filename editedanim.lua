-- 文件来源于EditedAnim，创意工坊 https://steamcommunity.com/sharedfiles/filedetails/?id=2384660166
-- 增加这个是因为本MOD需要EditedAnim调整头发的图层顺序
-- modimport引用这个文件 可以自动处理和 EditedAnim的依赖关系
-- 请自己拷贝走然后修改
-- 专服不需要

if GLOBAL.TheNet:IsDedicated() then return end

local PopupDialogScreen = require "screens/redux/popupdialog"
local mod_name = IsRail() and 'workshop-2199027653598529357' or 'workshop-2384660166'  --EditedAnim
local mod_name2 = 'workshop-2578151314'  --Element Reaction

local namestext = 
{
    'EditedAnims和Element Reaction',
    'EditedAnims',
    'Element Reaction',
}

local function PushSubscribeDialog(warning_type)
    if warning_type == 1 then
        TheSim:SubscribeToMod(mod_name)
        TheSim:SubscribeToMod(mod_name2)
    elseif warning_type == 2 then
        TheSim:SubscribeToMod(mod_name)
    elseif warning_type == 3 then
        TheSim:SubscribeToMod(mod_name2)
    else
        return
    end
    
    local screen = PopupDialogScreen(modinfo.name .. ":提示",
                                     '已尝试自动订阅 :'..namestext[warning_type]..' \n请稍后到mods列表里查看并勾选\n请订阅mod后,不要忘记开启mod!!!\n如果是服务器请联系服主开启mod\n如果订阅失败可到工坊手动订阅',
                                     {
        {text = '确定并退出', cb = function() GLOBAL.DoRestart(true) end}
    })
    TheFrontEnd:PushScreen(screen)                                    
end

local function PushPopupDialog(warning_type)
    local function doclose() TheFrontEnd:PopScreen(screen) end
    local screen = PopupDialogScreen(modinfo.name .. ":提示",
                                     '本模组需要依赖mods :'..namestext[warning_type]..' \n请订阅mod并到mod界面开启后再试\n请订阅mod后,不要忘记开启mod!!!',
                                     {
        {
            text = '自动订阅',
            cb = function()
                doclose()
                PushSubscribeDialog(warning_type)
            end
        },
        {text = '确认并退出', cb = function() GLOBAL.DoRestart(true) end}

    })
    TheFrontEnd:PushScreen(screen)                             
end

--

AddSimPostInit(function()
    local warning_type = 0
    if not GLOBAL.TUNING.EDITED_ANIM then
        warning_type = 2
        if GLOBAL.TUNING.LANGUAGE_GENSHIN_CORE == nil then
            warning_type = 1
        end
    elseif GLOBAL.TUNING.LANGUAGE_GENSHIN_CORE == nil then
        warning_type = 3
    end
    
    if warning_type == 0 then -- 存在则不处理
        return
    end
    TheWorld:DoTaskInTime(0.1, function ()
        PushPopupDialog(warning_type)
        SetServerPaused(true)
    end)
end)
