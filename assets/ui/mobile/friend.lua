local FRIEND_NUM_MAX		= 30; 	--最大好友数；
local UpdateFriendInfoTime	= 20; 	--每20秒刷新一下好友信息
ForFrameName 			= nil;	--标记从哪个面板转到查看好友面板的
--local BUDDY_MAX_NUM       	= 256;

function FriendDelete_OnClick()
	MessageBox(1,DefMgr:getStringDef(36));
	MessageBoxFrame:SetClientUserData(0, this:GetClientUserData(0));
	MessageBoxFrame:SetClientString( "删除好友" );	
end

function FriendContentFlower_OnClick()
end

function FriendContentMessageBtn_OnClick()
--[[
	FriendFrame:Hide();
	GongNengFrame:Hide();
	local uin = this:GetClientUserData(0);
	FriendChatFrame:SetClientUserData(0, uin);
	BuddyManager:clearNoReadMsgForUin(uin);
	FriendChatFrame:Show();
]]
end

--查看好友
function FriendContentToSeeFriendBtn_OnClick()
	if not CanUseNet() then
		return;
	end

	local uin = this:GetClientUserData(0);
	if not AccountManager:requestBuddyWatch(uin) then
		--观察失败		
	else
		ForFrameName = "FriendFrame";
		LoadLoopFrame:Show();
	end
end

function FriendFrame_OnLoad()
	this:RegisterEvent("GE_WATCHBUDDY_SUCCESS");
	this:RegisterEvent("GE_UPDATE_BUDDY_MSG");
	for i=1, FRIEND_NUM_MAX do
		local friend = getglobal("Friend"..i);
		friend:SetPoint("topleft", "FriendBoxPlane", "topleft", 0, 114*(i-1));
	end
end

function FriendFrame_OnEvent()
	if arg1 == "GE_WATCHBUDDY_SUCCESS" then
		if FriendFrame:IsShown() and ForFrameName == "FriendFrame" then
			FriendFrame:Hide();
			GongNengFrame:Hide();
			LoadLoopFrame:Hide();
			ToSeeFriendFrame:Show();
		end
	end

	if arg1 == "GE_UPDATE_BUDDY_MSG" then
		if FriendFrame:IsShown() then
			UpdateFriendInfo();
		end
	end
end

function FriendFrame_OnShow()
	if ClientCurGame:getName() == "SurviveGame" then
		HideAllFrame("FriendFrame");
	end

	GongNengFrame:Show();
	CurShowFrameName = "FriendFrame";
		
	AccountManager:getBuddyOffLineChat();
	ResetSlidingFrame()
	UpdateFriendInfo();
	UpdateFriendInfoTime = 20;
end

function FriendFrame_OnHide()
	if ClientCurGame:getName() == "MainMenuStage" then
		GongNengFrame:Hide();
	end

	if LoadLoopFrame:IsShown() then
		LoadLoopFrame:Hide();
	end
end

function FriendFrame_OnUpdate()
	UpdateFriendInfoTime = UpdateFriendInfoTime - arg1;
	if UpdateFriendInfoTime < 0 then
		AccountManager:getBuddyOffLineChat();
		UpdateFriendInfoTime = 20;
	end
end

function FriendFrameBackBtn_OnClick()
	FriendFrame:Hide();
	if ClientCurGame:getName() == "MainMenuStage" then
		LobbyFrame:Show();
	end		
end

--添加好友
function FriendFrameAddFriendBtn_OnClick()
	FriendFrame:Hide();
	AddFriendFrame:Show();	
end

function ResetSlidingFrame()
	for i=1, FRIEND_NUM_MAX do
		local sliding = getglobal("Friend"..i.."SlidingFrame");
		sliding:resetOffsetPos();
	end
end

