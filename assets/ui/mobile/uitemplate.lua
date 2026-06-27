selectBackpackGrid 	= -1;		--选中背包的格子
selectProductId 	= -1;		--简易制作面板选中制作物的格子物品的ID
selectNormalProductId 	= -1;		--正常制作面板选中制作物的格子物品的ID
tipsDisplayTime 	= 0.5;		--tips的显示时间
shortcutBoxDisplayTime 	= 0;		--快捷栏外框闪烁时间
itemTipsAlpha 		= 1;		
tipsItemId 		= nil;		--标记显示tips的物品的ID
tipsGridIndex		= -1;		
IsBackpackLongPress 	= false;	--标记背包格子长按按钮
IsShortcutLongPress 	= false;	--标记快捷栏长按按钮
IsStorageBoxLongPress 	= false;	--标记储物箱格子长按按钮
selectCreateItemId	= -1;		--标记创造模式选择的背包物品ID	

EquipSlotTypes = {8, 9, 10, 11}

function ToolType2EquipSlot(tooltype)
	if tooltype>=8 and tooltype<=11 then
		return tooltype-8+EQUIP_START_INDEX
	else
		return -1
	end
end

--设置并显示提示
function UpdateTipsFrame(tipsContent, type, itemId, gridIndex)	
	if type == 0 then				--显示提示
		TipsFrameType2Font:SetText(tipsContent);
		TipsFrame:Show();
		TipsFrameType1:Hide();
		TipsFrameType2:Show();
		tipsDisplayTime = 0.5;	
		return;
	elseif type == 1 then 				--显示物品名称
		if tipsContent ~= "" then      
			TipsFrameType1Font:SetText(tipsContent);
			TipsFrame:Show();
			TipsFrameType2:Hide();
			TipsFrameType1:Show();
			tipsDisplayTime = 0.5;			
			tipsItemId = itemId;
			tipsGridIndex = gridIndex;	
		end
	end
end

--设置高亮外框
function SetOnclikItemBoxTexture(btnName)
	if btnName == "" or btnName == nil then return end;

	if string.find(btnName, "PackFrame") then
		HidePackFrameAllItemBoxTexture();		
	elseif string.find(btnName, "MiniProduct") then
		HideMakeFrameAllItemBoxTexture();
	elseif string.find(btnName, "NormalProduct") then
		HideCraftingFrameAllItemBoxTexture();
	elseif string.find(btnName, "StorageLeftBox") then
		HideStorageBoxFrameAllLeftItemBoxTexture();
	elseif string.find(btnName, "CreateBoxItem") then
		HideCreateBoxItemBoxTexture();
	elseif string.find(btnName, "ToolShortcut") then
		ShortCutFrame_UpdateAllGrids();
	end

	local boxTexture = getglobal(btnName.."ContentBoxTexture");
	boxTexture:Show();
end

--是否是装备
function IsEquip(index)
	local type = ClientBackpack:getGridToolType(index);
	for i=1,#(EquipSlotTypes) do
		if EquipSlotTypes[i] == type then
			return true;
		end
	end

	return false;
end

--------------------------------------------------------MItemButton-----------------------------------------------------------
--快捷栏丢弃物品
function MItemButton_OnMouseDownUpdate()
	if StorageBoxFrame:IsShown() then
		local clientId = this:GetClientID();
		if clientId == 0 then return end

		local btnName = this:GetName();
		local grid_index = clientId - 1;

		if arg1 > 0.2 and ClientBackpack:getGridItem(grid_index) > 0 then			
			if string.find(btnName,"ToolShortcut") and not IsShortcutLongPress then
 				IsShortcutLongPress = true;
				SetMoveStorageItemIndex(grid_index);
				MoveProgressBarFrame:Show();
				MoveProgressBarFrame:SetPoint("bottom", btnName, "top", 0, 0);
				longPressTime = arg1;				
			end
			
			if arg1-longPressTime > 1.0 then
				MoveProgressBar:SetValue(1);
				MoveProgressBarFrameDesc:SetText("移动"..ClientBackpack:getGridNum(grid_index).."个"..ClientBackpack:getGridItemName(grid_index));
			else
				MoveProgressBar:SetValue(arg1-longPressTime);
				local num = math.floor( ClientBackpack:getGridNum(grid_index)*(arg1-longPressTime) );
				MoveProgressBarFrameDesc:SetText("移动"..num.."个"..ClientBackpack:getGridItemName(grid_index));
			end	
		end
	else
		if arg1 < 0.6 or IsShortcutLongPress then return end

		local name = this:GetName();
		if string.find(name,"ToolShortcut") and not CurWorld:isCreativeMode() then
			local grid_index = this:GetClientID() - 1;		
			if ClientBackpack:getGridItem(grid_index) > 0 then
				local tipsContent = "丢弃了"..ClientBackpack:getGridItemName(grid_index).."×"..ClientBackpack:getGridNum(grid_index)
				UpdateTipsFrame(tipsContent, 0);
			end
			CurMainPlayer:throwItem(grid_index, ClientBackpack:getGridNum(grid_index));
			IsShortcutLongPress = true;
		end
	end
	
