

function FlatWorldBtn_OnClick()
	ClientCurGame:requestCreateWorld(0, CreateWorldNameInput:GetText(), 0, CreateWorldSeedInput:GetText())

	TitleFrame:Hide()
	LobbyFrame:Show()
end

function NormalWorldBtn_OnClick()
	ClientCurGame:requestCreateWorld(0, CreateWorldNameInput:GetText(), 1, CreateWorldSeedInput:GetText())

	TitleFrame:Hide()
	LobbyFrame:Show()
end

function OpenWorldBtn_OnClick()
	ClientCurGame:requestCreateWorld(1, CreateWorldNameInput:GetText(), 1, CreateWorldSeedInput:GetText())

	TitleFrame:Hide()
	LobbyFrame:Show()
end
