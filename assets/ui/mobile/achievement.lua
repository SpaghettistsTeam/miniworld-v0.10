local CurAchievementGroup 	= 0;
local CurChooseAchievementId 	= 0;
local ACHIEVEMENT_NUM_MAX 	= 80;
AchievementFrameType		= 0;	--0帐号成就  1存档成就
AchArryNum			= 0;
AchNeenNum			= 0

local t_ArrowInfo = {
			["brown"] = {r=116, g=76, b=39, uv={x=1015, y=816, w=8, h=15}, },
			["green"] = {r=37, g=155, b=0, uv={x=1015, y=835, w=8, h=15}, },
			["black"] = {r=0, g=0, b=0, uv={x=1015, y=854, w=8, h=15}, },
		}

local t_achievementLabelBtnInfo = {
	{ name="AchievementFrameXinShouBtn", 	normalState={x=899, y=660, h=71, w=36}, pushState={x=825, y=660, h=71, w=36}, rewardNum=0, },
	{ name="AchievementFrameMainBtn", 	normalState={x=899, y=660, h=71, w=36}, pushState={x=825, y=660, h=71, w=36}, rewardNum=0, },	
	{ name="AchievementFrameProductionBtn", normalState={x=899, y=737, h=70, w=37}, pushState={x=825, y=737, h=70, w=37}, rewardNum=0, },
	{ name="AchievementFrameFightBtn", 	normalState={x=898, y=699, h=70, w=36}, pushState={x=824, y=699, h=70, w=36}, rewardNum=0, },
	{ name="AchievementFrameOtherBtn", 	normalState={x=899, y=777, h=71, w=36}, pushState={x=825, y=777, h=71, w=36}, rewardNum=0, },		
}

--上线的时候调用一次
--[[
function UpdateRewardNum()
	local num = AchievementMgr:getAchievementSize();
	for i=1,num do
		local achievementId = i + 1000 -1;
		local state = AchievementMgr:getAchievementState();
		if state == 2 then	
			local achievementDef = AchievementMgr:getAchievementDef(achievementId);
			local num = achievementDef.GoalNum;
			local arryNum = AchievementMgr:getAchievementArryNum(achievementId);
			if achievementDef ~= nil and arryNum >= num then	--可以领取奖励
				t_achievementLabelBtnInfo[achievementDef.Group].rewardNum = t_achievementLabelBtnInfo[achievementDef.Group].rewardNum + 1;
			end
		end
	end
end
--]]

function AchievementFrame_OnLoad()
	this:RegisterEvent("GE_ACHIEVEMENT_CHANGE");
	this:RegisterEvent("GE_ACHIEVEMENT_REWARD");
end

function AchievementFrame_OnEvent()
	if arg1 == "GE_ACHIEVEMENT_CHANGE" then
		UpdateAchievementInfo();
		UpdateAchievementDescShow(CurChooseAchievementId);
		UpdateAchievementBtnHalo(CurChooseAchievementId);
		UpdateTrackInfo();	
	end
	if arg1 == "GE_ACHIEVEMENT_REWARD" then
		local ge 	= GameEventQue:getCurEvent();
		local group 	= ge.body.achievementReward.type;
		local achiId 	= ge.body.achievementReward.achievementid;
		t_achievementLabelBtnInfo[group].rewardNum = t_achievementLabelBtnInfo[group].rewardNum + 1;
		if this:IsShown() then
			UpdateRewardTag();
		else								--没显示的时候也要更新一下状态
			local achievementDef = AchievementMgr:getAchievementDef(achiId);
			if achievementDef ~= nil then
				CurAchievementGroup = achievementDef.Group;
				if ClientCurGame:getName() == "SurviveGame" then
					AchievementFrameType = 1;
				else
					AchievementFrameType = 0;
				end
				UpdateAchievementState()
			end
		end
		UpdateAchievementFinishTips(achiId);
	end
end

