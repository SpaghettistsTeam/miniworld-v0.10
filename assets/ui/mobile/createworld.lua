CurNewWorldType = 0;

function CreateWorldFrame_OnShow()
	CreateWorldFrameSurvivalBtn_OnClick();
end

function CreateWorldFrameAdvancedSetBtn_OnClick()
	AdvancedSetFrame:Show();
	CreateWorldFrame:Hide();
end

function CreateWorldFrameSurvivalBtn_OnClick()
	CreateWorldFrameSurvivalBtnNormal:SetGray(false);
	CreateWorldFrameSurvivalBtnName:SetGray(false);
	CreateWorldFrameSurvivalBtnBkg:SetGray(false);
	CreateWorldFrameSurvivalBtnDescFont:SetTextColor(255, 255, 255);
	CreateWorldFrameCreateBtnNormal:SetGray(true);
	CreateWorldFrameCreateBtnName:SetGray(true);
	CreateWorldFrameCreateBtnBkg:SetGray(true);
	CreateWorldFrameCreateBtnDescFont:SetTextColor(96, 96, 96);
	CurNewWorldType = 0;

	local nickName = AccountManager:getNickName();
	CreateWorldFrameNameEdit:SetDefaultText(nickName..DefMgr:getStringDef(59));
end

function CreateWorldFrameCreateBtn_OnClick()
	CreateWorldFrameSurvivalBtnNormal:SetGray(true);
	CreateWorldFrameSurvivalBtnName:SetGray(true);
	CreateWorldFrameSurvivalBtnBkg:SetGray(true);
	CreateWorldFrameSurvivalBtnDescFont:SetTextColor(96, 96, 96);
	CreateWorldFrameCreateBtnNormal:SetGray(false);
	CreateWorldFrameCreateBtnName:SetGray(false);
	CreateWorldFrameCreateBtnBkg:SetGray(false);
	CreateWorldFrameCreateBtnDescFont:SetTextColor(255, 255, 255);
	CurNewWorldType = 1;

	local nickName = AccountManager:getNickName();
	CreateWorldFrameNameEdit:SetDefaultText(nickName..DefMgr:getStringDef(60));
end

function CreateWorldFrameBackBtn_OnClick()
	CreateWorldFrame:Hide();
	LobbyFrame:Show();
end

function CreateWorldFrameStartBtn_OnClick()
	CreateWorldFrame:Hide();
	LoadingFrame:Show();
	local worldName = CreateWorldFrameNameEdit:GetText();
	if worldName == "" then
		worldName = CreateWorldFrameNameEdit:GetDefaultText();
	end
	AccountManager:requestCreateWorld(CurNewWorldType, worldName, 1, "", AccountManager:getRoleModel());	
end