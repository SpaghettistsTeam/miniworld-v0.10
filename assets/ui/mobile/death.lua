
function DeathReviveBtn_OnClick()
	DeathFrame:Hide();
	ClientCurGame:setOperateUI(false);
	ClientCurGame:getMainPlayer():revive();
end

function DeathContinueBtn_OnClick()
end

function DeathMainMenuBtn_OnClick()
	DeathFrame:Hide();
	ClientMgr:gotoGame("MainMenuStage");
end

function DeathBackMainMenuBtn_OnClick()
	DeathFrame:Hide();
	ClientMgr:gotoGame("MainMenuStage");
end

function DeathFrame_OnLoad()
	this:RegisterEvent("GE_MAINPLAYER_DIE")
end

function DeathFrame_OnEvent()
	if arg1 == "GE_MAINPLAYER_DIE" then
		DeathFrame:Show()
	end
end

function DeathFrame_OnShow()
	DeathFrameContinueBtn:Disable();
	DeathFrameContinueBtnNormal:SetGray(true);	
	ClientCurGame:setOperateUI(true);
end

function DeathFrame_OnHide()
	ClientCurGame:setOperateUI(false);
end
