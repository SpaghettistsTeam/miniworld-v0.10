
t_DefaultSetData = {configure=2, view=1, peacemodel=0, volume=80, musicopen=1, soundopen=1, sensitivity=50,
			 reversalY=0, lefthanded=0, sight=0, autojump=1, brightness=50, view_distance=2,
			}
t_HighterSetData 	= {view_distance=3,};
t_MediumSetData 	= {view_distance=2,};
t_LowSetData 		= {view_distance=1,};

---------------------------------------SetMenuFrame---------------------------------------------------------
function SetMenuFrame_OnShow()
	if ClientCurGame:getName() == "SurviveGame" then
		SetMenuFrameChenDi:SetHeight(434);
		SetMenuFrameGameEndBtn:SetPoint("topleft", "SetMenuFrameChenDi", "topleft", 47, 311);
	else
		SetMenuFrameChenDi:SetHeight(338);
		SetMenuFrameGameEndBtn:SetPoint("topleft", "SetMenuFrameChenDi", "topleft", 47, 215);
	end	
	SetArchiveDealMsg(false);
end

function SetArchiveDealMsg(isDeal)
	ArchiveBox:setDealMsg(isDeal);
	for i=1, ARCHIVE_MAX do 
		local slidingFrame 	= getglobal("ArchiveBtn"..i.."SlidingFrame");
		slidingFrame:setDealMsg(isDeal);
	end
end

function SetMenuFrame_OnHide()
	SetArchiveDealMsg(true);
end

function SetContinueBtn_OnClick()
	SetMenuFrame:Hide();
end

function GameSet_OnClick()
	SetMenuFrame:Hide();
	GameSetFrame:Show();
end

function MainMenuBtn_OnClick()
	SetMenuFrame:Hide();
	HideAllFrame(nil);
	ClientMgr:gotoGame("MainMenuStage");
end

function GameEndBtn_OnClick()
	if ClientCurGame:getName() == "SurviveGame" then
		MainMenuBtn_OnClick();
	else
		SetMenuFrame:Hide();
	end
end

----------------------------------------------------GameSetFrame---------------------------------------------------
function SwitchBtn_OnMouseDown()
	local switchName 	= this:GetName();
	local state		= 0;
	local bkg 		= getglobal(this:GetName().."Bkg");
	local point 		= getglobal(switchName.."Point");
	if bkg:GetRealLeft() < point:GetRealLeft() then			--先前状态：开
		point:SetPoint("left", this:GetName(), "left", -5, 0);
		state = 0;
	else								--先前状态：关
		point:SetPoint("right", this:GetName(), "right", 5, 0);
		state = 1;
	end

	if string.find(switchName, "PeaceSwitch") then			--和平模式
		ClientMgr:setGameData("peacemodel", state);
	elseif string.find(switchName, "MusicSwitch") then		--音乐开关
		ClientMgr:setGameData("musicopen", state);
	elseif string.find(switchName, "SoundSwitch") then		--音效开关
		ClientMgr:setGameData("soundopen", state);
		
	elseif string.find(switchName, "ReversalYSwitch") then		--反转Y轴
		ClientMgr:setGameData("reversalY", state);
	elseif string.find(switchName, "LeftHandedSwitch") then		--左撇子模式
		ClientMgr:setGameData("lefthanded", state);
	elseif string.find(switchName, "QHeartSwitch") then		--准心模式
		ClientMgr:setGameData("sight", state);
	elseif string.find(switchName, "AutoJumpSwitch") then		--自动跳跃
		ClientMgr:setGameData("autojump", state);
	elseif string.find(switchName, "HideUISwitch") then		--隐藏界面
		GameSetFrame:Hide();
		HideAllUI();
	end

	if not string.find(switchName, "HideUISwitch") then
		ClientMgr:appalyGameSetData();
	end
end

function SetSwitchBtnState(switchName, state)
	local point = getglobal(switchName.."Point");
	if state == 1 then
		point:SetPoint("right", switchName, "right", 5, 0);		
	else
		point:SetPoint("left", switchName, "left", -5, 0);
	end
end

--声音
function VolumeBar_OnValueChanged()
	local value = GameSetFrameBaseVolumeBar:GetValue();
	local uvWidth = math.floor(189*value/100)
	local width   = math.floor(316*value/100)
	GameSetFrameBaseVolumeBkg1:SetTexUV(540, 839, uvWidth, 17);
	GameSetFrameBaseVolumeBkg1:SetWidth(width);

	ClientMgr:setGameData("volume", value);
	ClientMgr:appalyGameSetData();