end

function MItemButton_OnMouseDown()
	IsShortcutLongPress = false;
end

function MItemButton_OnMouseUp()
	if StorageBoxFrame:IsShown() then
		if IsShortcutLongPress then
			MoveProgressBarFrame:Hide();
			longPressTime = 0;
		end
	end
end

function MItemButton_OnClick()
	if IsShortcutLongPress then
		return;
	end

	local clientId = this:GetClientID();
	if clientId == 0 then return end

	local btnName = this:GetName();
	if string.find(btnName,"ToolShortcut") then	--快捷栏的点击处理
		local curSelectGridIndex = clientId -1;

		if BackpackFramePackFrame:IsShown() then
			if selectBackpackGrid ~= -1 then
				local index 		= selectBackpackGrid - BACKPACK_START_INDEX + 1;
				local boxTexture 	= getglobal("BackpackFramePackFrameItem"..index.."ContentBoxTexture");
				if selectBackpackGrid >= SHORTCUT_START_INDEX and selectBackpackGrid < 2000 then
					index 		= selectBackpackGrid - SHORTCUT_START_INDEX + 1;
					boxTexture = getglobal("ToolShortcut"..index.."ContentBoxTexture");
				end
				boxTexture:Hide();

				local grid_index = selectBackpackGrid;
				if ClientBackpack:getGridItem(grid_index) > 0 then 
					shortcutBoxDisplayTime = 2;     --交换的时候快捷栏按钮闪烁时间
				end
				ClientBackpack:swapItem(grid_index, curSelectGridIndex);
				selectBackpackGrid = -1;
				ShortCut_SelectedIndex = curSelectGridIndex - SHORTCUT_START_INDEX;
			else
				selectBackpackGrid = curSelectGridIndex;
				UpdateTipsFrame(ClientBackpack:getGridItemName(curSelectGridIndex),1,ClientBackpack:getGridItem(curSelectGridIndex), curSelectGridIndex);
				SetOnclikItemBoxTexture( this:GetName() );			
			end
			return;			
		elseif CreateBackpackFrame:IsShown() and selectCreateItemId > 0 then
			if not IsShortcutNotHasItem(selectCreateItemId) then	--快捷栏上没有此物品，把它放到快捷栏相应的位置上
				ClientBackpack:setItem(selectCreateItemId, curSelectGridIndex);
				CurMainPlayer:setCurShortcut(clientId-SHORTCUT_START_INDEX-1);
			end
			shortcutBoxDisplayTime = 2;
			curSelectGridIndex = -1;
			selectCreateItemId = -1;
			HideCreateBoxItemBoxTexture();
			return;		
		elseif StorageBoxFrame:IsShown() then			
			local itemId = ClientBackpack:getGridItem(curSelectGridIndex);
			if itemId > 0 then
				local durable = ClientBackpack:getGridDuration(curSelectGridIndex);
				if ClientBackpack:addStorageItem(curSelectGridIndex, itemId, 1, durable) > 0 then
					UpdateTipsFrame(ClientBackpack:getGridItemName(curSelectGridIndex), 1, ClientBackpack:getGridItem(curSelectGridIndex), curSelectGridIndex);
					ClientBackpack:removeItem(curSelectGridIndex,1);			
				else
					ShowGameTips(DefMgr:getStringDef(56));
				--	UpdateTipsFrame("储物箱已满！", 0);
				end
			end
			
		else
			UpdateTipsFrame(ClientBackpack:getGridItemName(curSelectGridIndex),1,ClientBackpack:getGridItem(curSelectGridIndex), curSelectGridIndex);
			CurMainPlayer:setCurShortcut(clientId-SHORTCUT_START_INDEX-1);			
		end
	
	end
