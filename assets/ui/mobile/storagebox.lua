STORAGEBOX_GRID_MAX = 60;     	--储物箱格子
CurAttachedStorage = nil
MoveStorageItemIndex = -1;  	--移动储物箱的格子


function StorageBoxFrame_Onload()
	this:RegisterEvent("GE_BACKPACK_CHANGE");
	this:RegisterEvent("GE_UPDATE_STORAGEBOX_POINT");

	for i=1,6 do
		for j=1,5 do
			local itembtn = getglobal("StorageLeftBoxItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "StorageLeftBoxPlane", "topleft", (j-1)*91, (i-1)*93);
		end
	end

	for i=1,12 do
		for j=1,5 do
			local itembtn = getglobal("StorageRightBoxStorageItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "StorageRightBoxPlane", "topleft", (j-1)*91, (i-1)*93);
		end
	end
end

function StorageBoxFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();
	local grid_index = ge.body.backpack.grid_index;

	if arg1 == "GE_BACKPACK_CHANGE" then
		if StorageBoxFrame:IsShown() then
			if grid_index >= BACKPACK_START_INDEX and grid_index < BACKPACK_START_INDEX + 1000 then
				UpdateLeftBoxOneItem(grid_index);
			end
			if grid_index >= STORAGE_START_INDEX and grid_index < STORAGE_START_INDEX + 1000 then
			--	UpdateRightBoxOneStorageItem(STORAGE_START_INDEX);
				UpdateRightBoxAllStorageItem();
			end
		end
	end

	if arg1 == "GE_UPDATE_STORAGEBOX_POINT" then
		if StorageBoxFrame:IsShown() then
			UpdateRightBoxPoint(grid_index);
		end
	end
end

function UpdateLeftBoxAllItem()
	for i=1,BACK_PACK_GRID_MAX do
		if i <= 30 then
			UpdateLeftBoxOneItem(BACKPACK_START_INDEX+i-1);
		end
	end
end

function UpdateLeftBoxOneItem(grid_index)
	local n = grid_index+1;
	if grid_index >= BACKPACK_START_INDEX then
		n = n - BACKPACK_START_INDEX
	end

	local icon = getglobal("StorageLeftBoxItem"..n.."ContentIcon");
	local num = getglobal("StorageLeftBoxItem"..n.."ContentCount");
	local durbar = getglobal("StorageLeftBoxItem"..n.."ContentDuration");

	UpdateItemIconCount(icon, num, durbar, grid_index);
end

local hasItemNum = 0;
function UpdateRightBoxAllStorageItem()
	local grid_num = 30
	if CurAttachedStorage:getAppend() ~= nil then
		grid_num = STORAGEBOX_GRID_MAX;
	end

	for i=1, grid_num do
		UpdateRightBoxOneStorageItem(STORAGE_START_INDEX+i-1);
	end	
end

local t_pointInfo ={
			{startY=105}
			}

function UpdateRightBoxPoint(grid_index)
	local grid_num 	= 30;
	local rows	= 6;
	if CurAttachedStorage:getAppend() ~= nil then
		grid_num	= STORAGEBOX_GRID_MAX;
		rows		= 12;
	end
	
--	105 667 11 573 -83 479 -177 385
--[[
	local top = StorageRightBoxPlane:GetRealTop();
	local beginrow  = 1;
	local endrow	= 5;
	for i=1, rows do
		top1 = 105 - (i-1)*94;
		top2 = 105 - i*94;
		if top1 == top then
			beginrow 	= i;
			endrow 		= i+4;
		else if top1 > top and top2 < top then
			beginrow	= i+1;
			endrow 		= i+3;
		end
	end
--]]	

--	StorageRightBoxPlane:GetRealTop();
--	StorageRightBoxPlane:GetRealBottom();
	if grid_index >= STORAGE_START_INDEX and grid_index < STORAGE_START_INDEX+grid_num then
		local index = grid_index - STORAGE_START_INDEX + 1;
		if index > 25 then
			offsetY = math.ceil((index - 25)/5) * 93;
		else
			offsetY = 0;
		end
		StorageRightBoxPlane:SetPoint("topleft", "StorageRightBox", "topleft", 0, -offsetY);
		StorageRightBox:setCurOffsety(-offsetY);
	end
end

function UpdateRightBoxOneStorageItem(grid_index)
	local n = grid_index+1;
	if grid_index >= STORAGE_START_INDEX then
		n = n - STORAGE_START_INDEX
	end

	local icon = getglobal("StorageRightBoxStorageItem"..n.."ContentIcon");
	local num = getglobal("StorageRightBoxStorageItem"..n.."ContentCount");
	local durbar = getglobal("StorageRightBoxStorageItem"..n.."ContentDuration");

	UpdateItemIconCount(icon, num, durbar, grid_index);
end

function HideStorageBoxFrameAllLeftItemBoxTexture()
	for i=1,BACK_PACK_GRID_MAX do
		local boxTexture = getglobal("StorageLeftBoxItem"..i.."ContentBoxTexture");
		boxTexture:Hide();
	end
end

function HideStorageBoxFrameAllRightItemBoxTexture()
	for i=1,STORAGEBOX_GRID_MAX do
		local boxTexture = getglobal("StorageRightBoxStorageItem"..i.."ContentBoxTexture");
		Hide();
	end
end

function StorageBoxFrame_OnShow()
	HideAllFrame("StorageBoxFrame");
	if CurAttachedStorage:getAppend() == nil then
		StorageRightBoxPlane:SetSize(468, 562);
		for i=31,STORAGEBOX_GRID_MAX do
			local itembtn = getglobal("StorageRightBoxStorageItem"..i);
			itembtn:Hide();
		end
	else
		StorageRightBoxPlane:SetSize(468, 1195);
		for i=31,STORAGEBOX_GRID_MAX do
			local itembtn = getglobal("StorageRightBoxStorageItem"..i);
			itembtn:Show();
		end
	end
	UpdateLeftBoxAllItem();
	UpdateRightBoxAllStorageItem();
end

function StorageBoxFrame_OnHide()
	ClientBackpack:detachContainer(CurAttachedStorage)
	CurAttachedStorage = nil
	StorageRightBox:resetOffsetPos();
	StorageLeftBox:resetOffsetPos();
	ClientCurGame:setOperateUI(false);
end

function StorageBoxFrameCloseBtn_OnMouseDown()
	local btnIcon = getglobal("StorageBoxFrameCloseBtnIcon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(43,43);
end

function StorageBoxFrameCloseBtn_OnMouseUp()
	local btnIcon = getglobal("StorageBoxFrameCloseBtnIcon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(55,56);	
end

function StorageBoxFrameCloseBtn_OnClick()	
	StorageBoxFrame:Hide();
end

function StorageBoxFrameTidyBtn_OnClick()
	ClientBackpack:sortStorageBox();
	UpdateRightBoxAllStorageItem();
end

function SetMoveStorageItemIndex(grid_index)
	MoveStorageItemIndex = grid_index;
end

----------------------------------MoveProgressBarFrame-----------------------
function MoveProgressBarFrame_OnHide()
	local num = math.floor(ClientBackpack:getGridNum(MoveStorageItemIndex)*MoveProgressBar:GetValue());
	
	if MoveStorageItemIndex >= BACKPACK_START_INDEX and MoveStorageItemIndex < SHORTCUT_START_INDEX+1000 and num > 0 then
		if ClientBackpack:addStorageItem( MoveStorageItemIndex, ClientBackpack:getGridItem(MoveStorageItemIndex),num ) > 0 then
			ClientBackpack:removeItem(MoveStorageItemIndex,num);			
		else
			ShowGameTips(DefMgr:getStringDef(56));
			--UpdateTipsFrame("储物箱已满！", 0);
		end
	elseif MoveStorageItemIndex >= STORAGE_START_INDEX and MoveStorageItemIndex < STORAGE_START_INDEX+1000 and num > 0 then
		local durable =	ClientBackpack:getGridDuration(MoveStorageItemIndex);
		ClientBackpack:addItem(MoveStorageItemIndex, ClientBackpack:getGridItem(MoveStorageItemIndex), num, durable, 2);
		ClientBackpack:removeItem(MoveStorageItemIndex,num);
	end

	MoveStorageItemIndex = -1;
	MoveProgressBarFrameDesc:SetText("");
end