end

--敏感度
function SensitivityBar_OnValueChanged()
	local value = GameSetFrameControlSensitivityBar:GetValue();
	local uvWidth = math.floor(189*value/100)
	local width   = math.floor(316*value/100);
	GameSetFrameControlSensitivityBkg1:SetTexUV(540, 839, uvWidth, 17);
	GameSetFrameControlSensitivityBkg1:SetWidth(width);

	ClientMgr:setGameData("sensitivity", value);
	ClientMgr:appalyGameSetData();
end

--亮度
function BrightnessBar_OnValueChanged()
	local value = GameSetFrameAdvancedBrightnessBar:GetValue();
	local uvWidth = math.floor(189*value/100)
	local width   = math.floor(316*value/100);
	GameSetFrameAdvancedBrightnessBkg1:SetTexUV(540, 839, uvWidth, 17);
	GameSetFrameAdvancedBrightnessBkg1:SetWidth(width);

	ClientMgr:setGameData("brightness", value);
	ClientMgr:appalyGameSetData();
end

--配置
function ConfigureBar_OnValueChanged()
	local value = GameSetFrameBaseConfigureBar:GetValue();
	local uvWidth = math.floor(195*value/100)
	local width   = math.floor(316*value/100);
	GameSetFrameBaseConfigureBkg1:SetTexUV(391, 892, uvWidth, 21);
	GameSetFrameBaseConfigureBkg1:SetWidth(width);

end

function ConfigureBar_OnMouseUp()
	local value = GameSetFrameBaseConfigureBar:GetValue();
	if value > 75 then
		GameSetFrameBaseConfigureBar:SetValue(100);
		ClientMgr:setGameData("configure", 3);
		ClientMgr:setGameData("view_distance", t_HighterSetData["view_distance"]);
		GameSetFrameBaseConfigureTitle:SetText(DefMgr:getStringDef(47));
		if GameSetFrameAdvanced:IsShown() then
			UpdateAdvancedSet();
		end
	elseif value > 25 then
		GameSetFrameBaseConfigureBar:SetValue(50);
		ClientMgr:setGameData("configure", 2);
		ClientMgr:setGameData("view_distance", t_MediumSetData["view_distance"]);
		GameSetFrameBaseConfigureTitle:SetText(DefMgr:getStringDef(48));
		if GameSetFrameAdvanced:IsShown() then
			UpdateAdvancedSet();
		end
	else
		GameSetFrameBaseConfigureBar:SetValue(0);
		ClientMgr:setGameData("configure", 1);
		ClientMgr:setGameData("view_distance", t_LowSetData["view_distance"]);
		GameSetFrameBaseConfigureTitle:SetText(DefMgr:getStringDef(49));
		if GameSetFrameAdvanced:IsShown() then
			UpdateAdvancedSet();
		end
	end
	ClientMgr:appalyGameSetData();
end

--视角
function ViewBar_OnValueChanged()
	local value = GameSetFrameBaseViewBar:GetValue();
	local uvWidth = math.floor(195*value/100)
	local width   = math.floor(316*value/100);
	GameSetFrameBaseViewBkg1:SetTexUV(391, 892, uvWidth, 21);
	GameSetFrameBaseViewBkg1:SetWidth(width);
end

function ViewBar_OnMouseUp()
	local value = GameSetFrameBaseViewBar:GetValue();
	if value > 75 then
		GameSetFrameBaseViewBar:SetValue(100);
		ClientMgr:setGameData("view", 2);
		GameSetFrameBaseViewTitle:SetText(DefMgr:getStringDef(50));
	elseif value > 25 then
		GameSetFrameBaseViewBar:SetValue(50);
		ClientMgr:setGameData("view", 3);
		GameSetFrameBaseViewTitle:SetText(DefMgr:getStringDef(51));
	else
		GameSetFrameBaseViewBar:SetValue(0);
		ClientMgr:setGameData("view", 1);
		GameSetFrameBaseViewTitle:SetText(DefMgr:getStringDef(52));
	end
	ClientMgr:appalyGameSetData();
end

--视野
function VDistanceBar_OnValueChanged()
	local value = GameSetFrameAdvancedVDistanceBar:GetValue();
	local uvWidth = math.floor(195*value/100)
	local width   = math.floor(316*value/100);
	GameSetFrameAdvancedVDistanceBkg1:SetTexUV(391, 892, uvWidth, 21);
	GameSetFrameAdvancedVDistanceBkg1:SetWidth(width);
