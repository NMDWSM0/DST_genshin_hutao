----------------------------------------------------
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

TUNING.AMAKUMO_GRASS_BGRATE = 0.008
TUNING.AMAKUMO_GRASS_NUMBER = 3
local FILTERS = {GROUND.ROAD, GROUND.WOODFLOOR, GROUND.CARPET, GROUND.CHECKER}

--在沼泽地刷新
local MarshBGRooms = {
	"BGMarsh",
}
local MarshRooms = {
	"Marsh",
	"SpiderMarsh",
}

for k, v in pairs(MarshBGRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.amakumo_grass = TUNING.AMAKUMO_GRASS_BGRATE
	end)
end
for k, v in pairs(MarshRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.amakumo_grass = TUNING.AMAKUMO_GRASS_NUMBER
	end)
end
terrain.filter.amakumo_grass = FILTERS