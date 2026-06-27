
function MyGameSingleRec_OnClick()
	CurSelectSingleRecord = this:GetParentFrame():GetClientID()
	BeginEnterSingleWorld()
end

function MyCreateRecEnter_OnClick()
end

function UpdateMyGameSurviveRec()
	wlist = AccountManager:getMyWorldList()

	local count = 0
	for i=1, wlist:getNumWorld(), 1 do
		desc = wlist:getWorldDesc(i-1)
		if desc.worldtype == 0 then
			count = count + 1
			if count > 3 then return end

			local label = getglobal("MyGamesFrameSurviveRec"..count.."Time")
			label:SetText(UnixTime2Str(desc.logintime))

			local pic = getglobal("MyGamesFrameSurviveRec"..count.."ShotPic")
			pic:SetTexture("data/1.png")

			SingleRecordWorldID[count] = desc.worldid
		end
	end

	for i=count+1, 3, 1 do
		local label = getglobal("MyGamesFrameSurviveRec"..i.."Time")
		label:SetText("")
		local pic = getglobal("MyGamesFrameSurviveRec"..i.."ShotPic")
		pic:SetTexture("ui/question.png")

		SingleRecordWorldID[i] = 0
	end

	CurSelectSingleRecord = 0
end

function UpdateMyGameCreateRec()
	wlist = AccountManager:getMyWorldList()

	local count = 0
	for i=1, wlist:getNumWorld(), 1 do
		desc = wlist:getWorldDesc(i-1)
		if desc.worldtype == 1 then
			count = count + 1
			if count > 3 then return end

			local name = "MyGamesFrameCreateRec"..count
			local label = getglobal(name.."Index")
			label:SetText(""..count)
			label = getglobal(name.."Name")
			label:SetText(desc.worldname)
			label = getglobal(name.."Type")
			label:SetText("创造")
			label = getglobal(name.."Players")
			label:SetText("1/32")
			label = getglobal(name.."State")
			label:SetText("分享")
		end
	end

	for i=count+1, 3, 1 do
	end
end

function MyGamesFrame_OnShow()
	UpdateMyGameSurviveRec()
	UpdateMyGameCreateRec()
end
