
function ReplaceGridItem(index, newitem)
	if ClientBackpack:getGridNum(index) <= 1 then
		ClientBackpack:replaceItem(index, newitem, 1, -1)
	else
		ClientBackpack:removeItem(index, 1)
		ClientBackpack:addItem(newitem, 1)
	end
end

--使用空桶
function BucketEmpty_OnUse(x,y,z,dir)
	local hasliquid = false
	local nx = 0
	local ny = 0
	local nz = 0
	hasliquid, nx, ny, nz = CurMainPlayer:getBlockOperate():pickLiquid(nx,ny,nz)
	if hasliquid then
		id = CurWorld:getBlockID(nx,ny,nz)
		newitem = 0
		if id == 3 then newitem = 1051
		elseif id == 5 then newitem = 1052 end

		if newitem > 0 then
			index = CurMainPlayer:getCurShortcut() + SHORTCUT_START_INDEX
			if not CurWorld:isCreativeMode() then
				ReplaceGridItem(index, newitem);
			end
			CurWorld:setBlockAll(nx,ny,nz, 0, 0)
		end
	end
	return true
end

--使用水桶
function Bucket_OnUse(x, y, z, dir, fluid_id)
	x1,y1,z1 = NeighborBlock(x,y,z,dir)
	solid = CurWorld:isBlockSolid(x1,y1,z1)
	liquid = CurWorld:isBlockLiquid(x1,y1,z1)

	if CurWorld:getBlockID(x1,y1,z1)==0 or not solid then
		if not solid and not liquid then
			CurWorld:destroyBlock(x1, y1, z1, true)
		end

		CurWorld:setBlockAll(x1,y1,z1, fluid_id, 0)

		index = CurMainPlayer:getCurShortcut() + SHORTCUT_START_INDEX
		if not CurWorld:isCreativeMode() then
			ReplaceGridItem(index, 1050);
		end
		return true
	end
	return false
end

function BucketWater_OnUse(x, y, z, dir)
	if CurWorld:getCurMapID() > 0 then
		GameEventQue:postInfoTips(5)
		return false
	end
	return Bucket_OnUse(x,y,z,dir, BLOCK_FLOW_WATER)
end

--使用岩浆桶
function BucketLava_OnUse(x, y, z, dir)
	return Bucket_OnUse(x,y,z,dir, BLOCK_FLOW_LAVA)
end


--使用打火石
function FlintSteel_OnUse(x, y, z, dir)
	x1,y1,z1 = NeighborBlock(x,y,z,dir)
	if CurWorld:getBlockID(x,y,z) == BLOCK_PORTAL_FRAME then
		if CurWorld:tryCreatePortal(x1,y1,z1, BLOCK_PORTAL) then return true end
	end

	if CurWorld:getBlockID(x1,y1,z1) == 0 then
		CurWorld:setBlockAll(x1,y1,z1, 500, 0)
		return true
	end
	return false
end

--使用睡莲
function LilyPad_OnUse(x, y, z, dir)
	local hasliquid = false
	local nx = 0
	local ny = 0
	local nz = 0
	hasliquid, nx, ny, nz = CurMainPlayer:getBlockOperate():pickLiquid(nx,ny,nz)
	if hasliquid and CurWorld:canPlaceBlockAt(nx,ny+1,nz, 234) then
		CurWorld:setBlockAll(nx,ny+1,nz, 234, DIR_NEG_Y)
		CurMainPlayer:shortcutItemUsed()
		return true
	end
	return false
end

--使用锄头
function Hoe_OnUse(x, y, z, dir)
	id = CurWorld:getBlockID(x,y,z)
	if id==BLOCK_DIRT or id==BLOCK_GRASS then
		if dir~=DIR_NEG_Y and CurWorld:getBlockID(x,y+1,z)==0 then
			CurWorld:setBlockAll(x, y, z, BLOCK_FARMLAND, 0)
			ClientCurGame:getMainPlayer():addCurToolDuration(-1)
			return true
		end
	end
	return false
