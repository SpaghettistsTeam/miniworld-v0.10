
CurSelectBuddyUIN = 0
CurSelectBuddyItemFrame = nil

function BuddyListItemMsgBtn_OnClick()
end

function BuddyListFilterFunc(group, i)
	local text = BuddyListFrameSearchEdit:GetText()
	if text == "" then return true end
	
	local info = nil
	if group == 0 then info = BuddyManager:getCloseBuddy(i)
	else info = BuddyManager:getNormalBuddy(i) end

	if string.find(info.name, text) == nil then return false
	else return true end
end

function BuddyListItem_OnClick()
	if arg1 == VK_RBUTTON then
		BuddyOptionFrame:SetPoint("topleft", this:GetName(), "topright", 16, 0)
		BuddyOptionFrame:Show()
		CurSelectBuddyUIN = this:GetClientID()
		CurSelectBuddyItemFrame = this
	end
end

function BuddyListFrameSearchBtn_OnClick()
	if not BuddyListFrameList:IsGroupOpen(0) then BuddyListFrameList:ToggleGroupOpen(0) end
	if not BuddyListFrameList:IsGroupOpen(1) then BuddyListFrameList:ToggleGroupOpen(1) end

	UpdateBuddyList(BuddyListFrameList)
end

function BuddyListFrameAddBtn_OnClick()
end

function BuddyListFrameSysMsgBtn_OnClick()
end

function BuddyListFrameTypeABtn_OnClick()
	BuddyListFrameList:ToggleGroupOpen(0)
	UpdateBuddyList(BuddyListFrameList)
end

function BuddyListFrameTypeBBtn_OnClick()
	BuddyListFrameList:ToggleGroupOpen(1)
	UpdateBuddyList(BuddyListFrameList)
end

BuddyList_CurViewPos = 0
function BuddyListScrollBar_OnValueChanged()
	BuddyList_CurViewPos = BuddyListFrameScrollBar:GetValue()
	BuddyListFrameList:SetViewPos(BuddyList_CurViewPos)
end

function ScrollBar_OnMouseWheel()
end

function UpdateBuddyItemFrame(itemframe, info)
	itemframe:SetClientID(info.uin)

	local name = itemframe:GetName()
	local nickframe = getglobal(name.."NickName")
	nickframe:SetText(info.name)

	local statusframe = getglobal(name.."Status")
	if info.online then statusframe:SetText("在线")
	else statusframe:SetText("") end

	local iconframe = getglobal(name.."Icon")
	iconframe:SetTexture("ui/roleicons/"..info.model..".png")
end

function UpdateBuddyList(listframe)
	listframe:Resize(0, BuddyManager:getNumCloseBuddy())
	listframe:Resize(1, BuddyManager:getNumNormalBuddy())

	for i=0, BuddyManager:getNumCloseBuddy()-1, 1 do
		itemframe = listframe:GetItemFrame(0, i)
		info = BuddyManager:getCloseBuddy(i)
		UpdateBuddyItemFrame(itemframe, BuddyManager:getCloseBuddy(i))
	end

	for i=0, BuddyManager:getNumNormalBuddy()-1, 1 do
		itemframe = listframe:GetItemFrame(1, i)
		UpdateBuddyItemFrame(itemframe, BuddyManager:getNormalBuddy(i))
	end

	scrollrange = listframe:GetTotalHeight() - BuddyListFrameList:GetHeight()
	if scrollrange <= 0 then
		BuddyListFrameScrollBar:Hide()
	else
		BuddyListFrameScrollBar:Show()
		BuddyListFrameScrollBar:SetMinValue(0)
		BuddyListFrameScrollBar:SetMaxValue(scrollrange)

		if BuddyList_CurViewPos > scrollrange then
			BuddyList_CurViewPos = scrollrange
			BuddyListFrameList:SetViewPos(BuddyList_CurViewPos)
		end
	end
end

function BuddyListFrame_OnLoad()
	this:RegisterEvent("GE_BUDDYLIST_CHANGE")

	BuddyListFrameList:SetFilterFunc("BuddyListFilterFunc")
	BuddyListFrameList:SetViewPos(0)
end

function BuddyListFrame_OnEvent()
	if arg1 == "GE_BUDDYLIST_CHANGE" then
		UpdateBuddyList(BuddyListFrameList)
	end
end

function BuddyListFrame_OnShow()
	BuddyListFrameMyNick:SetText(AccountManager:getNickName())

	UpdateBuddyList(BuddyListFrameList)
end

function BuddyListFrame_OnHide()
	BuddyChatFrame:Hide()
	BuddyOptionFrame:Hide()
end

function BuddyOptionTalkBtn_OnClick()
	ResetChatContentFrame()
	BuddyOptionFrame:Hide()
end

function BuddyOptionViewBtn_OnClick()
	BuddyViewFrame:Show()
	BuddyOptionFrame:Hide()
end

function BuddyOptionIntimateBtn_OnClick()
	flags = 0
	if not this:IsChecked() then flags = 1 end

	BuddyManager:requestBuddyChg(CurSelectBuddyUIN, flags)
