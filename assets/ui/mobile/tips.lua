--type1 点击有详细的tips type2仅仅显示文字
function TipsFrame_OnLoad()
	this:setUpdateTime(0.05);
end

function TipsFrame_OnShow()
	TipsFrameType1Font:SetBlendAlpha(1.0);
	TipsFrameType2Font:SetBlendAlpha(1.0);
	TipsFrameBkg:SetBlendAlpha(1.0);
end

local alpha = 1.0;
function TipsFrame_OnUpdate()
	tipsDisplayTime = tipsDisplayTime - arg1
	if tipsDisplayTime <= 0 then	
		alpha = alpha - 0.1;
		if alpha < 0 then
			alpha = 0;
		end	
		if TipsFrameType1:IsShown() then		
			TipsFrameType1Font:SetBlendAlpha(alpha);
		elseif TipsFrameType2:IsShown() then
			TipsFrameType2Font:SetBlendAlpha(alpha);
		end

		TipsFrameBkg:SetBlendAlpha(alpha);
	
		if alpha == 0 then
			alpha = 1.0;
			this:Hide();			
		end
	end
end

function TipsFrameType1_OnClick()
	IsLongPressTips = false;
	MItemTipsFrame:Show();
--[[	
	local itemDef = DefMgr:getItemDef(tipsItemId);

	local name = itemDef.Name;
	local desc = itemDef.Desc;
	
	local width = ItemTipsFrameDesc:GetTextExtentWidth(desc);
	
	if width > 1400 then
		ItemTipsFrame:Hide();
		ItemTipsBigFrame:Show();
		ItemTipsBigFrameName:SetText(name);
		ItemTipsBigFrameDesc:SetText(desc, 234,190,98);
	else
		ItemTipsBigFrame:Hide();
		ItemTipsFrame:Show();
		ItemTipsFrameName:SetText(name);
		ItemTipsFrameDesc:SetText(desc, 234,190,98);
	end
--]]
end

function ItemTipsFrame_OnClick()
	tipsItemId = nil;
	tipsGridIndex = -1	;
	this:Hide();
end

function ItemTipsBigFrame_OnClick()
	tipsItemId = nil;
	tipsGridIndex = -1
	this:Hide();
end

--------------------------------------------------MItemTipsFrame-----------------------------------------
longPressItemId = nil
longPressItemTop = 0;
longPressItemBottom = 0;
longPressItemLeft = 0;
longPressItemRight = 0;
IsLongPressTips = false;		--标记是否为长按tips;
function GetCraftingInfo(craftingDef)
	t_info = {};
	for i=1, 9 do
		local stuffSum = craftingDef.GridX * craftingDef.GridY;
		if craftingDef.MaterialID[i-1] ~= 0 and i <= stuffSum then
			local hasItem = false;
			for j=1, #(t_info) do
				if craftingDef.MaterialID[i-1] == t_info[j].id then
					t_info[j].num = t_info[j].num + craftingDef.MaterialCount[i-1];
					hasItem = true;
					break;
				end
			end
			if not hasItem then
				table.insert(t_info, {id=craftingDef.MaterialID[i-1], num=craftingDef.MaterialCount[i-1],});
			end
		end
	end

	return t_info;
end

function SetItemIcon(icon, itemid)
	local u = 0;
	local v = 0;
	local width = 0;
	local height = 0;
	local r = 255;
	local g = 255;
	local b = 255;
	h, u, v, width, height, r, g, b = ClientMgr:getItemIcon(itemid, u, v, width, height, r, g, b);
	icon:SetTextureHuires(h);
	icon:SetTexUV(u, v, width, height);
	icon:SetColor(r, g, b);
end

