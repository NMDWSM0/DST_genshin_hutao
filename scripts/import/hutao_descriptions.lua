--有几个函数我要先给一下
local function plainfloatfunc(num)  --直接写,浮点
    return string.format("%.1f", num) 
end

local function plainintfunc(num)    --直接写,整数
    return string.format("%d", num) 
end
local plainfunc = plainfloatfunc

local function dmgmultfunc(num)  --攻击倍率通用模板函数
    return string.format("%.1f%%", 100 * num) 
end
local dmgmultfunc_sc = dmgmultfunc
local dmgmultfunc_en = dmgmultfunc

local function timefunc(num)  --时间通用模板函数
    return string.format("%.1f秒", num) 
end
local function timefunc_en(num)
    return string.format("%.1fs", num) 
end
local timefunc_sc = timefunc

STRINGS.CHARACTERS.HUTAO = require "speech_wilson"

if TUNING.LANGUAGE_GENSHIN_HUTAO == "sc" then
    --基本描述
    STRINGS.CHARACTER_TITLES.hutao = "雪霁梅香"
    STRINGS.CHARACTER_NAMES.hutao = "胡桃"
    STRINGS.CHARACTER_DESCRIPTIONS.hutao = "\n「往生堂」七十七代堂主\n年纪轻轻就已主掌璃月的葬仪事务"
    STRINGS.CHARACTER_QUOTES.hutao = "\"太阳出来我晒太阳，月亮出来我晒月亮咯~\""

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.HUTAO = 
    {
	    GENERIC = "那是胡桃!",
	    ATTACKER = "她看上去很...",
	    MURDERER = "杀人者!",
	    REVIVER = "她.",
	    GHOST = "她.",
    }

    STRINGS.NAMES.HUTAO = "胡桃"

    STRINGS.CHARACTER_BIOS.hutao = {
        { title = "生日", desc = "7月15日" },
        { title = "最喜爱食物", desc = "幽幽大行军" },
        { title = "神之眼", desc = "火" },
        { title = "命之座", desc = "引蝶座" },
    }

    --技能文本
    TUNING.HUTAO_CONSTELLATION_DESC = {
        titlename = {
            "赤团开时斜飞去",
            "最不安神晴又复雨",
            "逗留采血色",
            "伴君眠花房",
            "无可奈何燃花作香",
            "幽蝶能留一缕芳",
        },
        content = {
            "处于蝶引来生施加的彼岸蝶舞状态下时，胡桃的重击没有次数上限。",
            "血梅香造成的伤害提高，提高值相当于效果附加时胡桃生命值上限的100%。\n此外，安神秘法会为命中的敌人施加血梅香效果。",
            "蝶引来生的技能等级提升3级。\n至多提升至15级。",
            "处于胡桃自己施加的血梅香状态影响下的敌人被击败时，附近的队伍中所有角色的暴击率提高12%，持续15秒。",
            "安神秘法的技能等级提升3级。\n至多提升至15级。",
            "胡桃的生命值降至25%以下，或承受足以使她倒下的伤害时触发：\n此次伤害不会使胡桃倒下，并在接下来的10秒内，胡桃的所有元素抗性和物理抗性提高200%，暴击率提高100%，并极大地提高抗打断能力。\n这个效果在胡桃生命值为1时会自动触发。\n该效果每60秒只能触发一次。",
        },
    }

    TUNING.HUTAO_TALENTS_DESC = {
		titlename = {
            "普通攻击·往生秘传枪法",
            "蝶引来生",
            "安神秘法",
            "蝶隐之时",
            "血之灶火",
            "多多益善",
        },
        content = {
            {
                {str = "普通攻击", title = true},
                {str = "进行连续枪击。", title = false},
                {str = "重击", title = true},
                {str = "消耗一定体力，对前方的敌人造成伤害。", title = false},
            },
            {
                {str = "只有永不间断的烈焰可以洗净世间的不净之物。\n胡桃消耗一部分生命值，击退周围敌人，进入彼岸蝶舞状态。", title = false},
                {str = "彼岸蝶舞", title = true},
                {str = "·基于进入该状态时胡桃的生命值上限，提高胡桃的攻击力。通过这种方式获得的攻击力提升，不能超过胡桃基础攻击力的500%；\n·将攻击伤害转为火元素伤害，该元素转化无法被附魔覆盖；\n·重击会为命中的敌人施加血梅香效果；\n·提高胡桃的抗打断能力。", title = false},
                {str = "血梅香", title = true},
                {str = "处于血梅香状态下的敌人，每4秒会受到一次火元素伤害。这个伤害视为元素战技伤害。\n同一个目标身上只能存在一个血梅香效果，且只能被胡桃自己刷新持续时间。\n\n彼岸蝶舞将在持续时间结束、胡桃下场或倒下时解除。", title = false},
            },
            {
                {str = "挥动炽热的魂灵，造成大范围火元素伤害。\n命中敌人时，基于胡桃的生命值上限，恢复胡桃的生命值。这个效果最多对5个命中的敌人生效。\n如果技能命中时胡桃的生命值低于或等于50%，则造成更高的伤害与治疗量。", title = false},
            },
            {
                {str = "蝶引来生施加的彼岸蝶舞状态结束后，队伍中所有角色的暴击率提高12%，持续8秒。" , title = false},
            },
            {
                {str = "胡桃的生命值低于或等于50%时，获得33%火元素伤害加成。", title = false},
            },
            {
                {str = "收获烹饪食物时，有18%概率额外获得一个新鲜度为75%的同种料理。", title = false},
            },
			{
                {str = "?", title = false},
            },
        },
	}

    TUNING.HUTAOSKILL_NORMALATK_TEXT = 
    {
        ATK_DMG = {
            title = "普通攻击伤害", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "重击伤害", 
            formula = dmgmultfunc,
        },
    }

    TUNING.HUTAOSKILL_ELESKILL_TEXT = 
    {
        HP_COST = {
            title = "技能消耗",
            formula = function(num)  
                return string.format("%d%%当前生命值", 100 * num)
            end,
        },
        ATK_INCREASE = {
            title = "攻击力提高",
            formula = function(num)  
                return string.format("%.2f%%生命值上限", 100 * num)
            end,
        },
        BLD_BLSM_DMG = {
            title = "血梅香伤害",
            formula = dmgmultfunc,
        },
        BLD_BLSM_DURATION = {
            title = "血梅香持续时间",
            formula = timefunc,
        },
        DURATION = {
            title = "持续时间",
            formula = timefunc,
        },
        CD = {
            title = "冷却时间",
            formula = timefunc,
        },
    }

    TUNING.HUTAOSKILL_ELEBURST_TEXT = 
    {
        DMG = {
            title = "技能伤害", 
            formula = dmgmultfunc,
        },
        LOWHP_DMG = {
            title = "低血量时技能伤害", 
            formula = dmgmultfunc,
        },
        REGENERATION = {
            title = "技能治疗量", 
            formula = function(num)
                return string.format("%.2f%%生命值上限", 100 * num)
            end,
        },
        LOWHP_REGENERATION = {
            title = "低血量时技能治疗量", 
            formula = function(num)
                return string.format("%.2f%%生命值上限", 100 * num)
            end,
        },
        CD = {
            title = "冷却时间",
            formula = timefunc,
        },
        ENERGY = {
            title = "元素能量",
            formula = plainintfunc,
        },
    }

    --其它文本
    

    --食物相关
    -- STRINGS.NAMES.SPICE_AMAKUMO_FOOD = "酥酥麻麻的{food}"
    -- STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ATTACH_BUFF_AMAKUMOEATEN = "身上的雷元素变得暴躁起来了。"
    -- STRINGS.CHARACTERS.GENERIC.ANNOUNCE_DETACH_BUFF_AMAKUMOEATEN = "身上的雷元素又安分下来了。"

    -- STRINGS.CANNOTUSE_SPICE_AMAKUMO = "这个食物不可以用天云草实粉调味吧。"

    -- STRINGS.NAMES.SPICE_AMAKUMO = "天云草实粉"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPICE_AMAKUMO = "使用天云草实制成的调味品，闻起来有点雷电的味道。"
    -- STRINGS.RECIPE_DESC.SPICE_AMAKUMO = "提高雷元素的活跃性！"

    -- STRINGS.NAMES.TRICOLORDANGO = "三彩团子"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRICOLORDANGO = "软糯弹牙的点心，团子上的光泽犹如晨露落于朝花之上。"

    -- STRINGS.NAMES.DANGOMILK = "团子牛奶"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.DANGOMILK = "将粘稠的团子加入牛奶而制成的创意饮品，滋味甜美，口感绵密。"

    -- STRINGS.NAMES.RAINBOWASTER = "紫苑云霓"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAINBOWASTER = "别具一格的饮品，难怪书中生病了的将军大人喝完后也会打起精神。"

    -- STRINGS.NAMES.ADJUDICATETIME = "裁决之时"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.ADJUDICATETIME = "雷电将军的特色料理，传说落一滴于地，只令得周围数百里千年寸草不生。"

    --物品描述
    -- STRINGS.NAMES.ENGULFINGLIGHTNING = "薙草之稻光"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENGULFINGLIGHTNING = "用于「斩草」的薙刀。对向此物之军势,也会如苇草般倒下吧..."
    -- STRINGS.RECIPE_DESC.ENGULFINGLIGHTNING = "用于「斩草」的薙刀"
	-- TUNING.WEAPONEFFECT_ENGULFINGLIGHTNING = {
    --     "非时之梦·常世灶食\n·攻击力获得提升,提升程度相当于元素充能效率超出100%部分的28%,至多通过这种方式提升80%。施放元素爆发后的12秒内,元素充能效率提升30%。",
    --     "非时之梦·常世灶食\n·攻击力获得提升,提升程度相当于元素充能效率超出100%部分的35%,至多通过这种方式提升90%。施放元素爆发后的12秒内,元素充能效率提升35%。",
    --     "非时之梦·常世灶食\n·攻击力获得提升,提升程度相当于元素充能效率超出100%部分的42%,至多通过这种方式提升100%。施放元素爆发后的12秒内,元素充能效率提升40%。",
    --     "非时之梦·常世灶食\n·攻击力获得提升,提升程度相当于元素充能效率超出100%部分的49%,至多通过这种方式提升110%。施放元素爆发后的12秒内,元素充能效率提升45%。",
    --     "非时之梦·常世灶食\n·攻击力获得提升,提升程度相当于元素充能效率超出100%部分的56%,至多通过这种方式提升120%。施放元素爆发后的12秒内,元素充能效率提升50%。",
    -- }

    -- STRINGS.NAMES.FAVONIUSLANCE = "西风长枪"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.FAVONIUSLANCE = "西风骑士团的制式长枪。枪杆直挺，枪尖轻风流溢。"
    -- STRINGS.RECIPE_DESC.FAVONIUSLANCE = "西风骑士团的制式长枪"
	-- TUNING.WEAPONEFFECT_FAVONIUSLANCE = {
    --     "顺风而行\n·攻击造成暴击时，有60%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每12秒只能触发一次。",
    --     "顺风而行\n·攻击造成暴击时，有70%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每10.5秒只能触发一次。",
    --     "顺风而行\n·攻击造成暴击时，有80%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每9秒只能触发一次。",
    --     "顺风而行\n·攻击造成暴击时，有90%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每7.5秒只能触发一次。",
    --     "顺风而行\n·攻击造成暴击时，有100%的概率产生少量元素微粒。能为角色恢复6点元素能量。该效果每6秒只能触发一次。",
    -- }

    -- STRINGS.NAMES.THECATCH = "「渔获」"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.THECATCH = "在久远的过去，曾经闻名稻妻的大盗爱用的枪。"
    -- STRINGS.RECIPE_DESC.THECATCH = "在久远的过去，曾经闻名稻妻的大盗爱用的枪"
	-- TUNING.WEAPONEFFECT_THECATCH = {
    --     "船歌\n·元素爆发造成的伤害提升16%，元素爆发的暴击率提升6%。",
    --     "船歌\n·元素爆发造成的伤害提升20%，元素爆发的暴击率提升7.5%。",
    --     "船歌\n·元素爆发造成的伤害提升24%，元素爆发的暴击率提升9%。",
    --     "船歌\n·元素爆发造成的伤害提升28%，元素爆发的暴击率提升10.5%。",
    --     "船歌\n·元素爆发造成的伤害提升32%，元素爆发的暴击率提升12%。",
    -- }
    -- STRINGS.NAMES.AKO_SAKE_VESSEL = "赤穗酒枡"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.AKO_SAKE_VESSEL = "过去称霸清籁地方的赤穗百目鬼一众爱用的酒具"
    -- STRINGS.RECIPE_DESC.AKO_SAKE_VESSEL = "「渔获」专用的精炼道具"

    STRINGS.NAMES.HUTAO_CONSTELLATION_STAR = "胡桃的命星"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.HUTAO_CONSTELLATION_STAR = "胡桃的命之座激活素材"
    STRINGS.RECIPE_DESC.HUTAO_CONSTELLATION_STAR = "胡桃的命之座激活素材"

    STRINGS.NAMES.CROWN_OF_INSIGHT = "智识之冕"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROWN_OF_INSIGHT = "提升天赋所需的珍贵素材。"

    -- STRINGS.NAMES.BOOK_FIREPIT = "异世界厨神的烤制教学"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_FIREPIT = "有种神秘的力量，能教会人做饭，甚至还能感受到一丝雷元素？"
    -- STRINGS.RECIPE_DESC.BOOK_FIREPIT = "制作一本能教人烤制的书"

    -- STRINGS.NAMES.BOOK_COOKPOT = "异世界厨神的炉灶教学"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_COOKPOT = "有种神秘的力量，能教会人做饭，甚至还能感受到一丝雷元素？"
    -- STRINGS.RECIPE_DESC.BOOK_COOKPOT = "制作一本能教人使用炉灶的书"

    -- STRINGS.NAMES.BOOK_SPICER = "异世界厨神的香料教学"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_SPICER = "有种神秘的力量，能教会人做饭，甚至还能感受到一丝雷元素？"
    -- STRINGS.RECIPE_DESC.BOOK_SPICER = "制作一本能教人调和香料的书"

    -- STRINGS.NAMES.BOOK_GIVEEXP = "超级经验书"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_GIVEEXP = "阅读这本书，你将找回所有丢失的烹饪经验"

    -- STRINGS.NAMES.AMAKUMO_FRUIT = "天云草实"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMAKUMO_FRUIT = "天云草结成的果实，贴在耳畔能听见微弱的电流声。"

    -- STRINGS.NAMES.AMAKUMO_GRASS = "天云草"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMAKUMO_GRASS = "原本生长在天云峠的植物，不知为什么出现在了这里。"

