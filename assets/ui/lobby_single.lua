
CurSelectSingleRecord = 0
SingleRecordWorldID = {}
CurNewWorldTerrType = 0


function SingleRecordBtn_OnClick()
	CurSelectSingleRecord = this:GetParentFrame():GetClientID()

	for i=1, 3, 1 do
		local btn = getglobal("SingleGameFrameRec"..i.."Record")
		if btn ~= this then btn:DisChecked() end
	end
end

function UnixTime2Str(t)
	return os.date("%c", t)
end

function UpdateSingleSurviveRec()
	wlist = AccountManager:getMyWorldList()

	local count = 0
	for i=1, wlist:getNumWorld(), 1 do
		desc = wlist:getWorldDesc(i-1)
		if desc.worldtype == 0 then
			count = count + 1
			if count > 3 then return end

			local btnname = "SingleGameFrameRec"..count
			local recbtn = getglobal(btnname)
			
			local label = getglobal(btnname.."RecordName")
			label:SetText(desc.worldname)
			label = getglobal(btnname.."RecordTime")
			label:SetText("上次时间: "..UnixTime2Str(desc.logintime))

			local pic = getglobal(btnname.."ShotPic")
			pic:SetTexture("data/1.png")

			local invbtn = getglobal(btnname.."RecordInvite")
			invbtn:Show()

			SingleRecordWorldID[count] = desc.worldid
		end
	end

	for i=count+1, 3, 1 do
		local btnname = "SingleGameFrameRec"..i

		local label = getglobal(btnname.."RecordName")
		label:SetText("")
		label = getglobal(btnname.."RecordTime")
		label:SetText("")

		local pic = getglobal(btnname.."ShotPic")
		pic:SetTexture("ui/question.png")

		local invbtn = getglobal(btnname.."RecordInvite")
		invbtn:Hide()

		SingleRecordWorldID[i] = 0
	end

	CurSelectSingleRecord = 0
end

function SingleGameFrame_OnLoad()
	this:RegisterEvent("GE_WORLDLIST_CHANGE")
end

function SingleGameFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();

	if arg1 == "GE_WORLDLIST_CHANGE" and ge.body.worldlist.myworld then
		UpdateSingleSurviveRec()
	end
end

function SingleGameFrame_OnShow()
	CurSelectSingleRecord = 0
	UpdateSingleSurviveRec()
end

function BeginCreateSingleWorld()
	SingleGameFrame:Hide()
	LobbyFrameTitleBar:MoveFrame("top", 0.5, 0, LobbyFrameTitleBar:GetHeight())
	LobbyFrameBottomBar:MoveFrame("bottom", 0.5, 0, LobbyFrameBottomBar:GetHeight())

	NewWorldFrame:Show()
end

function BeginDeleteSingleWorld()
	if CurSelectSingleRecord > 0 and SingleRecordWorldID[CurSelectSingleRecord]>0 then
		ClientCurGame:requestDeleteWorld(SingleRecordWorldID[CurSelectSingleRecord])
	end
end

function BeginEnterSingleWorld()
	if CurSelectSingleRecord > 0 and SingleRecordWorldID[CurSelectSingleRecord]>0 then
		ClientCurGame:requestEnterWorld(SingleRecordWorldID[CurSelectSingleRecord])
	end
end

function CancelCreateNewWorld()
	NewWorldFrame:Hide()
	LobbyFrameTitleBar:MoveFrame("bottom", 0.5, 0, LobbyFrameTitleBar:GetHeight())
	LobbyFrameBottomBar:MoveFrame("top", 0.5, 0, LobbyFrameBottomBar:GetHeight())
end

function SingleRecordInviteBtn_OnClick()
	CurSelectSingleRecord = this:GetParentFrame():GetParentFrame():GetClientID()
	local worldid = SingleRecordWorldID[CurSelectSingleRecord]
	if worldid > 0 then
		desc = AccountManager:getMyWorldList():findWorldDesc(worldid)
		AuthSettingFrameName:SetText(desc.worldname)
		AuthSettingFramePic:SetTexture("data/1.png")
		AuthSettingFrame:Show()
	end
end