end

--使用甘蔗
function Reeds_OnUse(x, y, z, dir)
	if dir ~= DIR_POS_Y then return end

	if CurWorld:canPlaceBlockAt(x,y+1,z, 228) then
		CurWorld:setBlockAll(x, y+1, z, 228, 0)
		CurMainPlayer:shortcutItemUsed()
		return true
	end
	return false
end

--公用函数, 使用一般的种子
function Seed_OnUse(x, y, z, dir, plantid)
	if dir==DIR_POS_Y and CurWorld:canPlaceBlockAt(x,y+1,z, plantid) then
		CurWorld:setBlockAll(x,y+1,z, plantid, 0)
		CurMainPlayer:shortcutItemUsed()
		return true
	end
	return false
end

--使用小麦种子
function WheatSeed_OnUse(x, y, z, dir)
	return Seed_OnUse(x,y,z,dir, 229)
end

--使用胡萝卜
function Carrots_OnUse(x,y,z,dir)
	return Seed_OnUse(x,y,z,dir, 236)
end

--使用马铃薯
function Potato_OnUse(x,y,z,dir)
	return Seed_OnUse(x,y,z,dir, 241)
end

--使用南瓜种子
function PumpkinSeed_OnUse(x, y, z, dir)
	return Seed_OnUse(x,y,z,dir, 231)
end

--使用西瓜种子
function MelonSeed_OnUse(x, y, z, dir)
	return Seed_OnUse(x,y,z,dir, 240)
end

--使用可可果
function Cocoa_OnUse(x, y, z, dir)
	if dir==DIR_NEG_Y or dir==DIR_POS_Y then return false end
	if CurWorld:getBlockID(x,y,z) ~= BLOCK_WOOD_JUNGLE then return false end

	x1, y1, z1 = NeighborBlock(x,y,z,dir)
	if CurWorld:canPlaceBlockAt(x1,y1,z1, 237) then
		newdir = ReverseDirection(dir)
		CurWorld:setBlockAll(x1,y1,z1, 237, newdir)
		CurMainPlayer:shortcutItemUsed()
		return true
	end
	return false
end

--使用骨粉
function BonePowder_OnUse(x,y,z,dir)
	if CurWorld:fertilizeBlock(x,y,z, 1500) then
		CurMainPlayer:shortcutItemUsed()
	end
	return true

	--[[
	CurMainPlayer:shortcutItemUsed()
	id = CurWorld:getBlockID(x,y,z)
	if id==226 or id==227 then
		if RollPoint(10) then
			if id == 226 then PlaceBigMushroomBrown(x,y,z, math.random(5,7), 316, 317, 318)
			else PlaceBigMushroom(x,y,z, math.random(5,7), 325, 326, 327) end
		end
	elseif id>=212 and id<=217 then
		bdata = CurWorld:getBlockData(x,y,z) + math.random(2,4)
		if bdata >= 7 then
			CurWorld:placeTree(x, y, z, id-212+200)
		else
			CurWorld:setBlockData(x,y,z, bdata)
		end
	elseif id==228 or id==229 or id==231 or id==236 or id==240 or id==241 or id==242 then
		bdata = CurWorld:getBlockData(x,y,z) + math.random(2,4)
		if bdata > 7 then bdata = 7 end
		CurWorld:setBlockData(x,y,z, bdata)
	elseif id==237 then --可可果特殊处理
		bdata = CurWorld:getBlockData(x,y,z)
		stage = math.floor(bdata/4)
		d = bdata-stage*4
		stage = stage + math.random(0,1)
		if stage > 2 then stage = 2 end

		CurWorld:setBlockData(x,y,z, stage*4+d)
	end
	return true]]
end

