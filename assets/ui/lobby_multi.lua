
CurSelectWorldDesc = nil
LastCheckedWorldItem = nil

function WorldListItem_OnClick()
	index = this:GetClientID()
	local wlist = nil
	if index > 100 then
		index = index-101
		wlist = AccountManager:getOpenWorldList()
	else
		index = index-1
		wlist = AccountManager:getMyWorldList()
	end

	if index < wlist:getNumWorld() then
		CurSelectWorldDesc = wlist:getWorldDesc(index)
		if LastCheckedWorldItem ~= nil then LastCheckedWorldItem:DisChecked() end

		this:Checked()
		LastCheckedWorldItem = this
	end
end

function LobbyEnterWorldBtn_MouseClick()
	if CurSelectWorldDesc ~= nil then
		ClientCurGame:requestEnterWorld(CurSelectWorldDesc.worldid)
	end
end

function LobbyOpenWorldBtn_MouseClick()
	if CurSelectWorldDesc ~= nil and CurSelectWorldDesc.owneruin==AccountManager:getUin() then
		ClientCurGame:requestOpenWorld(CurSelectWorldDesc.worldid, not CurSelectWorldDesc.isopen);
	end
end

function LobbyRefreshWorldBtn_MouseClick()
	ClientCurGame:requestRefreshOpenWorlds(0)
end

function MultiGameFrame_OnLoad()
	this:RegisterEvent("GE_WORLDLIST_CHANGE")
end

WORLDLIST_MAX_ROWS = 8

function UpdateWorldList(ismyworld)
	if ismyworld then
		btnname = "MyWorldListItem"
		wlist = AccountManager:getMyWorldList()
	else
		btnname = "OpenWorldListItem"
		wlist = AccountManager:getOpenWorldList()
	end

	for i=1, WORLDLIST_MAX_ROWS, 1 do
		local btn = getglobal(btnname..i)
		btn:DisChecked()

		local btn_worldname = getglobal(btnname..i.."WorldName")
		local btn_ownername = getglobal(btnname..i.."OwnerName")

		if i > wlist:getNumWorld() then
			btn_worldname:SetText("")
			btn_ownername:SetText("")
			break 
		end

		desc = wlist:getWorldDesc(i-1)

		if desc.isopen then btn_worldname:SetText("*"..desc.worldname)
		else btn_worldname:SetText(desc.worldname) end

		btn_ownername:SetText(desc.ownernick)
	end
	LastCheckedWorldItem = nil
end

function MultiGameFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();

	if arg1 == "GE_WORLDLIST_CHANGE" then
		UpdateWorldList(ge.body.worldlist.myworld)
	end

end