function UpdateFriendInfo()
	local num = AccountManager:getBuddyNum();
	if num-4 > 0 then
		FriendBoxPlane:SetSize(886, 453+114*(num-4));
	else
		FriendBoxPlane:SetSize(886, 453);
	end

	if num <= 0 then
		FriendFrameTipsDesc:Show();
	else
		FriendFrameTipsDesc:Hide();
	end

	for i=1, FRIEND_NUM_MAX do
		local friend 	= getglobal("Friend"..i);
		local delete	= getglobal("Friend"..i.."Delete");
		local message 	= getglobal("Friend"..i.."SlidingFrameContentMessageBtn");
		local msgNum 	= getglobal("Friend"..i.."SlidingFrameContentMessageBtnNum");
		local msgNormal = getglobal("Friend"..i.."SlidingFrameContentMessageBtnNormal");
		local toSee	= getglobal("Friend"..i.."SlidingFrameContentToSeeBtn");	
		local name	= getglobal("Friend"..i.."SlidingFrameContentName");
		local headIcon	= getglobal("Friend"..i.."SlidingFrameContentHeadIcon");
		local praiseNum	= getglobal("Friend"..i.."SlidingFrameContentPraiseNum");
		if i <= num then
			local uin = AccountManager:getBuddyUin(i-1);
			friend:Show();
			friend:SetClientUserData(0, uin);
			delete:SetClientUserData(0, uin);
			message:SetClientUserData(0, uin);
			toSee:SetClientUserData(0, uin);

			name:SetText(AccountManager:getBuddyName(uin));

			local model = AccountManager:getBuddyModel(uin);
			headIcon:SetTexture("ui/roleicons/"..model..".png");
			praiseNum:SetText(AccountManager:getBuddyCredit(uin));

			msgNormal:SetGray(true);
			msgNum:SetText("");
			--[[
			local chatMsgNum = BuddyManager:getChatNoReadMsgNumForUin(uin);
			if chatMsgNum > 0 then
				msgNormal:SetGray(false);
				msgNum:SetText(chatMsgNum);
			else
				msgNormal:SetGray(true);
				msgNum:SetText("");
			end
			]]
		else
			friend:Hide();
		end
	end
end

--------------------------------------------------ToSeeFriendFrame-------------------------------------------
local CurShowShareMapIndex = -1;
local t_shareMapInfo = {};

function ToSeeFriendFrame_OnLoad()
	this:setUpdateTime(0.05);
	this:RegisterEvent("GIE_NET_ANOMALY");
	this:RegisterEvent("GE_ADDBUDDY_SUCCESS");
end

function ToSeeFriendFrame_OnEvent()
	if arg1 == "GIE_NET_ANOMALY" then
		if ToSeeFriendFrame:IsShown() then
			ShowGameTips(DefMgr:getStringDef(37), 3);
		end
	elseif arg1 == "GE_ADDBUDDY_SUCCESS" then
		if ToSeeFriendFrame:IsShown() then
			local ge = GameEventQue:getCurEvent();
			ShowGameTips(ge.body.addBuddy.nickName.."成为你的好友", 3);
			ToSeeFriendFrameInfoAddOrDelFriendName:SetText(DefMgr:getStringDef(63));
		end
	end
end

function ToSeeFriendFrame_OnShow()
	GongNengFrame:Show();
	CurShowFrameName = "ToSeeFriendFrame";
		
	UpdateFriendShareMapInfoTable();
	if #(t_shareMapInfo) > 0 then
		SetFriendShareMapShowState(true);
		CurShowShareMapIndex = 1;
		UpdateFriendShareMap(CurShowShareMapIndex);
	else
		SetFriendShareMapShowState(false);		
	end

	UpdateToSeeFriendInfo();
end

local t_shareMapUIName = {"ToSeeFriendFrameInfoMapBkg", "ToSeeFriendFrameInfoGameModel", "ToSeeFriendFrameInfoMapName", "ToSeeFriendFrameInfoDownMapBtn",
			 "ToSeeFriendFrameInfoPraiseFont", "ToSeeFriendFrameInfoPraiseBtn", "ToSeeFriendFrameInfoRemark", "ToSeeFriendFrameInfoRemarkBkg",}
