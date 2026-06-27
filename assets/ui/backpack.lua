
MAX_SHORTCUT = 10
ShortCut_SelectedIndex = -1

function GridIndex2BtnName(grid_index)
	local n = grid_index+1;

	if grid_index >= FURNACE_START_INDEX then
		n = n - FURNACE_START_INDEX
		return "FurnaceBtn"..n

	elseif grid_index >= EQUIP_START_INDEX then
		n = n - EQUIP_START_INDEX
		return "EquipItemBtn"..n

	elseif grid_index >= MOUSE_PICKITEM_INDEX then
		return "MousePickItem"

	elseif grid_index >= COMMON_START_INDEX then
		n = n - COMMON_START_INDEX
		return "CommonUseItemBtn"..n

	elseif grid_index >= CRAFT_START_INDEX then
		n = n - CRAFT_START_INDEX
		return "CraftingBtn"..n

	elseif grid_index >= STORAGE_START_INDEX then
		n = n - STORAGE_START_INDEX
		return "StorageGridItem"..n

	elseif grid_index >= MINICRAFT_START_INDEX then
		n = n - MINICRAFT_START_INDEX
		return "MiniCraftingBtn"..n

	elseif grid_index >= SHORTCUT_START_INDEX then
		n = n - SHORTCUT_START_INDEX
		return "BackpackShortcut"..n
	
	else
		return "BackpackItem"..n;
	end
end

function UpdateItemIconCountDurable(iconbtn, numtext, durbar, durnum, grid_index)
	local itemid = ClientBackpack:getGridItem(grid_index);
	if itemid == 0 then
		iconbtn:SetTextureHuires(ClientMgr:getNullItemIcon());
		numtext:SetText("");
		durbar:Hide();
		durnum:Hide();
		return;
	end

	local u = 0;
	local v = 0;
	local width = 0;
	local height = 0;
	local r = 255;
	local g = 255;
	local b = 255;
	h, u, v, width, height, r, g, b = ClientMgr:getItemIcon(itemid, u, v, width, height, r, g, b);
	iconbtn:SetTextureHuires(h);
	iconbtn:SetTexUV(u, v, width, height);
	iconbtn:SetColor(r, g, b);

	count = ClientBackpack:getGridNum(grid_index);
	if count > 1 then
		numtext:SetText(count);
	else
		numtext:SetText("");
	end

	maxdur = ClientBackpack:getGridMaxDuration(grid_index);
	if maxdur > 0 then
		dur = ClientBackpack:getGridDuration(grid_index)
		if dur < 0 then dur = 0 end
		durnum:SetText(dur);
		dur = dur/maxdur;

		durbar:SetTexUV(143, 698, dur*60, 9)
		durbar:SetWidth(60*dur)

		if dur > 0.8 then durbar:SetColor(0, 255, 0) --绿色
		elseif dur > 0.6 then durbar:SetColor(0, 128, 0) --深绿色
		elseif dur > 0.4 then durbar:SetColor(128, 128, 0) --棕色
		elseif dur > 0.2 then durbar:SetColor(255, 255, 0) --橙色
		else durbar:SetColor(255, 0, 0) end --红色

		durnum:Show();

		if dur == 1.0 then durbar:Hide()
		else durbar:Show() end
	else
		durbar:Hide()
	end
end

function BackpackGrids_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");

	for i=1,3,1 do
		for j=1, 10, 1 do
			local itembtn = getglobal("BackpackItem"..((i-1)*10+j));
			itembtn:SetPoint("TOPLEFT", "BackpackGrids", "TOPLEFT", (j-1)*66, (i-1)*66);
		end
	end

	for i=1,10,1 do
		local ShortcutBtn = getglobal("BackpackShortcut"..i);
		ShortcutBtn:SetPoint("TOPLEFT", "BackpackGrids", "TOPLEFT", (i-1)*66, 215);
	end
end

function BackpackGrids_UpdateOneGrid(grid_index)
	
	local name = GridIndex2BtnName(grid_index);
	local iconbtn = getglobal(name.."ContentIcon");
	if iconbtn == nil then
		DebugString(name.."  grid_index="..grid_index);
	end
	local numtext = getglobal(name.."ContentCount");
	local durbar = getglobal(name.."ContentDuration");
	local durnum = getglobal(name.."ContentDurationNum");
	
	UpdateItemIconCountDurable(iconbtn, numtext, durbar, durnum, grid_index);
end

function BackpackGrids_UpdateAllGrids()
	for i=0, 9, 1 do
		BackpackGrids_UpdateOneGrid(SHORTCUT_START_INDEX+i)
	end
	for i=0, 29, 1 do
		BackpackGrids_UpdateOneGrid(i)
	end
	for i=0, 3, 1 do
		BackpackGrids_UpdateOneGrid(EQUIP_START_INDEX+i)
	end
end

function BackpackGrids_OnEvent()
	local ge = GameEventQue:getCurEvent();
	local grid_index = ge.body.backpack.grid_index;

	if arg1 == "GE_BACKPACK_CHANGE" then
		if grid_index < 0 then
			BackpackGrids_UpdateAllGrids()
		else
			BackpackGrids_UpdateOneGrid(grid_index);
		end
	end
end

function BackpackFrame_OnLoad()
	for i=1,2,1 do
		for j=1, 3, 1 do
			local usebtn = getglobal("CommonUseItemBtn"..((i-1)*3+j));
			usebtn:SetPoint("TOPLEFT", "BackpackFrame", "TOPLEFT", (j-1)*55+439, (i-1)*55+63);
		end
	end
end

function BackpackFrame_OnShow()
	BackpackGrids:SetPoint("TOPLEFT", "BackpackFrame", "TOPLEFT", 30, 214);
	BackpackGrids:Show()
	EquipFrame:Show()
	blackscr = getglobal("PopupUIBlackFrame");
	blackscr:Show();
end

function ThrowMiniCraftingMtls()
	for i=0, 3, 1 do
		index = i + MINICRAFT_START_INDEX
		num = ClientBackpack:getGridNum(index)
		if num > 0 then
			CurMainPlayer:throwItem(index, num)			
		end
	end
end

function BackpackFrame_OnHide()
	ThrowMiniCraftingMtls()

	BackpackGrids:Hide()
	EquipFrame:Hide()
	blackscr = getglobal("PopupUIBlackFrame");
	blackscr:Hide();
end

function BackpackFrameCloseBtn_OnClick()
	AccelKey_E()
end

function BackpackFrameSortBtn_OnClick()
end