end

-------------------------------------------------------PackGridBtn-------------------------------------------------------------
--背包丢弃物品
function PackGridBtn_OnMouseDownUpdate()	
	if arg1 < 0.6 then return end

	if this:GetClientID() == 0 then return; end
	local grid_index = this:GetClientID() - 1;

	local name = this:GetName();
	if string.find(name, "PackFrameItem") then		
		if ClientBackpack:getGridItem(grid_index) > 0 then
			local tipsContent = "丢弃了"..ClientBackpack:getGridItemName(grid_index).."×"..ClientBackpack:getGridNum(grid_index)
			UpdateTipsFrame(tipsContent, 0);
			if selectBackpackGrid ~= -1 and selectBackpackGrid == grid_index then
				local index 		= selectBackpackGrid - BACKPACK_START_INDEX + 1;
				local boxTexture 	= getglobal("BackpackFramePackFrameItem"..index.."ContentBoxTexture");
				boxTexture:Hide();
				selectBackpackGrid	= -1;
			end
		end
		CurMainPlayer:throwItem(grid_index, ClientBackpack:getGridNum(grid_index));
	elseif string.find(name, "Repair") then
		if string.find(name, "RepairBtn") then return; end	--修理按钮不处理

		if ClientBackpack:getGridItem(grid_index) > 0 then
			IsLongPressTips		= true;
			tipsItemId		= ClientBackpack:getGridItem(grid_index);
			longPressItemId 	= ClientBackpack:getGridItem(grid_index);
			longPressItemTop	= this:GetRealTop();			
			longPressItemBottom 	= this:GetRealBottom();
			longPressItemLeft	= this:GetRealLeft();
			longPressItemRight	= this:GetRealRight();	
			tipsGridIndex = grid_index;
			MItemTipsFrame:Show();
		end
	elseif	string.find(name, "EquipBoxItem") or string.find(name, "RoleFrameEquip") then
		if ClientBackpack:getGridItem(grid_index) > 0 then
			IsLongPressTips		= true;
			tipsItemId		= ClientBackpack:getGridItem(grid_index);
			longPressItemId 	= ClientBackpack:getGridItem(grid_index);
			longPressItemTop	= this:GetRealTop();			
			longPressItemBottom 	= this:GetRealBottom();
			longPressItemLeft	= this:GetRealLeft();
			longPressItemRight	= this:GetRealRight();	
			tipsGridIndex = grid_index;
			MItemTipsFrame:Show();
		end
	elseif	string.find(name, "Furnace") then			--熔炉
		if ClientBackpack:getGridItem(grid_index) > 0 then
			IsLongPressTips		= true;
			tipsItemId		= ClientBackpack:getGridItem(grid_index);
			longPressItemId 	= ClientBackpack:getGridItem(grid_index);
			longPressItemTop	= this:GetRealTop();			
			longPressItemBottom 	= this:GetRealBottom();
			longPressItemLeft	= this:GetRealLeft();
			longPressItemRight	= this:GetRealRight();	
			tipsGridIndex = grid_index;
			MItemTipsFrame:Show();
		end
	end
end

function PackGridBtn_OnMouseUp()
	--长按结束关闭tips
	local name = this:GetName();
	if string.find(name, "EquipBoxItem") or string.find(name, "RoleFrameEquip") then	--装备
		if LongPressItemTipsFrame:IsShown() then
			LongPressItemTipsFrame:Hide();
		end
		if MItemTipsFrame:IsShown() and IsLongPressTips then
			MItemTipsFrame:Hide();
		end
	elseif	string.find(name, "Furnace") then			--熔炉
		if LongPressItemTipsFrame:IsShown() then
			LongPressItemTipsFrame:Hide();
		end
		if MItemTipsFrame:IsShown() and IsLongPressTips then
			MItemTipsFrame:Hide();
		end
	end
	if IsBackpackLongPress then
		IsBackpackLongPress = false;
	end
end

