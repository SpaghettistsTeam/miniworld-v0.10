
function CraftingTableFrame_OnLoad()
	for i=1,3,1 do
		for j=1, 3, 1 do
			local usebtn = getglobal("CraftingBtn"..((i-1)*3+j));
			usebtn:SetPoint("TOPLEFT", "CraftingTableFrame", "TOPLEFT", (j-1)*67+74, (i-1)*67+135);
		end
	end
end

function CraftingTableFrame_OnShow()
	BackpackGrids:SetPoint("TOPLEFT", "CraftingTableFrame", "TOPLEFT", 13, 365);
	BackpackGrids:Show()
	blackscr = getglobal("PopupUIBlackFrame");
	blackscr:Show();
end

function ThrowCraftingTableMtls()
	for i=0,2,1 do
		for j=0, 2, 1 do
			index = i*3 + j + CRAFT_START_INDEX
			num = ClientBackpack:getGridNum(index)
			if num > 0 then
				CurMainPlayer:throwItem(index, num)
			end
		end
	end
end

function CraftingTableFrame_OnHide()
	ThrowCraftingTableMtls()

	BackpackGrids:Hide()
	blackscr = getglobal("PopupUIBlackFrame");
	blackscr:Hide();
end

function CraftingTableFrameCloseBtn_OnClick()
	AccelKey_E()
end