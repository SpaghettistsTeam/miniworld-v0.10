REPAIR_GRID_MAX = 30;
REPAIR_ITEM_GRID_INDEX = 15000;		--要修理的物品的grid_index;

function RepairFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");

	for i=1,REPAIR_GRID_MAX/5 do
		for j=1,5 do
			local itembtn = getglobal("WaitRepairBoxItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "WaitRepairBoxPlane", "topleft", (j-1)*106, (i-1)*106);
		end
	end

	for i=1,REPAIR_GRID_MAX/5 do
		for j=1,5 do
			local itembtn = getglobal("RepairStuffBoxItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "RepairStuffBoxPlane", "topleft", (j-1)*106, (i-1)*106);
		end
	end
end

function RepairFrame_OnEvent()
	if arg1 == "GE_BACKPACK_CHANGE" then		
		if RepairFrame:IsShown() then
			local ge = GameEventQue:getCurEvent();
			local grid_index = ge.body.backpack.grid_index;
			if grid_index >= BACKPACK_START_INDEX and grid_index < BACKPACK_START_INDEX+1006 then
				UpdateWaitRepairItem();
			elseif grid_index >= REPAIR_START_INDEX and grid_index <= REPAIR_START_INDEX+3 then
				UpdateRepairItem(grid_index);
			end		
		end
	end
end

function RepairFrame_OnShow()
	HideAllFrame("RepairFrame");
	UpdateWaitRepairItem();
end

function RepairFrame_OnHide()
	ClearRepairFrame();
	ClientCurGame:setOperateUI(false);
end

function ClearRepairFrame()
	RepairFrameDurTitle:Hide();
	RepairFrameDuration:SetText("");
	RepairFrameStarNum:SetText("");
end 

function RepairFrameCloseBtn_OnMouseDown()
	local btnIcon = getglobal("RepairFrameCloseBtnIcon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(51,51);
end

function RepairFrameCloseBtn_OnMouseUp()
	local btnIcon = getglobal("RepairFrameCloseBtnIcon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(66,67);
end

function RepairFrameCloseBtn_OnClick()
	RepairFrame:Hide();
end

function RepairFrameRepairBtn_OnClick()
	local starNum = MainPlayerAttrib:getExp();
	if ClientBackpack:getGridItem(15000) == 0 then
		UpdateTipsFrame("请放入要修理的物品", 0);
	elseif ClientBackpack:getGridItem(15001) == 0 then
		UpdateTipsFrame("请放入修理材料", 0);
	elseif MainPlayerAttrib:getExp() < tonumber( RepairFrameStarNum:GetText() ) then--星星不足
		UpdateTipsFrame("星星不足", 0);
	else
		local itemName = ClientBackpack:getGridItemName(15002);
		ClientBackpack:removeItem(15000, ClientBackpack:getGridNum(15000));
		ClientBackpack:removeItem(15001, ClientBackpack:getGridNum(15001));
		local durable = ClientBackpack:getGridDuration(15002);
		local itemId = ClientBackpack:getGridItem(15002)
		local num = ClientBackpack:getGridNum(15002);
		if ClientBackpack:addItem(15002, itemId, num, durable, 2) == 0 then
			CurMainPlayer:throwItem(grid_index, num);
		end
		ClientBackpack:removeItem(15002, ClientBackpack:getGridNum(15002));
		--扣掉星星;
		UpdateTipsFrame(itemName.." 修理成功！", 0);
	end
end

function UpdateWaitRepairItem()
	local t_waitRepairItem = {};
	for i=1, BACK_PACK_GRID_MAX do 
		local grid_index = BACKPACK_START_INDEX + i - 1;
		local itemId = ClientBackpack:getGridItem(grid_index);

		local durable = ClientBackpack:getGridDuration(grid_index);
		local toolDef = DefMgr:getToolDef(itemId);
		if toolDef ~= nil and itemId ~= 1000 and durable < toolDef.Duration then
			table.insert(t_waitRepairItem, grid_index);
		end
	end
	for i=1, MAX_SHORTCUT do
		local grid_index = SHORTCUT_START_INDEX + i - 1;
		local itemId = ClientBackpack:getGridItem(grid_index);
		local durable = ClientBackpack:getGridDuration(grid_index);
		local toolDef = DefMgr:getToolDef(itemId);
		if toolDef ~= nil and durable < toolDef.Duration then
			table.insert(t_waitRepairItem, grid_index);
		end
	end
	
	for i=1, REPAIR_GRID_MAX do
		local waitRepair	= getglobal("WaitRepairBoxItem"..i);
		local waitRepairIcon 	= getglobal("WaitRepairBoxItem"..i.."ContentIcon");
		local waitRepairNum 	= getglobal("WaitRepairBoxItem"..i.."ContentCount");
		local waitRepairDurbar 	= getglobal("WaitRepairBoxItem"..i.."ContentDuration");
		
		if i <= #(t_waitRepairItem) then
			waitRepair:SetClientID(t_waitRepairItem[i]+1);
			UpdateItemIconCount(waitRepairIcon, waitRepairNum, waitRepairDurbar, t_waitRepairItem[i]);
		else
			waitRepair:SetClientID(0);
			waitRepairIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
			waitRepairNum:SetText("");
			waitRepairDurbar:Hide();
		end		
	end
end

function UpdateRepairStuff(itemId)
	local toolDef = DefMgr:getToolDef(itemId);	
	local t_repairStuff = {};

	if toolDef ~= nil then
		for i=1, BACK_PACK_GRID_MAX do 			
			local grid_index = BACKPACK_START_INDEX + i - 1;
			local itemId = ClientBackpack:getGridItem(grid_index);
			for j=1, 6 do
				if toolDef.RepairId[j-1] == itemId  then
					table.insert(t_repairStuff, grid_index);
				end
			end
		end
		for i=1, MAX_SHORTCUT do
			local grid_index = SHORTCUT_START_INDEX + i - 1;
			local itemId = ClientBackpack:getGridItem(grid_index);
			for j=1, 6 do
				if toolDef.RepairId[j-1] == itemId  then
					table.insert(t_repairStuff, grid_index);
				end
			end
		end
	end

	for i=1, REPAIR_GRID_MAX do
		local stuffItem		= getglobal("RepairStuffBoxItem"..i);
		local stuffItemIcon 	= getglobal("RepairStuffBoxItem"..i.."ContentIcon");
		local stuffItemNum 	= getglobal("RepairStuffBoxItem"..i.."ContentCount");
		local stuffItemDurbar 	= getglobal("RepairStuffBoxItem"..i.."ContentDuration");
		
		if i <= #(t_repairStuff) then
			stuffItem:SetClientID(t_repairStuff[i]+1);
			UpdateItemIconCount(stuffItemIcon, stuffItemNum, stuffItemDurbar, t_repairStuff[i]);
		else
			stuffItem:SetClientID(0);
			stuffItemIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
			stuffItemNum:SetText("");
			stuffItemDurbar:Hide();
		end		
	end 
end

function UpdateRepairItem(grid_index)
	for i=1, 3 do
		local repairItem = getglobal("RepairFrameRepairItem"..i);
		if repairItem:GetClientID()-1 == grid_index then
			local icon 	= getglobal(repairItem:GetName() .. "ContentIcon");
			local num	= getglobal(repairItem:GetName() .. "ContentCount");
			local durbar	= getglobal(repairItem:GetName() .. "ContentDuration");
			UpdateItemIconCount(icon, num, durbar, grid_index);
			if grid_index == 15002 then
				icon:SetGray(true);
				local itemId = ClientBackpack:getGridItem(15002);
				local toolDef = DefMgr:getToolDef(itemId);
				if itemId > 0 and toolDef ~= nil then
					local durable = ClientBackpack:getGridDuration(15002);
					
					RepairFrameDurTitle1:Show();
					RepairFrameDuration1:SetText(durable.."/"..toolDef.Duration);
				else
					RepairFrameDurTitle1:Hide();
					RepairFrameDuration1:SetText("");
				end
			end
		end	
	end

	local itemId = ClientBackpack:getGridItem(REPAIR_ITEM_GRID_INDEX);
	UpdateRepairStuff(itemId);
	UpdateRepairShow();
end

function RepairItemOnclick(grid_index)
	if grid_index == 15002 then return end		--修理后的格子上的东西不能拿下来;
	local itemId = ClientBackpack:getGridItem(grid_index);
	if itemId < 1 then return; end			--格子里没有东西

	UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 0);	
	local num = ClientBackpack:getGridNum(grid_index);
	if grid_index == 15001 then			--修理所需材料格子里的物品，先添加到背包里，然后从材料格子删除掉
		CurMainPlayer:gainItems(itemId, num, 2);
		ClientBackpack:removeItem(15002, ClientBackpack:getGridNum(15002));
	elseif grid_index == 15000 then			--正在修理的物品格子，带耐久度的添加到背包里，如果放不下扔地上，并且把材料放回背包里；
		local durable = ClientBackpack:getGridDuration(15000);
		if ClientBackpack:addItem(15000, itemId, num, durable, 2) == 0 then
			CurMainPlayer:throwItem(grid_index, num);
		end
		
		CurMainPlayer:gainItems(ClientBackpack:getGridItem(15001), ClientBackpack:getGridNum(15001), 2);
		ClientBackpack:removeItem(15001, ClientBackpack:getGridNum(15001));
		ClientBackpack:removeItem(15002, ClientBackpack:getGridNum(15002));
	end	

	ClientBackpack:removeItem(grid_index, num);		--移除格子里面的物品
end

function UpdateRepairShow()
	local repiarDur = GetRepairDuration();
	local toolDef = DefMgr:getToolDef(ClientBackpack:getGridItem(REPAIR_ITEM_GRID_INDEX));
	
	if toolDef ~= nil then
		local curDur = ClientBackpack:getGridDuration(REPAIR_ITEM_GRID_INDEX);
		local totalDur = toolDef.Duration;
		local cost = 0;
		if repiarDur ~= 0 then
			cost = math.ceil( toolDef.RepairExp + repiarDur*0.01 );
		end
		RepairFrameStarNum:SetText(cost);
		RepairFrameDurTitle:Show();
		RepairFrameDuration:SetText(curDur.."/"..totalDur);
	else
		RepairFrameDurTitle:Hide();
		RepairFrameDuration:SetText("");
		RepairFrameStarNum:SetText("");
	end
end

function PlaceRepairStuff(grid_index)
	local itemId = ClientBackpack:getGridItem(grid_index);
	local toolDef = DefMgr:getToolDef(ClientBackpack:getGridItem(REPAIR_ITEM_GRID_INDEX));
	
	if itemId > 0 and toolDef ~= nil then
		local num = ClientBackpack:getGridNum(grid_index);
		local RepairAmount = 0;
		for i=1,6 do
			if itemId == toolDef.RepairId[i-1] then
				RepairAmount = toolDef.RepairAmount[i-1];
				break;
			end
		end
		local needNum = math.ceil( GetRepairDuration() / RepairAmount );
		if needNum == 0 then return; end

		if num < needNum then
			needNum = num;
			ClientBackpack:swapItem(grid_index, 15001);
		else
			CurMainPlayer:gainItems(ClientBackpack:getGridItem(15001), ClientBackpack:getGridNum(15001), 2);
			ClientBackpack:removeItem(15001, ClientBackpack:getGridNum(15001));	
			ClientBackpack:moveItem(grid_index, 15001, needNum);
		end
		SetRepairResultGrid( needNum*RepairAmount );
	end
end

function GetRepairDuration()
	local toolDef = DefMgr:getToolDef(ClientBackpack:getGridItem(REPAIR_ITEM_GRID_INDEX));
	if toolDef ~= nil then
		local curDur 	= ClientBackpack:getGridDuration(REPAIR_ITEM_GRID_INDEX);
		local totalDur 	= toolDef.Duration;
		return totalDur - curDur;
	end
	return 0;
end

function RepairItemShowTips(clientId, top, bottom, left, right)
	if clientId == 0 then return; end
	local grid_index = clientId - 1;
	tipsItemId = itemId;
	tipsGridIndex = grid_index;

	TipsFrameType1_OnClick();
end

function SetRepairResultGrid(durable)
	if GetRepairDuration() < durable then
		durbar = GetRepairDuration();
	end
	ClientBackpack:doRepair(GetRepairDuration());
end