function PackGridBtn_OnClick()
	local btnName = this:GetName();

	local clientId = this:GetClientID();
	if clientId == 0 then return end	
	local grid_index = clientId - 1;

	if string.find(btnName, "PackFrameItem") then				--背包栏	
		if grid_index >= 30 then return end;
		
		if selectBackpackGrid ~= - 1 then
		--	local from_grid = selectBackpackGrid + BACKPACK_START_INDEX - 1;
			ClientBackpack:swapItem(selectBackpackGrid, grid_index);
			
			local index 		= selectBackpackGrid - BACKPACK_START_INDEX + 1;
			local boxTexture 	= getglobal("BackpackFramePackFrameItem"..index.."ContentBoxTexture");
			if selectBackpackGrid >= SHORTCUT_START_INDEX and selectBackpackGrid < 2000 then
				index 		= selectBackpackGrid - SHORTCUT_START_INDEX + 1;
				boxTexture = getglobal("ToolShortcut"..index.."ContentBoxTexture");
			end
			boxTexture:Hide();
			selectBackpackGrid = -1;
		else
			UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 1, ClientBackpack:getGridItem(grid_index), grid_index);
			selectBackpackGrid = clientId - 1;
			SetOnclikItemBoxTexture( this:GetName() );
		end				
	elseif string.find(btnName, "EquipBoxItem") then			--装备面板的装备列表
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 1, ClientBackpack:getGridItem(grid_index), grid_index);
		local equipSlot = ToolType2EquipSlot(ClientBackpack:getGridToolType(grid_index));
		if equipSlot > 0 then
			ClientBackpack:swapItem(grid_index, equipSlot);
		end
	elseif  string.find(btnName, "RoleFrameEquip") then			--装备栏
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 1, ClientBackpack:getGridItem(grid_index), grid_index);
		local togrid_index = GetPackFrameFristNullGridIndex();
		if togrid_index ~= -1 then
			ClientBackpack:swapItem(grid_index, togrid_index);
		end	
	elseif  string.find(btnName, "MiniProduct") then				--2*2制作面板的制作物列表
		SetOnclikItemBoxTexture( this:GetName() );
		local itemId = ClientBackpack:getGridItem(grid_index);
		local enough = ClientBackpack:getGridEnough(grid_index);
		selectProductId = itemId;
		ClientBackpack:updateCraftContainer(itemId, MINICRAFT_START_INDEX, enough);
		UpdateMakeFrameRight(grid_index);		
	elseif string.find(btnName, "MakeFrameStuffGrid") then			--制作面板的材料格子
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 1, ClientBackpack:getGridItem(grid_index), grid_index);	
	elseif string.find(btnName, "CreateBoxItem") then			--创造模式的背包格子
		SetOnclikItemBoxTexture( this:GetName() );
		local itemDef = DefMgr:getItemDef(clientId);
		selectCreateItemId = clientId;
		UpdateTipsFrame(itemDef.Name, 1, clientId, grid_index);
	elseif string.find(btnName, "FurnaceStuffBoxItem") then			--熔炉材料格子
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 0);
		ClientBackpack:swapItem(grid_index, FURNACE_START_INDEX);
	elseif string.find(btnName, "FurnaceFuelBoxItem") then			--熔炉燃料格子
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 0);
		ClientBackpack:swapItem(grid_index, FURNACE_START_INDEX+1);
	elseif string.find(btnName, "FurnaceItem") then				--熔炉格子
		FurnaceItemOnclick(grid_index);
	elseif string.find(btnName, "WaitRepairBoxItem") then			--待修理物品格子
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 0)
		ClientBackpack:swapItem(grid_index, REPAIR_ITEM_GRID_INDEX);	
	elseif string.find(btnName, "RepairStuffBoxItem") then			--修理材料格子
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 0);	
		PlaceRepairStuff(grid_index);
	elseif string.find(btnName, "RepairItem") then				--修理格子
		RepairItemOnclick(grid_index);
	end
end

-----------------------------------------CraftingTableGridBtn-----------------------------------------------
local longPressTime = 0

function CraftingTableGridBtn_OnMouseDown()
	local btnName = this:GetName();

	if string.find(btnName,"StorageLeftBox") then
		IsBackpackLongPress = false;
	elseif string.find(btnName,"StorageRightBox") then
		IsStorageBoxLongPress = false;
	end
end