function UpdateAchievementState()	
	local t_info = GetCurTypeAchievemntTable();

	for i=1,ACHIEVEMENT_NUM_MAX do
		if i <= #(t_info) then		
			local achievementDef 	= t_info[i];
			local frontState	= AchievementMgr:getAchievementState(achievementDef.ID);			
			local achievementState 	= GetAchievementState(achievementDef);
			
			if achievementState == 0 then	--判断一下其它存档这个成就的情况
				if 1 == achievementDef.Type and AccountManager:uniAchievementFinish(achievementDef.ID) then
					achievementState = 1;
				end
			elseif achievementState == 22 then
				achievementState = 2;
			end 

			if frontState ~= achievementState then 
				if AchievementFrameType ~= 0 or achievementDef.Type == 2 then 				--or not 他人存档
					AchievementMgr:setAchievementState(t_info[i].ID, achievementState);
				end
			end
		end			
	end
end

function AchievementFrame_OnShow()
--	AchievementFrameMainBtn_OnClick();
	HideAllFrame("AchievementFrame");
	AchievementFrameMainBtn:Checked();
	CurAchievementGroup = 2;
	UpdateAchievementLabelBtnState("AchievementFrameMainBtn");
	UpdateRewardTag();

	UpdateAchievementInfo();
	SetDefaultAchievementShow();

	UpdateSlidingFrameSize();
	UpdateAchievementPoint();
end

function UpdateRewardTag()
	for i=1, #(t_achievementLabelBtnInfo) do
		if i > 1 then			--新手类型的暂时没有
			local rewardTag = getglobal(t_achievementLabelBtnInfo[i].name.."RewardTag"); 
			if t_achievementLabelBtnInfo[i].rewardNum > 0 then
				rewardTag:Show();
			else
				rewardTag:Hide();
			end
		end
	end
end

function AchievementFrame_OnHide()
	AchievementIconInfo:resetOffsetPos();
end

