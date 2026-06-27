

function LoginBtn_OnClick()
	local name = LoginFrameUserNameEdit:GetText();

	if ( name == "" ) then
		--Login_MessageBoxOK( { ["text"] = "账号不能为空", ["opDesc"] = "" } );
	else
		ClientCurGame:requestLogin(name, LoginFramePasswordEdit:GetPassWord());
	end
end

function RememberBtn_OnClick()
--[[
	local checked = not LoginFrameRememberBtn:GetCheckState()
	LoginFrameRememberBtn:SetCheckState(checked)

	if checked then LoginFrameRememberBtnCheck:Show()
	else LoginFrameRememberBtnCheck:Hide() end
	]]
end

function RegisterBtn_OnClick()
	local name = LoginFrameUserNameEdit:GetText();

	if ( name == "" ) then
		--Login_MessageBoxOK( { ["text"] = "账号不能为空", ["opDesc"] = "" } );
	else
		ClientCurGame:requestRegister(name, LoginFramePasswordEdit:GetPassWord())
	end
end

function SettingBtn_OnClick()
end

function OfflineModeBtn_OnClick()
	ClientMgr:setGameVar("ViewRadius", "1")
	ClientCurGame:offlineCreateWorld(1, "test", 0, "aaa", 1)
end

function OfflineModeBtn2_OnClick()
	ClientMgr:setGameVar("ViewRadius", "4")
	ClientCurGame:offlineCreateWorld(1, "test2", 1, "aaa1", 1)
end

IsFirstLogin = false
function LoginFrame_OnLoad()
	this:RegisterEvent("GE_FIRST_LOGIN")
	this:RegisterEvent("GE_LOGIN_ONLINE")
end

function LoginFrame_OnEvent()
	if arg1 == "GE_FIRST_LOGIN" then
		IsFirstLogin = true
		LoginScreenFrame:Hide()
		SelectRoleFrame:Show()
	elseif arg1 == "GE_LOGIN_ONLINE" then
		LoginScreenFrame:Hide()
		LobbyFrame:Show()
	end
end