
EquipSlotTypes = {8, 9, 10, 11}

function ToolType2EquipSlot(tooltype)
	if tooltype>=8 and tooltype<=11 then
		return tooltype-8+EQUIP_START_INDEX
	else
		return -1
	end
end

--点击合成产出格
function PickCraftResultGrid(grid_index)
	result = ClientBackpack:moveItem(grid_index, MOUSE_PICKITEM_INDEX, ClientBackpack:getGridNum(grid_index));
	if result then
		UIBeginDrag("MousePickItem");
	end
end

--拾取普通格子里的物品
function PickGridItem(grid_index, rbutton)
	local movenum = ClientBackpack:getGridNum(grid_index);
	if movenum == 0 then return end

	if rbutton then
		movenum = math.floor((movenum+1)/2)
	end

	if ClientBackpack:moveItem(grid_index, MOUSE_PICKITEM_INDEX, movenum) then
		UIBeginDrag("MousePickItem");
	end
end

--是否可以放入装备
function CanPutEquipItem(grid_index)
	local dragitemtype = ClientBackpack:getGridToolType(MOUSE_PICKITEM_INDEX);
	local offset = grid_index-EQUIP_START_INDEX+1;
	if EquipSlotTypes[offset] ~= dragitemtype then
		return false;
	end
	return true;
end

function PutGridItem(grid_index, rbutton)
	local movenum = ClientBackpack:getGridNum(MOUSE_PICKITEM_INDEX)
	if rbutton then movenum = 1 end

	ClientBackpack:moveItem(MOUSE_PICKITEM_INDEX, grid_index, movenum);
	if ClientBackpack:getGridNum(MOUSE_PICKITEM_INDEX) == 0 then
		UIEndDrag("MousePickItem");
	end
end

function UpdateItemtipsFrame(grid_index)
	if ClientBackpack:getGridItem(grid_index) == 0 then 
		UIEndDrag("ItemTipsFrame")
		return
	end

	name = ClientBackpack:getGridItemName(grid_index)
	systips = getglobal( "ItemTipsFrameText" );
	systips:Clear();
	systips:AddText(name, 255, 255, 255);
	systips:SetDispPos(systips:GetStartDispPos());

	UIBeginDrag("ItemTipsFrame", 50, -50, 1)
end



PutItemRecords = {}
PutItemNumRecord = 0
PutItemTotalItemNum = 0
PutItemOriginNum = {}

function AddPutItemRecord(grid_index)
	
	if not ClientBackpack:canPutItem(grid_index) then
		return
	end

	--点击的是装备位置,  如果装备类型不对, 返回
	if IsGridIndexType(grid_index,EQUIP_START_INDEX) and not CanPutEquipItem(grid_index) then
		return
	end

	--鼠标和格子的物品不一样
	if ClientBackpack:getGridNum(grid_index)>0 and ClientBackpack:getGridItem(grid_index) ~= ClientBackpack:getGridItem(MOUSE_PICKITEM_INDEX) then
		return
	end

	--已经记录
	for i=1,PutItemNumRecord do
		if PutItemRecords[i] == grid_index then return end
	end
		
	PutItemNumRecord = PutItemNumRecord + 1
	PutItemRecords[PutItemNumRecord] = grid_index
	PutItemOriginNum[PutItemNumRecord] = ClientBackpack:getGridNum(grid_index)
end

function ShiftMoveItem(grid_index)
    destindex = 0
    if IsGridIndexType(grid_index, BACKPACK_START_INDEX) then
	toolslot = ToolType2EquipSlot(ClientBackpack:getGridToolType(grid_index))
	if toolslot >= 0 then
		ClientBackpack:swapItem(grid_index, toolslot)
		return
	else
		destindex = SHORTCUT_START_INDEX
	end
    else
	destindex = BACKPACK_START_INDEX 
    end
        
    ClientBackpack:shiftMoveItem(grid_index, destindex)
    UpdateItemtipsFrame(grid_index)
end

function ItemButton_MouseDown()
	local grid_index = this:GetClientID();
	PutItemNumRecord = 0

	if string.find(arg2, "S") ~= nil then --shift + MouseKeyDown
		ShiftMoveItem(grid_index)
		return
	end
    
	--if IsGridIndexType(grid_index,MINICRAFT_RESULT_INDEX) or IsGridIndexType(grid_index,CRAFT_RESULT_INDEX) then
	--	PickCraftResultGrid(grid_index);
	--	return
	--end

	if ClientBackpack:getGridItem(MOUSE_PICKITEM_INDEX) == 0 then
		PickGridItem(grid_index, arg1==VK_RBUTTON);
	else
		AddPutItemRecord(grid_index)
		PutItemTotalItemNum = ClientBackpack:getGridNum(MOUSE_PICKITEM_INDEX)
	end
end

function CanSwapMousePickItem(grid_index)

	if not ClientBackpack:canPutItem(grid_index) then return end

	if IsGridIndexType(grid_index,EQUIP_START_INDEX) and not CanPutEquipItem(grid_index) then
		return false
	end

	local itemnum = ClientBackpack:getGridNum(grid_index);
	local itemid = ClientBackpack:getGridItem(grid_index);

	local dragitemid = ClientBackpack:getGridItem(MOUSE_PICKITEM_INDEX);
	local dragitemnum = ClientBackpack:getGridNum(MOUSE_PICKITEM_INDEX);
	
	if dragitemnum>0 and itemnum>0 and itemid~=dragitemid then
		return true
	end
	return false;
end

function ItemButton_MouseUp()
	local grid_index = this:GetClientID();

	if PutItemNumRecord==0 and CanSwapMousePickItem(grid_index) then
		ClientBackpack:swapItem(MOUSE_PICKITEM_INDEX, grid_index);
	elseif PutItemNumRecord == 1 then
		PutGridItem(PutItemRecords[1], arg1==VK_RBUTTON);
	end

	PutItemNumRecord = 0;
end

CurSelectGridIndex = -1
function ItemButton_MouseEnter()
	local grid_index = this:GetClientID();
	CurSelectGridIndex = grid_index
	local box = getglobal(this:GetName().."ContentBoxTexture")
	box:Show()

	if PutItemNumRecord < 1 then
		UpdateItemtipsFrame(grid_index)
		return 
	end

	AddPutItemRecord(grid_index);

	n = 0
	if string.find(arg1, "L") ~= nil then
		n = math.floor(PutItemTotalItemNum/PutItemNumRecord)
		if n == 0 then n = 1 end
	elseif string.find(arg1, "R") ~= nil then
		n = 1
	else
		return
	end

	for i=1, PutItemNumRecord do
		n2 = PutItemOriginNum[i] + n
		grid = PutItemRecords[i]
		nsrc = ClientBackpack:getGridNum(grid)

		if nsrc > n2 then
			ClientBackpack:moveItem(grid, MOUSE_PICKITEM_INDEX, nsrc-n2)
		elseif nsrc < n2 then
			ClientBackpack:moveItem(MOUSE_PICKITEM_INDEX, grid, n2-nsrc)
			if n==1 and ClientBackpack:getGridNum(MOUSE_PICKITEM_INDEX) == 0 then
			    PutItemNumRecord = 0
			    break
			end
		end
	end
end

function ItemButton_MouseLeave()
	CurSelectGridIndex = -1
	local box = getglobal(this:GetName().."ContentBoxTexture")
	box:Hide()

	if PutItemNumRecord < 1 then
		UIEndDrag("ItemTipsFrame")
	end
end

function ItemButton_Throw()
end