function SetFriendShareMapShowState(state)
	if state then
		for i=1, #(t_shareMapUIName) do
			local ui = getglobal(t_shareMapUIName[i]);
			if not ui:IsShown() then
				ui:Show();
			end
		end
	else
		for i=1, #(t_shareMapUIName) do
			local ui = getglobal(t_shareMapUIName[i]);
			if ui:IsShown() then
				ui:Hide();
			end
		end
		ToSeeFriendFrameInfoLeftArrowBtn:Hide();
		ToSeeFriendFrameInfoRightArrowBtn:Hide();
	end
end

function UpdateFriendShareMapInfoTable()
	local buddyInfo = BuddyManager:getWatchBuddyInfo();
	if buddyInfo == nil then return; end;

	t_shareMapInfo = {};
	for i=1, buddyInfo:getWorldNum() do
		local worldDesc = buddyInfo:getWorldDesc(i-1);
		if worldDesc ~= nil and worldDesc.open == 1 then
			table.insert(t_shareMapInfo, worldDesc);
		end
	end
end

function UpdateToSeeFriendInfo()
	local  buddyInfo =  BuddyManager:getWatchBuddyInfo();
	if buddyInfo == nil then return; end;

	local rolemodel = buddyInfo:getModel();
	local player = BuddyManager:getSelectRole(rolemodel-1);
	player:attachUIModelView(ToSeeFriendFrameRoleView);
	ToSeeFriendFrameRoleView:playActorAnim(100100,0);
	ToSeeFriendFrameRoleHeadIcon:SetTexture("ui/roleicons/"..rolemodel..".png");

	ToSeeFriendFrameRoleName:SetText(buddyInfo:getNickName());
	ToSeeFriendFrameRoleUin:SetText(buddyInfo:getUin());
	ToSeeFriendFrameJewelFont:SetText(buddyInfo:getDiamond());
	
	if IsFriend(buddyInfo:getUin()) then
		ToSeeFriendFrameInfoAddOrDelFriendName:SetText(DefMgr:getStringDef(63));
	else
		ToSeeFriendFrameInfoAddOrDelFriendName:SetText("添加好友");
	end

	ToSeeFriendFrameInfoAchiPoint:SetText(buddyInfo:getAchievementScore());
	local finishNum = buddyInfo:getAchievementInfo().finishnum;
	local Num	= buddyInfo:getAchievementInfo().num;
	local ratio 	= finishNum/Num;
	if finishNum == 0 then
		ratio = 0
	end
	local text =  string.format("%2.2f", ratio*100) .."%";
	ToSeeFriendFrameInfoAchiPercent:SetText(text);
	ToSeeFriendFrameInfoAchiProgressBar:SetValue(ratio);

	ToSeeFriendFrameInfoFlowerFont:SetText(buddyInfo:getFlower());
	ToSeeFriendFrameInfoPraiseNum:SetText(buddyInfo:getCredit());
end

function ToSeeFriendFrame_OnHide()
	local  buddyInfo =  BuddyManager:getWatchBuddyInfo();
	if buddyInfo == nil then return; end;

	local rolemodel = buddyInfo:getModel();
	local player = BuddyManager:getSelectRole(rolemodel-1);
	player:detachUIModelView(ToSeeFriendFrameRoleView);
	GongNengFrame:Hide();
end

function ToSeeFriendFrameInfoLeftArrowBtn_OnClick()
	CurShowShareMapIndex = CurShowShareMapIndex - 1
	UpdateFriendShareMap(CurShowShareMapIndex);
	if CurShowShareMapIndex == 1 then
		ToSeeFriendFrameInfoLeftArrowBtn:Hide();
	end
end

