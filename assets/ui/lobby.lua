
CurSelectWorldDesc = nil
LastCheckedWorldItem = nil

function HideLobbyPopFrames()
	if LobbyFrameSelectGame:IsShown() then LobbyFrameSelectGame:Hide() end
	if SingleGameFrame:IsShown() then SingleGameFrame:Hide() end
	if MyGamesFrame:IsShown() then MyGamesFrame:Hide() end
	if NewWorldFrame:IsShown() then NewWorldFrame:Hide() end
end

function TitleBarSingleGameBtn_OnClick()
	HideLobbyPopFrames()
	SingleGameFrame:Show()
end

function TitleBarMultiGameBtn_OnClick()
	HideLobbyPopFrames()
	LobbyFrame:Hide()
	MultiGameFrame:Show()
end

function TitleBarShopBtn_OnClick()
end

function TitleBarVIPBtn_OnClick()
end

function BottomBarBuddyBtn_OnClick()
	if BuddyListFrame:IsShown() then BuddyListFrame:Hide()
	else BuddyListFrame:Show() end
end

function BottomBarMyGameBtn_OnClick()
	HideLobbyPopFrames()
	MyGamesFrame:Show()
end

function BottomBarNoticeBtn_OnClick()
end

function SelectGameSingleBtn_OnClick()
	IsFirstLogin = false
	HideLobbyPopFrames()
	BeginCreateSingleWorld()
end

function SelectGameMultiBtn_OnClick()
	IsFirstLogin = false
	HideLobbyPopFrames()
end

function LobbyFrame_OnLoad()
end

function LobbyFrame_OnEvent()
end

function LobbyFrame_OnShow()
	TitleBarRoleNickName:SetText(AccountManager:getNickName())
	LobbyFrameTitleBar:EndMoveFrame()
	LobbyFrameTitleBar:SetPoint("top", "LobbyFrame", "top", 0, 0)
	LobbyFrameBottomBar:EndMoveFrame()
	LobbyFrameBottomBar:SetPoint("bottom", "LobbyFrame", "bottom", 0, 0)

	if IsFirstLogin then
		LobbyFrameSelectGame:Show()
	else
		TitleBarSingleGameBtn_OnClick()
	end
end

function MainMenuStage_Enter()
	ClientMgr:setGameVar("ViewRadius", "2");
	if AccountManager:isLogin() then
		LobbyFrame:Show()
	else
	--	LoginFrame:Show()
	end
end

function MainMenuStage_Quit()
	LoginScreenFrame:Hide()
	LobbyFrame:Hide()
	MultiGameFrame:Hide()
	HideLobbyPopFrames()
end

function SurviveGame_Enter()
	if ClientMgr:isMobile() then
		PlayMainFrame:Show()
	else
		ShotcutFrame:Show()
		PlayerStatusFrame:Show()
	end
end

function SurviveGame_Quit()
	if ClientMgr:isMobile() then
		PlayMainFrame:Hide()
	else
		ShotcutFrame:Hide()
		PlayerStatusFrame:Hide()
	end
end