end

function BuddyOptionRemoveBtn_OnClick()
	BuddyManager:requestDelBuddy(CurSelectBuddyUIN)
end

CurDisplayedChatNum = 0
function ResetChatContentFrame()
	CurDisplayedChatNum = 0

	local y = 0
	local ybottom = CurSelectBuddyItemFrame:GetTop()+BuddyChatFrame:GetHeight()
	if ybottom > GetScreenHeight() then
		y = GetScreenHeight() - ybottom
	end

	BuddyChatFrameContent:Clear()
	BuddyChatFrame:SetPoint("topleft", CurSelectBuddyItemFrame:GetName(), "topright", 16, y)
	BuddyChatFrame:Show()

	UpdateBuddyChatContent()
end

function AddOneLineToBuddyChat(speaker, text) --speaker==nil表示是自己
	local color
	if speaker == nil then
		speaker = AccountManager:getNickName()
		color = "#cFFD100"
	else
		color = "#c00C4FF"
	end

	local chatdisp = BuddyChatFrameContent
	chatdisp:AddText(color..speaker..": #n"..text, 255, 255, 255);
	CurDisplayedChatNum = CurDisplayedChatNum + 1
end

function UpdateBuddyChatContent()
	local buddy = BuddyManager:findBuddy(CurSelectBuddyUIN)
	if buddy == nil then return end

	for i=CurDisplayedChatNum, buddy:getNumChatInfo()-1, 1 do
		local chatinfo = buddy:getChatInfo(i)
		if chatinfo.frombuddy then AddOneLineToBuddyChat(buddy.name, chatinfo.content)
		else AddOneLineToBuddyChat(nil, chatinfo.content) end
	end

	local chatdisp = BuddyChatFrameContent
	local maxviewlines = chatdisp:GetAccurateViewLines()
	local n = chatdisp:GetTextLines() - maxviewlines

	if n > 0 then
		BuddyChatFrameScrollBar:Show()
		BuddyChatFrameScrollBar:SetMinValue(0)
		BuddyChatFrameScrollBar:SetMaxValue(n)
		BuddyChatFrameScrollBar:SetValue(n)
	else
		BuddyChatFrameScrollBar:Hide()
	end

	chatdisp:SetDispPos(chatdisp:GetStartDispPos());
	for i = 1, n, 1 do
		chatdisp:ScrollDown();
	end
end

function BuddyChatScrollBar_OnValueChanged()
	local n = BuddyChatFrameScrollBar:GetValue()

	local chatdisp = BuddyChatFrameContent
	chatdisp:SetDispPos(chatdisp:GetStartDispPos());
	for i = 1, n, 1 do
		chatdisp:ScrollDown();
	end
end

function BuddyChatEditbox_OnEnterPressed()
	local text = BuddyChatFrameInput:GetText();
	BuddyChatFrameInput:AddStringToHistory(text);
	BuddyChatFrameInput:Clear();
	
	BuddyManager:sendPrivateChat(CurSelectBuddyUIN, text)
end

function BuddyChatFrameClose_OnClick()
	BuddyChatFrame:Hide()
end

function BuddyChatFrame_OnLoad()
	this:RegisterEvent("GE_BUDDY_CHAT")
end

function BuddyChatFrame_OnEvent()
	if arg1 == "GE_BUDDY_CHAT" then
		UpdateBuddyChatContent()
	end
end

----------------------------buddyviewframe---------------------------------------
function BuddyViewRotateLeftBtn_OnMouseDown()
	BuddyViewFrameRoleView:setRotateSpeed(ROTATE_ACTOR_SPEED);
end
function BuddyViewRotateLeftBtn_OnMouseUp()
	BuddyViewFrameRoleView:setRotateSpeed(0);
end
function BuddyViewRotateRightBtn_OnMouseDown()
	BuddyViewFrameRoleView:setRotateSpeed(-ROTATE_ACTOR_SPEED);
end
function BuddyViewRotateRightBtn_OnMouseUp()
	BuddyViewFrameRoleView:setRotateSpeed(0);
end

function BuddyViewEnterBtn_OnClick()
end

function BuddyWorldBtn_OnClick()
end

function BuddyViewFrameClose_OnClick()
	BuddyViewFrame:Hide()
end

function BuddyViewFrame_OnLoad()
end

function BuddyViewFrame_OnEvent()
end

function BuddyViewFrame_OnShow()
	local buddy = BuddyManager:findBuddy(CurSelectBuddyUIN)
	if buddy ~= nil then
		BuddyViewFrameNickName:SetText(buddy.name)
		BuddyViewFrameWhoseWorld:SetText(buddy.name.."的世界")

		local player = ClientCurGame:getSelectRole();
		player:attachUIModelView(BuddyViewFrameRoleView);
	end
end

function BuddyViewFrame_OnHide()
	local player = ClientCurGame:getSelectRole();
	player:detachUIModelView();
end