function ToSeeFriendFrameInfoRightArrowBtn_OnClick()
	CurShowShareMapIndex = CurShowShareMapIndex + 1;
	UpdateFriendShareMap(CurShowShareMapIndex);
	if CurShowShareMapIndex == #(t_shareMapInfo) then
		ToSeeFriendFrameInfoRightArrowBtn:Hide();
	end
end

function HideFriendShareMap()
	ToSeeFriendFrameInfoGameModel:Hide();
	ToSeeFriendFrameInfoMapName:Hide();
	ToSeeFriendFrameInfoDownMapBtn:Hide();
end

function UpdateFriendShareMap(index)
	if index > 1 then
		ToSeeFriendFrameInfoLeftArrowBtn:Show();
	else
		ToSeeFriendFrameInfoLeftArrowBtn:Hide();
	end

	if index < #(t_shareMapInfo) then
		ToSeeFriendFrameInfoRightArrowBtn:Show();
	else
		ToSeeFriendFrameInfoRightArrowBtn:Hide();
	end

	local gameModel	= getglobal("ToSeeFriendFrameInfoGameModel");
	local mapName = getglobal("ToSeeFriendFrameInfoMapName");
	if index > #(t_shareMapInfo) then
		gameModel:Hide();
		mapName:SetText("");
		ToSeeFriendFrameInfoRemark:SetText("");
	else	  
		local worldInfo = t_shareMapInfo[index];
		gameModel:Show();

		if worldInfo.owtype == 0 then
			gameModel:SetTexUV(822, 84, 76, 76);
		elseif worldInfo.owtype == 1 then
			gameModel:SetTexUV(901, 84, 76, 76);
		end

		local name = worldInfo.owname;
		mapName:SetText(name, 255, 230, 67);
		if mapName:GetTextLines() >  1 then
			mapName:SetPoint("left", gameModel:GetName(), "right", 10, 10);
		else
			mapName:SetPoint("left", gameModel:GetName(), "right", 10, 27);
		end

		local text = worldInfo.memo;
		ToSeeFriendFrameInfoRemark:SetText(text, 255, 255, 255);
	end
end

--更新箭头
local changeSpeed = 2;
local changeOffset = changeSpeed
local curOffset = 0;
function ToSeeFriendFrame_OnUpdate()
	curOffset = curOffset + changeOffset;
	if curOffset > 15 then
		curOffset = 15;
		changeOffset = -changeSpeed*0.5;
	elseif curOffset <= 0 then
		curOffset = 0;
		changeOffset = changeSpeed;
	end

	if ToSeeFriendFrameInfoLeftArrowBtn:IsShown() then
		ToSeeFriendFrameInfoLeftArrowBtnNormal:SetPoint("right", "ToSeeFriendFrameInfoMapBkg", "left", -(10+curOffset), 0);
	end
	if ToSeeFriendFrameInfoRightArrowBtn:IsShown() then
		ToSeeFriendFrameInfoRightArrowBtnNormal:SetPoint("left", "ToSeeFriendFrameInfoMapBkg", "right", 10+curOffset, 0);
	end
end

function ToSeeFriendFrameCollectBtn_OnClick()
end

--添加、删除好友
function ToSeeFriendFrameInfoAddOrDelFriend_OnClick()
	local  buddyInfo =  BuddyManager:getWatchBuddyInfo();
	if buddyInfo == nil then return; end;

	local uin = buddyInfo:getUin();
	if IsFriend(uin) then
		if AccountManager:requestBuddyAttentionDel(uin) then
			ShowGameTips(DefMgr:getStringDef(42), 3);
			ToSeeFriendFrameInfoAddOrDelFriendName:SetText("添加好友");
		end
	else
		if AccountManager:getBuddyNum() >= FRIEND_NUM_MAX then
			ShowGameTips(DefMgr:getStringDef(39), 3);
			return;
		end
		if not CanUseNet() then
			return;
		end

		if not AccountManager:requestBuddyAttention(uin) then
			ShowGameTips(DefMgr:getStringDef(41), 3);
		end
	end