function SetTipsFramePos(frame)
	local realwidth = frame:GetRealWidth();
	local realheight = frame:GetRealHeight();
	local screenWidth = GetScreenWidth();
	local screenHeight = GetScreenHeight();

	if frame:GetRealWidth() <= GetScreenWidth() - longPressItemRight then		
		if frame:GetRealHeight() <= GetScreenHeight() - longPressItemTop then						--在右下方
			frame:SetPoint("topleft", "$parent", "topleft", longPressItemRight, longPressItemTop);
		else														--在右上方
			frame:SetPoint("bottomleft", "$parent", "topleft", longPressItemRight, longPressItemBottom);											
		end
	else					
		if frame:GetRealHeight() <= GetScreenHeight() - longPressItemTop then						--在左下方
			frame:SetPoint("topright", "$parent", "topleft", longPressItemLeft, longPressItemTop);
		else														--在左上方
			frame:SetPoint("bottomright", "$parent", "toleft", longPressItemLeft, longPressItemBottom);											
		end
	end
end

function SetTipsFramePosForBtnFrame(frame)
	local btnName = MItemTipsFrame:GetClientString();

	if string.find(btnName, "EnchantTopBoxItem") then	--附魔的上面格子
		frame:SetPoint("topleft", "$parent", "topleft", 725, 127);
	elseif string.find(btnName, "EnchantBottomBox") then	--附魔的下面格子
		frame:SetPoint("bottomleft", "$parent", "topleft", 725, 570);
	end
end

