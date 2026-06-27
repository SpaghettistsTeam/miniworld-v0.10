
MAX_SHORTCUT = 6
ShortCut_SelectedIndex = -1
CurPlayerExpVal = 0;

----------------------------------------------------UIHideFrame---------------------------------------------------
t_UIName = { "PlayMainFrame", "GongNengFrame"}

function UIHideFrame_OnLoad()
	this:setUpdateTime(0.05);
end

function UIHideFrame_OnShow()
	UIHideFrameTex:SetBlendAlpha(1);	
end

function UIHideFrame_OnClick()
	if UIHideFrameTex:GetBlendAlpha() == 0 then
		UIHideFrameTex:SetBlendAlpha(1);
	else
		for i=1, #(t_UIName) do
			local frame = getglobal(t_UIName[i]);
			frame:Show();
		end
		UIHideFrame:Hide();
		CurMainPlayer:setUIHide(false);
	end
end

function UIHideFrame_OnUpdate()
	if UIHideFrameTex:GetBlendAlpha() > 0 then
		local alpha = UIHideFrameTex:GetBlendAlpha() - 0.05;
		if alpha < 0 then
			alpha = 0;
		end
		UIHideFrameTex:SetBlendAlpha(alpha);
	end
end

----------------------------------------------------PlayMainFrame-----------------------------------------------------
t_allFrame =  {
		"BackpackFrame",
		"CreateBackpackFrame",
		"StorageBoxFrame",
		"FurnaceFrame",
		"RepairFrame", 
		"CraftingTableFrame",
		"FriendFrame",
		"AchievementFrame",
		"DeathFrame",
		"ToSeeFriendFrame",
		"FriendFrame",
		"AddFriendFrame", 
		"BuffFrame", 
		"EnchantFrame", 
		"IntroduceFrame",
		"MonumentFrame",
	}
function HideAllFrame(frameName)
	for i=1, #(t_allFrame) do		
		if t_allFrame[i] ~= frameName then
			local frame = getglobal(t_allFrame[i]);
			if frame:IsShown() then
				frame:Hide();
			end
		end
	end
end


function HideAllUI()
	for i=1, #(t_UIName) do
		local frame = getglobal(t_UIName[i]);
		if frame:IsShown() then
			frame:Hide();
		end
	end
	for i=1, #(t_allFrame) do		
		local frame = getglobal(t_allFrame[i]);
		if frame:IsShown() then
			frame:Hide();
		end
	end

	CurMainPlayer:setUIHide(true);
	UIHideFrame:Show();
end

function PlayShortcut_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");
	this:RegisterEvent("GE_SHORTCUT_SELECTED");

	for i=1,MAX_SHORTCUT do
		local ShortcutBtn = getglobal("ToolShortcut"..i);
		local x = 10 + (i-1)*82;
		local x = math.floor(413*(i-1)/5) + 10;
		ShortcutBtn:SetPoint("TOPLEFT", "PlayShortcut", "TOPLEFT", x, 6);
	end
end

function PlayShortcut_OnUpdate()
	if not BackpackFramePackFrame:IsShown() then
		return;
	end
	if selectBackpackGrid < 0 or selectBackpackGrid < SHORTCUT_START_INDEX or selectBackpackGrid > SHORTCUT_START_INDEX + 1000 then
		return
	end
--[[
	local index  = selectBackpackGrid - SHORTCUT_START_INDEX + 1;
	local selbox = getglobal("ToolShortcut"..index.."ContentBoxTexture");
	shortcutBoxDisplayTime = shortcutBoxDisplayTime - arg1
	if shortcutBoxDisplayTime > 0 then		
		if selbox:IsShown() then
			selbox:Hide();
		else
			selbox:Show()
		end
	else
		selbox:Show();
	end
--]]
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

	UpdateItemIconCount(ShortcutIcon, ShortcutNum, durbar, grid_index);
	if n-1 == ShortCut_SelectedIndex then
		ClientCurGame:setCurToolID(ClientBackpack:getGridItem(grid_index));
	end
end

function ShortCutFrame_UpdateAllGrids()
	for i=0, 5, 1 do
		ShortCutFrame_UpdateOneGrid(SHORTCUT_START_INDEX+i)
	end
end

function ShortCutFrame_Selected(index)
	if BackpackFramePackFrame:IsShown() then
		return;
	end

	if ShortCut_SelectedIndex >= 0 then
		local selbox = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentBoxTexture1");
		selbox:Hide()