end

DownMapMaxNum = 20;
--下载小伙伴的地图
function ToSeeFriendFrameInfoDownMapBtn_OnClick()
	if ClientCurGame:getName() == "SurviveGame" then
		ShowGameTips(DefMgr:getStringDef(43), 3);
		return;
	end
	if AccountManager:getMyWorldList():getDownWorldNum() >= DownMapMaxNum then
		MessageBox(5, DefMgr:getStringDef(28));
		MessageBoxFrame:SetClientString( "下载存档满" );
		return;
	end

	local netState = ClientMgr:getNetworkState();
	if netState == 0 then
		ShowGameTips(DefMgr:getStringDef(19), 3);
	elseif netState == 2 then		
		MessageBox(2, DefMgr:getStringDef(21));
		MessageBoxFrame:SetClientString( "下载地图网络提示" );
	else
		DownLoadWorld(1);
	end
end

function DownLoadWorld(useNetType)
	if #(t_shareMapInfo) > 0 and CurShowShareMapIndex <= #(t_shareMapInfo) then
		local worldInfo = t_shareMapInfo[CurShowShareMapIndex];		
		if AccountManager:requestDownWorld(worldInfo.owid) then
			IsNeedReset = true;
			UseNetType = useNetType;
			IsDownWorld = true;
			
			--加入下载列表中
			local index = GetNewestIndex();
			if index ~= nil then
				local createWorldInfo = AccountManager:getMyWorldList():getWorldDesc(index-1);
				local loadState = GetNewLoadWorldListState();
				if loadState == 1 then
					if ClientMgr:isSharingOWorld() or IsLoadingWorldList() then
						loadState = 2;
					else				
						AccountManager:requestLoadWorld(createWorldInfo.worldid);
					end
				end

				local ArchiveBtnName = "ArchiveBtn"..index;				
				AccountManager:addLoadWorldData(createWorldInfo.worldid, worldInfo.owid, worldInfo.shareVersion);
				table.insert(t_LoadWorldList, {worldId=createWorldInfo.worldid, state= loadState, name=ArchiveBtnName});
			end

			ToSeeFriendFrame:Hide();
			LobbyFrame:Show();
			LobbyFrameRoleInfo:Hide();
			LobbyFrameMoreGame:Hide();
			LobbyFrameArchiveFrame:Show();
		else
			UseNetType = 0;
			ShowGameTips(DefMgr:getStringDef(29), 3);
		end
	end
end

function shareMapDownMapBtn_OnClick()
	
end

--点赞
function ToSeeFriendFrameInfoPraiseBtn_OnClick()
	local  buddyInfo =  BuddyManager:getWatchBuddyInfo();
	if buddyInfo == nil then return; end;

	if #(t_shareMapInfo) > 0 and CurShowShareMapIndex <= #(t_shareMapInfo) then
		local worldInfo = t_shareMapInfo[CurShowShareMapIndex];	
		local result = AccountManager:requestAddCreditWorld(buddyInfo:getUin(), worldInfo.owid);
		if 0 == result then
			local num = 3 - BuddyManager:getCreditNumToday();
			ShowGameTips("点赞成功，今天可用的点赞还有"..num.."个");
			ToSeeFriendFrameInfoPraiseNum:SetText(buddyInfo:getCredit());
		elseif 1 == result then
			ShowGameTips(DefMgr:getStringDef(30), 3);
		elseif 2 == result then
			ShowGameTips(DefMgr:getStringDef(31), 3);
		end
	end	
end

function ToSeeFriendFrameBackBtn_OnClick()
	ToSeeFriendFrame:Hide();
	
	local frame = getglobal(ForFrameName);
	if frame ~= nil then
		if string.find(ForFrameName, "LobbyFrame") then
			LobbyFrame:Show();
		end
		frame:Show();
		if string.find(ForFrameName, "LobbyFrameMoreGame") then
			local name = LobbyFrameMoreGameAttentionBtnName:GetText();				
			if string.find(name, "返回列表") then
				LobbyFrameMoreGameRankBtn:Hide();
				LobbyFrameMoreGameTypeBtn:Hide();
				UpdateMoreGameAttentionInfo();
			end
		end
	else
		FriendFrame:Show();
	end