end

function VDistanceBar_OnMouseUp()
	local value = GameSetFrameAdvancedVDistanceBar:GetValue();
	if value > 75 then
		GameSetFrameAdvancedVDistanceBar:SetValue(100);
		ClientMgr:setGameData("view_distance", 3);
		GameSetFrameAdvancedVDistanceTitle:SetText(DefMgr:getStringDef(53));
	elseif value > 25 then
		GameSetFrameAdvancedVDistanceBar:SetValue(50);
		ClientMgr:setGameData("view_distance", 2);
		GameSetFrameAdvancedVDistanceTitle:SetText(DefMgr:getStringDef(54));
	else
		GameSetFrameAdvancedVDistanceBar:SetValue(0);
		ClientMgr:setGameData("view_distance", 1);
		GameSetFrameAdvancedVDistanceTitle:SetText(DefMgr:getStringDef(55));
	end
	ClientMgr:appalyGameSetData();
end

--恢复默认
function GameSetFrameResetBtn_OnClick()
	ClientMgr:setGameData("configure", t_DefaultSetData["configure"]);
	ClientMgr:setGameData("view", t_DefaultSetData["view"]);
	ClientMgr:setGameData("peacemodel", t_DefaultSetData["peacemodel"]);
	ClientMgr:setGameData("volume", t_DefaultSetData["volume"]);
	ClientMgr:setGameData("musicopen", t_DefaultSetData["musicopen"]);
	ClientMgr:setGameData("soundopen", t_DefaultSetData["soundopen"]);	
	if GameSetFrameBase:IsShown() then
		UpdateBaseSet();
	end

	ClientMgr:setGameData("sensitivity", t_DefaultSetData["sensitivity"]);
	ClientMgr:setGameData("reversalY", t_DefaultSetData["reversalY"]);
	ClientMgr:setGameData("lefthanded", t_DefaultSetData["lefthanded"]);
	ClientMgr:setGameData("sight", t_DefaultSetData["sight"]);
	ClientMgr:setGameData("autojump", t_DefaultSetData["autojump"]);
	if GameSetFrameControl:IsShown() then
		UpdateControlSet();
	end

	ClientMgr:setGameData("brightness", t_DefaultSetData["brightness"]);
	ClientMgr:setGameData("view_distance", t_DefaultSetData["view_distance"]);
	if GameSetFrameAdvanced:IsShown() then
		UpdateAdvancedSet();
	end
	ClientMgr:appalyGameSetData();
end

function GameSetFrame_OnShow()
	GameSetFrameBaseBtn:Checked();
	UpdateGameSetFrameLable("GameSetFrameBaseBtn");
	GameSetFrameBase:Show();
	GameSetFrameControl:Hide();
	GameSetFrameAdvanced:Hide();
end