--		local uv = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentUVAnimationTex")
--		uv:Hide();
	end

	ShortCut_SelectedIndex = index;

	local selbox = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentBoxTexture1");
	selbox:Show();
--	local uv = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentUVAnimationTex")
--	uv:SetUVAnimation(150, true);
--	uv:Show();
end

function HideShortCutAllItemBoxTexture()
	for i=1, 6 do
		local boxTexture = getglobal("ToolShortcut"..i.."ContentBoxTexture");
		boxTexture:Hide();
	end
end

function PlayShortcut_OnEvent()
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
	end
end


local tagIsShow = false;
function PlayLeftGongNengExtend_OnClick()
	PlayLeftGongNengExtend:Hide();
	PlayLeftGongNengShrink:Show();
	PlayLeftGongNengList:Show();

	if tagIsShow then
		PlayLeftGongNengListAchievementBtnRewardTag:Show();
	else
		PlayLeftGongNengListAchievementBtnRewardTag:Hide();
	end
end

function PlayLeftGongNengShrink_OnClick()
	PlayLeftGongNengExtend:Show();
	
	PlayLeftGongNengShrink:Hide();
	PlayLeftGongNengList:Hide();

	if tagIsShow then
		PlayLeftGongNengExtendRewardTag:Show();
	else
		PlayLeftGongNengExtendRewardTag:Hide();
	end
end

function PlayLeftGongNengListMapBtn_OnClick()
	ClientCurGame:enableMinimap(true);
	MapFrame:Show();

	for i=1, #(t_UIName) do
		local frame = getglobal(t_UIName[i]);
		if frame:IsShown() then
			frame:Hide();
		end
	end
	for i=1, #(t_allFrame) do		
		local frame = getglobal(t_allFrame[i]);
		if frame:IsShown() then
			frame:Hide();
		end
	end

	CurMainPlayer:setUIHide(true, true);
	PlayLeftGongNengShrink_OnClick();
end

function PlayLeftGongNengListAchievementBtn_OnClick()
	if not AchievementFrame:IsShown() then
		AchievementFrameType = 1;
		AchievementFrame:Show();
		AchievementFrame:SetPoint("bottom", "PlayShortcut", "top", -30, 0);
	end
	PlayLeftGongNengShrink_OnClick();
end

function SetLeftGongNengFrameTag(isShow)
	tagIsShow = isShow;
	if isShow then
		if PlayLeftGongNengExtend:IsShown() then
			PlayLeftGongNengExtendRewardTag:Show();
		end
		if PlayLeftGongNengList:IsShown() then
			PlayLeftGongNengListAchievementBtnRewardTag:Show();
		end
	else
		if PlayLeftGongNengExtend:IsShown() then
			PlayLeftGongNengExtendRewardTag:Hide();
		end
		if PlayLeftGongNengList:IsShown() then
			PlayLeftGongNengListAchievementBtnRewardTag:Hide();
		end
	end
end

function PlayLeftGongNengListEnchantBtn_OnClick()
	if EnchantFrame:IsShown() then
		EnchantFrame:Hide();
	else
		Enchant_Type = 1;
		EnchantFrame:Show();
	end
	PlayLeftGongNengShrink_OnClick();
end

function PlayerBuff_OnLoad()
	this:setUpdateTime(0.05);
end

