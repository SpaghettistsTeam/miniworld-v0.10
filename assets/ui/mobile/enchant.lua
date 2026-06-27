ENCHANT_GRID_MAX 	= 30;
ENCHANT_ATTR_MAX	= 5;		--最大属性条数
Enchant_Type		= 1;  		--1对物品附魔，2对卷轴附魔
EnchantBoxType		= 0;		--0上面的格子 1下面的格子
EnchantAttrBtnName	= nil;		--要显示tips的属性条控件名

function EnchantCloseBtn_OnMouseDown()
	local btnIcon = getglobal("EnchantFrameCloseBtnIcon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(37,37);
end

function EnchantCloseBtn_OnMouseUp()
	local btnIcon = getglobal("EnchantFrameCloseBtnIcon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(47,48);
end

function EnchantFrameCloseBtn_OnClick()
	EnchantFrame:Hide();
end

function EnchantFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");
	this:RegisterEvent("GE_PLAYERATTR_CHANGE")

	for i=1,ENCHANT_GRID_MAX/5 do
		for j=1,5 do
			local itembtn = getglobal("EnchantTopBoxItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "EnchantTopBoxPlane", "topleft", (j-1)*82, (i-1)*85);
		end
	end

	for i=1,ENCHANT_GRID_MAX/5 do
		for j=1,5 do
			local itembtn = getglobal("EnchantBottomBoxItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "EnchantBottomBoxPlane", "topleft", (j-1)*82, (i-1)*85);
		end
	end

	for i=1, ENCHANT_ATTR_MAX do	
		local attr 	= getglobal("EnchantFrameAttr"..i);
		attr:SetPoint("topleft", "EnchantFrameGreenLine", "topright", 5, (i-1)*50 - 75);		
	end 
end

function EnchantFrame_OnEvent()
	if arg1 == "GE_BACKPACK_CHANGE" then
		if EnchantFrame:IsShown() then
			local ge = GameEventQue:getCurEvent();
			local grid_index = ge.body.backpack.grid_index;
			if grid_index >= BACKPACK_START_INDEX and grid_index < BACKPACK_START_INDEX+1006 then
				UpdateEnchatBoxOneGrid(grid_index);
			elseif grid_index >= ENCHANT_START_INDEX and grid_index < ENCHANT_START_INDEX+2 then
				UpdateEnchantItemGrid();
				UpdateEnchatAttr();
			end
		end	
	elseif arg1 == "GE_PLAYERATTR_CHANGE" then
		if EnchantFrame:IsShown() then
			local starNum = math.floor(MainPlayerAttrib:getExp()/100);
			EnchantFrameStarText:SetText(starNum);
		end
	end
end

function EnchantFrame_OnShow()
	HideAllFrame("EnchantFrame");

	EnchantTopBox:resetOffsetPos();
	EnchantBottomBox:resetOffsetPos();
	for i=1, 5 do 
		local attr = getglobal("EnchantFrameAttr"..i);
		local desc = getglobal("EnchantFrameAttr"..i.."Desc");
		desc:Clear();
	
		attr:SetClientUserData(0, 0);
		attr:SetClientUserData(1, 0);
		attr:SetClientUserData(2, 0);
	end
	if Enchant_Type ==  1 then
		EnchantFrameTopTitle:Show();
		EnchantFrameTopTitle1:Hide();
		EnchantFrameBottomTitle:Show();
		EnchantFrameBottomTitle1:Hide();
	elseif Enchant_Type == 2 then
		EnchantFrameTopTitle:Hide();
		EnchantFrameTopTitle1:Show();
		EnchantFrameBottomTitle:Hide();
		EnchantFrameBottomTitle1:Show();
	end

	UpdateEnchantBoxGrid();
	UpdateEnchantItemGrid();

	local starNum = math.floor(MainPlayerAttrib:getExp()/100);
	EnchantFrameStarText:SetText(starNum);

	EnchantFrameEnchanntItem1Name:SetText("");
	EnchantFrameEnchanntItem2Name:SetText("");
end

function UpdateEnchatBoxOneGrid(grid_index)

	local itemId = ClientBackpack:getGridItem(grid_index);
	local enchantNum = ClientBackpack:getGridEnchantNum(grid_index);
	local itemDef = DefMgr:getItemDef(itemId);	
	if itemDef ~= nil then
		if Enchant_Type == 1 then
			if itemDef.EnchantTag == 1 or itemDef.EnchantTag == 3 then
				EnchantBoxType = 0;
			end
			if enchantNum > 0 and (itemDef.EnchantTag == 2 or itemDef.EnchantTag == 3) then
				EnchantBoxType = 1;
			end
		elseif Enchant_Type == 2 then
			if enchantNum > 0 and (itemDef.EnchantTag == 1 or itemDef.EnchantTag == 3) then
				EnchantBoxType = 1;
			end
			if itemDef.EnchantTag == 2 or itemDef.EnchantTag == 3 then
				EnchantBoxType = 0;
			end
		end
	end


	if EnchantBoxType == 0 then
		for i=1, ENCHANT_GRID_MAX do
			local topItem 		= getglobal("EnchantTopBoxItem"..i);
			local topItemIcon 	= getglobal("EnchantTopBoxItem"..i.."ContentIcon");
			local topItemNum 	= getglobal("EnchantTopBoxItem"..i.."ContentCount");
			local topItemDurbar 	= getglobal("EnchantTopBoxItem"..i.."ContentDuration");

			local clientId = topItem:GetClientID();
			if clientId ~= 0 and clientId == grid_index+1 then
				if ClientBackpack:getGridItem(grid_index) > 0 then
					UpdateItemIconCount(topItemIcon, topItemNum, topItemDurbar, grid_index);
				else
					topItem:SetClientID(0);
					topItemIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
					topItemNum:SetText("");
					topItemDurbar:Hide();
				end
				return;
			end
		end

		for i=1, ENCHANT_GRID_MAX do
			local topItem 		= getglobal("EnchantTopBoxItem"..i);
			local topItemIcon 	= getglobal("EnchantTopBoxItem"..i.."ContentIcon");
			local topItemNum 	= getglobal("EnchantTopBoxItem"..i.."ContentCount");
			local topItemDurbar 	= getglobal("EnchantTopBoxItem"..i.."ContentDuration");

			if topItem:GetClientID() == 0 then
				if ClientBackpack:getGridItem(grid_index) > 0 then
					topItem:SetClientID(grid_index+1);
					UpdateItemIconCount(topItemIcon, topItemNum, topItemDurbar, grid_index);
					return;
				end
			end
		end
	elseif EnchantBoxType == 1 then 
		for i=1, ENCHANT_GRID_MAX do
			local bottomItem 	= getglobal("EnchantBottomBoxItem"..i);
			local bottomItemIcon	= getglobal("EnchantBottomBoxItem"..i.."ContentIcon");
			local bottomItemNum	= getglobal("EnchantBottomBoxItem"..i.."ContentCount");
			local bottomItemDurbar  = getglobal("EnchantBottomBoxItem"..i.."ContentDuration");

			local clientId = bottomItem:GetClientID();
			if clientId ~= 0 and clientId == grid_index+1 then
				if ClientBackpack:getGridItem(grid_index) > 0 then
					UpdateItemIconCount(bottomItemIcon, bottomItemNum, bottomItemDurbar, grid_index);
				else
					bottomItem:SetClientID(0);
					bottomItemIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
					bottomItemNum:SetText("");
					bottomItemDurbar:Hide();
				end
				return;
			end
		end

		for i=1, ENCHANT_GRID_MAX do
			local bottomItem 	= getglobal("EnchantBottomBoxItem"..i);
			local bottomItemIcon	= getglobal("EnchantBottomBoxItem"..i.."ContentIcon");
			local bottomItemNum	= getglobal("EnchantBottomBoxItem"..i.."ContentCount");
			local bottomItemDurbar  = getglobal("EnchantBottomBoxItem"..i.."ContentDuration");

			if bottomItem:GetClientID() == 0 then
				if ClientBackpack:getGridItem(grid_index) > 0 then
					bottomItem:SetClientID(grid_index+1);
					UpdateItemIconCount(bottomItemIcon, bottomItemNum, bottomItemDurbar, grid_index);
					return;
				end
			end
		end
	end
end

function UpdateEnchantBoxGrid()
	local t_topBoxGrid = {};
	local t_bottomBoxGrid = {};
	for i=1, BACK_PACK_GRID_MAX do
		local grid_index = BACKPACK_START_INDEX + i - 1;
		local itemId = ClientBackpack:getGridItem(grid_index);
		local enchantNum = ClientBackpack:getGridEnchantNum(grid_index);
		local itemDef = DefMgr:getItemDef(itemId);	
		if itemDef ~= nil then
			if Enchant_Type == 1 then
				if itemDef.EnchantTag == 1 or itemDef.EnchantTag == 3 then
					table.insert(t_topBoxGrid, grid_index);
				end
				if enchantNum > 0 and (itemDef.EnchantTag == 2 or itemDef.EnchantTag == 3) then
					table.insert(t_bottomBoxGrid, grid_index);
				end
			elseif Enchant_Type == 2 then
				if enchantNum > 0 and (itemDef.EnchantTag == 1 or itemDef.EnchantTag == 3) then
					table.insert(t_bottomBoxGrid, grid_index);
				end
				if itemDef.EnchantTag == 2 or itemDef.EnchantTag == 3 then
					table.insert(t_topBoxGrid, grid_index);
				end
			end
		end
	end
	for i=1, MAX_SHORTCUT do
		local grid_index = SHORTCUT_START_INDEX + i - 1;
		local itemId = ClientBackpack:getGridItem(grid_index);
		local enchantNum = ClientBackpack:getGridEnchantNum(grid_index);
		local itemDef = DefMgr:getItemDef(itemId);
		if itemDef ~= nil then
			local enchantTag = itemDef.EnchantTag;
			if Enchant_Type == 1 then
				if itemDef.EnchantTag == 1 or itemDef.EnchantTag == 3 then
					table.insert(t_topBoxGrid, grid_index);
				end
				if enchantNum > 0 and (itemDef.EnchantTag == 2 or itemDef.EnchantTag == 3) then
					table.insert(t_bottomBoxGrid, grid_index);
				end
			elseif Enchant_Type == 2 then
				if enchantNum > 0 and (itemDef.EnchantTag == 1 or itemDef.EnchantTag == 3) then
					table.insert(t_bottomBoxGrid, grid_index);
				end
				if itemDef.EnchantTag == 2 or itemDef.EnchantTag == 3 then
					table.insert(t_topBoxGrid, grid_index);
				end
			end
		end
	end

	for i=1, ENCHANT_GRID_MAX do
		local topItem 		= getglobal("EnchantTopBoxItem"..i);
		local topItemIcon 	= getglobal("EnchantTopBoxItem"..i.."ContentIcon");
		local topItemNum 	= getglobal("EnchantTopBoxItem"..i.."ContentCount");
		local topItemDurbar 	= getglobal("EnchantTopBoxItem"..i.."ContentDuration");
		if i <= #(t_topBoxGrid) then
			topItem:SetClientID(t_topBoxGrid[i]+1);
			UpdateItemIconCount(topItemIcon, topItemNum, topItemDurbar, t_topBoxGrid[i]);
		else
			topItem:SetClientID(0);
			topItemIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
			topItemNum:SetText("");
			topItemDurbar:Hide();
		end
	end
	for i=1, ENCHANT_GRID_MAX do
		local bottomItem 	= getglobal("EnchantBottomBoxItem"..i);
		local bottomItemIcon	= getglobal("EnchantBottomBoxItem"..i.."ContentIcon");
		local bottomItemNum	= getglobal("EnchantBottomBoxItem"..i.."ContentCount");
		local bottomItemDurbar  = getglobal("EnchantBottomBoxItem"..i.."ContentDuration");
		if i <= #(t_bottomBoxGrid) then
			bottomItem:SetClientID(t_bottomBoxGrid[i]+1);
			UpdateItemIconCount(bottomItemIcon, bottomItemNum, bottomItemDurbar, t_bottomBoxGrid[i]);
		else
			bottomItem:SetClientID(0);
			bottomItemIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
			bottomItemNum:SetText("");
			bottomItemDurbar:Hide();
		end
	end
end

function UpdateEnchantItemGrid()
	for i=1, 2 do
		local grid_index = ENCHANT_START_INDEX + i - 1;
		local icon = getglobal("EnchantFrameEnchanntItem"..i.."ContentIcon");
		local num = getglobal("EnchantFrameEnchanntItem"..i.."ContentCount");
		local durbar = getglobal("EnchantFrameEnchanntItem"..i.."ContentDuration");
		UpdateItemIconCount(icon, num, durbar, grid_index);

		if ClientBackpack:getGridItem(16001) > 0 then
			EnchantFrameArrow3:Show();
		else
			EnchantFrameArrow3:Hide();
		end
	end
end

t_EnchantAttrList = {};
local t_ChooseEnchantAttr = {};
function UpdateEnchatAttr()
	EnchantFrameEnchantBtnNormal:SetGray(false);
	EnchantFrameEnchantBtn:Enable();

	t_ChooseEnchantAttr = {};
	local itemId = ClientBackpack:getGridItem(16000);
	if itemId > 0 then
		local itemDef = DefMgr:getItemDef(itemId);
		EnchantFrameEnchanntItem1Name:SetText(itemDef.Name);
		local stuffType = itemDef.StuffType;
		local enchantMentDef = DefMgr:getEnchantMentDef(stuffType);
		if enchantMentDef == NULL then return end;

		local toolDef = DefMgr:getToolDef(itemDef.ID);
		if toolDef == NULL then return end;

		local stuffId = ClientBackpack:getGridItem(16001);
		local itemEnchantNum = ClientBackpack:getGridEnchantNum(16000);

		if itemEnchantNum == 0 then
			if stuffId > 0 then		--合并附魔
				EnchantFrameText:SetText("合并附魔属性");
				MergeEnchant(enchantMentDef, toolDef.Type);			
				
				local stuffDef = DefMgr:getItemDef(stuffId);
				EnchantFrameEnchanntItem2Name:SetText(stuffDef.Name);
			else				--随机附魔				
				RandomEnchant(enchantMentDef, toolDef.Type);	
				for i=1, 5 do 
					local attr = getglobal("EnchantFrameAttr"..i);
					local desc = getglobal("EnchantFrameAttr"..i.."Desc");
					desc:Clear();

					attr:SetClientUserData(0, 0);
					attr:SetClientUserData(1, 0);
					attr:SetClientUserData(2, 0);
				end
				EnchantFrameText:SetText("随机获得附魔属性");			
				EnchantFrameEnchanntItem2Name:SetText("");
			end
		else
			if stuffId > 0 then		--合并附魔
				EnchantFrameText:SetText("合并附魔属性");
				MergeEnchant(enchantMentDef, toolDef.Type);			

				local stuffDef = DefMgr:getItemDef(stuffId);
				EnchantFrameEnchanntItem2Name:SetText(stuffDef.Name);
			else
				for i=1, 5 do 
					local attr = getglobal("EnchantFrameAttr"..i);
					local desc = getglobal("EnchantFrameAttr"..i.."Desc");
					local text = "";
					if i <= itemEnchantNum then
						local id = ClientBackpack:getGridEnchantId(16000, i-1);
						local enchantDef = DefMgr:getEnchantDef(id);
						if enchantDef ~= nil then
							text = enchantDef.Name..enchantDef.EnchantLevel;
							desc:SetText(text, 255, 255, 255);

							attr:SetClientUserData(0, id);
							attr:SetClientUserData(1, 0);
							attr:SetClientUserData(2, 0);
						end
					else
						desc:Clear();
						attr:SetClientUserData(0, 0);
						attr:SetClientUserData(1, 0);
						attr:SetClientUserData(2, 0);
					end
				end
				EnchantFrameEnchantBtnText:SetText(0);
				EnchantFrameText:SetText("请选择附魔材料");
				EnchantFrameEnchanntItem2Name:SetText("")
			end
		end
	else
		for i=1, 5 do 
			local attr = getglobal("EnchantFrameAttr"..i);
			local desc = getglobal("EnchantFrameAttr"..i.."Desc");
			desc:Clear();
			attr:SetClientUserData(0, 0);
			attr:SetClientUserData(1, 0);
			attr:SetClientUserData(2, 0);
		end
		EnchantFrameEnchantBtnText:SetText(0);
		EnchantFrameText:SetText("请选择附魔物品");
		EnchantFrameEnchanntItem1Name:SetText("");

		local stuffId = ClientBackpack:getGridItem(16001);
		local stuffDef = DefMgr:getItemDef(stuffId);
		if stuffDef ~= nil then
			EnchantFrameEnchanntItem2Name:SetText(stuffDef.Name);
		else
			EnchantFrameEnchanntItem2Name:SetText("");
		end
	end
end

--合并附魔
function MergeEnchant(enchantMentDef, toolType)
	t_ChooseEnchantAttr = {};
	local itemEnchantNum = ClientBackpack:getGridEnchantNum(16000);
	for i=1, itemEnchantNum do
		local enchantId = ClientBackpack:getGridEnchantId(16000, i-1);
		local id = math.floor(enchantId/100);
		local level = enchantId - 100*id;

		local enchantDef = DefMgr:getEnchantDef(enchantId);
		table.insert(t_ChooseEnchantAttr, {ID=id, EnchantLevel=level, ownLevel=level, isOwn=true, isChoose=false, canChoose=true, conflictID=enchantDef.ConflictID});
	end

	local stuffEnchantNum = ClientBackpack:getGridEnchantNum(16001);
	for i=1, stuffEnchantNum do
		local enchantId = ClientBackpack:getGridEnchantId(16001, i-1);
		local id = math.floor(enchantId/100);
		local level = enchantId - 100*id;

		local hasSameAttr = false;
		for j=1, #(t_ChooseEnchantAttr) do		
			if id == t_ChooseEnchantAttr[j].ID then
				hasSameAttr = true;
				if level == t_ChooseEnchantAttr[j].EnchantLevel and level ~= 5 then
					t_ChooseEnchantAttr[j].EnchantLevel = t_ChooseEnchantAttr[j].EnchantLevel + 1;
				elseif level > t_ChooseEnchantAttr[j].EnchantLevel then
					t_ChooseEnchantAttr[j].EnchantLevel = level;
				end
			end
		end
		if not hasSameAttr then
			local choose = true;
			local enchantDef = DefMgr:getEnchantDef(enchantId);
			if enchantDef ~= nil then
				if not CanChooseForToolType(enchantDef, toolType) or EnchantConflict(enchantDef.ConflictID) then
					choose = false;
				end
			end
			table.insert(t_ChooseEnchantAttr, {ID=id, EnchantLevel=level, ownLevel=level, isOwn=false, isChoose=false, canChoose=choose, conflictID=enchantDef.ConflictID});
		end
	end

	local mergeAttrNum = #(t_ChooseEnchantAttr);

	local isGray = true
	for i=1, mergeAttrNum do
		if t_ChooseEnchantAttr[i].isOwn and t_ChooseEnchantAttr[i].EnchantLevel ~= t_ChooseEnchantAttr[i].ownLevel then
			isGray = false;
			break;
		elseif not t_ChooseEnchantAttr[i].isOwn and t_ChooseEnchantAttr[i].canChoose then
			isGray = false;
			break;
		end
	end
	if isGray then
		EnchantFrameEnchantBtnNormal:SetGray(true);
		EnchantFrameEnchantBtn:Disable();
		EnchantFrameText:SetText("无适合属性");
		EnchantFrameEnchantBtnText:SetText(0);
	end

	if GetCanChooseNum() > 5 then
		if not isGray then
			EnchantFrameEnchantBtnText:SetText("?");
		end
	else						--计算花费
		local isGray = true
		for i=1, mergeAttrNum do
			if t_ChooseEnchantAttr[i].isOwn and t_ChooseEnchantAttr[i].EnchantLevel ~= t_ChooseEnchantAttr[i].ownLevel then
				isGray = false;
				break;
			elseif t_ChooseEnchantAttr[i].canChoose then
				isGray = false;
				break;
			end
		end

		if not isGray then
			local cost = 0;
			for i=1, mergeAttrNum do
				if t_ChooseEnchantAttr[i].isOwn then
					if t_ChooseEnchantAttr[i].EnchantLevel > t_ChooseEnchantAttr[i].ownLevel then
						local cost1 = GetMergeCostForLevel(enchantMentDef, t_ChooseEnchantAttr[i].EnchantLevel);
						local cost2 = GetMergeCostForLevel(enchantMentDef, t_ChooseEnchantAttr[i].ownLevel);
						cost = cost + cost1 - cost2;
					end
				else
					cost = cost + GetMergeCostForLevel(enchantMentDef, t_ChooseEnchantAttr[i].EnchantLevel);
				end
			end
			EnchantFrameEnchantBtnText:SetText(cost);
		end
	end

	local attrIndex = 1;
	for i=1, mergeAttrNum do 
		if attrIndex > 5 then break; end

		local attr = getglobal("EnchantFrameAttr"..attrIndex);
		local desc = getglobal("EnchantFrameAttr"..attrIndex.."Desc");
		local text = "";		
		if t_ChooseEnchantAttr[i].canChoose then
			attrIndex = attrIndex + 1;
			local id = t_ChooseEnchantAttr[i].ID*100 + t_ChooseEnchantAttr[i].EnchantLevel;
			local enchantDef = DefMgr:getEnchantDef(id);
			if t_ChooseEnchantAttr[i].isOwn then
				text = "#cffffff"..enchantDef.Name..t_ChooseEnchantAttr[i].ownLevel.."#n";
				local ownId = t_ChooseEnchantAttr[i].ID*100 + t_ChooseEnchantAttr[i].ownLevel;
				if GetCanChooseNum() > 5 then
					if t_ChooseEnchantAttr[i].ownLevel ~= t_ChooseEnchantAttr[i].EnchantLevel then 
						text = text.."#cfff600".."→ ?";					
						attr:SetClientUserData(0, ownId);
						attr:SetClientUserData(1, 0);
						attr:SetClientUserData(2, 1);
					end
				else
					if t_ChooseEnchantAttr[i].ownLevel ~= t_ChooseEnchantAttr[i].EnchantLevel then
						text = text.."#cfff600".."→"..t_ChooseEnchantAttr[i].EnchantLevel.."#n";

						attr:SetClientUserData(0, ownId);
						attr:SetClientUserData(1, t_ChooseEnchantAttr[i].EnchantLevel);
						attr:SetClientUserData(2, 0);
					end
				end
			else
				if GetCanChooseNum() > 5 then
					text = "#cfff600".."?#n";
					attr:SetClientUserData(0, 0);
					attr:SetClientUserData(1, 0);
					attr:SetClientUserData(2, 1);
				else
					text = "#cfff600"..enchantDef.Name..t_ChooseEnchantAttr[i].EnchantLevel.."#n";

					attr:SetClientUserData(0, id);
					attr:SetClientUserData(1, 0);
					attr:SetClientUserData(2, 0);
				end	
			end
			desc:SetText(text, 255, 255, 255);	
		end		
	end

	for i=1, 5 do
		if i > attrIndex then
			local attr = getglobal("EnchantFrameAttr"..i);
			local desc = getglobal("EnchantFrameAttr"..i.."Desc");

			desc:Clear();
			attr:SetClientUserData(0, 0);
			attr:SetClientUserData(1, 0);
			attr:SetClientUserData(2, 0);
		end
	end
end

function GetCanChooseNum()
	local canChooseNum = 0;
	for i=1, #(t_ChooseEnchantAttr) do
		if t_ChooseEnchantAttr[i].canChoose then
			canChooseNum = canChooseNum + 1;
		end
	end

	return canChooseNum;
end

--计算这条属性是否能被合并
function CanChooseForToolType(enchantDef, toolType)
	local canChoose = false;
	for i=1, MAX_TOOL_TYPE do
		if toolType ~= 0 and toolType == enchantDef.ToolType[i-1] then
			canChoose = true;
		end
	end
	return canChoose;	
end

--计算这条属性是否与其它属性冲突
function EnchantConflict(conflictID)
	for i=1, #(t_ChooseEnchantAttr) do
		if conflictID ~=0 and conflictID == t_ChooseEnchantAttr[i].conflictID then
			return true;
		end
	end

	return false;
end

--计算合并附魔的等级花费
function GetMergeCostForLevel(enchantMentDef, level)
	local cost = 0;
	for i=1, level do
		if i <= 5 then
			cost = cost + enchantMentDef.MergeCost[i-1];
		else
			local index = level;
			if level == 100 then
			end
		end
	end
	return cost;
end

--随机附魔
function RandomEnchant(enchantMentDef, toolType)
	--找到随机的附魔属性条数
	local t_AttrNumProb = {};
	local prob = 0;
	local total = 0;
	for i=1, 5 do
		total = total + enchantMentDef.AttrWeight[i-1];
		if enchantMentDef.AttrWeight[i-1] ~= 0 then
			prob = prob + enchantMentDef.AttrWeight[i-1];
			table.insert(t_AttrNumProb, prob);
		end
	end
	if total == 0 then
		total = 1;
	end
	local randomNum = math.random(0, total-1);
	local attrNum = 0;
	for i=1, #(t_AttrNumProb) do 
		if randomNum < t_AttrNumProb[i] then
			attrNum = i;
			break;
		end
	end

	--找到符合条件的附魔属性
	local t_AccordAttr = {};
	DefMgr:setCurAccordEnchants(toolType);
	local curAccordNum = DefMgr:getCurAccordEnchantsNum();
	for i=1, curAccordNum do
		local enchantDef = DefMgr:getCurAccordEnchantDef(i-1);
		table.insert(t_AccordAttr, enchantDef);
	end

	--选择的附魔属性
	t_ChooseEnchantAttr = {};
	t_ChooseEnchantAttr = GetChooseEnchantDef(attrNum, t_AccordAttr, enchantMentDef);

	--计算花费
	local cost = enchantMentDef.Cost;
	EnchantFrameEnchantBtnText:SetText(cost);
end

function GetChooseEnchantDef(attrNum, t_AccordAttr, enchantMentDef)
	local t_AttrInfo = {}
	for i=1, attrNum do
		local t_ChooseAttrProb = {};
		local total = 0;
		for j=1, #(t_AccordAttr) do
			total = total + t_AccordAttr[j].Weight;
			table.insert(t_ChooseAttrProb, total);
		end
		if total == 0 then
			total = 1;
		end
		local randomNum = math.random(0, total-1);
		for k=1, #(t_AccordAttr) do 
			if randomNum < t_ChooseAttrProb[k] then
				local isConflict = false;
				for n=1, #(t_AttrInfo) do
					if t_AccordAttr[k].ConflictID ~= 0 and t_AccordAttr[k].ConflictID == t_AttrInfo[n].ConflictID then
						isConflict = true;
					end
				end
				if not isConflict then
					table.insert(t_AttrInfo, t_AccordAttr[k]);
					break;
				end
			end
		end
	end

	local t_RandomAttr = {};
	for i=1, #(t_AttrInfo) do
		local level = RandomLevel(enchantMentDef);
		local id = t_AttrInfo[i].ID * 100 + level;			
		local enchantDef = DefMgr:getEnchantDef(id);
		if enchantDef == nil then
			enchantDef = t_AttrInfo[i].ID * 100 + 1;
		end
		table.insert(t_RandomAttr, enchantDef);
		t_RandomAttr[i].canChoose = true;
	end

	return t_RandomAttr;
end

--随机等级
function RandomLevel(enchantMentDef)
	local level = 1;
	local t_LevelProb = {}
	local prob = 0;
	local total = 0;
	for i=1, 5 do
		total = total + enchantMentDef.LevelWeight[i-1];
		if enchantMentDef.LevelWeight[i-1] ~= 0 then
			prob = prob + enchantMentDef.LevelWeight[i-1];
			table.insert(t_LevelProb, prob);
		end
	end
	if total == 0 then
		total = 1;
	end
	local randomNum = math.random(0, total-1);
	local attrNum = 0;
	for i=1, #(t_LevelProb) do 
		if randomNum < t_LevelProb[i] then
			level = i;
			break;
		end
	end

	return level;
end

--点击附魔属性条
function EnchantAttrBtn_OnClick()
	EnchantAttrBtnName = this:GetName();
	EnchantAttrTipsFrame:Show();
end

function EnchantFrame_OnHide()
	if ClientBackpack:getGridItem(16000) > 0 then
		CurMainPlayer:throwItem(16000, 1);
	end

	if ClientBackpack:getGridItem(16001) > 0 then
		CurMainPlayer:throwItem(16001, 1);
	end

	if MItemTipsFrame:IsShown() then
		MItemTipsFrame:Hide();
	end

	ClientCurGame:setOperateUI(false);
end

function EnchantItemBtn_OnMouseDownUpdate()
end

function EnchantFrameAddStar_OnClick()
end

function EnchantFrameEnchantBtn_OnClick()
	local itemId = ClientBackpack:getGridItem(16000);
	if itemId > 0 then
		--材料不足
		local enchantNum = ClientBackpack:getGridEnchantNum(16000);		
		if enchantNum > 0 then
			if ClientBackpack:getGridItem(16001) < 1 then
				if Enchant_Type == 1 then
					local text = "请放入附魔材料";
					ShowGameTips(text, 3);
				elseif Enchant_Type ==  2 then
					local text = "请放入要取出附魔的物品";
					ShowGameTips(text, 3);
				end
				return;
			end
		end
		--多于5条属性，跳到选择属性面板
		if GetCanChooseNum() > 5 then
			ChooseEnchantFrame:Show();
			return;
		end

		--星星不足
		local cost = tonumber(EnchantFrameEnchantBtnText:GetText());
		local starNum = math.floor(MainPlayerAttrib:getExp()/100);
		if cost > starNum then
			local text = "附魔所需星星不足";
			ShowGameTips(text, 2);
			return;
		end
	
		--附魔
		ClientBackpack:clearEnchant(16000);
		local enchantIndex = 0;
		for i=1, #(t_ChooseEnchantAttr) do			
			if t_ChooseEnchantAttr[i].canChoose then
				enchantIndex = enchantIndex + 1;
				local id = t_ChooseEnchantAttr[i].ID;
				local level = t_ChooseEnchantAttr[i].EnchantLevel;
				ClientBackpack:enchant(enchantIndex-1, id, level);
			end
		end

		local itemDef = DefMgr:getItemDef(itemId);
		local text = itemDef.Name.."附魔成功！";
		ShowGameTips(text, 1);

		EnchantFrameEnchanntItem1UvAnimation:SetUVAnimation(120, false);

		MainPlayerAttrib:addExp(-100*cost);
		t_ChooseEnchantAttr = {};
	else
		--没有放入附魔
		if Enchant_Type == 1 then
			local text = "请放入要附魔的物品";
			ShowGameTips(text, 2);
		elseif Enchant_Type ==  2 then
			local text = "请放入要附魔的材料";
			ShowGameTips(text, 2);
		end
	end
end

------------------------------------------------EnchantAttrTipsFrame------------------------------------------------------
--UserData  0属性表Id 1升级后等级 2是否超过5条
function EnchantAttrTipsFrame_OnShow()
	if EnchantAttrBtnName == nil or EnchantAttrBtnName == "" then return end

	local btn = getglobal(EnchantAttrBtnName);
	local id = btn:GetClientUserData(0);
	local level = btn:GetClientUserData(1);
	local more = btn:GetClientUserData(2);
	local text = ""
	local bkgH = 0;	
	
	if id > 0 then
		bkgH = bkgH + 100;
		local enchantDef = DefMgr:getEnchantDef(id);
		if enchantDef ~= nil then
			EnchantAttrTipsFrameName:SetText(enchantDef.Name..enchantDef.EnchantLevel);
			text = text..enchantDef.AttrDesc.."\n";
		end
	else
		EnchantAttrTipsFrameName:Hide();
	end
	if level > 0 then
		bkgH = bkgH + 30;
		text = text.."\n该次附魔会将该属性升为"..level.."级\n";
	end
	if more > 0 then
		bkgH = bkgH + 30;
		text = text.."\n属性超过5条，点击附魔后选择\n";
	end

	EnchantAttrTipsFrameDesc:SetText(text, 255, 255, 255);
	EnchantAttrTipsFrameBkg:SetSize(325, bkgH);
	EnchantAttrTipsFrameBkg:SetPoint("topright", EnchantAttrBtnName, "topleft", 0, 0);

	if id > 0 then
		EnchantAttrTipsFrameDesc:SetPoint("topleft", "EnchantAttrTipsFrameBkg", "topleft", 15, 60);
	else
		EnchantAttrTipsFrameDesc:SetPoint("topleft", "EnchantAttrTipsFrameBkg", "topleft", 15, 10);
	end
	
end

function EnchantAttrTipsFrame_OnClick()
	EnchantAttrTipsFrame:Hide();
end
-------------------------------------------------EnchantItemBtn-----------------------------------------------------------
function EnchantItemBtn_OnClick()
	local clientId = this:GetClientID();
	if clientId == 0 then return end

	local btnName = this:GetName();
	local grid_index = clientId - 1;
	local itemId = ClientBackpack:getGridItem(grid_index);
	if itemId < 1 then return end

	local enchantNum = ClientBackpack:getGridEnchantNum(grid_index);
	if string.find(btnName, "EnchanntItem") then		
		if enchantNum > 0 then						--附魔的物品
			local togrid_index = GetPackFrameFristNullGridIndex();
			if togrid_index ~= -1 then
				ClientBackpack:swapItem(grid_index, togrid_index);
			else
				CurMainPlayer:throwItem(grid_index, 1);
			end
		else
			ClientBackpack:addItem(itemId, 1);
			ClientBackpack:removeItem(grid_index, 1);
		end
	else
		IsLongPressTips		= false;
		tipsItemId		= ClientBackpack:getGridItem(grid_index);
		longPressItemId 	= ClientBackpack:getGridItem(grid_index);
		longPressItemTop	= this:GetRealTop();			
		longPressItemBottom 	= this:GetRealBottom();
		longPressItemLeft	= this:GetRealLeft();
		longPressItemRight	= this:GetRealRight();	
		tipsGridIndex = grid_index;

		MItemTipsFrame:SetClientString(btnName);
		MItemTipsFrame:Show();
	end

	--[[
	local enchantNum = ClientBackpack:getGridEnchantNum(grid_index);
	if string.find(btnName, "EnchantTopBoxItem") then
		EnchantBoxType = 0;
		if enchantNum > 0 or ClientBackpack:getGridNum(grid_index) == 1 then		
			ClientBackpack:swapItem(grid_index, 16000);
		else
			EnchanntItemChange(grid_index, 16000);
			ClientBackpack:removeItem(grid_index, 1);
		end
	elseif string.find(btnName, "EnchantBottomBox") then
		EnchantBoxType = 1;
		ClientBackpack:swapItem(grid_index, 16001);
	elseif string.find(btnName, "EnchanntItem") then		
		if enchantNum > 0 then						--附魔的物品
			local togrid_index = GetPackFrameFristNullGridIndex();
			if togrid_index ~= -1 then
				ClientBackpack:swapItem(grid_index, togrid_index);
			else
				CurMainPlayer:throwItem(grid_index, 1);
			end
		else
			ClientBackpack:addItem(itemId, 1);
			ClientBackpack:removeItem(grid_index, 1);
		end
	end
	--]]
end

--附魔面板的物品放置逻辑
function EnchantItemPlace(btnName, grid_index)
	local enchantNum = ClientBackpack:getGridEnchantNum(grid_index);
	if string.find(btnName, "EnchantTopBoxItem") then
		EnchantBoxType = 0;
		if enchantNum > 0 or ClientBackpack:getGridNum(grid_index) == 1 then		
			ClientBackpack:swapItem(grid_index, 16000);
		else
			EnchanntItemChange(grid_index, 16000);
			ClientBackpack:removeItem(grid_index, 1);
		end
	elseif string.find(btnName, "EnchantBottomBox") then
		EnchantBoxType = 1;
		ClientBackpack:swapItem(grid_index, 16001);
	end
end

function EnchanntItemChange(grid_index, togrid_index)
	local itemId = ClientBackpack:getGridItem(togrid_index);
	if itemId > 0 then
		local enchantNum = ClientBackpack:getGridEnchantNum(togrid_index);
		if enchantNum > 0 then
			local null_index = GetPackFrameFristNullGridIndex();
			ClientBackpack:setEnchantItem(togrid_index, null_index);	--16000放到空格子
			ClientBackpack:setEnchantItem(grid_index, togrid_index);	--附魔物品放到16000
		else
			ClientBackpack:addItem(itemId, 1);				--16000放到背包
			ClientBackpack:setEnchantItem(grid_index, togrid_index);	--附魔物品放到16000
		end
	else
		ClientBackpack:setEnchantItem(grid_index, togrid_index);		--附魔物品放到16000		
	end	
end

function EnchantItemBtn_OnMouseDownUpdate()
	local btnName = this:GetName();
	if string.find(btnName, "EnchantTopBox") or string.find(btnName, "EnchantBottomBox") then
		return;
	end

	if arg1 < 0.6 then return end
	
	local grid_index = this:GetClientID() - 1;

	if ClientBackpack:getGridItem(grid_index) <= 0 then return end

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

function EnchantItemBtn_OnMouseUp()
	if MItemTipsFrame:IsShown() and IsLongPressTips then
		MItemTipsFrame:Hide();
	end
end

--------------------------------------------------ChooseEnchantFrame---------------------------------------
function ChooseEnchantAttrBtn_OnClick()
	local normal = getglobal(this:GetName().."Normal");
	local check = getglobal(this:GetName().."CheckedBG");
	local clientId = this:GetClientID();
	if Enchant_Type == 1 and not t_ChooseEnchantAttr[clientId].canChoose then
		return;
	end

	local chooseNum = 0;
	local canChooseNum = 0;
	for i=1, #(t_ChooseEnchantAttr) do
		if t_ChooseEnchantAttr[i].isChoose then
			chooseNum = chooseNum + 1;
		end
		if t_ChooseEnchantAttr[i].canChoose then
			canChooseNum = canChooseNum + 1;	
		end
	end

	if Enchant_Type == 2 or canChooseNum > 5 then
		canChooseNum = 5;		
	end

	if normal:IsShown() then
		if chooseNum >= canChooseNum then
			ShowGameTips("最多只能选择"..canChooseNum.."条属性", 3);
			return;
		end
		normal:Hide();
		check:Show();
		if clientId <= #(t_ChooseEnchantAttr) then
			t_ChooseEnchantAttr[clientId].isChoose = true;
		end
	else
		check:Hide();
		normal:Show();
		if clientId <= #(t_ChooseEnchantAttr) then
			t_ChooseEnchantAttr[clientId].isChoose = false;
		end
	end

	ChooseCost();
end

function ChooseEnchantFrame_OnLoad()
	for i=1, 2 do
		for j=1, 5 do
			local attr = getglobal("ChooseEnchantFrameAttrBtn"..(i-1)*5+j);
			attr:SetPoint("topleft", "ChooseEnchantFrameChenDi", "topleft", 100+(i-1)*330, 65+(j-1)*56);
		end
	end
end

function ResetChooseAttrBtn()
	for i=1, 10 do
		local normal = getglobal("ChooseEnchantFrameAttrBtn"..i.."Normal");
		local check = getglobal("ChooseEnchantFrameAttrBtn"..i.."CheckedBG"); 
		normal:Show();
		normal:SetGray(false);
		check:Hide();
	end
end

function ChooseEnchantFrame_OnShow()
	ResetChooseAttrBtn();
	ChooseEnchantFrameConfirmBtnText:SetText(0);
	local t_selfAttr = {};
	local t_addAttr = {};
	for i=1, #(t_ChooseEnchantAttr) do
		if t_ChooseEnchantAttr[i].isOwn then
			table.insert(t_selfAttr, {attrInfo=t_ChooseEnchantAttr[i], clientId=i});
		else
			table.insert(t_addAttr, {attrInfo=t_ChooseEnchantAttr[i], clientId=i});
		end
	end
	for i=1, 5 do
		local attr = getglobal("ChooseEnchantFrameAttrBtn"..i);
		local desc = getglobal("ChooseEnchantFrameAttrBtn"..i.."Desc");
		if i <= #(t_selfAttr) then
			attr:Show();
			attr:SetClientID(t_selfAttr[i].clientId);
			local id = t_selfAttr[i].attrInfo.ID *100 + t_selfAttr[i].attrInfo.EnchantLevel;
			local enchantDef = DefMgr:getEnchantDef(id);
			if enchantDef ~= nil then
				local text = enchantDef.Name..t_selfAttr[i].attrInfo.EnchantLevel;
				desc:SetText(text, 255, 255, 255);
			end
		else
			attr:Hide();
			attr:SetClientID(0);
		end
	end

	for i=6, 10 do
		local attr = getglobal("ChooseEnchantFrameAttrBtn"..i);
		local normal = getglobal("ChooseEnchantFrameAttrBtn"..i.."Normal");
		local desc = getglobal("ChooseEnchantFrameAttrBtn"..i.."Desc");
		local index = i-5;
		if index <= #(t_addAttr) then
			attr:Show();
			attr:SetClientID(t_addAttr[index].clientId);
			local id = t_addAttr[index].attrInfo.ID *100 + t_addAttr[index].attrInfo.EnchantLevel;
			local enchantDef = DefMgr:getEnchantDef(id);
			if enchantDef ~= nil then
				local text = enchantDef.Name..t_addAttr[index].attrInfo.EnchantLevel;
				desc:SetText(text, 255, 255, 255);
			end
			
			if Enchant_Type == 2 or t_addAttr[index].attrInfo.canChoose then
				normal:SetGray(false);
			else
				normal:SetGray(true);
			end
		else
			attr:Hide();
			attr:SetClientID(0);
		end
	end
end

function ChooseCost()
	--计算花费
	local itemId = ClientBackpack:getGridItem(16000);
	local enchantMentDef = nil;
	if itemId > 0 then
		local itemDef = DefMgr:getItemDef(itemId);
		local stuffType = itemDef.StuffType;
		enchantMentDef = DefMgr:getEnchantMentDef(stuffType);
	end
	if enchantMentDef == nil then return end

	local cost = 0;
	for i=1, #(t_ChooseEnchantAttr) do
		if t_ChooseEnchantAttr[i].isChoose then
			if t_ChooseEnchantAttr[i].isOwn then
				if t_ChooseEnchantAttr[i].EnchantLevel > t_ChooseEnchantAttr[i].ownLevel then
					local cost1 = GetMergeCostForLevel(enchantMentDef, t_ChooseEnchantAttr[i].EnchantLevel);
					local cost2 = GetMergeCostForLevel(enchantMentDef, t_ChooseEnchantAttr[i].ownLevel);
					cost = cost + cost1 - cost2;
				end
			else
				cost = cost + GetMergeCostForLevel(enchantMentDef, t_ChooseEnchantAttr[i].EnchantLevel);
			end
		end
	end

	ChooseEnchantFrameConfirmBtnText:SetText(cost);
end

--确定
function ChooseEnchantFrameConfirmBtn_OnClick()
	local itemId = ClientBackpack:getGridItem(16000);
	local enchantMentDef = nil;
	if itemId > 0 then
		local itemDef = DefMgr:getItemDef(itemId);
		local stuffType = itemDef.StuffType;
		enchantMentDef = DefMgr:getEnchantMentDef(stuffType);
	end
	--计算花费
	local chooseNum = 0;		--已选择的数量
	local canChooseNum = 0;		--可以选择的数量
	local cost = tonumber(ChooseEnchantFrameConfirmBtnText:GetText());
	for i=1, #(t_ChooseEnchantAttr) do
		if t_ChooseEnchantAttr[i].isChoose then
			chooseNum = chooseNum + 1;
		end
		if t_ChooseEnchantAttr[i].canChoose then
			canChooseNum = canChooseNum + 1;
		end
	end
	if Enchant_Type == 2 or canChooseNum > 5 then
		canChooseNum = 5;		
	end
	--星星不足
	local starNum = math.floor(MainPlayerAttrib:getExp()/100);
	if cost > starNum then
		local text = "附魔所需星星不足";
		ShowGameTips(text, 2);
		return;
	end
	--属性条选择不足
	if chooseNum < canChooseNum then
		ShowGameTips("请选择够"..canChooseNum.."条属性", 3);
		return;
	end
	
	local index = 0;
	ClientBackpack:clearEnchant(16000);
	for i=1, #(t_ChooseEnchantAttr) do
		if t_ChooseEnchantAttr[i].isChoose then
			ClientBackpack:enchant(index, t_ChooseEnchantAttr[i].ID, t_ChooseEnchantAttr[i].EnchantLevel);
			index = index + 1;		
		end
	end
	
	local itemDef = DefMgr:getItemDef(itemId);
	local text = itemDef.Name.."附魔成功！";
	ShowGameTips(text, 1);

	MainPlayerAttrib:addExp(-100*cost);
	ChooseEnchantFrame:Hide();
	t_ChooseEnchantAttr = {};

	EnchantFrameEnchanntItem1UvAnimation:SetUVAnimation(120, false);
end

--取消
function ChooseEnchantFrameCancelBtn_OnClick()
	for i=1, #(t_ChooseEnchantAttr) do
		t_ChooseEnchantAttr[i].isChoose = false;
	end

	ChooseEnchantFrame:Hide();
end