function MItemTipsFrame_OnShow()
	if tipsItemId == nil or tipsItemId == 0 or tipsGridIndex == -1 then
		MItemTipsFrame:Hide();
		return;
	end

	local btnName = MItemTipsFrame:GetClientString();

	if not IsLongPressTips then
		if not string.find(btnName, "Enchant") then
			TipsBkgFrame:Show();
		end
	end	
	
	local frameH = 120;
	local frameW = 450;
	local num = 0;
	if not CurWorld:isCreativeMode() then
		num = ClientBackpack:getGridEnchantNum(tipsGridIndex); --附魔属性数量
	end
	for i=1, 5 do
		local enchant = getglobal("MItemTipsFrameEnchant"..i);
		if i <= num then
			local id = ClientBackpack:getGridEnchantId(tipsGridIndex, i-1);
			local enchantDef = DefMgr:getEnchantDef(id);
			if enchantDef ~= nil then
				enchant:Show();
				local text = enchantDef.Name..enchantDef.EnchantLevel;
				enchant:SetText(text);
			else
				enchant:Hide();
				enchant:SetText("");
			end
		else
			enchant:Hide();
			enchant:SetText("");
		end
	end
	frameH = frameH + num*29;

	MItemTipsFrameDesc:SetPoint("topleft", "MItemTipsFrame", "topleft", 15, num*29+62)
	MItemTipsFrameLine:SetPoint("topleft", "MItemTipsFrame", "topleft", 0, num*29+112)
	MItemTipsFrameCraftingTitle:SetPoint("topleft", "MItemTipsFrame", "topleft", 15, num*29+143);


	local itemDef = DefMgr:getItemDef(tipsItemId);
	MItemTipsFrameName:SetText(itemDef.Name);
	MItemTipsFrameDesc:SetText(itemDef.Desc, 208, 212, 224)

	SetItemIcon(MItemTipsFrameIcon, tipsItemId);
	
	local t_craftingInfo = {};
	local craftingDef = DefMgr:findCrafting(tipsItemId);
	if craftingDef ~= nil then
		t_craftingInfo = GetCraftingInfo(craftingDef);
	end

	for i=1, 9 do
		local needBtn 	= getglobal("MItemTipsFrameCraftingNeed"..i);
		local icon 	= getglobal("MItemTipsFrameCraftingNeed"..i.."Icon")
		local name 	= getglobal("MItemTipsFrameCraftingNeed"..i.."Name");
		if i <= #(t_craftingInfo) then
			needBtn:Show();
			local itemid 	= t_craftingInfo[i].id;
			local num 	= t_craftingInfo[i].num;
			local text	= "缺省的名字".."×"..num;
			if DefMgr:getItemDef(itemid) ~= nil then
				text = DefMgr:getItemDef(itemid).Name.."×"..num;
			end
			SetItemIcon(icon, itemid); 
			name:SetText(text);
		else
			needBtn:Hide();
		end
	end

	if #(t_craftingInfo) > 0 then
		frameH = frameH + 20;
		MItemTipsFrameLine:Show();
		MItemTipsFrameCraftingTitle:Show();
	else
		MItemTipsFrameLine:Hide();
		MItemTipsFrameCraftingTitle:Hide();
	end

	
	if btnName ~= nil and btnName ~= "" then
		frameH = frameH + 50;
		MItemTipsFramePlaceBtn:Show();
	else
		MItemTipsFramePlaceBtn:Hide();
	end

	frameH = frameH + math.ceil( #(t_craftingInfo)/2 ) * 47;
	MItemTipsFrame:SetHeight(frameH);

	if IsLongPressTips then
		SetTipsFramePos(MItemTipsFrame);
	elseif btnName ~= nil and btnName ~= "" then
		SetTipsFramePosForBtnFrame(MItemTipsFrame);
	else
		MItemTipsFrame:SetPoint("center", "$parent", "center", 0, 0);
	end
end

function MItemTipsFramePlaceBtn_OnClick()
	local btnName = MItemTipsFrame:GetClientString();

	if string.find(btnName, "Enchant") then			--附魔物品放置
		EnchantItemPlace(btnName, tipsGridIndex);
	end

	MItemTipsFrame:Hide();
	TipsBkgFrame:Hide();	
end

function MItemTipsFrame_OnClick()
	MItemTipsFrame:Hide();
end

function MItemTipsFrame_OnHide()
	tipsItemId = nil
	tipsGridIndex = -1;
	MItemTipsFrame:SetClientUserData(0, 0);
	MItemTipsFrame:SetClientString("");

	if TipsBkgFrame:IsShown() then
		TipsBkgFrame:Hide();
	end
end

function TipsBkgFrame_OnClick()
	if MItemTipsFrame:IsShown() then		
		MItemTipsFrame:Hide();	
	end
end

function LongPressItemTipsFrame_OnShow()
	if longPressItemId == nil or longPressItemId == 0 then return; end
	
	local itemDef 	= DefMgr:getItemDef(longPressItemId);
	local name 	= itemDef.Name;
	local desc 	= itemDef.Desc;	
	local width 	= LongPressItemTipsFrameDesc:GetTextExtentWidth(desc);	
	if width > 1400 then
		LongPressItemTipsFrameBkg:SetSize(500, 300);
		LongPressItemTipsFrameDesc:SetSize(480, 200);
	else
		LongPressItemTipsFrameBkg:SetSize(500, 200);
		LongPressItemTipsFrameDesc:SetSize(480, 130);
	end

	--设置Tips位置

	local realwidth = LongPressItemTipsFrame:GetRealWidth();
	local realheight = LongPressItemTipsFrame:GetRealHeight();
	local screenWidth = GetScreenWidth();
	local screenHeight = GetScreenHeight();

	if LongPressItemTipsFrameBkg:GetRealWidth() <= GetScreenWidth() - longPressItemRight then		
		if LongPressItemTipsFrameBkg:GetRealHeight() <= GetScreenHeight() - longPressItemTop then						--在右下方
			LongPressItemTipsFrameBkg:SetPoint("topleft", "$parent", "topleft", longPressItemRight, longPressItemTop);
		else																--在右上方
			LongPressItemTipsFrameBkg:SetPoint("bottomleft", "$parent", "topleft", longPressItemRight, longPressItemBottom);											
		end
	else					
		if LongPressItemTipsFrameBkg:GetRealHeight() <= GetScreenHeight() - longPressItemTop then						--在左下方
			LongPressItemTipsFrameBkg:SetPoint("topright", "$parent", "topleft", longPressItemLeft, longPressItemTop);
		else																--在左上方
			LongPressItemTipsFrameBkg:SetPoint("bottomright", "$parent", "toleft", longPressItemLeft, longPressItemBottom);											
		end
	end

	LongPressItemTipsFrameName:SetText(name);
	LongPressItemTipsFrameDesc:SetText(desc, 234, 190, 98);
end

function LongPressItemTipsFrame_OnClick()
	longPressItemId = nil;
	this:Hide();
end

------------------------------------------------------------AchievementFinishTipsFrame--------------------------------------------------
local AchievementFinishTipsShowTime = 3;
local TipsAchiType = 0;
function UpdateAchievementFinishTips(achiId)
	local achievementDef = AchievementMgr:getAchievementDef(achiId);
	if achievementDef ~= nil then
		local num = achievementDef.GoalNum;
		local arryNum = AchievementMgr:getAchievementArryNum(achiId);
		if AchievementMgr:getAchievementState(achiId) ==  2 and arryNum >= num then
			AchievementFinishTipsFrame:SetPoint("bottom", "$parent", "top", 0, 0);
			AchievementFinishTipsShowTime = 3;
			if achievementDef.Type == 1 then
				TipsAchiType = 1;
			else
				TipsAchiType = 0;
			end

			ClientMgr:playSound2D("sounds/ui/info/achievement_reach.ogg", 500);
			AchievementFinishTipsFrame:Show();
			local icon =  getglobal("AchievementFinishTipsFrameIcon");
			SetAchievementBtnIcon(icon, achievementDef.IconID);
			AchievementFinishTipsFrameName:SetText(achievementDef.Name);
			SetLeftGongNengFrameTag(true);
		end
	end
end

function AchievementFinishTipsFrame_OnLoad()
	this:setUpdateTime(0.05);
end

function AchievementFinishTipsFrame_OnShow()
	curOffset = 0;
end

function AchievementFinishTipsFrame_OnClick()
	if not AchievementFrame:IsShown() then
		AchievementFrameType = TipsAchiType;
		AchievementFrame:Show();
	end
end

local changeOffset = 20;
local curOffset = 0;

function AchievementFinishTipsFrame_OnUpdate()
	AchievementFinishTipsShowTime = AchievementFinishTipsShowTime - arg1;
	if AchievementFinishTipsShowTime < 0 then
		curOffset = curOffset - changeOffset;
		if curOffset < 0 then
			AchievementFinishTipsFrame:SetPoint("bottom", "$parent", "top", 0, 0);			
			AchievementFinishTipsFrame:Hide();
		end		
	else
		curOffset = curOffset + changeOffset;
		if curOffset > 100 then
			curOffset = 100;
		end
	end

	AchievementFinishTipsFrame:SetPoint("bottom", "$parent", "top", 0, curOffset);
end

------------------------------------------------------GameTipsFrame-------------------------------------------------------
function GameTipsFrame_OnShow()
	local text = this:GetClientString();
	GameTipsFrameDesc:SetText(text, 255, 255, 255);
end

function GameTipsFrameCloseBtn_OnClick()
	GameTipsFrame:Hide();
end

--------------------------------------------------------GameTipsFrame1---------------------------------------------------
t_gametip = {};
--type 1√ 2× 3无
function ShowGameTips(text, type)
	if not GameTipsFrame1:IsShown() then
		GameTipsFrame1:Show();
	end
	table.insert(t_gametip, {Text = text, Type = type});
end

function GameTipsFrame1_OnLoad()
	this:setUpdateTime(0.05);

	for i=1, 3 do
		local tips = getglobal("GameTipsFrame1Tips"..i);
		tips:SetPoint("topleft", "GameTipsFrame1", "topleft", 0, 0);
	end
end

function GameTipsFrame1_OnShow()
	
end

function GameTipsFrame1_OnUpdate()
	if t_gametip[1] ~= nil then
		local tips = GetNullTipsFrame();
		if tips ~= nil then
			tips:Show();
			local text	= getglobal(tips:GetName().."Text");
			local text1	= getglobal(tips:GetName().."Text1");
			local bkg	= getglobal(tips:GetName().."Bkg");
			local bkg1  	= getglobal(tips:GetName().."Bkg1");
			local tick  	= getglobal(tips:GetName().."Tick");
			local cross 	= getglobal(tips:GetName().."Cross");

			if text:GetTextExtentWidth(t_gametip[1].Text) > 320 then
				text:Hide();
				bkg:Hide();
				text1:Show();
				bkg1:Show();
				text1:SetText(t_gametip[1].Text);
			else
				text1:Hide();
				bkg1:Hide();
				text:Show();
				bkg:Show();
				text:SetText(t_gametip[1].Text);
			end
	
			local offsetX = (text:GetWidth() - text:GetTextExtentWidth(t_gametip[1].Text))/2 - 10;
			if t_gametip[1].Type == 1 then
				tick:SetPoint("right", text:GetName(), "left", offsetX, 0);
				tick:Show();
				cross:Hide();
			elseif t_gametip[1].Type == 2 then
				cross:SetPoint("right", text:GetName(), "left", offsetX, 0);				
				tick:Hide();
				cross:Show();
			else
				tick:Hide();
				cross:Hide();
			end
			table.remove(t_gametip, 1);
		end
	elseif not IsHasShowTipsFrame() then
		GameTipsFrame1:Hide();
	end
end

function IsHasShowTipsFrame()
	for i=1, 3 do
		local tips = getglobal("GameTipsFrame1Tips"..i);
		if tips:IsShown() then
			return true;
		end
	end
	return false;
end

function GetNullTipsFrame()
	for i=1, 3 do
		local tips = getglobal("GameTipsFrame1Tips"..i);
		if not tips:IsShown() then
			if not IsHasShowTipsFrame() then
				return tips;
			else
				local fontIndex = i-1;
				if fontIndex == 0 then
					fontIndex = 3;
				end
				local frontTips = getglobal("GameTipsFrame1Tips"..fontIndex);
				local intervalY = tips:GetRealTop() - frontTips:GetRealTop();
			
				if intervalY > 45 then
					DebugString("--------------------------index="..i.."\n");
					return tips;
				end
			end
		end
	end
	return nil;
end

function GameTipsTemplate_OnLoad()
	this:setUpdateTime(0.04);
end

local t_alpha = {1.0, 1.0, 1.0};
local t_offsetY = {0, 0, 0};
local t_time	= {0.2, 0.2, 0.2};	--tips显示的时间	
function GameTipsTemplate_OnUpdate()
	local index = this:GetClientID();
	t_time[index] = t_time[index] - arg1;

	if t_time[index] < 0 then
		t_alpha[index] = t_alpha[index] - 0.04;
		t_offsetY[index] = t_offsetY[index] - 6;

		this:SetPoint("topleft", "GameTipsFrame1", "topleft", 0, t_offsetY[index])
		local bkg = getglobal(this:GetName().."Bkg");
		local text = getglobal(this:GetName().."Text");
		local tick = getglobal(this:GetName().."Tick");
		local cross = getglobal(this:GetName().."Cross");
		
		if t_alpha[index] < 0 then
			t_alpha[index] = 1.0;
			t_offsetY[index] = 0
			bkg:SetBlendAlpha(1.0);
			text:SetBlendAlpha(1.0);
			tick:SetBlendAlpha(1.0);
			cross:SetBlendAlpha(1.0);
			this:SetPoint("topleft", "GameTipsFrame1", "topleft", 0, 0)
			t_time[index] = 0.2;
			this:Hide();
		else
			bkg:SetBlendAlpha(t_alpha[index]);
			text:SetBlendAlpha(t_alpha[index]);
			if tick:IsShown() then
				tick:SetBlendAlpha(t_alpha[index]);
			end
			if cross:IsShown() then
				cross:SetBlendAlpha(t_alpha[index]);
			end
		end
	end
end