end
------------------------------------------------FriendChatFrame--------------------------------------------
local ChatFriendUin 	= 0;
local UpdateTime   	= 20;			--20秒刷新一下聊天信息
local t_chatMsg		= {};			--聊天内容

function FriendChatFrame_OnLoad()
	this:RegisterEvent("GE_UPDATE_BUDDY_MSG");
end

function FriendChatFrame_OnEvent()
	if arg1 == "GE_UPDATE_BUDDY_MSG" then
		if FriendChatFrame:IsShown() then
			UpdateChatMsg();
			BuddyManager:clearCurChatBuddyNoReadNum(ChatFriendUin);
		end
	end
end

function FriendChatFrame_OnShow()
--[[
	FriendChatBoxContent:AddText("大王叫我来巡山：飞流直下三千尺", 9, 255, 0);
	FriendChatBoxContent:AddText("采蘑菇的小熊酱：疑是银河落九天", 255, 255, 255);
	FriendChatBoxContent:AddText("大王叫我来巡山：三千越甲可吞吴", 9, 255, 0);
	FriendChatBoxContent:AddText("采蘑菇的小熊酱：百二秦关终属楚", 255, 255, 255);	

	FriendChatBoxContent:AddText("大王叫我来巡山：身无彩凤双飞翼", 9, 255, 0);
	FriendChatBoxContent:AddText("采蘑菇的小熊酱：心有灵犀一点通", 255, 255, 255);
	FriendChatBoxContent:AddText("大王叫我来巡山：落红岂是无情物", 9, 255, 0);
	UpdateChatBoxContentPosition();

	FriendChatBoxContent:AddText("采蘑菇的小熊酱：化作春泥更护花", 255, 255, 255);
	FriendChatBoxContent:AddText("大王叫我来巡山：无边落木萧萧下", 9, 255, 0);
	FriendChatBoxContent:AddText("采蘑菇的小熊酱：不尽长江滚滚来", 255, 255, 255);
	FriendChatBoxContent:AddText("大王叫我来巡山：人生得意须尽欢", 9, 255, 0);
	FriendChatBoxContent:AddText("采蘑菇的小熊酱：莫使金樽空对月", 255, 255, 255);
]]
	ChatFriendUin =  this:GetClientUserData(0);
	UpdateTime = 20;
	AccountManager:getBuddyOffLineChat();
	UpdateChatMsg();
end

function UpdateChatMsg()
	t_chatMsg = {};
	local num = BuddyManager:getChatMsgNum();
	for i=1, num do
		local chatMsg = BuddyManager:getChatMsg(i-1);
		if chatMsg.uin == ChatFriendUin or chatMsg.uin == AccountManager:getUin() then
			table.insert(t_chatMsg, chatMsg);
			local msg = chatMsg.msg;
			if msg ~= "" then
			end
		end
	end

	FriendChatBoxContent:Clear();
	if #(t_chatMsg) > 1 then
		table.sort(t_chatMsg,
			 function(a,b)
			 	return a.time < b.time; 
			 end
			);
	end

	for i=1, #(t_chatMsg) do
		local msg = t_chatMsg[i].msg;
		if msg ~= "" then
		end
		local name = AccountManager:getNickName();
		if t_chatMsg[i].uin ~= AccountManager:getUin() then
			name = AccountManager:getBuddyName(t_chatMsg[i].uin);
			FriendChatBoxContent:AddText(name.."："..t_chatMsg[i].msg, 9, 255, 0);
		else
			FriendChatBoxContent:AddText(name.."："..t_chatMsg[i].msg, 255, 255, 255);
		end
		if i == #(t_chatMsg) then
			UpdateChatBoxContentPosition();	
		end
	end
