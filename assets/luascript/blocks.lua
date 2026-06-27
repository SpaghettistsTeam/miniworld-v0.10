
--点击工作台
function CraftingTable_OnClick(x, y, z, toolid)
	if not CurWorld:isCreativeMode() then
		craftframe = getglobal("CraftingTableFrame");

		UIFrameMgr:frameShow(craftframe);
		ClientCurGame:setOperateUI(true);
		return true;
	end
	return true;
end

--点击附魔台
function EnchantTable_OnClick(x, y, z, toolid)
	if not CurWorld:isCreativeMode() then
		enchantframe = getglobal("EnchantFrame");

		Enchant_Type = 2;
		enchantframe:Show();
		ClientCurGame:setOperateUI(true);
		return true;
	end
	return true;
end

--点击铁砧
function Anvil_OnClick(x, y, z, toolid)
	if not CurWorld:isCreativeMode() then
		repairframe = getglobal("RepairFrame");

		UIFrameMgr:frameShow(repairframe);
	--	repairframe:Show();
		ClientCurGame:setOperateUI(true);

		bdata = CurWorld:getBlockData(x, y, z)
		stage = math.floor(bdata/4)
		dir = bdata - stage*4

		if stage > 2 then
			CurWorld:setBlockAll(x, y, z, 0, 0)
		else
			stage = stage + 1
			CurWorld:setBlockData(x, y, z, stage*4 + dir);
		end
		return true;
	end
	return true;
end

--点击熔炉
function Furnace_OnClick(x, y, z, toolid)
	if not CurWorld:isCreativeMode() then
		CurAttachedFurnace = WorldContainerMgr:getFurnace(x,y,z)
		ClientBackpack:attachContainer(CurAttachedFurnace)

		local furnaceframe = getglobal("FurnaceFrame");
		UIFrameMgr:frameShow(furnaceframe);
	--	furnaceframe:Show();

		ClientCurGame:setOperateUI(true);
		return true;
	end
	return true;
end

--点击储物箱
function StorageBox_OnClick(x, y, z, toolid)
	if not CurWorld:isCreativeMode() then
		blockdata = CurWorld:getBlockData(x,y,z)
		if blockdata >= 4 then return true end --已经打开
		
		dir = blockdata%4
		
		local lx,ly,lz = LeftOnPlaceDir(x,y,z, dir)
		local rx,ry,rz = RightOnPlaceDir(x,y,z, dir)

		if CurWorld:getBlockID(lx,ly,lz) == 801 then
			CurAttachedStorage = WorldContainerMgr:getStorageBox(lx,ly,lz)
			CurAttachedStorage:append(WorldContainerMgr:getStorageBox(x,y,z))
		elseif CurWorld:getBlockID(rx,ry,rz) == 801 then
			CurAttachedStorage = WorldContainerMgr:getStorageBox(x,y,z)
			CurAttachedStorage:append(WorldContainerMgr:getStorageBox(rx,ry,rz))
		else
			CurAttachedStorage = WorldContainerMgr:getStorageBox(x,y,z)
			CurAttachedStorage:append(nil)
		end

		ClientBackpack:attachContainer(CurAttachedStorage)
		
		UIFrameMgr:frameShow(StorageBoxFrame);
	--	StorageBoxFrame:Show()
		ClientCurGame:setOperateUI(true)
		return true
	end
	return true
end

--点击宝箱
function TreasureBox_OnClick(x, y, z, toolid)
	if not CurWorld:isCreativeMode() then
		blockdata = CurWorld:getBlockData(x,y,z)
		if blockdata >= 4 then return true end --已经打开
		
		dir = blockdata%4
		
		CurAttachedStorage = WorldContainerMgr:getStorageBox(x,y,z)
		CurAttachedStorage:append(nil)

		ClientBackpack:attachContainer(CurAttachedStorage)
		
		UIFrameMgr:frameShow(StorageBoxFrame);
		ClientCurGame:setOperateUI(true)
		return true
	end
	return true
end

--门
function OpenOrCloseDoor(x,y,z)
	blockdata = CurWorld:getBlockData(x,y,z)
	if blockdata >= 8 then blockdata = blockdata-8
	else blockdata = blockdata+8 end

	CurWorld:setBlockData(x,y,z,blockdata)
end

function Door_OnClick(x, y, z, toolid)
	id = CurWorld:getBlockID(x,y,z)
	
	--open or close door
	OpenOrCloseDoor(x,y,z)

	if CurWorld:getBlockID(x,y+1,z) == id then
		OpenOrCloseDoor(x,y+1,z)	
	elseif CurWorld:getBlockID(x,y-1,z) == id then
		OpenOrCloseDoor(x,y-1,z)
	end
	return true
end

