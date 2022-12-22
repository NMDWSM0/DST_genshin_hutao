local assets =
{
	Asset( "ANIM", "anim/raiden_shogun.zip" ),
	Asset( "ANIM", "anim/ghost_raiden_build.zip" ),
}

local skins =
{
	normal_skin = "raiden_shogun",
	ghost_skin = "ghost_raiden_build",
}

local base_prefab = "raiden_shogun"

local tags = {"BASE", "RAIDEN_SHOGUN", "CHARACTER"}

return CreatePrefabSkin("raiden_shogun_none",
{
	base_prefab = base_prefab,
	skins = skins,
	assets = assets,
	skin_tags = tags,
	
	build_name_override = "raiden_shogun",
	rarity = "Character",

	skip_item_gen = true,
	skip_giftable_gen = true,
})