function PlayerBuff_OnUpdate()
	local num = MainPlayerAttrib:getBuffNum();
	if num < 1 then
		PlayerBuff1:Hide();
		PlayerBuff2:Hide();
		PlayerBuff3:Hide();
		if BuffFrame:IsShown() then
			BuffFrame:Hide();
		end
	 	return;
	end

	local t_buff = {};
	local t_debuff = {};
	for i=1, num do
		local info = MainPlayerAttrib:getBuffInfo(i-1);
		local time = math.ceil( (info.def.EffectTicks - info.ticks)*0.05 );
		if info.def.Type == 0 then
			table.insert(t_buff, {iconName=info.def.IconName, remaintime=time});
		elseif info.def.Type == 1 then
			table.insert(t_debuff, {iconName=info.def.IconName, remaintime=time});
		end
	end
	
	if #(t_buff) > 1 then
		table.sort(t_buff,
			 function(a,b)
				return a.remaintime < b.remaintime;
			 end
			);
	end

	if #(t_debuff) > 1 then
		table.sort(t_debuff,
			 function(a,b)
				return a.remaintime < b.remaintime;
			 end
			);
	end

	local buff1 = getglobal("PlayerBuff1");
	local buff2 = getglobal("PlayerBuff2"); 
	local buff3 = getglobal("PlayerBuff3");  	

	if #(t_buff) > 1 then
		buff1:Show();
		buff2:Show();

		local icon1 	= getglobal(buff1:GetName().."Icon");
		local time1  	= getglobal(buff1:GetName().."RemainTime");
		icon1:SetTexture("ui/bufficons/"..t_buff[1].iconName..".png");
		local timetext = t_buff[1].remaintime.."s";
		if t_buff[1].remaintime > 60 then 
			timetext = math.floor(t_buff[1].remaintime/60).."m";
		end
		time1:SetText(timetext);

		local icon2 = getglobal(buff2:GetName().."Icon");
		local time2  = getglobal(buff2:GetName().."RemainTime");	
		icon2:SetTexture("ui/bufficons/"..t_buff[2].iconName..".png");
		timetext = t_buff[2].remaintime.."s";
		if t_buff[2].remaintime > 60 then 
			timetext = math.floor(t_buff[2].remaintime/60).."m";
		end
		time2:SetText(timetext);

		if #(t_debuff) > 0 then
			buff3:Show();
			local icon3 = getglobal(buff3:GetName().."Icon");
			local time3  = getglobal(buff3:GetName().."RemainTime");
			icon3:SetTexture("ui/bufficons/"..t_debuff[1].iconName..".png");
			timetext = t_debuff[1].remaintime.."s";
			if t_debuff[1].remaintime > 60 then 
				timetext = math.floor(t_debuff[1].remaintime/60).."m";
			end
			time3:SetText(timetext);
		else
			buff3:Hide();
		end
	elseif #(t_buff) > 0 then
		buff1:Show();
		local icon1 = getglobal(buff1:GetName().."Icon");
		local time1  = getglobal(buff1:GetName().."RemainTime");
		icon1:SetTexture("ui/bufficons/"..t_buff[1].iconName..".png");
		local timetext = t_buff[1].remaintime.."s";
		if t_buff[1].remaintime > 60 then 
			timetext = math.floor(t_buff[1].remaintime/60).."m";
		end
		time1:SetText(timetext);

		if #(t_debuff) > 0 then
			buff2:Show();
			local icon2 = getglobal(buff2:GetName().."Icon");
			local time2  = getglobal(buff2:GetName().."RemainTime");
			icon2:SetTexture("ui/bufficons/"..t_debuff[1].iconName..".png");
			timetext = t_debuff[1].remaintime.."s";
			if t_debuff[1].remaintime > 60 then 
				timetext = math.floor(t_debuff[1].remaintime/60).."m";
			end
			time2:SetText(timetext);
		else
			buff2:Hide();
		end
		buff3:Hide();
	else
		if #(t_debuff) > 0 then
			buff1:Show();
			local icon1 = getglobal(buff1:GetName().."Icon");
			local time1  = getglobal(buff1:GetName().."RemainTime");
			icon1:SetTexture("ui/bufficons/"..t_debuff[1].iconName..".png");
			local timetext = t_debuff[1].remaintime.."s";
			if t_debuff[1].remaintime > 60 then 
				timetext = math.floor(t_debuff[1].remaintime/60).."m";
			end
			time1:SetText(timetext);
		else
			buff1:Hide();
		end

		buff2:Hide();
		buff3:Hide();
	end 
end

function PlayerBuff_OnClick()
	if BuffFrame:IsShown() then
		BuffFrame:Hide();
	else
		BuffFrame:Show();
	end
end

function PlayHPBar_OnLoad()
	this:RegisterEvent("GE_PLAYERATTR_CHANGE")
end

function PlayHPBar_OnShow()
end

function PlayOxygenBar_OnLoad()
	this:RegisterEvent("GE_PLAYERATTR_CHANGE")
	this:RegisterEvent("GE_SHOW_OXYGEN")
end

function PlayOxygenBar_OnEvent()
	if arg1 == "GE_PLAYERATTR_CHANGE" then
		PlayerOxygenBar:SetCurValue(MainPlayerAttrib:getOxygen()/10, false);
	elseif arg1 == "GE_SHOW_OXYGEN" then
		local ge = GameEventQue:getCurEvent()
		if ge.body.oxygen.show and not CurWorld:isCreativeMode()then
			PlayerOxygenBar:Show()
		else
			PlayerOxygenBar:Hide()
		end
	end
end

function PlayHPBar_OnEvent()
	if arg1 == "GE_PLAYERATTR_CHANGE" then
		PlayerHPBar:SetCurValue(MainPlayerAttrib:getHP()/MainPlayerAttrib:getMaxHP(), false)
	end
