
--非常非常感谢“能力勋章”的作者整理的这一份新版制作栏的详细内容
--[[
{
	name,--配方名，一般情况下和需要合成的道具同名
	ingredients,--配方
	tab,--合成栏(已废弃)
	level,--解锁科技
	placer,--建筑类科技放置时显示的贴图、占位等/也可以配List用于添加更多额外参数，比如不可分解{no_deconstruction = true}
	min_spacing,--最小间距，不填默认为3.2
	nounlock,--不解锁配方，只能在满足科技条件的情况下制作(分类默认都算专属科技站,不需要额外添加了)
	numtogive,--一次性制作的数量，不填默认为1
	builder_tag,--制作者需要拥有的标签
	atlas,--需要用到的图集文件(.xml)，不填默认用images/name.xml
	image,--物品贴图(.tex)，不填默认用name.tex
	testfn,--尝试放下物品时的函数，可用于判断坐标点是否符合预期
	product,--实际合成道具，不填默认取name
	build_mode,--建造模式,水上还是陆地(默认为陆地BUILDMODE.LAND,水上为BUILDMODE.WATER)
	build_distance,--建造距离(玩家距离建造点的距离)
	filters,--制作栏分类列表，格式参考{"SPECIAL_EVENT","CHARACTER"}
	
	--扩展字段
	placer,--建筑类科技放置时显示的贴图、占位等
	filter,--制作栏分类
	description,--覆盖原来的配方描述
	canbuild,--制作物品是否满足条件的回调函数,支持参数(recipe, self.inst, pt, rotation),return 结果,原因
	sg_state,--自定义制作物品的动作(比如吹气球就可以调用吹的动作)
	no_deconstruction,--填true则不可分解(也可以用function)
	require_special_event,--特殊活动(比如冬季盛宴限定之类的)
	dropitem,--制作后直接掉落物品
	actionstr,--把"制作"改成其他的文字
	manufactured,--填true则表示是用制作站制作的，而不是用builder组件来制作(比如万圣节的药水台就是用这个)
}

-----------分类------------
--FAVORITES--收藏
--CRAFTING_STATION--科技站专属
--SPECIAL_EVENT--特殊节日
--MODS--模组物品(所有非科技站解锁的mod物品会自动添加这个标签)
	
--CHARACTER--人物专属
--TOOLS--工具
--LIGHT--光源
--PROTOTYPERS--科技
--REFINE--精炼
--WEAPONS--武器
--ARMOUR--盔甲
--CLOTHING--服装
--RESTORATION--治疗
--MAGIC--魔法
--DECOR--装饰

--STRUCTURES--建筑
--CONTAINERS--容器
--COOKING--烹饪
--GARDENING--食物、种植
--FISHING--钓鱼
--SEAFARING--航海
--RIDING--骑乘
--WINTER--保暖道具
--SUMMER--避暑道具
--RAIN--雨具
--EVERYTHING--所有
--]]

local Recipes = {

    ---------------------------武器-----------------------------
	

    ---------------------------精炼-----------------------------
    --命之座
	--[[
    {
        name = "raiden_constellation_star",
        ingredients = 
        {
			Ingredient("opalpreciousgem", 1),
            Ingredient("purplegem", 1),
            Ingredient("amakumo_fruit", 10, "images/inventoryimages/amakumo_fruit.xml")
        },
        level = TECH.SCIENCE_TWO,
        atlas = "images/inventoryimages/raiden_constellation_star.xml",
        image = "raiden_constellation_star.tex",
        filters = { "REFINE", "CHARACTER" },
    },]]

}


for k, data in pairs(Recipes) do
    AddRecipe2(data.name, data.ingredients, data.level, {
        min_spacing = data.min_spacing,
        nounlock = data.nounlock,
        numtogive = data.numtogive,
        builder_tag = data.builder_tag,
        atlas = data.atlas,
        image = data.image,
        testfn = data.testfn,
        product = data.product,
        build_mode = data.build_mode,
        build_distance = data.build_distance,

        placer = data.placer,
        filter = data.filter,
        description = data.description,
        canbuild = data.canbuild,
        sg_state = data.sg_state,
        no_deconstruction = data.no_deconstruction,
        require_special_event = data.require_special_event,
        dropitem = data.dropitem,
        actionstr = data.actionstr,
        manufactured = data.manufactured,
    }, data.filters)
end