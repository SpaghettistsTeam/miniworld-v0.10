FURNACE_GRID_MAX = 30;
CurAttachedFurnace = nil
function FurnaceFrame_OnLoad()
	this:RegisterEvent("GE_FURNACE_PROGRESS");
	this:RegisterEvent("GE_BACKPACK_CHANGE");

	for i=1,FURNACE_GRID_MAX/5 do
		for j=1,5 do
			local itembtn = getglobal("FurnaceStuffBoxItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "FurnaceStuffBoxPlane", "topleft", (j-1)*106, (i-1)*106);
		end
	end

	for i=1,FURNACE_GRID_MAX/5 do
		for j=1,5 do
			local itembtn = getglobal("FurnaceFuelBoxItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "FurnaceFuelBoxPlane", "topleft", (j-1)*106, (i-1)*106);
		end
	end
end

function FurnaceFrameCloseBtn_OnMouseDown()
	local btnIcon = getglobal("FurnaceFrameCloseBtnIcon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(51,51);
end

function FurnaceFrameCloseBtn_OnMouseUp()
	local btnIcon = getglobal("FurnaceFrameCloseBtnIcon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(66,67);
end

function FurnaceFrameCloseBtn_OnClick()
	FurnaceFrame:Hide();
end

function FurnaceFrame_OnShow()
	HideAllFrame("FurnaceFrame");
	UpdateFurnaceLeftFrame();	
end

function FurnaceFrame_OnHide()
	if CurAttachedFurnace ~= nil then 
		ClientBackpack:detachContainer(CurAttachedFurnace)
	end
	FurnaceStuffBox:resetOffsetPos();
	FurnaceFuelBox:resetOffsetPos();
	ClientCurGame:setOperateUI(false);
end

function FurnaceFrame_OnEvent()
	if CurAttachedFurnace == nil then return end

	if arg1 == "GE_FURNACE_PROGRESS" then
		local fuel = CurAttachedFurnace:getHeatPercent()
		local mticks = CurAttachedFurnace:getMeltTicksPercent()

		FurnaceFrameFuelProgressBar:SetValue(fuel);
		FurnaceFrameArrowProgressBar:SetValue(mticks);
	end

	if arg1 == "GE_BACKPACK_CHANGE" then
		local ge = GameEventQue:getCurEvent();
		local grid_index = ge.body.backpack.grid_index;
		if grid_index>=BACKPACK_START_INDEX and grid_index<BACKPACK_START_INDEX+1006 then
			UpdateFurnaceLeftFrame();
		elseif grid_index >= FURNACE_START_INDEX and grid_index < FURNACE_START_INDEX+3 then
			UpdateFurnaceRightFrame(grid_index);
		end
		
	end
end

function UpdateFurnaceLeftFrame()
	local t_furnaceStuff = {};
	local t_furnaceFuel = {};
	for i=1, BACK_PACK_GRID_MAX do
		local grid_index = BACKPACK_START_INDEX + i - 1;
		local itemId = ClientBackpack:getGridItem(grid_index);
		local furnaceDef = DefMgr:getFurnaceDef(itemId);
		if furnaceDef ~= nil then
			if furnaceDef.Heat > 0 then
				table.insert(t_furnaceFuel, grid_index);
			elseif furnaceDef.Result > 0 then
				table.insert(t_furnaceStuff, grid_index);
			end
		end
	end
	for i=1, MAX_SHORTCUT do
		local grid_index = SHORTCUT_START_INDEX + i - 1;
		local itemId = ClientBackpack:getGridItem(grid_index);
		local furnaceDef = DefMgr:getFurnaceDef(itemId);
		if furnaceDef ~= nil then
			if furnaceDef.Heat > 0 then
				table.insert(t_furnaceFuel, grid_index);
			elseif furnaceDef.Result > 0 then
				table.insert(t_furnaceStuff, grid_index);
			end
		end
	end

	for i=1, FURNACE_GRID_MAX do
		local stuffItem 	= getglobal("FurnaceStuffBoxItem"..i);
		local stuffItemIcon 	= getglobal("FurnaceStuffBoxItem"..i.."ContentIcon");
		local stuffItemNum 	= getglobal("FurnaceStuffBoxItem"..i.."ContentCount");
		local stuffItemDurbar 	= getglobal("FurnaceStuffBoxItem"..i.."ContentDuration");
		if i <= #(t_furnaceStuff) then
			stuffItem:SetClientID(t_furnaceStuff[i]+1);
			UpdateItemIconCount(stuffItemIcon, stuffItemNum, stuffItemDurbar, t_furnaceStuff[i]);
		else
			stuffItem:SetClientID(0);
			stuffItemIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
			stuffItemNum:SetText("");
			stuffItemDurbar:Hide();
		end
	end

	for i=1, FURNACE_GRID_MAX do 
		local fuelItem		= getglobal("FurnaceFuelBoxItem"..i);
		local fuelItemIcon 	= getglobal("FurnaceFuelBoxItem"..i.."ContentIcon");
		local fuelItemNum 	= getglobal("FurnaceFuelBoxItem"..i.."ContentCount");
		local fuelItemDurbar 	= getglobal("FurnaceFuelBoxItem"..i.."ContentDuration");
		if i <= #(t_furnaceFuel) then
			fuelItem:SetClientID(t_furnaceFuel[i]+1);
			UpdateItemIconCount(fuelItemIcon, fuelItemNum, fuelItemDurbar, t_furnaceFuel[i]);
		else
			fuelItem:SetClientID(0);
			fuelItemIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
			fuelItemNum:SetText("");
			fuelItemDurbar:Hide();
		end
	end
end

function UpdateFurnaceRightFrame(grid_index)
	for i=1, 3 do
		local furnaceItem = getglobal("FurnaceFrameFurnaceItem"..i);
		if furnaceItem:GetClientID()-1 == grid_index then
			local icon 	= getglobal(furnaceItem:GetName() .. "ContentIcon");
			local num	= getglobal(furnaceItem:GetName() .. "ContentCount");
			local durbar	= getglobal(furnaceItem:GetName() .. "ContentDuration");
			local lack	= getglobal(furnaceItem:GetName() .. "ContentLack");
			UpdateItemIconCount(icon, num, durbar, grid_index);

			if i == 3 and ClientBackpack:getGridItem(grid_index) > 0 and ClientBackpack:getGridEnough(grid_index) == 0 then
				icon:SetGray(true);
				lack:Show();
			else
				icon:SetGray(false);
				lack:Hide();
			end
		end	
	end

	local furnaceDef = DefMgr:getFurnaceDef(ClientBackpack:getGridItem(FURNACE_START_INDEX));
	local itemId = ClientBackpack:getGridItem(FURNACE_START_INDEX+2);
	if furnaceDef ~= nil and itemId > 0 and itemId ~= furnaceDef.Result
	   and ClientBackpack:getGridEnough(FURNACE_START_INDEX+2) ~= 0 then
		FurnaceFrameTips3:Show();
	else
		FurnaceFrameTips3:Hide();
	end

	if ClientBackpack:getGridItem(FURNACE_START_INDEX+2) > 0 then
		FurnaceFrameName:SetText(ClientBackpack:getGridItemName(FURNACE_START_INDEX+2)..":");
		local itemDef 	= DefMgr:getItemDef(ClientBackpack:getGridItem(FURNACE_START_INDEX+2))
		FurnaceFrameItemDesc:SetText(itemDef.Desc, 118, 67, 0);
	else
		FurnaceFrameName:SetText("");
		FurnaceFrameItemDesc:Clear();
	end
end

function FurnaceItemOnclick(grid_index)
	local itemId 	= ClientBackpack:getGridItem(grid_index);
	local num 	= ClientBackpack:getGridNum(grid_index);
	
	if itemId < 1 then return; end

	if grid_index == 9002 then	
		if ClientBackpack:getGridEnough(9002) == 0 then return end
		local name 		= ClientBackpack:getGridItemName(grid_index);
		local tipsContent 	= "获得"..num.."个"..name;
		ShowGameTips(tipsContent, 1);
		CurMainPlayer:gainItems(itemId, num, 1);
	else
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 0);

		local durable = ClientBackpack:getGridDuration(grid_index);
		if ClientBackpack:addItem(grid_index, itemId, num, durable, 2) == 0 then
			CurMainPlayer:throwItem(grid_index, num);
		end
	end

	ClientBackpack:removeItem(grid_index, num);
	if grid_index == 9000 and ClientBackpack:getGridItem(9002) > 0 and ClientBackpack:getGridEnough(9002) == 0 then
		ClientBackpack:removeItem(9002, ClientBackpack:getGridNum(9002));
	end
	
end