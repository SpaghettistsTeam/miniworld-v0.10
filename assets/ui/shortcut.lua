
MAX_SHORTCUT = 10
ShortCut_SelectedIndex = -1

function ShortCutFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");
	this:RegisterEvent("GE_SHORTCUT_SELECTED");
	this:RegisterEvent("GE_HIDE_UI");

	for i=1,10,1 do
		local ShortcutBtn = getglobal("ToolShortcut"..i);
		local x = math.floor((736-125)*(i-1)/9) + 125
		ShortcutBtn:SetPoint("TOPLEFT", "ShotcutFrame", "TOPLEFT", x, 66);
	end
end

function ShortCutFrame_UpdateOneGrid(grid_index)

	local n = grid_index+1;
	if grid_index >= SHORTCUT_START_INDEX then
		n = n - SHORTCUT_START_INDEX
	end

	local ShortcutBtn = getglobal("ToolShortcut"..n);
	local ShortcutIcon = getglobal("ToolShortcut"..n.."ContentIcon");
	local ShortcutNum = getglobal("ToolShortcut"..n.."ContentCount");
	local durbar = getglobal("ToolShortcut"..n.."ContentDuration");
	local durnum = getglobal("ToolShortcut"..n.."ContentDurationNum");

	UpdateItemIconCountDurable(ShortcutIcon, ShortcutNum, durbar, durnum, grid_index);
	if n-1 == ShortCut_SelectedIndex then
		ClientCurGame:setCurToolID(ClientBackpack:getGridItem(grid_index));
	end
end

function ShortCutFrame_UpdateAllGrids()
	for i=0, 9, 1 do
		ShortCutFrame_UpdateOneGrid(SHORTCUT_START_INDEX+i)
	end
end

function ShortCutFrame_Selected(index)
	if ShortCut_SelectedIndex >= 0 then
		local selbox = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentBoxTexture");
		selbox:Hide()
	end

	ShortCut_SelectedIndex = index;
	local selbox = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentBoxTexture");
	selbox:Show();
end

IsHideUI = false;
function ShortCutFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();

	if arg1 == "GE_BACKPACK_CHANGE" then
		local grid_index = ge.body.backpack.grid_index;
		if grid_index>=SHORTCUT_START_INDEX and grid_index<SHORTCUT_START_INDEX+1000 then
			ShortCutFrame_UpdateOneGrid(grid_index);
		elseif grid_index < 0 then
			ShortCutFrame_UpdateAllGrids();
		end
	elseif arg1 == "GE_SHORTCUT_SELECTED" then
		ShortCutFrame_Selected(ge.body.shortcut.selectgrid);
	elseif arg1 == "GE_HIDE_UI" then
		local isHide = ge.body.uiHide.isHide;
		setUIState(isHide);
		IsHideUI = isHide;
	end
end

local t_UIName = {"PlayerStatusFrame", "ShotcutFrame", "BackpackGrids", "ItemTipsFrame", "BackpackFrame", "PopupUIBlackFrame",
			"ChatInputFrame", "ChatContentFrame", "CraftingTableFrame", "DeathFrame", "EquipFrame", "FurnaceFrame",
			"GameOptionFrame", "StorageBoxFrame", }
function setUIState(isHide)
	if isHide then
		for i=1, #(t_UIName) do
			local frame = getglobal(t_UIName[i]);
			if frame:IsShown() then
				frame:Hide();
			end
		end
	else
		ShotcutFrame:Show();
		PlayerStatusFrame:Show();
	end
end

function PlayerStatusFrame_OnLoad()
	this:RegisterEvent("GE_PLAYERATTR_CHANGE")
	this:RegisterEvent("GE_SHOW_OXYGEN")
end

function PlayerStatusFrame_OnShow()
	PlayerHPBar:SetCurValue(MainPlayerAttrib:getHP()/MainPlayerAttrib:getMaxHP(), true)
	PlayerFoodBar:SetCurValue(MainPlayerAttrib:getFoodLevel()/20, true)
	PlayerOxygenBar:SetCurValue(MainPlayerAttrib:getOxygen()/10, true)
end

function PlayerStatusFrame_OnEvent()
	if arg1 == "GE_PLAYERATTR_CHANGE" then
		PlayerHPBar:SetCurValue(MainPlayerAttrib:getHP()/MainPlayerAttrib:getMaxHP(), false)
		PlayerFoodBar:SetCurValue(MainPlayerAttrib:getFoodLevel()/20, false)
		PlayerOxygenBar:SetCurValue(MainPlayerAttrib:getOxygen()/10, false)

	elseif arg1 == "GE_SHOW_OXYGEN" then
		local ge = GameEventQue:getCurEvent()
		if ge.body.oxygen.show then PlayerOxygenBar:Show()
		else PlayerOxygenBar:Hide() end
	end
end