function GameSetFrameCloseBtn_OnMouseDown()
	local btnIcon = getglobal("GameSetFrameCloseBtnIcon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(51,51);
end

function GameSetFrameCloseBtn_OnMouseUp()
	local btnIcon = getglobal("GameSetFrameCloseBtnIcon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(66,67);
end

function GameSetFrameCloseBtn_OnClick()		
	GameSetFrame:Hide();
end

function GameSetFrameBaseBtn_OnClick()
	UpdateGameSetFrameLable("GameSetFrameBaseBtn");
	GameSetFrameControl:Hide();
	GameSetFrameAdvanced:Hide();
	GameSetFrameBase:Show();	
end

function GameSetFrameControlBtn_OnClick()
	UpdateGameSetFrameLable("GameSetFrameControlBtn");
	GameSetFrameBase:Hide();
	GameSetFrameAdvanced:Hide();
	GameSetFrameControl:Show();
end

function GameSetFrameAdvancedBtn_OnClick()
	UpdateGameSetFrameLable("GameSetFrameAdvancedBtn");
	GameSetFrameBase:Hide();
	GameSetFrameControl:Hide();
	GameSetFrameAdvanced:Show();
end

local t_GameSetLabel = {"GameSetFrameBaseBtn", "GameSetFrameControlBtn", "GameSetFrameAdvancedBtn",}

function UpdateGameSetFrameLable(btnName)
	for i=1,#(t_GameSetLabel) do
		local btn = getglobal(t_GameSetLabel[i]);
		local name = getglobal(t_GameSetLabel[i].."Name");		
		if t_GameSetLabel[i] == btnName then
			name:SetTextColor(96, 179, 0);
		else
			btn:SetChecked(false);
			name:SetTextColor(68, 65, 58);
		end
	end
end

--“基础”设置
function GameSetFrameBase_OnShow()
	UpdateBaseSet();
end

function UpdateBaseSet()
	local cfgVal = ClientMgr:getGameData("configure");						--配置
	if cfgVal == 1 then
		GameSetFrameBaseConfigureTitle:SetText(DefMgr:getStringDef(49));
		GameSetFrameBaseConfigureBar:SetValue(0);
	elseif cfgVal == 2 then
		GameSetFrameBaseConfigureTitle:SetText(DefMgr:getStringDef(48));
		GameSetFrameBaseConfigureBar:SetValue(50);
	else
		GameSetFrameBaseConfigureTitle:SetText(DefMgr:getStringDef(47));
		GameSetFrameBaseConfigureBar:SetValue(100);
	end

	local viewVal = ClientMgr:getGameData("view");							--视角
	if viewVal == 1 then
		GameSetFrameBaseViewTitle:SetText(DefMgr:getStringDef(52));
		GameSetFrameBaseViewBar:SetValue(0);
	elseif viewVal == 3 then
		GameSetFrameBaseViewTitle:SetText(DefMgr:getStringDef(51));
		GameSetFrameBaseViewBar:SetValue(50);
	else
		GameSetFrameBaseViewTitle:SetText(DefMgr:getStringDef(50));
		GameSetFrameBaseViewBar:SetValue(100);
	end
	
	SetSwitchBtnState("GameSetFrameBasePeaceSwitch", ClientMgr:getGameData("peacemodel"));		--和平模式
	GameSetFrameBaseVolumeBar:SetValue(ClientMgr:getGameData("volume"));				--音量
	SetSwitchBtnState("GameSetFrameBaseMusicSwitch", ClientMgr:getGameData("musicopen"));		--音乐开关
	SetSwitchBtnState("GameSetFrameBaseSoundSwitch", ClientMgr:getGameData("soundopen"));		--音效开关
end

--“控制”设置
function GameSetFrameControl_OnShow()
	UpdateControlSet();
end

function UpdateControlSet()
	GameSetFrameControlSensitivityBar:SetValue(ClientMgr:getGameData("sensitivity"));		--灵敏度
	SetSwitchBtnState("GameSetFrameControlReversalYSwitch", ClientMgr:getGameData("reversalY"));	--反转Y轴
	SetSwitchBtnState("GameSetFrameControlLeftHandedSwitch", ClientMgr:getGameData("lefthanded"));	--左撇子模式
	SetSwitchBtnState("GameSetFrameControlQHeartSwitch", ClientMgr:getGameData("sight"));		--准心模式
	SetSwitchBtnState("GameSetFrameControlAutoJumpSwitch", ClientMgr:getGameData("autojump"));	--自动跳跃
end

--“高级”设置
function GameSetFrameAdvanced_OnShow()
	UpdateAdvancedSet();
end

function UpdateAdvancedSet()
	GameSetFrameAdvancedBrightnessBar:SetValue(ClientMgr:getGameData("brightness"));		--画面亮度
	local viewDval = ClientMgr:getGameData("view_distance");					--视野距离
	if viewDval == 1 then
		GameSetFrameAdvancedVDistanceTitle:SetText(DefMgr:getStringDef(55));
		GameSetFrameAdvancedVDistanceBar:SetValue(0);
	elseif viewDval == 2 then
		GameSetFrameAdvancedVDistanceTitle:SetText(DefMgr:getStringDef(54));
		GameSetFrameAdvancedVDistanceBar:SetValue(50);
	else
		GameSetFrameAdvancedVDistanceTitle:SetText(DefMgr:getStringDef(53));
		GameSetFrameAdvancedVDistanceBar:SetValue(100);
	end

	if ClientCurGame:getName() == "SurviveGame" then
		GameSetFrameAdvancedHideUITitle:Show();
		GameSetFrameAdvancedHideUISwitch:Show();
		SetSwitchBtnState("GameSetFrameAdvancedHideUISwitch", 0);
	else
		GameSetFrameAdvancedHideUITitle:Hide();
		GameSetFrameAdvancedHideUISwitch:Hide();
	end
end