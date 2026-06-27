
function CancelOperateUI(level)
	tipsframe = getglobal("ItemTipsFrame")
	if tipsframe:IsShown() then
		tipsframe:Hide()
	end

	if ChatInputFrame:IsShown() then
		ChatInputFrame:Hide()
		return true
	end

	craftframe = getglobal("CraftingTableFrame");
	if craftframe:IsShown() then
		craftframe:Hide();
		return true
	end

	if FurnaceFrame:IsShown() then
		FurnaceFrame:Hide();
		return true
	end

	bpframe = getglobal("BackpackFrame");
	if bpframe:IsShown() then
		bpframe:Hide();
		return true
	end

	if StorageBoxFrame:IsShown() then
		StorageBoxFrame:Hide()
		return true
	end

	if level==1 and GameOptionFrame:IsShown() then
		GameOptionFrame:Hide()
		return true
	end

	return false
end

function AccelKey_E()
	if ClientCurGame:isOperateUI() then
		if CancelOperateUI(0) then 
			ClientCurGame:setOperateUI(false)
		end
	else
		BackpackFrame:Show();
		ClientCurGame:setOperateUI(true);
	end

end

function AccelKey_Q()
	local player = ClientCurGame:getMainPlayer()
	player:throwItem(player:getCurShortcut()+SHORTCUT_START_INDEX, 1)
	--[[
	if ClientCurGame:isOperateUI() then
		if CurSelectGridIndex >= 0 then player:throwItem(CurSelectGridIndex, 1) end
	else
		player:throwItem(player:getCurShortcut()+SHORTCUT_START_INDEX, 1)
	end]]
end

function AccelKey_Enter()
	if not ClientCurGame:isOperateUI() then
		chatframe = getglobal("ChatInputFrame");
		chatframe:Show();
		ClientCurGame:setOperateUI(true);
	end
end

function AccelKey_Slash()
	AccelKey_Enter()
end

function AccelKey_Escape()
	if ClientCurGame:getName() == "SurviveGame" then
		if ClientCurGame:isOperateUI() then
			if CancelOperateUI(1) then 
				ClientCurGame:setOperateUI(false)
			end
		else
			GameOptionFrame:Show()
			ClientCurGame:setOperateUI(true)
		end
	elseif ClientCurGame:getName() == "MainMenuStage" then
		if NewWorldFrame:IsShown() then
			CancelCreateNewWorld()
		end
	end
end

function AccelKey_Number(n)
	if ClientCurGame:isOperateUI() then
		if CurSelectGridIndex < 0 then return end

		srcindex = n-1+SHORTCUT_START_INDEX
		srcnum = ClientBackpack:getGridNum(srcindex)
		if srcnum == 0 then return end
	
		if ClientBackpack:getGridNum(CurSelectGridIndex) > 0 then
			ClientBackpack:swapItem(srcindex, CurSelectGridIndex)
		else
			ClientBackpack:moveItem(srcindex, CurSelectGridIndex, srcnum)
		end
	else
		CurMainPlayer:setCurShortcut(n-1)
	end
end

function AccelKey_Num0()
	AccelKey_Number(10)	
end
function AccelKey_Num1()
	AccelKey_Number(1)
end
function AccelKey_Num2()
	AccelKey_Number(2)
end
function AccelKey_Num3()
	AccelKey_Number(3)
end
function AccelKey_Num4()
	AccelKey_Number(4)
end
function AccelKey_Num5()
	AccelKey_Number(5)
end
function AccelKey_Num6()
	AccelKey_Number(6)
end
function AccelKey_Num7()
	AccelKey_Number(7)
end
function AccelKey_Num8()
	AccelKey_Number(8)
end
function AccelKey_Num9()
	AccelKey_Number(9)
end
