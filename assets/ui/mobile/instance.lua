--------------------------------------------------------BossHpFrame------------------------------------------------------------------
function UpdateBossHpFrame(hp, monsterId)
	if hp < 0 then
		BossHpFrame:Hide();
	else
		BossHpFrame:Show();
		local monsterDef = DefMgr:getMonsterDef(monsterId);
		if monsterDef ~= nil then
			BossHpFrameName:SetText(monsterDef.Name);
			local totalHp = monsterDef.Life;
			width = 552 * (hp/totalHp);
	
			BossHpFrameHp:SetWidth(width);
		end
	end
end

local DialogueShowTime = 1;
function BossHpFrame_OnLoad()
	this:setUpdateTime(0.05);

	this:RegisterEvent("GIE_GAME_DIALOGUE");
end

function BossHpFrame_OnEvent()
	if arg1 == "GIE_GAME_DIALOGUE" then
		local ge = GameEventQue:getCurEvent();
		local text = ge.body.dialogue.info;
		if BossHpFrame:IsShown() then
			DialogueShowTime = 1;
			BossHpFrameDialogueBkg:Show();
			BossHpFrameDialogue:SetText(text);
		end
	end
end

function BossHpFrame_OnShow()
end

function BossHpFrame_OnUpdate()
	if BossHpFrameDialogueBkg:IsShown() then
		DialogueShowTime = DialogueShowTime - arg1;
		if DialogueShowTime < 0 then
			BossHpFrameDialogueBkg:Hide();
			BossHpFrameDialogue:SetText("");
			BossHpFrameDialogueBkg:SetBlendAlpha(1.0);
			BossHpFrameDialogue:SetBlendAlpha(1.0);
		else
			local alpha = DialogueShowTime;
			if alpha < 0 then
				alpha = 0;
			end
			BossHpFrameDialogueBkg:SetBlendAlpha(alpha);
			BossHpFrameDialogue:SetBlendAlpha(alpha);
		end
	end
end

--------------------------------------------------------InstanceTaskFrame----------------------------------------------------------
t_InstanceGoal = {
			{id=1, mapid=1, stringId=2000, neednum=1, arrynum=0},
			{id=2, mapid=1, stringId=2001, neednum=1, arrynum=0},			
		}

t_CurIntanceGoal = {};

local DelayTime = 2;
local IsComplete = false;	--是否完成了目标

local IsNeedInit = true;	
local IsPopup = true;
local PopupDistance = 0;

function GetRemainGoalNum()
	local num = 0;
	for i=1, #(t_CurIntanceGoal) do
		if t_CurIntanceGoal[i].neednum > t_CurIntanceGoal[i].arrynum then 
			num = num + 1;
		end
	end
	return num;
end

function SetCurIntanceGoal(mapid)
	t_CurIntanceGoal = {};
	for i=1, #(t_InstanceGoal) do
		if t_InstanceGoal[i].mapid == mapid then
			table.insert(t_CurIntanceGoal, t_InstanceGoal[i]);
		end
	end
end