else
    --基本描述
    STRINGS.CHARACTER_TITLES.hutao = "Fragrance in Thaw"
    STRINGS.CHARACTER_NAMES.hutao = "Hu Tao"
    STRINGS.CHARACTER_DESCRIPTIONS.hutao = "The 77th Director of the Wangsheng Funeral Parlor.\nShe took over the business at a rather young age."
    STRINGS.CHARACTER_QUOTES.hutao = "\"When the sun's out bathe in sunlight, bur when the moon's out bathe in moonlight.\""                  

    STRINGS.CHARACTERS.GENERIC.DESCRIBE.HUTAO = 
    {
	    GENERIC = "It's Hu Tao!",
	    ATTACKER = "That Hu Tao looks shifty...",
	    MURDERER = "Murderer!",
	    REVIVER = "Hu Tao, friend of ghosts.",
	    GHOST = "Hu Tao could use a heart.",
    }

    STRINGS.NAMES.HUTAO = "Hu Tao"

    STRINGS.CHARACTER_BIOS.hutao = {
        { title = "Birthday", desc = "July 15" },
        { title = "Favorite Food", desc = "Ghostly March" },
        { title = "Vision", desc = "Pyro" },
        { title = "Constellation", desc = "Papilio Charontis" },
    }

    --技能文本
    TUNING.HUTAO_CONSTELLATION_DESC = {
        titlename = {
            "Crimson Bouquet",
            "Ominous Rainfall",
            "Lingering Carmine",
            "Garden of Eternal Rest",
            "Floral Incense",
            "Butterfly’s Embrace",
        },
        content = {
            "While in a Paramita Papilio state activated by Guide to Afterlife, Hu Tao’s Charge Attacks do not have a max limit.",
            "Increases the Blood Blossom DMG by an amount equal to 10% of Hu Tao’s Max HP at the time the effect is applied.\nAdditionally, Spirit Soother will also apply the Blood Blossom effect.",
            "Increases the Level of Guide to Afterlife by 3.\nMaximum upgrade level is 15.",
            "Upon defeating an enemy affected by a Blood Blossom that Hu Tao applied herself, all nearby allies in the party will have their CRIT Rate increased by 12% for 15s.",
            "Increases the Level of Spirit Soother by 3.\nMaximum upgrade level is 15.",
            "Triggers when Hu Tao’s HP drops below 25%, or when she suffers a lethal strike:\nHu Tao will not fall as a result of the DMG sustained. Additionally, for the next 10s, her All Elemental and Physical RES is increased by 200%, her CRIT Rate is increased by 100%, and her resistance to interruption is greatly increased.\nThis effect triggers automatically when Hu Tao has 1 HP left.\nCan only occur once every 60s.",
        },
    }

    TUNING.HUTAO_TALENTS_DESC = {
		titlename = {
            "Normal Attack:\nSecret Spear of Wangsheng",
            "Guide to Afterlife",
            "Spirit Soother",
            "Flutter By",
            "Sanguine Rouge",
            "The More the Merrier",
        },
        content = {
            {
                {str = "Normal Attack", title = true},
                {str = "Performs consecutive spear strikes.", title = false},
                {str = "Charged Attack", title = true},
                {str = "Perform a forward attack, damaging opponents in front of her.", title = false},
            },
            {
                {str = "Only an unwavering flame can cleanse the impurities of this world.\nHu Tao consumes a set portion of her HP to knock the surrounding enemies back and enter the Paramita Papilio state.", title = false},
                {str = "Paramita Papilio", title = true},
                {str = "·Increases Hu Tao’s ATK based on her Max HP at the time of entering this state. ATK Bonus gained this way cannot exceed 500% of Hu Tao’s Base ATK.\n·Converts attack DMG to Pyro DMG, which cannot be overridden by any other elemental infusion.\n·Charged Attacks apply the Blood Blossom effect to the enemies hit.\n·Increases Hu Tao’s resistance to interruption.", title = false},
                {str = "Blood Blossom", title = true},
                {str = "Enemies affected by Blood Blossom will take Pyro DMG every 4s. This DMG is considered Elemental Skill DMG.\nEach enemy can be affected by only one Blood Blossom effect at a time, and its duration may only be refreshed by Hu Tao herself.\n\nParamita Papilio ends when its duration is over, or Hu Tao has left the battlefield or fallen.", title = false},
            },
            {
                {str = "Commands a blazing spirit to attack, dealing Pyro DMG in a large AoE.\nUpon striking the enemy, regenerates a percentage of Hu Tao’s Max HP. This effect can be triggered up to 5 times, based on the number of enemies hit.\nIf Hu Tao’s HP is below or equal to 50% when the enemy is hit, both the DMG and HP Regeneration are increased.", title = false},
            },
            {
                {str = "When a Paramita Papilio state activated by Guide to Afterlife ends, all allies in the party will have their CRIT Rate increased by 12% for 8s." , title = false},
            },
            {
                {str = "When Hu Tao’s HP is equal to or less than 50%, her Pyro DMG Bonus is increased by 33%.", title = false},
            },
            {
                {str = "When Hu Tao cooks a dish, she has a 18% chance to receive an additional dish which has 75% perish time remained of the same type.", title = false},
            },
            {
                {str = "?", title = false},
            },
        },
	}

    TUNING.HUTAOSKILL_NORMALATK_TEXT = 
    {
        ATK_DMG = {
            title = "Normal Attack DMG", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "Charged Attack DMG", 
            formula = dmgmultfunc,
        },
    }

    TUNING.HUTAOSKILL_ELESKILL_TEXT = 
    {
        HP_COST = {
            title = "Activation Cost",
            formula = function(num)  
                return string.format("%d%%Current HP", 100 * num)
            end,
        },
        ATK_INCREASE = {
            title = "ATK Increase",
            formula = function(num)  
                return string.format("%.2f%%Max HP", 100 * num)
            end,
        },
        BLD_BLSM_DMG = {
            title = "Blood Blossom DMG",
            formula = dmgmultfunc,
        },
        BLD_BLSM_DURATION = {
            title = "Blood Blossom Duration",
            formula = timefunc_en,
        },
        DURATION = {
            title = "Duration",
            formula = timefunc_en,
        },
        CD = {
            title = "CD",
            formula = timefunc_en,
        },
    }

    TUNING.HUTAOSKILL_ELEBURST_TEXT = 
    {
        DMG = {
            title = "Skill DMG", 
            formula = dmgmultfunc,
        },
        LOWHP_DMG = {
            title = "Low HP Skill DMG", 
            formula = dmgmultfunc,
        },
        REGENERATION = {
            title = "Skill HP Regeneration", 
            formula = function(num)
                return string.format("%.2f%%Max HP", 100 * num)
            end,
        },
        LOWHP_REGENERATION = {
            title = "Low HP Skill\nRegeneration", 
            formula = function(num)
                return string.format("%.2f%%Max HP", 100 * num)
            end,
        },
        CD = {
            title = "CD",
            formula = timefunc_en,
        },
        ENERGY = {
            title = "Energy Cost",
            formula = plainintfunc,
        },
    }


    --其它文本
    

    --食物相关
    -- STRINGS.NAMES.SPICE_AMAKUMO_FOOD = "Tingling {food}"
    -- STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ATTACH_BUFF_AMAKUMOEATEN = "I can feel Electro element becoming active."
    -- STRINGS.CHARACTERS.GENERIC.ANNOUNCE_DETACH_BUFF_AMAKUMOEATEN = "Electro element returns stable now."

    -- STRINGS.NAMES.SPICE_AMAKUMO = "Amakumo Spice"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPICE_AMAKUMO = "Spice made of Amakumo fruit.You can even smell Electro element."
    -- STRINGS.RECIPE_DESC.SPICE_AMAKUMO = "Make Electro element more active!"

    -- STRINGS.CANNOTUSE_SPICE_AMAKUMO = "This food cannot spiced by Amakumo Spice."

    -- STRINGS.NAMES.TRICOLORDANGO = "Tricolor Dango"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRICOLORDANGO = "A soft,glutinous snack.The luster of this dango is like the falling morning dew,and it gives off the feeling of lush flowres and branches."

    -- STRINGS.NAMES.DANGOMILK = "Dango Milk"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.DANGOMILK = "A creative snack made by adding sticky dango to milk.It is sweet and have a dence mouthfeel."

    -- STRINGS.NAMES.RAINBOWASTER = "Rainbow Aster"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAINBOWASTER = "A unique drink.It is utterly unsurprising that the ill Shogun in the tale war re-energized by the merits of this drink alone."

    -- STRINGS.NAMES.ADJUDICATETIME = "Adjudicate Time"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.ADJUDICATETIME = "Raiden shogun's specialty.It is said that if dropped on the ground then it will be barren hundred miles around for thousands of years."

    --物品描述
    -- STRINGS.NAMES.ENGULFINGLIGHTNING = "Engulfing Lightning"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENGULFINGLIGHTNING = "A naginata used to \"cut grass.\" Any army that stands before this weapon will probably be likewise cut down..."
    -- STRINGS.RECIPE_DESC.ENGULFINGLIGHTNING = "A naginata used to \"cut grass.\""
	-- TUNING.WEAPONEFFECT_ENGULFINGLIGHTNING = {
    --     "Timeless Dream:Eternal Stove\n·ATK increased by 28% of Energy Recharge over the base 100%.You can gain a maximum bonus of 80% ATK.Gain 30% Energy Recharge for 12s after using an Elemental Burst.",
    --     "Timeless Dream:Eternal Stove\n·ATK increased by 35% of Energy Recharge over the base 100%.You can gain a maximum bonus of 90% ATK.Gain 35% Energy Recharge for 12s after using an Elemental Burst.",
    --     "Timeless Dream:Eternal Stove\n·ATK increased by 42% of Energy Recharge over the base 100%.You can gain a maximum bonus of 100% ATK.Gain 40% Energy Recharge for 12s after using an Elemental Burst.",
    --     "Timeless Dream:Eternal Stove\n·ATK increased by 49% of Energy Recharge over the base 100%.You can gain a maximum bonus of 110% ATK.Gain 45% Energy Recharge for 12s after using an Elemental Burst.",
    --     "Timeless Dream:Eternal Stove\n·ATK increased by 56% of Energy Recharge over the base 100%.You can gain a maximum bonus of 120% ATK.Gain 50% Energy Recharge for 12s after using an Elemental Burst.",
    -- }

    -- STRINGS.NAMES.FAVONIUSLANCE = "Favonius Lance"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.FAVONIUSLANCE = "A polearm made in the style of the Knights of Favonius. Its shaft is straight, and its tip flows lightlty like the wind."
    -- STRINGS.RECIPE_DESC.FAVONIUSLANCE = "A polearm made in the style of the Knights of Favonius"
	-- TUNING.WEAPONEFFECT_FAVONIUSLANCE = {
    --     "Windfall\n·CRIT Hits have a 60% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 12s.",
    --     "Windfall\n·CRIT Hits have a 70% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 10.5s.",
    --     "Windfall\n·CRIT Hits have a 80% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 9s.",
    --     "Windfall\n·CRIT Hits have a 90% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 7.5s.",
    --     "Windfall\n·CRIT Hits have a 100% chance to generate a small amount of Elemental Particles, which will regenerate 6 Energy for the character.Can only occur once every 6s.",
    -- }

    -- STRINGS.NAMES.THECATCH = "\"The Catch\""
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.THECATCH = "In the distant past, this was the beloved spear of a famed Inazuman bandit."
    -- STRINGS.RECIPE_DESC.THECATCH = "The beloved spear of a famed Inazuman bandit"
	-- TUNING.WEAPONEFFECT_THECATCH = {
    --     "Shanty\n·Increases Elemental Burst DMG by 16% and Elemental Burst CRIT Rate by 6%.",
    --     "Shanty\n·Increases Elemental Burst DMG by 20% and Elemental Burst CRIT Rate by 7.5%.",
    --     "Shanty\n·Increases Elemental Burst DMG by 24% and Elemental Burst CRIT Rate by 9%.",
    --     "Shanty\n·Increases Elemental Burst DMG by 28% and Elemental Burst CRIT Rate by 10.5%.",
    --     "Shanty\n·Increases Elemental Burst DMG by 32% and Elemental Burst CRIT Rate by 12%.",
    -- }
    -- STRINGS.NAMES.AKO_SAKE_VESSEL = "Ako’s Sake Vessel"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.AKO_SAKE_VESSEL = "This was the favored liquor vessel of Ako Domeki,who once ruled over the Seirai region."
    -- STRINGS.RECIPE_DESC.AKO_SAKE_VESSEL = "Specialized refinement material for “The Catch.”"

    STRINGS.NAMES.HUTAO_CONSTELLATION_STAR = "Hu Tao's Stella Fortuna"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.HUTAO_CONSTELLATION_STAR = "Hu Tao's Constellation Activation Material."
    STRINGS.RECIPE_DESC.HUTAO_CONSTELLATION_STAR = "Hu Tao's Constellation Activation Material"

    STRINGS.NAMES.CROWN_OF_INSIGHT = "Crown of Insight"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROWN_OF_INSIGHT = "A precious Talent Level-Up material."

    -- STRINGS.NAMES.BOOK_FIREPIT = "Course of Roasting"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_FIREPIT = "Have a miraculous power.Teach readers cooking.And can even feel Electro element?"
    -- STRINGS.RECIPE_DESC.BOOK_FIREPIT = "Craft a book to teach readers roasting"

    -- STRINGS.NAMES.BOOK_COOKPOT = "Course of Cooking"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_COOKPOT = "Have a miraculous power.Teach readers cooking.And can even feel Electro element?"
    -- STRINGS.RECIPE_DESC.BOOK_COOKPOT = "Craft a book to teach readers cooking"

    -- STRINGS.NAMES.BOOK_SPICER = "Course of Spicing"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_SPICER = "Have a miraculous power.Teach readers cooking.And can even feel Electro element?"
    -- STRINGS.RECIPE_DESC.BOOK_SPICER = "Craft a book to teach readers spicing"

    -- STRINGS.NAMES.BOOK_GIVEEXP = "Super EXP Book"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_GIVEEXP = "reading this book enbales you to master all the cooking experience you've lost"

    -- STRINGS.NAMES.AMAKUMO_FRUIT = "Amakumo Fruit"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMAKUMO_FRUIT = "The fruit of the Amakumo Grass.Can hear it crackling with a tiny current if hold it up to the ear."

    -- STRINGS.NAMES.AMAKUMO_GRASS = "Amakumo Grass"
    -- STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMAKUMO_GRASS = "A plant originally grows in Amakumo Peak.It appears here due to some unknown reasons."

end