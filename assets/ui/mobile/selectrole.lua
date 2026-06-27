
SelectRoleIndex = 0; 
RoleNickName = "";	
--------------------------------------------------------SelectRoleFrame--------------------------------------------
local t_RoleBindId = { 2, 4, 3, 5, 6 };
local t_PlayerIndices = { 1, 0, 7, 6, 5 };

function SelectRoleFrame_OnLoad()
end

function SelectRoleFrame_OnEvent()
end

function SelectRoleFrame_OnShow()
	if IsFirstLogin then
		InputRoleNameFrame:Show();		
	end
	SelectRoleView:addBackgroundEffect("particles/1100.ent", 0, 0, 0);

	SelectRoleIndex = 0;
	
	for i=1, 5 do
		local player = BuddyManager:getSelectRole(t_PlayerIndices[i]);
		player:attachUIModelView(SelectRoleView, i-1);
		SelectRoleView:bindActorToAnchor(t_RoleBindId[i], i-1);
		SelectRoleView:playActorAnim(100100,i-1);
	end

	SelectRoleView:bindActorToAnchor(1, SelectRoleIndex);
	SelectRoleView:playActorAnim(100108, SelectRoleIndex);
	SelectRoleView:setActorCollide(false, SelectRoleIndex);

	SelectRoleView:setCameraLookAt(0, 216, -1200, 0, 127, 0);
	SelectRoleView:setCameraFov(30);	
end

function SelectRoleFrame_OnClick()
	local index = SelectRoleView:getActorOnScreenPoint(GetCursorPosX(),GetCursorPosY());
	if index ~= -1 then
		SelectRoleView:bindActorToAnchor(t_RoleBindId[SelectRoleIndex+1], SelectRoleIndex);
		SelectRoleView:playActorAnim(100100, SelectRoleIndex);
		SelectRoleView:setActorCollide(true, SelectRoleIndex);
		SelectRoleIndex = index;
		SelectRoleView:bindActorToAnchor(1, SelectRoleIndex);
		SelectRoleView:playActorAnim(100108, SelectRoleIndex);
		SelectRoleView:setActorCollide(false, SelectRoleIndex);
	end
end

function SelectRoleFrameNextBtn_OnClick()
	if AccountManager:requestModifyRole(RoleNickName, t_PlayerIndices[SelectRoleIndex+1]+1) then
		SelectRoleFrame:Hide();
		BackgroundFrame:Show();
		LobbyFrame:Show();
	else
	end
end

function SelectRoleFrameSkipNextBtn_OnClick()
	if AccountManager:requestModifyRole(RoleNickName, t_PlayerIndices[SelectRoleIndex+1]+1) then
		SelectRoleFrame:Hide();
		LoadingFrame:Show();
		AccountManager:requestCreateWorld(0, RoleNickName..DefMgr:getStringDef(59), 1, "", AccountManager:getRoleModel());
	end
end

---------------------------------------------------InputRoleNameFrame-----------------------------------------------
function InputRoleNameFrame_OnShow()
	InputRoleNameFrameRandomBtn_OnClick();
end

function InputRoleNameFrameOkBtn_OnClick()
	if InputRoleNameFrameNameEdit:GetText() == "" then
		--提示角色名不能为空
		ShowGameTips(DefMgr:getStringDef(45), 3)
	--	GameTipsFrame:SetClientString("角色名不能为空");
	--	GameTipsFrame:Show();
		return;
	end
	if not AccountManager:requestCheckNickname(InputRoleNameFrameNameEdit:GetText()) then
		--提示角色名已存在
		ShowGameTips(DefMgr:getStringDef(46), 3)
	--	GameTipsFrame:SetClientString("角色名已存在");
	--	GameTipsFrame:Show();
		return;
	end
	RoleNickName = InputRoleNameFrameNameEdit:GetText();
	InputRoleNameFrame:Hide();
	SelectRoleFrameNextBtn:Show();
	SelectRoleFrameSkipNextBtn:Show();
end

function InputRoleNameFrameRandomBtn_OnClick()
	local nickname = DefMgr:getRandomName(0)
	if not ClientCurGame:requestCheckNickname(nickname) then
		nickname = nickname..(math.random(1,999))
	end
	InputRoleNameFrameNameEdit:SetText(nickname)
end