function SetNextIntanceGoal()
	ClientMgr:clientLog("keeee#(t_CurIntanceGoal): "..#(t_CurIntanceGoal));
	for i=1, #(t_CurIntanceGoal) do
		ClientMgr:clientLog("keeeeSetNextIntanceGoalNeedNum: "..t_CurIntanceGoal[i].neednum);
		ClientMgr:clientLog("keeeeSetNextIntanceGoalarrynum: "..t_CurIntanceGoal[i].arrynum);
		if t_CurIntanceGoal[i].neednum > t_CurIntanceGoal[i].arrynum then
			ClientMgr:clientLog("keeeeSetNextIntanceGoal");
			local text = DefMgr:getStringDef(t_CurIntanceGoal[i].stringId);
			local desc = text..t_CurIntanceGoal[i].arrynum.."/"..t_CurIntanceGoal[i].neednum;
			InstanceTaskFrameGoalDescFont:SetText(desc);

			IsPopup = true;
			DelayTime = 2;
			PopupDistance = InstanceTaskFrameGoalDescFont:GetTextExtentWidth(desc);
			InstanceTaskFrameGoalDescFont:SetPoint("topleft", "InstanceTaskFrameGoalDesc", "topleft", -PopupDistance, 0);
			InstanceTaskFrameGoalDescTick:Hide();
			InstanceTaskFrameGoalDescTick:SetPoint("left", "InstanceTaskFrameGoalDescFont", "left", PopupDistance+3, -5);
			return;
		end
	end

	InstanceTaskFrameGoalDescFont:Hide();
	InstanceTaskFrameGoalDescTick:Hide();
end

function InstanceTaskFrame_OnLoad()
	this:setUpdateTime(0.05);
	this:RegisterEvent("GIE_MISSION_COMPLETE");
end

function InstanceTaskFrame_OnEvent()
	if arg1 == "GIE_MISSION_COMPLETE" then
		IsNeedInit = false
		local ge = GameEventQue:getCurEvent();
		local id = ge.body.mission.id;
		UpdateInstanceTask(id);
	end
end

function UpdateInstanceTask(id)
	for i=1, #(t_CurIntanceGoal) do
		if t_CurIntanceGoal[i].id == id then
			t_CurIntanceGoal[i].arrynum = t_CurIntanceGoal[i].arrynum + 1;
			local text = DefMgr:getStringDef(t_CurIntanceGoal[i].stringId);
			local desc = text..t_CurIntanceGoal[i].arrynum.."/"..t_CurIntanceGoal[i].neednum;
			InstanceTaskFrameGoalDescFont:SetText(desc);

			if t_CurIntanceGoal[i].arrynum == t_CurIntanceGoal[i].neednum then	--完成了目标
				IsComplete = true;				
				DelayTime = 2;
				
				PopupDistance = InstanceTaskFrameGoalDescFont:GetTextExtentWidth(desc);
				InstanceTaskFrameGoalDescFont:SetPoint("topleft", "InstanceTaskFrameGoalDesc", "topleft", -PopupDistance, 0);
				InstanceTaskFrameGoalDescTick:Show();
				InstanceTaskFrameGoalDescTick:SetPoint("left", "InstanceTaskFrameGoalDescFont", "left", PopupDistance+3, -5);
				IsPopup = true;
			else
			
			end
		end
	end
end

function InstanceTaskFrame_OnShow()
	if IsNeedInit then	
		local goalNum = #(t_CurIntanceGoal);
		InstanceTaskFrameGoalBtnNum:SetText(goalNum);

		local text = DefMgr:getStringDef(t_CurIntanceGoal[1].stringId);
		local desc = text..t_CurIntanceGoal[1].arrynum.."/"..t_CurIntanceGoal[1].neednum;
		InstanceTaskFrameGoalDescFont:SetText(desc);
		PopupDistance = InstanceTaskFrameGoalDescFont:GetTextExtentWidth(desc);
				
		InstanceTaskFrameGoalDescFont:SetPoint("topleft", "InstanceTaskFrameGoalDesc", "topleft", -PopupDistance, 0);
		InstanceTaskFrameGoalDescTick:Hide();
		InstanceTaskFrameGoalDescTick:SetPoint("left", "InstanceTaskFrameGoalDescFont", "left", PopupDistance+3, -5);
		DelayTime = 2;
		IsPopup = true;
	end
end

function InstanceTaskFrame_OnClick()
	if GetRemainGoalNum() > 0 then 
		if IntroduceFrame:IsShown() then
			IntroduceFrame:Hide();	
		else
			IntroduceFrame:Show();	
		end
	end
end

function InstanceTaskFrameGoalBtn_OnClick()
	if IntroduceFrame:IsShown() then
		IntroduceFrame:Hide();
	else
		IntroduceFrame:Show();
	end
end

local PopupSpeed = 4;
function InstanceTaskFrame_OnUpdate()
	if IsPopup then
		DelayTime = DelayTime - arg1;
		if DelayTime > 0 then
			PopupDistance = PopupDistance - PopupSpeed;
			if PopupDistance >= -3 then
				InstanceTaskFrameGoalDescFont:SetPoint("topleft", "InstanceTaskFrameGoalDesc", "topleft", -PopupDistance, 0);
			end
		else
			IsPopup = false;
			PopupDistance = 0;
			if IsComplete then
				IsComplete = false;
				local goalNum = GetRemainGoalNum();
				InstanceTaskFrameGoalBtnNum:SetText(goalNum);
				SetNextIntanceGoal();
			end
		end
	end
end
-----------------------------------------------------IntroduceFrame----------------------------------------------------------------
t_InstanceIntroduce = {
		{stringId1=3000, stringId2=2000, stringId3=2001, stringId4=0,},
	}
function IntroduceFrame_OnShow()
	HideAllFrame("IntroduceFrame");
	local text = DefMgr:getStringDef(t_InstanceIntroduce[CUR_WORLD_MAPID].stringId1);
	IntroduceFrameDesc:SetText(text);

	text = DefMgr:getStringDef(t_InstanceIntroduce[CUR_WORLD_MAPID].stringId2);
	if text ~= "" then
		IntroduceFrameGoal1Desc:SetText("1."..text);	
		if t_CurIntanceGoal[1].neednum <= t_CurIntanceGoal[1].arrynum then
			local width = IntroduceFrameGoal1Desc:GetTextExtentWidth("1."..text);
			IntroduceFrameTick1:SetPoint("left", "IntroduceFrameGoal1Desc", "left", width+5, 0);
			IntroduceFrameTick1:Show();	
		else
			IntroduceFrameTick1:Hide();
		end
	else
		IntroduceFrameGoal1Desc:SetText("");
		IntroduceFrameTick1:Hide();
	end

	text = DefMgr:getStringDef(t_InstanceIntroduce[CUR_WORLD_MAPID].stringId3);
	if text ~= "" then
		IntroduceFrameGoal2Desc:SetText("2."..text);
		if t_CurIntanceGoal[2].neednum <= t_CurIntanceGoal[2].arrynum then
			local width = IntroduceFrameGoal1Desc:GetTextExtentWidth("2."..text);
			IntroduceFrameTick2:SetPoint("left", "IntroduceFrameGoal2Desc", "left", width+5, 0);
			IntroduceFrameTick2:Show();	
		else
			IntroduceFrameTick2:Hide();
		end		
	else
		IntroduceFrameGoal2Desc:SetText("");
		IntroduceFrameTick2:Hide();
	end

	text = DefMgr:getStringDef(t_InstanceIntroduce[CUR_WORLD_MAPID].stringId4);
	if text ~= "" then
		IntroduceFrameGoal3Desc:SetText("3."..text);
		if t_CurIntanceGoal[1].neednum <= t_CurIntanceGoal[1].arrynum then
			local width = IntroduceFrameGoal1Desc:GetTextExtentWidth("3."..text);
			IntroduceFrameTick3:SetPoint("left", "IntroduceFrameGoal3Desc", "left", width+5, 0);
			IntroduceFrameTick3:Show();	
		else
			IntroduceFrameTick3:Hide();
		end		
	else
		IntroduceFrameGoal3Desc:SetText("");
		IntroduceFrameTick3:Hide();
	end
end

function IntroduceFrame_OnClick()
	IntroduceFrame:Hide();
end

----------------------------------------------------MonumentFrame------------------------------------------------------------------
function MonumentFrame_OnShow()
	HideAllFrame("MonumentFrame");	
	MonumentFrameDesc:SetText("于2015年8月8日战胜了一代黑龙!挑战时间5分钟", 255, 255, 255);
end

function MonumentFrame_OnClick()
	MonumentFrame:Hide();
end