function AchievementFrameCloseBtn_OnMounseDown()
	local btnIcon = getglobal("AchievementFrameCloseBtnIcon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(37,37);
end

function AchievementFrameCloseBtn_OnMouseUp()
	local btnIcon = getglobal("AchievementFrameCloseBtnIcon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(47,48);
end

function AchievementFrameCloseBtn_OnClick()
	AchievementFrame:Hide();
end

function AchievementFrameMainBtn_OnClick()
	CurAchievementGroup = 2;
	UpdateAchievementLabelBtnState("AchievementFrameMainBtn");
		
	UpdateAchievementInfo();
	SetDefaultAchievementShow();
	UpdateSlidingFrameSize();
end

function AchievementFrameProductionBtn_OnClick()
	CurAchievementGroup = 3;
	UpdateAchievementLabelBtnState("AchievementFrameProductionBtn");
	
	UpdateAchievementInfo();
	SetDefaultAchievementShow();
	UpdateSlidingFrameSize();
end

function AchievementFrameFightBtn_OnClick()
	CurAchievementGroup = 4;
	UpdateAchievementLabelBtnState("AchievementFrameFightBtn");

	UpdateAchievementInfo();
	SetDefaultAchievementShow();
	UpdateSlidingFrameSize();
end

function AchievementFrameOtherBtn_OnClick()
	CurAchievementGroup = 5;
	UpdateAchievementLabelBtnState("AchievementFrameOtherBtn");	

	
	UpdateAchievementInfo();
	SetDefaultAchievementShow();
	UpdateSlidingFrameSize();
end

function UpdateAchievementLabelBtnState(btnName)
	AchievementLine:clearLine();
	AchievementIconInfo:resetOffsetPos();
	for i=1,#(t_achievementLabelBtnInfo) do
		if i > 1 then				--新手类型暂时没有
			local info = t_achievementLabelBtnInfo[i];
			local btn = getglobal(info.name);
			local btnIcon = getglobal(info.name.."Icon");		
			if info.name == btnName then
				btnIcon:SetTexUV(info.pushState.x, info.pushState.y, info.pushState.h, info.pushState.w);
			else
				btn:SetChecked(false);
				btnIcon:SetTexUV(info.normalState.x, info.normalState.y, info.normalState.h, info.normalState.w);
			end
		end
	end
end

function GetCurTypeAchievemntTable()
	local t_info = {};

	local num = AchievementMgr:getAchievementSize();
	for i=1,num do
		local achievementId = i + 1000 -1;
		local achievementDef = AchievementMgr:getAchievementDef(achievementId);
		if achievementDef ~= nil and CurAchievementGroup == achievementDef.Group then
			table.insert(t_info, achievementDef);
		end
	end
	return t_info;
end

function UpdateSlidingFrameSize()
	local t_info = GetCurTypeAchievemntTable();
	local maxGridX = 0;
	local maxGridY = 0;
	for i=1, #(t_info) do
		if t_info[i].GridX > maxGridX then
			maxGridX = t_info[i].GridX;
		end
		if t_info[i].GridY > maxGridY then
			maxGridY = t_info[i].GridY;
		end
	end
	local sizeX = 867;
	local sizeY = 385;
	if maxGridX*70+17 > sizeX then
		sizeX = maxGridX*70 + 25;
	end
	if maxGridY*70+17 > sizeY then
		sizeY = maxGridY*70 + 25;
	end

	AchievementIconInfoPlane:SetSize(sizeX, sizeY);
end

function UpdateAchievementInfo()
	local t_info = GetCurTypeAchievemntTable();

	for i=1,ACHIEVEMENT_NUM_MAX do
		local btn 	 = getglobal("AchievementBtn"..i);
		local btnIcon 	 = getglobal("AchievementBtn"..i.."Icon");
		local btnAward1  = getglobal("AchievementBtn"..i.."Award1");
		local unlock	 = getglobal("AchievementBtn"..i.."Unlock");	
		local lockIcon   = getglobal("AchievementBtn"..i.."Lock");
		local finishIcon = getglobal("AchievementBtn"..i.."Finish");
		local btnArrow 	 = getglobal("AchievementBtn"..i.."Arrow");
	
		if i <= #(t_info) then		
			local achievementDef 	= t_info[i];
			local frontState	= AchievementMgr:getAchievementState(achievementDef.ID);			
			local achievementState 	= GetAchievementState(achievementDef);
			
			if achievementState == 0 then	--判断一下其它存档这个成就的情况
				if 1 == achievementDef.Type and AccountManager:uniAchievementFinish(achievementDef.ID) then
					achievementState = 1;
				end
			end 
			
			if achievementState == 0 then
				btnIcon:Hide();
				lockIcon:Show();
				finishIcon:Hide();
				btnAward1:Hide();				
			elseif achievementState == 1 then
				btnIcon:Show();
				btnIcon:SetGray(true);
				lockIcon:Hide();
				finishIcon:Hide();
				btnAward1:Hide();
			elseif achievementState == 2 or achievementState == 22 then
				btnIcon:Show();
				btnIcon:SetGray(false);
				lockIcon:Hide();
				finishIcon:Hide();
				if achievementState == 22 then			--可领取奖励特效
					btnAward1:SetUVAnimation(100, true);
					btnAward1:Show();
					achievementState = 2;
				else
					btnAward1:Hide();
				end			
			elseif achievementState == 3 then
				btnIcon:Show();
				btnIcon:SetGray(false);
				lockIcon:Hide();
				finishIcon:Show();
				btnAward1:Hide();
			end
--[[
			if AchievementFrameType == 0 then		--帐号成就图标设置
				if achievementState < 3 then
					btnIcon:Hide();
					lockIcon:Show();
					finishIcon:Hide();
					btnAward1:Hide();
				else
					btnIcon:Show();
					btnIcon:SetGray(false);
					lockIcon:Hide();
					finishIcon:Show();
					btnAward1:Hide();
				end
			end
]]		
			if frontState < 2 and achievementState == 2 then	--解锁特效
				unlock:SetUVAnimation(100, false);
			end

			if frontState ~= achievementState then 
				if AchievementFrameType ~= 0 or achievementDef.Type == 2 then 				--or not 他人存档
					AchievementMgr:setAchievementState(t_info[i].ID, achievementState);
				end
			end			
			UpdateAchievementEye();
		
			btnArrow:Hide();
			SetAchievementBtnIcon(btnIcon, achievementDef.IconID);
			SetAchievementBtnLine(achievementDef, btnArrow, achievementState);
			btn:SetPoint("topleft", "AchievementLine", "topleft", 70*(achievementDef.GridX-1), 70*(achievementDef.GridY-1));
			btn:SetClientUserData(0,t_info[i].ID);
			btn:Show();
		else
			btn:Hide();
		end
	end
end

--achievementState 0未解锁 1解锁未激活 2激活未完成 22激活可领取奖励  3激活完成
function GetAchievementState(achievementDef)
	for i=1, 4 do
		local frontId = achievementDef.FrontID[i-1];
		local frontDef =  AchievementMgr:getAchievementDef(frontId);     --DefMgr:getAchievementDef(frontId);
		if frontId > 0 and frontDef ~= nil then			
			if GetAchievementState(frontDef) < 3 then		--有前置条件为未完成(可领取奖励除外)，当前的成就状态为0
				return 0;
			end
		end
	end
	
	if AchievementMgr:getAchievementArryNum(achievementDef.ID) >= achievementDef.GoalNum then
		if AchievementMgr:getAchievementRewardState(achievementDef.ID) == 2 then		--领取了奖励，状态为3
			return 3;
		else
			if AchievementMgr:getAchievementRewardState(achievementDef.ID) ~= 1 then 
				if AchievementFrameType ~= 0 or achievementDef.Type == 2 then 				--or not 他人存档		
					AchievementMgr:setAchievementRewardState(achievementDef.ID, 1);			--奖励状态设置为可领取状态													
				end				
			end
			return 22;
		end
	else
		return 2;
	end
end

--设置图标
function SetAchievementBtnIcon(btnIcon, itemId)
	local u = 0;
	local v = 0;
	local width = 0;
	local height = 0;
	local r = 255;
	local g = 255;
	local b = 255;
	h, u, v, width, height, r, g, b = ClientMgr:getItemIcon(itemId, u, v, width, height, r, g, b);
	btnIcon:SetTextureHuires(h);
	btnIcon:SetTexUV(u, v, width, height);
	btnIcon:SetColor(r, g, b);
end

--画线、箭头
function SetAchievementBtnLine(achievementDef, btnArrow, achievementState)
	local color = "black";
	if achievementState == 2 then
		color = "green";
	elseif achievementState == 3 then
		color = "brown"
	end

	btnArrow:SetTexUV(t_ArrowInfo[color].uv.x, t_ArrowInfo[color].uv.y, t_ArrowInfo[color].uv.w, t_ArrowInfo[color].uv.h);
	for i=1, 4 do
		local frontId = achievementDef.FrontID[i-1];
		local frontDef =  AchievementMgr:getAchievementDef(frontId);
		if frontId > 0 and frontDef ~= nil then			
			btnArrow:Show();			--有前置条件就显示箭头
			AchievementLine:AddLine(frontDef.GridX, frontDef.GridY, achievementDef.GridX, achievementDef.GridY, t_ArrowInfo[color].r, t_ArrowInfo[color].g, t_ArrowInfo[color].b);
		end
	end
end

--追踪眼睛图标
function UpdateAchievementEye()
	for i=1, ACHIEVEMENT_NUM_MAX do
		local btn 	= getglobal("AchievementBtn"..i);
		local btnEye	= getglobal("AchievementBtn"..i.."Eye");
		if AchievementMgr:getCurTrackID() == btn:GetClientUserData(0) and AchievementMgr:getCurTrackID() > 0 and AchievementFrameType == 1 then
			btnEye:Show();	
		else
			btnEye:Hide();
		end
		--[[
		if 他人地图存档 then
			btnEye:Hide();
		end
		]]
	end
end

function SetDefaultAchievementShow()
	local t_info = GetCurTypeAchievemntTable();
	for i=1, #(t_info) do
		if AchievementMgr:getAchievementState(t_info[i].ID) == 2 then
			CurChooseAchievementId = t_info[i].ID;
			UpdateAchievementDescShow(t_info[i].ID);
			UpdateAchievementBtnHalo(t_info[i].ID);			
			return;
		end
	end
end

function UpdateAchievementPoint()
	local szText = DefMgr:getStringDef(57).."#cffffff"..AccountManager:getAchievementPoints();
--[[
	if 他人地图存档 then
		szText = "这里是玩家名字的进度";
	end
]]
	AchievementFramePoint:SetText(szText, 80, 54, 22);
end

function AchievementBtn_OnClick()
	local achievementId = this:GetClientUserData(0);
	local btnAward4 = getglobal("AchievementDecsRewardBtnAward4");
	btnAward4:Hide(); 
	CurChooseAchievementId = achievementId;	
	UpdateAchievementDescShow(achievementId);
	UpdateAchievementBtnHalo(achievementId);
end

function UpdateAchievementBtnHalo(achievementId)
	local t_info = GetCurTypeAchievemntTable();

	for i=1,ACHIEVEMENT_NUM_MAX do
		if i < #(t_info) then
			local btn 	= getglobal("AchievementBtn"..i);
			local halo 	= getglobal("AchievementBtn"..i.."Halo"); 
			if btn:GetClientUserData(0) == CurChooseAchievementId then
				halo:SetUVAnimation(50, true);
				halo:Show();
			else
				halo:Hide();
			end
		end
	end
end

function UpdateAchievementDescShow(achievementId)
	UpdateAchievementDesc(achievementId);
	UpdateAchievementFrontCondition(achievementId);
	UpdateAchievementReward(achievementId);
	UpdateAchievementTrackTag();
end

--前置条件
function UpdateAchievementFrontCondition(achievementId)
	local achievementDef = AchievementMgr:getAchievementDef(achievementId);
	
	if achievementDef ~= nil then
		AchievementDecsCondition1:SetText(DefMgr:getStringDef(57));
		AchievementDecsCondition1:SetTextColor(98, 97, 97);
		for i=1, 4 do
			local condition	= getglobal("AchievementDecsCondition"..i)
			local frontId 	= achievementDef.FrontID[i-1];
			local frontDef 	= AchievementMgr:getAchievementDef(frontId); --DefMgr:getAchievementDef(frontId);
			if frontId > 0 and frontDef ~= nil then
				condition:SetText(frontDef.Name);				
				if AchievementMgr:getAchievementState(frontId) == 3 then
					condition:SetTextColor(255, 234, 0);
				else
					condition:SetTextColor(98, 97, 97);
				end
			elseif i ~= 1 then
				condition:SetText("");
			end
		end
 	end
end

--描述
function UpdateAchievementDesc(achievementId)
	local achievementDef = AchievementMgr:getAchievementDef(achievementId);   --DefMgr:getAchievementDef(achievementId);
	if achievementDef ~= nil then
		AchievementDecsText:SetText(achievementDef.Desc);
		local szText = achievementDef.Name;
		if AchievementFrameType == 1 or achievementDef.Type == 2 then --and not 他人地图存档		--存档成就或者成就类型为帐号成就的时候才显示进度
			local num = achievementDef.GoalNum;
			local arryNum = AchievementMgr:getAchievementArryNum(achievementDef.ID);			
			local szText = achievementDef.Name.."#cff0000("..arryNum.."/"..num..")";
		end
		AchievementDecsName:SetText(szText, 255, 255, 255);
	end
end

--奖励
function UpdateAchievementReward(achievementId)
	local achievementDef = AchievementMgr:getAchievementDef(achievementId); 
	if achievementDef == nil then return; end

	for i=1, 2 do
		local rewardIcon 	= getglobal("AchievementDecsReward" .. i);
		local numFont 		= getglobal("AchievementDecsRewardNum" .. i);
		local rewardItemBtn	= getglobal("AchievementDecsRewardItemBtn"..i);
		if achievementDef.RewardID[i-1] > 0 then
			if achievementDef.RewardType[i-1] == 0 then
				SetAchievementBtnIcon(rewardIcon, achievementDef.RewardID[i-1]);
			elseif achievementDef.RewardType[i-1] == 1 then
				rewardIcon:SetTexture("ui/mobile/ui.png");
				rewardIcon:SetTexUV(682, 70, 26, 26);
			elseif achievementDef.RewardType[i-1] == 2 then
				rewardIcon:SetTexture("ui/mobile/ui.png");
				rewardIcon:SetTexUV(434, 213, 49, 53);
			end
			numFont:SetText("×"..achievementDef.RewardNum[i-1]);
			rewardItemBtn:SetClientUserData(0, achievementDef.RewardID[i-1]);	--用来标记奖励物品的itemID;
		else
			rewardIcon:SetTextureHuires(ClientMgr:getNullItemIcon());
			numFont:SetText("");
			rewardItemBtn:SetClientUserData(0, 0);
		end
	end
	
	local btn 	= getglobal("AchievementDecsRewardBtn");
	local btnNormal = getglobal("AchievementDecsRewardBtnNormal");
	local btnName = getglobal("AchievementDecsRewardBtnName");

	local btnAward4 = getglobal("AchievementDecsRewardBtnAward4");
	btnAward4:Hide();
	local state = AchievementMgr:getAchievementRewardState(achievementId);
	if state == 0 then
		btn:Disable();
		btnNormal:SetGray(true);
		btnName:SetTexUV(802, 992, 120, 30);
		btnName:SetSize(135, 34);
	elseif state == 1 then
		btn:Enable();
		btnNormal:SetGray(false);
		btnName:SetTexUV(802, 992, 120, 30);
		btnName:SetSize(135, 34);
		local btnAward4 = getglobal("AchievementDecsRewardBtnAward4");
		btnAward4:SetUVAnimation(100, true);		
	elseif state == 2 then
		btn:Disable();
		btnNormal:SetGray(true);
		btnName:SetTexUV(933, 992, 89, 30);
		btnName:SetSize(100, 34);
	end

	if AchievementFrameType == 0 and achievementDef.Type == 1 then	--or 他人地图存档 --如果是帐号成就，类型为普通的成就 不可领取奖励
		btn:Disable();
		btnNormal:SetGray(true);
		local btnAward4 = getglobal("AchievementDecsRewardBtnAward4");
		btnAward4:Hide();
	end
end

function AchievementDecsRewardItemBtn_Onclick()
	local itemId = this:GetClientUserData(0);
	if itemId > 0 and DefMgr:getItemDef(itemId) then
		local itemDef = DefMgr:getItemDef(itemId);
		UpdateTipsFrame(itemDef.Name, 0);	
	end
end

--追踪标记
function UpdateAchievementTrackTag()
	if AchievementFrameType == 0 then -- or 他人地图存档				--帐号成就不允许追踪
		AchievementDecsTrackBtnTrackTag:Hide();
		return
	end
	if AchievementMgr:getCurTrackID() == CurChooseAchievementId then
		AchievementDecsTrackBtnTrackTag:Show();
	else
		AchievementDecsTrackBtnTrackTag:Hide();
	end
end

--追踪
function AchievementDecsTrackBtn_OnClick()
	--[[
		if 他人地图存档 then
			return;
		end
	]]
	if  AchievementMgr:getAchievementState(CurChooseAchievementId) == 2 and AchievementFrameType == 1 then	--存档成就才可以点击追踪
		if AchievementDecsTrackBtnTrackTag:IsShown() then
			AchievementDecsTrackBtnTrackTag:Hide();
			AchievementMgr:setCurTrackID(0);
		else
			AchievementDecsTrackBtnTrackTag:Show();
			AchievementMgr:setCurTrackID(CurChooseAchievementId);
		end
		UpdateAchievementEye();
		UpdateTaskTrackFrame();
	end
end

function UpdateTrackInfo()
	if AchievementFrameType == 0 then	--or 他人地图存档	--帐号成就不更新追踪面板
		return;
	end
	if  AchievementMgr:getAchievementState(AchievementMgr:getCurTrackID()) ~= 2 then
		AchievementDecsTrackBtnTrackTag:Hide();
		AchievementMgr:setCurTrackID(0);
		
	end
	UpdateAchievementEye();
	UpdateTaskTrackFrame();
end

function hasFinishAchievement()
	for i=1, #(t_achievementLabelBtnInfo) do
		if i > 1 then			--新手类型的暂时没有
			local rewardTag = getglobal(t_achievementLabelBtnInfo[i].name.."RewardTag"); 
			if t_achievementLabelBtnInfo[i].rewardNum > 0 then
				return true;
			end
		end
	end

	return false;
end

--领取奖励
function AchievementDecsRewardBtn_OnClick()
	local achievementDef = AchievementMgr:getAchievementDef(CurChooseAchievementId);   --DefMgr:getAchievementDef(CurChooseAchievementId);
	if achievementDef ~= nil then
		for i=1, 2 do
			local type	= achievementDef.RewardType[i-1];
			local itemId 	= achievementDef.RewardID[i-1];
			local num 	= achievementDef.RewardNum[i-1]
			if itemId > 0 then
				if type == 0 then
					CurMainPlayer:gainItems(itemId, num);
				elseif type == 1 then
					local exp = num * 100;
					MainPlayerAttrib:addExp(exp);
				elseif type == 2 then
				end
			end
		end
		
		AchievementMgr:setAchievementState(CurChooseAchievementId, 3);	
		AchievementMgr:setAchievementRewardState(CurChooseAchievementId, 2);
		t_achievementLabelBtnInfo[CurAchievementGroup].rewardNum = t_achievementLabelBtnInfo[CurAchievementGroup].rewardNum - 1;
		UpdateAchievementInfo();
		UpdateAchievementDescShow(CurChooseAchievementId);	
		UpdateTrackInfo();
		UpdateRewardTag();
		UpdateAchievementPoint();
	
		SetLeftGongNengFrameTag( hasFinishAchievement() );

		local btnName = GetCurSelectAchievementBtn();
		if btnName ~= nil then
			local btnAward2  = getglobal(btnName.."Award2");
			btnAward2:SetUVAnimation(100, false);

			local btnAward3 = getglobal("AchievementDecsRewardBtnAward3");
			btnAward3:SetUVAnimation(100, false);
			local btnAward4 = getglobal("AchievementDecsRewardBtnAward4");
			btnAward4:Hide(); 
		end

		ClientMgr:playSound2D("sounds/ui/info/achievement_complete.ogg", 500);
	end
end

function GetCurSelectAchievementBtn()
	local t_info = GetCurTypeAchievemntTable();
	for i=1,ACHIEVEMENT_NUM_MAX do
		if i < #(t_info) then
			local btn 	= getglobal("AchievementBtn"..i);
			if btn:GetClientUserData(0) == CurChooseAchievementId then
				return btn:GetName();
			end
		end
	end
	return nil;
end

function AchievementFrameArrow_OnLoad()
	this:setUpdateTime(0.05);
end

--更新箭头
local changeSpeed = 2;
local changeOffset = changeSpeed
local curOffset = 0;
function AchievementFrameArrow_OnUpdate()
	curOffset = curOffset + changeOffset;
	if curOffset > 15 then
		curOffset = 15;
		changeOffset = -changeSpeed*0.5;
	elseif curOffset <= 0 then
		curOffset = 0;
		changeOffset = changeSpeed;
	end

	if AchievementIconInfo:getCanMoveTopDistance() > 0 then
		AchievementFrameArrowTop:Show();
	else
		AchievementFrameArrowTop:Hide();
	end
	if AchievementIconInfo:getCanMoveLeftDistance() > 0 then
		AchievementFrameArrowLeft:Show();
	else
		AchievementFrameArrowLeft:Hide();
	end
	if AchievementIconInfo:getCanMoveBottomDistance() > 0 then
		AchievementFrameArrowBottom:Show();
	else
		AchievementFrameArrowBottom:Hide();
	end
	if AchievementIconInfo:getCanMoveRightDistance() > 0 then
		AchievementFrameArrowRight:Show();
	else
		AchievementFrameArrowRight:Hide();
	end

	if AchievementFrameArrowTop:IsShown() then			
		AchievementFrameArrowTop:SetPoint("bottom", "AchievementFrameIconBox", "top", 0, 20-curOffset);
	end
	if AchievementFrameArrowLeft:IsShown() then			
		AchievementFrameArrowLeft:SetPoint("right", "AchievementFrameIconBox", "left",20-curOffset, 0);
	end
	if AchievementFrameArrowBottom:IsShown() then			
		AchievementFrameArrowBottom:SetPoint("bottom", "AchievementFrameIconBox", "bottom", 0, 10+curOffset);
	end
	if AchievementFrameArrowRight:IsShown() then			
		AchievementFrameArrowRight:SetPoint("right", "AchievementFrameIconBox", "right", 10+curOffset, 0);
	end
end