function CraftingTableGridBtn_OnMouseUp()
	local btnName = this:GetName();

	if string.find(btnName,"StorageLeftBox") then 				--储物箱面板的物品格子
		if IsBackpackLongPress then
			MoveProgressBarFrame:Hide();
			longPressTime = 0;
		end
	elseif string.find(btnName,"StorageRightBox") then 			--长按储物箱面板的储物箱格子
		if IsStorageBoxLongPress then
			MoveProgressBarFrame:Hide();
			longPressTime = 0;
		end
	end
end

function CraftingTableGridBtn_OnMouseDownUpdate()
	local clientId = this:GetClientID();
	if clientId == 0 then return end

	local btnName = this:GetName();
	local grid_index = clientId - 1;
	
	if string.find(btnName,"StorageLeftBox") or string.find(btnName,"StorageRightBox") then 	--长按储物箱面板的格子
		if arg1 > 0.2 and ClientBackpack:getGridItem(grid_index) > 0 then			
			if string.find(btnName,"StorageLeftBox") and not IsBackpackLongPress then
 				IsBackpackLongPress = true;
				SetMoveStorageItemIndex(grid_index);
				MoveProgressBarFrame:Show();
				MoveProgressBarFrame:SetPoint("bottom", btnName, "top", 0, 0);
				longPressTime = arg1;				
			elseif string.find(btnName,"StorageRightBox") and not IsStorageBoxLongPress then
				IsStorageBoxLongPress = true;
				SetMoveStorageItemIndex(grid_index);
				MoveProgressBarFrame:Show();
				MoveProgressBarFrame:SetPoint("bottom", btnName, "top", 0, 0);
				longPressTime = arg1;
			end
			
			if arg1-longPressTime > 1.0 then
				MoveProgressBar:SetValue(1);
				MoveProgressBarFrameDesc:SetText("移动"..ClientBackpack:getGridNum(grid_index).."个"..ClientBackpack:getGridItemName(grid_index));
			else
				MoveProgressBar:SetValue(arg1-longPressTime);
				local num = math.floor( ClientBackpack:getGridNum(grid_index)*(arg1-longPressTime) );
				MoveProgressBarFrameDesc:SetText("移动"..num.."个"..ClientBackpack:getGridItemName(grid_index));
			end	
		end
	end
end

function CraftingTableGridBtn_OnClick()
	local clientId = this:GetClientID();
	if clientId == 0 then return end

	local btnName = this:GetName();
	local grid_index = clientId - 1;

	if string.find(btnName,"NormalProduct") then 				--工作台制作物列表
		SetOnclikItemBoxTexture( this:GetName() );
		local itemId = ClientBackpack:getGridItem(grid_index);
		local enough = ClientBackpack:getGridEnough(grid_index);	
		selectNormalProductId = itemId; 		
		ClientBackpack:updateCraftContainer(itemId, CRAFT_START_INDEX, enough);
		UpdateCraftingFrameRight(grid_index);
	elseif string.find(btnName,"CraftingFrameStuffGrid") then 		--工作台的材料格子
		UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 1, ClientBackpack:getGridItem(grid_index), grid_index);
	elseif string.find(btnName,"StorageLeftBox") then 			--储物箱面板的物品格子
		if IsBackpackLongPress then
			return;
		end

		local itemId = ClientBackpack:getGridItem(grid_index);
		if itemId > 0 then
			local durable = ClientBackpack:getGridDuration(grid_index);
			if ClientBackpack:addStorageItem(grid_index, itemId, 1, durable) > 0 then
				UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 1, ClientBackpack:getGridItem(grid_index), grid_index);
				ClientBackpack:removeItem(grid_index,1);
			else
				ShowGameTips(DefMgr:getStringDef(56));
			--	UpdateTipsFrame("储物箱已满！", 0);
			end
		end
	elseif string.find(btnName,"StorageRightBox") then 			--储物箱面板的储物箱格子
		if IsStorageBoxLongPress then
			return;
		end
		local itemId = ClientBackpack:getGridItem(grid_index);
		if itemId > 0 then
			local durable 	= ClientBackpack:getGridDuration(grid_index);
			local num	= ClientBackpack:getGridNum(grid_index);
			if ClientBackpack:addItem(grid_index, itemId, 1, durable, 2) == 0 then
				CurMainPlayer:throwItem(grid_index, 1);
			end
			UpdateTipsFrame(ClientBackpack:getGridItemName(grid_index), 1, ClientBackpack:getGridItem(grid_index), grid_index);
			ClientBackpack:removeItem(grid_index, 1);
		end
	end
end