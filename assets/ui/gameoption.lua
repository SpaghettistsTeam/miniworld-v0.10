
function GameOptContinueBtn_OnClick()
	ClientCurGame:setOperateUI(false);
	GameOptionFrame:Hide();
end

function GameOptMainMenuBtn_OnClick()
	ClientCurGame:setOperateUI(false);
	GameOptionFrame:Hide();
	HideAllFrame(nil);
	ClientMgr:gotoGame("MainMenuStage");
end

function GameOptHideUIBtn_OnClick()
	GameOptionFrame:Hide();
	HideAllUI();
end

function GameOptionFrame_OnShow()
	if ClientMgr:isMobile() then
		GameOptionFrameHideUIBtn:Show();
	else
		GameOptionFrameHideUIBtn:Hide();
	end
end

function GameOptionFrame_OnHide()
end