function PackAuthSetting(auth1, auth2, auth3)
	local bits = 0
	if auth1 then bits = bits+1 end
	if auth2 then bits = bits+2 end
	if auth3 then bits = bits+4 end

	return bits
end

function UnpackAuthSetting(inputbits)
	local auth1 = false
	local auth2 = false
	local auth3 = false

	local bits = inputbits%8
	if bits >= 4 then
		auth3 = true
		bits = bits - 4
	end
	if bits >= 2 then
		auth2 = true
		bits = bits - 2
	end
	if bits > 0 then
		auth1 = true
	end

	return auth1, auth2, auth3
end

function AuthSettingFrame_OnShow()
	local worldid = SingleRecordWorldID[CurSelectSingleRecord]
	if worldid > 0 then
		desc = AccountManager:getMyWorldList():findWorldDesc(worldid)
		local a1, a2, a3 = UnpackAuthSetting(desc.closepermits)
		AuthSettingFrameCloseAuth1:SetChecked(a1)
		AuthSettingFrameCloseAuth2:SetChecked(a2)
		AuthSettingFrameCloseAuth3:SetChecked(a3)

		a1, a2, a3 = UnpackAuthSetting(desc.normalpermits)
		AuthSettingFrameNormalAuth1:SetChecked(a1)
		AuthSettingFrameNormalAuth2:SetChecked(a2)

		a1, a2, a3 = UnpackAuthSetting(desc.otherpermits)
		AuthSettingFrameOtherAuth1:SetChecked(a1)
	end
end

function AuthSettingConfirm_OnClick()
	local worldid = SingleRecordWorldID[CurSelectSingleRecord]
	desc = AccountManager:getMyWorldList():findWorldDesc(worldid)
	
	if desc ~= nil then
		local bits1 = PackAuthSetting(AuthSettingFrameCloseAuth1:IsChecked(), AuthSettingFrameCloseAuth2:IsChecked(), AuthSettingFrameCloseAuth3:IsChecked())
		local bits2 = PackAuthSetting(AuthSettingFrameNormalAuth1:IsChecked(), AuthSettingFrameNormalAuth2:IsChecked(), false)
		local bits3 = PackAuthSetting(AuthSettingFrameOtherAuth1:IsChecked(), false, false)

		desc.closepermits = bits1
		desc.normalpermits = bits2
		desc.otherpermits = bits3
		ClientCurGame:requestSetWorldPermits(worldid, bits1, bits2, bits3)
	end

	AuthSettingFrame:Hide()
end

function AuthSettingClose_OnClick()
	AuthSettingFrame:Hide()
end

function NewWorldEnterBtn_OnClick()
	ClientCurGame:requestCreateWorld(0, NewWorldFrameWorldName:GetText(), CurNewWorldTerrType, NewWorldFrameWorldSeed:GetText())
end

function NewWorldModeBtn_OnClick()
end

function NewWorldMoreOptBtn_OnClick()
	NewWorldFrameWorldName:Hide()
	NewWorldFrameMode:Hide()
	NewWorldFrameMoreOpt:Hide()

	NewWorldFrameWorldSeed:Show()
	NewWorldFrameTerrType:Show()
	NewWorldFrameSaveOpt:Show()
end

function InitNewWorldShowHide()
	NewWorldFrameWorldName:Show()
	NewWorldFrameMode:Show()
	NewWorldFrameMoreOpt:Show()

	NewWorldFrameWorldSeed:Hide()
	NewWorldFrameTerrType:Hide()
	NewWorldFrameSaveOpt:Hide()
end

function NewWorldFrame_OnShow()
	InitNewWorldShowHide()

	NewWorldFrameWorldName:SetText("")
	NewWorldFrameWorldSeed:SetText("")
	NewWorldFrameTerrType:SetText("世界类型: 默认")
	CurNewWorldTerrType = 1
end

function NewWorldSaveOptBtn_OnClick()
	InitNewWorldShowHide()
end

function NewWorldTerrTypeBtn_OnClick()
	CurNewWorldTerrType = 1 - CurNewWorldTerrType

	if CurNewWorldTerrType == 0 then 
		NewWorldFrameTerrType:SetText("世界类型: 超平坦")
	else 
		NewWorldFrameTerrType:SetText("世界类型: 默认")
	end
end