--使用雪
function Snow_OnUse(x,y,z,dir)
	if CurWorld:getBlockID(x,y,z) == 115 then
		blockdata = CurWorld:getBlockData(x,y,z)
		if blockdata < 7 then
			CurWorld:setBlockData(x,y,z, blockdata+1)
			CurMainPlayer:shortcutItemUsed()
			return true
		end
	end
	return false
end

--使用台阶
function Slab_OnUse(x,y,z,dir, slabid)
	if CurWorld:getBlockID(x,y,z) == slabid then
		blockdata = CurWorld:getBlockData(x,y,z)
		if (dir==DIR_POS_Y and blockdata==0) or (dir==DIR_NEG_Y and blockdata==1) then
			CurWorld:setBlockData(x,y,z, 2)
			CurMainPlayer:shortcutItemUsed()
			return true
		end
	end

	nx, ny, nz = NeighborBlock(x,y,z,dir)
	curid = CurWorld:getBlockID(nx,ny,nz)
	if curid == slabid then
		blockdata = CurWorld:getBlockData(nx,ny,nz)
		if blockdata==0 or blockdata==1 then
			CurWorld:setBlockData(nx,ny,nz, 2)
			CurMainPlayer:shortcutItemUsed()
			return true
		end
	end
	return false
end

function StoneSlab_OnUse(x,y,z,dir)
	return Slab_OnUse(x,y,z,dir, 506)
end
function SandStoneSlab_OnUse(x,y,z,dir)
	return Slab_OnUse(x,y,z,dir, 507)
end

--使用门
function Door_OnUse(x,y,z,dir, doorid)
	if dir ~= DIR_POS_Y then return true end

	nx,ny,nz = NeighborBlock(x,y,z,dir)
	if not CurWorld:canPlaceBlockAt(nx,ny,nz,doorid) then return true end

	placedir = CurMainPlayer:getBlockOperate():getCurPlaceDir(nx,ny,nz)

	local lx, ly, lz = LeftOnPlaceDir(nx,ny,nz, placedir)
	local rx, ry, rz = RightOnPlaceDir(nx,ny,nz, placedir)

	local left_nc = 0
	local right_nc = 0
	if CurWorld:isBlockNormalCube(lx,ly,lz) then left_nc = left_nc + 1 end
	if CurWorld:isBlockNormalCube(lx,ly+1,lz) then left_nc = left_nc + 1 end

	if CurWorld:isBlockNormalCube(rx,ry,rz) then right_nc = right_nc + 1 end
	if CurWorld:isBlockNormalCube(rx,ry+1,rz) then right_nc = right_nc + 1 end

	local leftdoor = (CurWorld:getBlockID(lx,ly,lz)==doorid) or (CurWorld:getBlockID(lx,ly+1,lz)==doorid)
	local rightdoor = (CurWorld:getBlockID(rx,ry,rz)==doorid) or (CurWorld:getBlockID(rx,ry+1,rz)==doorid)

	updata = 4
	if left_nc<right_nc or (leftdoor and not rightdoor) then  --镜像
		updata = updata + 0
	else
		updata = updata + 1
	end

	CurWorld:setBlockAll(nx,ny,nz, doorid, placedir)
	CurWorld:setBlockAll(nx,ny+1,nz, doorid, updata)
	CurMainPlayer:shortcutItemUsed()
	return true
end

function WoodDoor_OnUse(x,y,z,dir)
	return Door_OnUse(x,y,z,dir, 812)
end

function IronDoor_OnUse(x,y,z,dir)
	return Door_OnUse(x,y,z,dir, 814)
end