end

function FriendChatFrameSendBtn_OnClick()
	if not CanUseNet() then
		return;
	end

	local text = FriendChatFrameChatEdit:GetText()
	if text ~= "" then
		AccountManager:sendBuddyOffLineChat(ChatFriendUin, text);
		AccountManager:addBuddyChatMsg(text);
		FriendChatFrameChatEdit:Clear();
	end
end

function UpdateChatBoxContentPosition()
	local lines = FriendChatBoxContent:GetTextLines() - 8;
	if lines > 0 then
		FriendChatBoxPlane:SetPoint("topleft", "FriendChatBox", "topleft", 0, -lines * 50);
		FriendChatBox:setCurOffsety(-lines * 50);
	else
		FriendChatBoxPlane:SetPoint("topleft", "FriendChatBox", "topleft", 0, 0);
		FriendChatBox:setCurOffsety(0);
	end
end

function FriendChatFrame_OnUpdate()
	local lines = FriendChatBoxContent:GetTextLines() - 8;
	if lines > 0 then
		FriendChatBoxPlane:SetSize(910, 395+lines*50);
	else
		FriendChatBoxPlane:SetSize(910, 395);
	end

	UpdateTime = UpdateTime - arg1
	if UpdateTime < 0 then
		AccountManager:getBuddyOffLineChat();
		UpdateTime = 20;
	end
end

function FriendChatFrameBackBtn_OnClick()
	FriendChatFrame:Hide();
	FriendFrame:Show();
end

--------------------------------------------------------------------AddFriendFrame---------------------------------------------------------
local SHOW_NEARBY_PLAYER_MAX	= 20;
local AddFriendTipsShowTime 	= 2;

function AddFriendFrame_OnLoad()
	this:RegisterEvent("GE_ADDBUDDY_SUCCESS");
	this:RegisterEvent("GIE_BUDDY_FIND");
	this:RegisterEvent("GE_WATCHBUDDY_SUCCESS");
	this:RegisterEvent("GIE_NET_ANOMALY");
end

function AddFriendFrame_OnEvent()
	if arg1 == "GE_ADDBUDDY_SUCCESS" then
		if AddFriendFrame:IsShown() then
			local ge = GameEventQue:getCurEvent();
			ShowGameTips(ge.body.addBuddy.nickName.."成为你的好友");
			UpdateNearbyPlayerInfo();
		end
	elseif arg1 == "GIE_BUDDY_FIND" then
		if AddFriendFrame:IsShown() then
			UpdateNearbyPlayerInfo();
		end
	elseif arg1 == "GE_WATCHBUDDY_SUCCESS" then
		if AddFriendFrame:IsShown() and ForFrameName == "AddFriendFrame" then
			AddFriendFrame:Hide();
			GongNengFrame:Hide();
			LoadLoopFrame:Hide();
			ToSeeFriendFrame:Show();
		end
	elseif arg1 == "GIE_NET_ANOMALY" then
		if AddFriendFrame:IsShown() then
			ShowGameTips(DefMgr:getStringDef(37), 3);
		end
	end
end

function AddFriendFrame_OnShow()
	GongNengFrame:Show()
	CurShowFrameName = "AddFriendFrame";

	AddFriendFrameContentMiniNum:SetText(AccountManager:getUin());
	UpdateNearbyPlayerInfo();
	AddFriendFrameContentTipsFont:SetText("");
	AddFriendFrameContentTips:Hide();
end

function AddFriendFrame_OnHide()
	GongNengFrame:Hide();
	if LoadLoopFrame:IsShown() then
		LoadLoopFrame:Hide();
	end
end

function AddFriendFrameBackBtn_OnClick()
	AddFriendFrame:Hide();
	FriendFrame:Show();
end

function AddFriendFrameInviteBtn_OnClick()
end

