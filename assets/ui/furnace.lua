
CurAttachedFurnace = nil

function FurnaceFrame_OnLoad()
	this:RegisterEvent("GE_FURNACE_PROGRESS");
end

function FurnaceFrame_OnShow()
	BackpackGrids:SetPoint("TOPLEFT", "FurnaceFrame", "TOPLEFT", 30, 325);
	BackpackGrids:Show()
	blackscr = getglobal("PopupUIBlackFrame");
	blackscr:Show();
end

function FurnaceFrame_OnHide()
	ClientBackpack:detachContainer(CurAttachedFurnace)

	BackpackGrids:Hide()
	blackscr = getglobal("PopupUIBlackFrame");
	blackscr:Hide();
end

function FurnaceFrame_OnEvent()
	if CurAttachedFurnace == nil then return end

	if arg1 == "GE_FURNACE_PROGRESS" then
		local fuel = CurAttachedFurnace:getHeatPercent()
		local mticks = CurAttachedFurnace:getMeltTicksPercent()

		FuelProgressBar:SetValue(fuel);
		SmeltProgressBar:SetValue(mticks);
	end
end

function FurnaceFrameCloseBtn_OnClick()
	AccelKey_E()
end