--使用床
function Bed_OnUse(x,y,z,dir)
	if(CurWorld:getCurMapID() > 0) then
		GameEventQue:postInfoTips(6)
		return true
	end

	if dir ~= DIR_POS_Y then return true end

	local blockid = 828
	nx,ny,nz = NeighborBlock(x,y,z,dir)
	if not CurWorld:canPlaceBlockAt(nx,ny,nz,blockid) then return true end

	placedir = CurMainPlayer:getBlockOperate():getCurPlaceDir(nx,ny,nz)
	nx2, ny2, nz2 = NeighborBlock(nx,ny,nz, ReverseDirection(placedir))
	if not CurWorld:canPlaceBlockAt(nx2,ny2,nz2,blockid) then return true end

	CurWorld:setBlockAll(nx,ny,nz, blockid, placedir)
	CurWorld:setBlockAll(nx2,ny2,nz2, blockid, placedir+4)
	CurMainPlayer:shortcutItemUsed()
	return true
end

function StorageBoxGrade(x,y,z)
	if CurWorld:getBlockID(x,y,z) ~= 801 then return 0 end

	if CurWorld:getBlockID(x-1,y,z) == 801 then return 2 end
	if CurWorld:getBlockID(x+1,y,z) == 801 then return 2 end
	if CurWorld:getBlockID(x,y,z-1) == 801 then return 2 end
	if CurWorld:getBlockID(x,y,z+1) == 801 then return 2 end
	return 1
end

function StorageBox_OnUse(x,y,z,dir)
	nx,ny,nz = NeighborBlock(x,y,z,dir)
	if not CurWorld:canPlaceBlockAt(nx,ny,nz, 801) then return false end
	
	negxgrade = StorageBoxGrade(nx-1, ny, nz)
	posxgrade = StorageBoxGrade(nx+1, ny, nz)
	negzgrade = StorageBoxGrade(nx, ny, nz-1)
	poszgrade = StorageBoxGrade(nx, ny, nz+1)

	if negxgrade + posxgrade + negzgrade + poszgrade >= 2 then return false end

	placedir = CurMainPlayer:getBlockOperate():getCurPlaceDir(nx,ny,nz)
	if negxgrade > 0 then
		if placedir==DIR_NEG_X or placedir==DIR_POS_X then placedir = DIR_NEG_Z end
		CurWorld:setBlockData(nx-1,ny,nz, placedir)
	elseif posxgrade > 0 then
		if placedir==DIR_NEG_X or placedir==DIR_POS_X then placedir = DIR_NEG_Z end
		CurWorld:setBlockData(nx+1,ny,nz, placedir)
	elseif negzgrade > 0 then
		if placedir==DIR_NEG_Z or placedir==DIR_POS_Z then placedir = DIR_NEG_X end
		CurWorld:setBlockData(nx,ny,nz-1, placedir)
	elseif poszgrade > 0 then
		if placedir==DIR_NEG_Z or placedir==DIR_POS_Z then placedir = DIR_NEG_X end
		CurWorld:setBlockData(nx,ny,nz+1, placedir)
	end

	CurWorld:setBlockAll(nx,ny,nz, 801, placedir)
	CurMainPlayer:shortcutItemUsed()
	return true
end

function Furnace_OnUse(x,y,z,dir)
	nx,ny,nz = NeighborBlock(x,y,z,dir)
	if not CurWorld:canPlaceBlockAt(nx,ny,nz, 802) then return false end

	placedir = CurMainPlayer:getBlockOperate():getCurPlaceDir(nx,ny,nz)
	CurWorld:setBlockAll(nx,ny,nz, 802, placedir)
	WorldContainerMgr:addFurnace(nx,ny,nz)
	CurMainPlayer:shortcutItemUsed()

	return true;
end

function Minecart_OnUse(x, y, z, dir, itemid)
	local blockid = CurWorld:getBlockID(x,y,z)
	if blockid==BLOCK_RAIL or blockid==BLOCK_RAIL_ACTIVATOR or blockid==BLOCK_RAIL_POWERED then
		local cart = ActorMinecart:create(itemid)
		ClientActorManager:spawnActor(cart, x*100+50, y*100, z*100+50, 0, 0)
		return true
	end
	return false
end