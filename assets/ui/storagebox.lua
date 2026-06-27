
CurAttachedStorage = nil

function StorageBoxFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");

	for i=1,6,1 do
		for j=1, 10, 1 do
			local itembtn = getglobal("StorageGridItem"..((i-1)*10+j));
			itembtn:SetPoint("TOPLEFT", "StorageGrids", "TOPLEFT", (j-1)*66, (i-1)*66);
		end
	end
end

function StorageBoxFrame_OnEvent()
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

function StorageBoxFrame_OnShow()
	local sizex, sizey = 683, 676

	if CurAttachedStorage:getAppend() == nil then
		StorageGridsEx:Hide()
		StorageBoxFrameBkgGrid2:Hide()
		StorageBoxFrameBkgTitle2:SetPoint("TOPLEFT", "StorageBoxFrameBkgTitle1", "BOTTOMLEFT", 0, 172)
	else
		StorageGridsEx:Show()
		StorageBoxFrameBkgGrid2:Show()
		StorageBoxFrameBkgTitle2:SetPoint("TOPLEFT", "StorageBoxFrameBkgTitle1", "BOTTOMLEFT", 0, 381)
		sizey = 881
	end

	StorageBoxFrameBkgGrid3:SetPoint("TOPLEFT", "StorageBoxFrameBkgTitle2", "BOTTOMLEFT", 5, -20)
	BackpackGrids:SetPoint("TOPLEFT", "StorageBoxFrameBkgGrid3", "TOPLEFT", 24, 3);
	BackpackGrids:Show()
	StorageBoxFrame:SetSize(sizex, sizey)
	UIFrameMgr:ForceUpdateFramePos()

	blackscr = getglobal("PopupUIBlackFrame");
	blackscr:Show();
end

function StorageBoxFrame_OnHide()
	ClientBackpack:detachContainer(CurAttachedStorage)
	CurAttachedStorage = nil

	BackpackGrids:Hide()
	blackscr = getglobal("PopupUIBlackFrame");
	blackscr:Hide();
end

function StorageBoxFrameCloseBtn_OnClick()
	AccelKey_E()
end