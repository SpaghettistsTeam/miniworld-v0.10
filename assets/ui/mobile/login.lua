IsFirstLogin = false;
isEnterGame = false;

function LoginFrame_OnLoad()
	this:RegisterEvent("GE_ENTER_GAME");
	this:setUpdateTime(0.05)

	LoginScreenFrameBkgFX:addBackgroundEffect("particles/1102.ent", 0, -450, 700);
end

function LoginFrame_OnEvent()
	if arg1 == "GE_ENTER_GAME" then
		LoginScreenFrame:Hide();
		local ge = GameEventQue:getCurEvent();
		IsFirstLogin = ge.body.entergame.firsttime;		
		if IsFirstLogin then
			SelectRoleFrame:Show();
		else
			BackgroundFrame:Show();
			LobbyFrame:Show()		
		end
	end
end

function LoginFrame_OnShow()
	LoginScreenFrameEnterGame:SetBlendAlpha(1.0);
	isEnterGame = false;
	LoginScreenFrameUpdateProgressBar:SetValue(0.5);
--	ClientMgr:playMusic("sounds/music/theme1.ogg");
	LoginScreenFrameVersion:SetText(ClientMgr:clientVersion());
end

function LoginFrame_OnClick()
	if isEnterGame then return; end
	isEnterGame = true;
	AccountManager:requestEnterGame();
end

alphaIncSpeed = 0.25/12;
changeAlpha = alphaIncSpeed;
curAlpha = 0
angleSpeed = 10;
angle = 0;
function LoginFrame_OnUpdate()
	curAlpha = curAlpha + changeAlpha;
	if curAlpha > 1 then
		curAlpha = 1;
		changeAlpha = -alphaIncSpeed*2
	elseif curAlpha < 0 then
		curAlpha = 0;
		changeAlpha = alphaIncSpeed
	end

	LoginScreenFrameEnterGame:SetBlendAlpha(curAlpha)

	angle = angle + angleSpeed;
	if angle > 360 then
		angle = angle - 360;
	end
	LoginScreenFrameCircle:SetAngle(angle);
end

function LoginScreenFrameSdkLoginBtn_OnClick()
end