local SelectStoreType = 0;		--商城类型；
local t_StorePlayerIndices = { 2, 3, 4, 8, 9 };	
local CurSelectStoreRoleIndex = 1;
		
function StoreFrame_OnShow()
	GongNengFrame:Show();
	CurShowFrameName = "StoreFrame";

	StoreFrameRoleView:addBackgroundEffect("particles/1100.ent", 0, 0, 0);

	StoreFrameRoleView:setCameraLookAt(0, 216, -1200, 0, 127, 0);
	StoreFrameRoleView:setCameraFov(30);

	StoreFrameJewelFont:SetText(AccountManager:getDiamond());
	StoreFrameRoleBtn_OnClick()	--默认打开角色商城

--	StoreFrameScrollBar:SetValue(20);
end

function StoreFrame_OnHide()
	GongNengFrame:Hide();
	LobbyFrame:Show();
end

function StoreFrameBackBtn_OnClick()
	StoreFrame:Hide();
end

--礼包
function StoreFrameGiftBtn_OnClick()
end

--角色
function StoreFrameRoleBtn_OnClick()
	if SelectStoreType ~= 1 then
		HideCurShowStoreFrame();		
		SelectStoreType = 1;
		SetStoreFrameLabelTexUvNormal();
		StoreFrameRoleBtnNormal:SetTexUV(425, 390, 120, 120);
		StoreFrameRoleBtn:SetSize(135, 135);
		StoreFrameRole:Show();
	end
end

--坐骑
function StoreFrameRideBtn_OnClick()
--[[
	if SelectStoreType ~= 2 then
		SelectStoreType = 2;
		SetStoreFrameLabelTexUvNormal();
		StoreFrameRideBtnNormal:SetTexUV(646, 390, 120, 120);
		StoreFrameRideBtn:SetSize(135, 135);
	end
]]
end

--宠物
function StoreFramePetBtn_OnClick()
--[[
	if SelectStoreType ~= 3 then
		SelectStoreType = 3;
		SetStoreFrameLabelTexUvNormal();
		StoreFramePetBtnNormal:SetTexUV(425, 512, 120, 120);
		StoreFramePetBtn:SetSize(135, 135);
	end
]]
end

--道具
function StoreFramePropBtn_OnClick()
	if SelectStoreType ~= 4 then
		HideCurShowStoreFrame();
		SelectStoreType = 4;
		SetStoreFrameLabelTexUvNormal();
		StoreFramePropBtnNormal:SetTexUV(646, 512, 120, 120);
		StoreFramePropBtn:SetSize(135, 135);	
		StoreFrameProp:Show();
		local player = BuddyManager:getSelectRole(t_StorePlayerIndices[CurSelectStoreRoleIndex]);
		player:detachUIModelView(StoreFrameRoleView);
	end
end

--钻石
function StoreFrameJewelBtn_OnClick()
--[[	
	if SelectStoreType ~= 5 then
		SelectStoreType = 5;
		SetStoreFrameLabelTexUvNormal();
		StoreFrameJewelBtnNormal:SetTexUV(871, 512, 120, 120);
		StoreFrameJewelBtn:SetSize(135, 135);
	end
]]
end

local t_StoreLabelInfo = {
				{name="StoreFrameRoleBtn", x=328, y=403, w=94, h=99,},
				{name="StoreFrameRideBtn", x=549, y=403, w=94, h=99,},
				{name="StoreFramePetBtn", x=328, y=525, w=94, h=99,},
				{name="StoreFramePropBtn", x=549, y=525, w=94, h=99,},
				{name="StoreFrameJewelBtn", x=774, y=525, w=94, h=99,},
			}
function SetStoreFrameLabelTexUvNormal()
	for i=1, #(t_StoreLabelInfo) do
		local btn = getglobal(t_StoreLabelInfo[i].name);
		local btnNormal = getglobal(btn:GetName().."Normal");
		
		btnNormal:SetTexUV(t_StoreLabelInfo[i].x, t_StoreLabelInfo[i].y, t_StoreLabelInfo[i].w, t_StoreLabelInfo[i].h);
		btn:SetSize(106, 112);
	end
end

function HideCurShowStoreFrame()
	if SelectStoreType == 1 then
		StoreFrameRole:Hide();
	elseif SelectStoreType == 2 then
	elseif SelectStoreType == 3 then
	elseif SelectStoreType == 4 then
		StoreFrameProp:Hide();
	elseif SelectStoreType == 5 then
	end
end

-------------------------------------------------------StoreFrameRole-------------------------------------------------------
function StoreFrameRole_OnLoad()
	this:setUpdateTime(0.05);

	StoreFrameRoleView:setCameraWidthFov(30)
	StoreFrameRoleView:setCameraLookAt(0, 220, -1200, 0, 128, 0)
	StoreFrameRoleView:setActorPosition(-200, 0, -400)
end