--添加好友
function AddFriendFrameAddFriendBtn_OnClick()
	local uin = tonumber(AddFriendFrameContentEdit:GetText());
	if AccountManager:isBuddy(uin) then
		ShowGameTips(DefMgr:getStringDef(38), 3);
		return;
	end
	if AccountManager:getBuddyNum() >= FRIEND_NUM_MAX then
		ShowGameTips(DefMgr:getStringDef(39), 3);
		return;
	end
	if AccountManager:getUin() == uin then
		ShowGameTips(DefMgr:getStringDef(40), 3);
		return;
	end
	if not CanUseNet() then
		return;
	end

	if not AccountManager:requestBuddyAttention(uin) then
		ShowGameTips(DefMgr:getStringDef(41), 3);
	end
end

function AddFriendFrameContentTips_OnUpdate()
	AddFriendTipsShowTime = AddFriendTipsShowTime - arg1;
	if AddFriendTipsShowTime < 0  then
		AddFriendFrameContentTips:Hide();	
	end
end

function AddFriendFrameSeekNearbyBtn_OnClick()
	if not CanUseNet() then
		return;
	end

	if AccountManager:requestBuddyFind() then
	else
		ShowGameTips(DefMgr:getStringDef(44), 3);
	end
end

function NearbyPlayerToSee_OnClick()
	if not CanUseNet() then
		return;
	end

	local uin = this:GetParentFrame():GetClientID();
	if uin > 0 then
		if not AccountManager:requestBuddyWatch(uin) then
			--观察失败		
		else
			ForFrameName = "AddFriendFrame";
			LoadLoopFrame:Show();
		end
	end
end

function NearbyPlayerAddFriend_OnClick()
	if not CanUseNet() then
		return;
	end
	if AccountManager:getBuddyNum() >= FRIEND_NUM_MAX then
		ShowGameTips(DefMgr:getStringDef(39), 3);
		return;
	end

	local uin = this:GetParentFrame():GetClientID();
	if uin > 0 then
		if not AccountManager:requestBuddyAttention(uin) then
			ShowGameTips(DefMgr:getStringDef(41), 3);
		end
	end
end

--是否为你的好友
function IsFriend(uin)
	local num = AccountManager:getBuddyNum();
	for i=1, num do
		local getBuddyUin = AccountManager:getBuddyUin(i-1);
		if uin == getBuddyUin then
			return true;
		end
	end

	return false;	
end

--非好友的附近玩家
function getNearbyBuddyInfo()
	t_table = {};
	local num = BuddyManager:getBuddyFindNum();
	for i=1, num do
		local buddyInfo = BuddyManager:getBuddyFindInfo(i-1);
		if buddyInfo ~= nil and not IsFriend(buddyInfo.uin) then
			table.insert(t_table, buddyInfo);
		end
	end
	return t_table;
end

function UpdateNearbyPlayerInfo()
	local t_NearbyBuddyInfo = getNearbyBuddyInfo();
	local num = #(t_NearbyBuddyInfo);
	if num > 4 then
		NearbyPlayerBoxPlane:SetSize((num-4)*195+809, 114);
	else
		NearbyPlayerBoxPlane:SetSize(809, 114);
	end
	
	for i=1, SHOW_NEARBY_PLAYER_MAX do	
		local buddyInfo = t_NearbyBuddyInfo[i];
		local frame = getglobal("NearbyPlayer"..i);
		if i <= num then
			local icon	= getglobal("NearbyPlayer"..i.."HeadIcon");				
			local rolemodel = buddyInfo.model;
			icon:SetTexture("ui/roleicons/"..rolemodel..".png");
			
			frame:SetClientID(buddyInfo.uin);
			frame:Show();
		else
			frame:SetClientID(0);
			frame:Hide();
		end
		frame:SetPoint("topleft", "NearbyPlayerBoxPlane", "topleft" , 195*(i-1)+55, 0);		
	end
end