end

function PlayerExpBar_OnLoad()
	this:RegisterEvent("GE_PLAYERATTR_CHANGE");
end

function PlayerExpBar_OnEvent()
	if arg1 == "GE_PLAYERATTR_CHANGE" then
		SetExpBar();
	end
end

function SetExpBar()
	local exp = MainPlayerAttrib:getExp();
	if exp ~= CurPlayerExpVal then
		starNum = math.floor(exp/100);
		PlayerExpBarText:SetText(starNum);

		local expBarVal = (exp - starNum * 100) / 100 ;
		PlayerExpBarExp:SetWidth(578*expBarVal);
		
		local uv = getglobal("PlayerExpBarUVAnimationTex");
		uv:SetPoint("right", "PlayerExpBarExp", "right", 20, 0);
		uv:SetUVAnimation(80, false);
		uv:Show();		
		
		curStarNum = math.floor(CurPlayerExpVal/100);
		if starNum > curStarNum then
			--星星特效
			local starUV = getglobal("PlayerExpBarStarUV");
			starUV:SetUVAnimation(100, false);
			starUV:Show();
			ClientMgr:playSound2D("sounds/ui/info/experience_star.ogg", 500);	
		end

		CurPlayerExpVal = exp;
	end		
end

function PlayMainFrameSneakBtn_OnClick()
end

function PlayMainFrameFlyBtn_OnClick()
	if PlayMainFrameFlyDown:IsShown() then
		PlayMainFrameFlyDown:Hide();
		CurMainPlayer:setFlyMode(false);
	else
		PlayMainFrameFlyDown:Show();		
		CurMainPlayer:setFlyMode(true);
	end
	
	if PlayMainFrameFlyUp:IsShown() then
		PlayMainFrameFlyUp:Hide()
	else
		PlayMainFrameFlyUp:Show()
	end
end

function PlayMainFrameFlyDown_OnMouseUp()
	CurMainPlayer:cancelMoveUp(-1)
end
function PlayMainFrameFlyDown_OnMouseDown()
	CurMainPlayer:setMoveUp(-1)
end
function PlayMainFrameFlyDown_OnClick()
end

function PlayMainFrameFlyUp_OnMouseUp()
	CurMainPlayer:cancelMoveUp(1)
end
function PlayMainFrameFlyUp_OnMouseDown()
	CurMainPlayer:setMoveUp(1)
end
function PlayMainFrameFlyUp_OnClick()
end

function PlayMainFrameSettingBtn_OnClick()
	if ClientCurGame:getName() == "SurviveGame" then
		if not GameOptionFrame:IsShown() then
			GameOptionFrame:Show()
			ClientCurGame:setOperateUI(true)
		end
	end
end

function PlayMainFrameBackpackBtn_OnClick()
	if CurWorld:isCreativeMode() then
		if CreateBackpackFrame:IsShown() then
			CreateBackpackFrame:Hide();
		else
			CreateBackpackFrame:Show();
			ClientCurGame:setOperateUI(true);
		end
	else
		if BackpackFrame:IsShown() then
			BackpackFrame:Hide();
		else
			BackpackFrame:Show();
			ClientCurGame:setOperateUI(true);
		end	
	end
end

function PlayMainFrameVipBtn_OnClick()
--	EnchantFrame:Show();	
end

function PlayMainFrame_OnLoad()
	this:RegisterEvent("GIE_FLYMODE_CHANGE");
	this:RegisterEvent("GIE_INFO_TIPS");
	this:RegisterEvent("GIE_ENTER_WORLD");
	this:RegisterEvent("GIE_UPDATE_BOSS_STATE");
	this:RegisterEvent("GIE_LEAVE_WORLD");
end

