

function CreateRoleRandNameBtn_OnClick()
	local nickname = DefMgr:getRandomName(0)
	if not ClientCurGame:requestCheckNickname(nickname) then
		nickname = nickname..(math.random(1,999))
	end
	CreateRoleFrameNickEdit:SetText(nickname)
end

ROTATE_ACTOR_SPEED = 180.0
function CreateRoleRotateLeftBtn_OnMouseDown()
	SelectRoleView:setRotateSpeed(ROTATE_ACTOR_SPEED);
end

function CreateRoleRotateLeftBtn_OnMouseUp()
	SelectRoleView:setRotateSpeed(0);
end

function CreateRoleRotateRightBtn_OnMouseDown()
	SelectRoleView:setRotateSpeed(-ROTATE_ACTOR_SPEED);
end

function CreateRoleRotateRightBtn_OnMouseUp()
	SelectRoleView:setRotateSpeed(0);
end

function CreateRoleEnterBtn_OnClick()
	local nickname = CreateRoleFrameNickEdit:GetText()
	if AccountManager:requestModifyRole(nickname, 1) then
		if ClientCurGame:requestLoginOnline() then
		else
		end
	else
	end
end

function SelectRoleFrame_OnLoad()
	this:RegisterEvent("GE_LOGIN_ONLINE")

	SelectRoleView:setCameraWidthFov(54)
	SelectRoleView:setCameraLookAt(0, 220, -1200, 0, 128, 0)
	SelectRoleView:setActorPosition(0, 0, -300)
end

function SelectRoleFrame_OnEvent()
	if this:IsShown() then
		if arg1 == "GE_LOGIN_ONLINE" then
			SelectRoleFrame:Hide()
			LobbyFrame:Show()
		end
	end
end

function SelectRoleFrame_OnShow()
	local player = ClientCurGame:getSelectRole();
	player:attachUIModelView(SelectRoleView);
end

function SelectRoleFrame_OnHide()
	local player = ClientCurGame:getSelectRole();
	player:detachUIModelView();
end