function StoreFrameRole_OnShow()
	StoreFrameRoleDesc:SetText("考古队保镖，前海军陆战队队员擅长格斗与射击。", 255, 255, 255);
	CurSelectStoreRoleIndex = 1;
	StoreFrameRoleRightBtn:Hide();
	StoreFrameRoleLeftBtn:Show();
	UpdateStoreRole();
end

function UpdateStoreRole()
	local player = BuddyManager:getSelectRole(t_StorePlayerIndices[CurSelectStoreRoleIndex]);
	player:attachUIModelView(StoreFrameRoleView);
	StoreFrameRoleView:playActorAnim(100100, 0);

	local leftHead 		= getglobal("StoreFrameRoleLeftHead");
	local selectedHead 	= getglobal("StoreFrameRoleSelectedHead");
	local rightHead 	= getglobal("StoreFrameRoleRightHead");
	
	local model = t_StorePlayerIndices[CurSelectStoreRoleIndex] + 1;
	selectedHead:SetTexture("ui/roleicons/"..model..".png");

	if CurSelectStoreRoleIndex - 1 > 0 then
		local n = t_StorePlayerIndices[CurSelectStoreRoleIndex-1] + 1;
		leftHead:Show();
		leftHead:SetTexture("ui/roleicons/"..n..".png");
	else
		leftHead:Hide();
	end

	if CurSelectStoreRoleIndex + 1 <= 5 then
		local n = t_StorePlayerIndices[CurSelectStoreRoleIndex+1] + 1;
		rightHead:Show();
		rightHead:SetTexture("ui/roleicons/"..n..".png");
	else
		rightHead:Hide();
	end
end

--更新箭头
local changeSpeed = 2;
local changeOffset = changeSpeed
local curOffset = 0;
function StoreFrameRole_OnUpdate()
	curOffset = curOffset + changeOffset;
	if curOffset > 15 then
		curOffset = 15;
		changeOffset = -changeSpeed*0.5;
	elseif curOffset <= 0 then
		curOffset = 0;
		changeOffset = changeSpeed;
	end

	if StoreFrameRoleLeftBtn:IsShown() then
		StoreFrameRoleLeftBtnNormal:SetPoint("topleft", "StoreFrameRole", "topleft", -(20+curOffset), 42);
	end
	if StoreFrameRoleRightBtn:IsShown() then
		StoreFrameRoleRightBtnNormal:SetPoint("topleft", "StoreFrameRole", "topleft", 655+curOffset, 42);
	end
end

function ScrollBar_OnMouseUp()
	DebugString("scrollBarTest11111111111111111111111111111");
end

function StoreFrameRoleLeftBtn_OnClick()
	if CurSelectStoreRoleIndex ~= 5 then
		if CurSelectStoreRoleIndex ==  1 then
			StoreFrameRoleRightBtn:Show();
		end
		local player = BuddyManager:getSelectRole(t_StorePlayerIndices[CurSelectStoreRoleIndex]);
		player:detachUIModelView(StoreFrameRoleView);

		CurSelectStoreRoleIndex = CurSelectStoreRoleIndex + 1;
		UpdateStoreRole();

		if CurSelectStoreRoleIndex == 5 then
			StoreFrameRoleLeftBtn:Hide();
		end
	end
end

function StoreFrameRoleRightBtn_OnClick()
	if CurSelectStoreRoleIndex ~= 1 then
		if CurSelectStoreRoleIndex ==  5 then
			StoreFrameRoleLeftBtn:Show();
		end

		local player = BuddyManager:getSelectRole(t_StorePlayerIndices[CurSelectStoreRoleIndex]);
		player:detachUIModelView(StoreFrameRoleView);

		CurSelectStoreRoleIndex = CurSelectStoreRoleIndex - 1;
		UpdateStoreRole();

		if CurSelectStoreRoleIndex == 1 then
			StoreFrameRoleRightBtn:Hide();
		end
	end
end

function StoreFrameRoleBuytBtn_OnClick()
end

------------------------------------------------------StoreFrameProp-------------------------------------------------------
local PAGE_PROP_MAX_NUM = 6;
function StoreFrameProp_OnShow()
	local text = "另送道具  #cff4800(限购1次)#n"
	StoreFramePropItem1Desc:SetText(text, 255, 255, 255);
end

function StoreItem_OnClick()
	SetStoreItemState(this:GetClientID());
end

function SetStoreItemState(clientId)
	for i=1, PAGE_PROP_MAX_NUM do
		local item 	= getglobal("StoreFramePropItem"..i);
		local iconBkg	= getglobal("StoreFramePropItem"..i.."IconBkg");
		local iconCheck = getglobal("StoreFramePropItem"..i.."IconCheck");
		if item ~= nil then
			if item:GetClientID() == clientId then
				iconBkg:Hide();
				iconCheck:Show();
			else
				iconCheck:Hide();
				iconBkg:Show();
			end
		end
	end
end