CUR_WORLD_MAPID = 0;		-- 0主世界 大于0为副本
function PlayMainFrame_OnEvent()
	if arg1 == "GIE_FLYMODE_CHANGE" then
		if CurWorld:isCreativeMode() then
			if not CurMainPlayer:getFlyMode() then
				CurMainPlayer:setMoveUp(0);
				if PlayMainFrameFlyDown:IsShown() then
					PlayMainFrameFlyDown:ClearPushState();
					UIFrameMgr:frameHide(PlayMainFrameFlyDown);
				end
				if PlayMainFrameFlyUp:IsShown() then
					PlayMainFrameFlyDown:ClearPushState();
					UIFrameMgr:frameHide(PlayMainFrameFlyUp);	
				end
				if PlayMainFrameFly:IsChecked() then
					PlayMainFrameFly:SetChecked(false);
				end
			end
		end
	elseif arg1 == "GIE_INFO_TIPS" then
		local ge 	= GameEventQue:getCurEvent();
		local text 	= ge.body.infotips.info;
		ShowGameTips(text, 3);
	elseif arg1 == "GIE_ENTER_WORLD" then
		local ge = GameEventQue:getCurEvent();
		local mapid = ge.body.enterworld.mapid;
		CUR_WORLD_MAPID = mapid;
		EnterWorld(mapid);
	elseif arg1 == "GIE_UPDATE_BOSS_STATE" then
		local ge = GameEventQue:getCurEvent();
		local hp = ge.body.bossstate.hp;
		local monsterId = ge.body.bossstate.id;
		UpdateBossHpFrame(hp, monsterId);
	elseif arg1 == "GIE_LEAVE_WORLD" then
		local ge = GameEventQue:getCurEvent();
		local mapid = ge.body.enterworld.mapid;
		if mapid > 0 then
			if InstanceTaskFrame:IsShown() then
				InstanceTaskFrame:Hide();
			end
			if BossHpFrame:IsShown() then
				BossHpFrame:Hide();
			end
			if IntroduceFrame:IsShown() then
				IntroduceFrame:Hide();
			end
		end
	end
end

function EnterWorld(mapid)
	if mapid == 0 then	--进入了主世界
		UpdateTaskTrackFrame();			--刷新成就追踪面板
		if InstanceTaskFrame:IsShown() then
			InstanceTaskFrame:Hide();
		end
		if BossHpFrame:IsShown() then
			BossHpFrame:Hide();
		end
		if IntroduceFrame:IsShown() then
			IntroduceFrame:Hide();
		end
	else			--进入了副本					
		TaskTrackFrame:Hide();			--隐藏成就追踪面板
		SetCurIntanceGoal(mapid);
		InstanceTaskFrame:Show();
	end
end

function PlayMainFrame_OnShow()
	PlayerHPBar:SetCurValue(MainPlayerAttrib:getHP()/MainPlayerAttrib:getMaxHP(), true)
	--判断是否有追踪任务，显示追踪任务面板
	if AchievementMgr:getCurTrackID() > 0 then -- and not 他人地图存档
		TaskTrackFrame:Show();
		UpdateTaskTrackFrame();
	end
	--判断是生存模式还是创造模式
	if CurWorld:isCreativeMode() then
	--	PlayMainFrameSneak:Hide();
		PlayMainFrameFly:Show();
		PlayerHPBar:Hide();
		PlayerExpBar:Hide();	
	else
		PlayMainFrameFly:Hide();
	--	PlayMainFrameSneak:Show();
		PlayerHPBar:Show();
		PlayerExpBar:Show();
	end

	GongNengFrame:Show();
	CurPlayerExpVal = MainPlayerAttrib:getExp();
	local starNum = math.floor(CurPlayerExpVal/100);
	PlayerExpBarText:SetText(starNum);
	
	local expBarVal = (CurPlayerExpVal - starNum * 100) / 100 ;
	PlayerExpBarExp:SetWidth(578*expBarVal);
	

--	PlayMainFrameBackpackUVAnimationTex:SetUVAnimation(80, true);
--	PlayMainFrameBackpackUVAnimationTex:Show();

--	PlayMainFrameJumpUVAnimationTex:SetUVAnimation(80, true);
--	PlayMainFrameJumpUVAnimationTex:Show();

--	PlayerExpBarUVAnimationTex:SetUVAnimation(80, true);
--	PlayerExpBarUVAnimationTex:Show();
end

-----------------------------------------------------TaskTrackFrame---------------------------------------------
function TaskTrackFrame_OnShow()
end

function UpdateTaskTrackFrame()
	if CUR_WORLD_MAPID > 0 then return end

	local achievementId = AchievementMgr:getCurTrackID();
	local achievementDef = DefMgr:getAchievementDef(achievementId);

	if achievementId > 0 and achievementDef ~= nil then
		TaskTrackFrame:Show();	
		local num = achievementDef.GoalNum;
		local arryNum = AchievementMgr:getAchievementArryNum(achievementDef.ID);
		local szText = achievementDef.TrackDesc.."#n("..arryNum.."/"..num..")";
		if arryNum >= num then	
			szText = achievementDef.TrackDesc.."#n(已完成)";
			AchievementFinishTipsFrame:Show();
		end
		TaskTrackFrameDesc:SetText(szText, 255, 255, 255);
	else
		TaskTrackFrame:Hide();
	end
end