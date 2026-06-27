
local t_type = {
		{
		 iconPath = "ui/mobile/ui2.png", uv={x=885,y=449,w=61,h=61}, leftNamePath = "ui/mobile/ui.png",
		 leftUv={x=893,y=830,w=61,h=33}, leftNameWidth=69, rightNamePath = "ui/mobile/ui.png", rightUv = {x=961,y=830,w=60,h=33}
		}, --删除， 取消
		{
		 iconPath = "ui/mobile/ui2.png", uv={x=885,y=449,w=61,h=61}, leftNamePath = "ui/mobile/ui2.png",
		 leftUv={x=164,y=603,w=119,h=33}, leftNameWidth=134, rightNamePath = "ui/mobile/ui.png", rightUv = {x=961,y=830,w=60,h=33}
		}, --继续分享，取消
		{
		 iconPath = "ui/mobile/ui2.png", uv={x=885,y=449,w=61,h=61}, leftNamePath = "ui/mobile/ui2.png",
		 leftUv={x=293,y=888,w=93,h=35}, leftNameWidth=105, rightNamePath = "ui/mobile/ui.png", rightUv = {x=961,y=830,w=60,h=33}
		}, --去升级，取消
		{
		 iconPath = "ui/mobile/ui2.png", uv={x=885,y=449,w=61,h=61}, centerNamePath = "ui/mobile/ui.png",
		 centerUv={x=641,y=736,w=60,h=32}, centerNameWidth=69, 
		}, --确定
		{
		 iconPath = "ui/mobile/ui2.png", uv={x=885,y=449,w=61,h=61}, leftNamePath = "ui/mobile/ui.png",
		 leftUv={x=641,y=736,w=60,h=32}, leftNameWidth=69, rightNamePath = "ui/mobile/ui.png", rightUv = {x=961,y=830,w=60,h=33}
		}, --确定，取消
	}

function MessageBox(type, note)
	if type > #t_type then return; end

	MessageBoxFrame:SetClientString("");
	MessageBoxFrameDesc:clearHistory();

	MessageBoxFrameIcon:SetTexture(t_type[type].iconPath);
	MessageBoxFrameIcon:SetTexUV(t_type[type].uv.x, t_type[type].uv.y, t_type[type].uv.w, t_type[type].uv.h);

	if type ~= 4 then
		MessageBoxFrameLeftBtn:Show();
		MessageBoxFrameRightBtn:Show();	
		MessageBoxFrameCenterBtn:Hide();
		MessageBoxFrameLeftBtnName:SetTexture(t_type[type].leftNamePath);
		MessageBoxFrameLeftBtnName:SetSize(t_type[type].leftNameWidth, 37);
		MessageBoxFrameLeftBtnName:SetTexUV(t_type[type].leftUv.x, t_type[type].leftUv.y, t_type[type].leftUv.w, t_type[type].leftUv.h);	
		MessageBoxFrameRightBtnName:SetTexture(t_type[type].rightNamePath);
		MessageBoxFrameRightBtnName:SetTexUV(t_type[type].rightUv.x, t_type[type].rightUv.y, t_type[type].rightUv.w, t_type[type].rightUv.h);
	else
		MessageBoxFrameLeftBtn:Hide();
		MessageBoxFrameRightBtn:Hide();	
		MessageBoxFrameCenterBtn:Show();
		MessageBoxFrameCenterBtnName:SetSize(t_type[type].centerNameWidth, 37);
		MessageBoxFrameCenterBtnName:SetTexUV(t_type[type].centerUv.x, t_type[type].centerUv.y, t_type[type].centerUv.w, t_type[type].centerUv.h);	
	end

	MessageBoxFrameDesc:SetText(note, 255, 230, 67);
	local lines = MessageBoxFrameDesc:GetTextLines();
	if lines == 1 then
		MessageBoxFrameDesc:SetPoint("topleft", "MessageBoxFrame", "toleft", 126, 48);
	elseif lines == 2 then
		MessageBoxFrameDesc:SetPoint("topleft", "MessageBoxFrame", "toleft", 126, 32);
	else
		MessageBoxFrameDesc:SetPoint("topleft", "MessageBoxFrame", "toleft", 126, 15);
	end
	MessageBoxFrame:Show();
end
local isOnclik = false;
function MessageBoxFrameLeftBtn_OnClick()
	if isOnclik then return end;

	isOnclik = true;
	if MessageBoxFrame:GetClientString() == "删除地图" then
		local n = MessageBoxFrame:GetClientUserData(0);
		if n > 0 then
			--调用删除存档接口
			local worldInfo = AccountManager:getMyWorldList():getWorldDesc(n-1);
			DeleteMapIndex = n
			local worldId = worldInfo.worldid;
			if AccountManager:requestDeleteWorld(worldId) then
				DelLoadWorldList(worldId);
			end
		end
	elseif MessageBoxFrame:GetClientString() == "删除未下载完成地图" then
		local n = MessageBoxFrame:GetClientUserData(0);
		if n > 0 then
			--调用删除存档接口
			local worldInfo = AccountManager:getMyWorldList():getWorldDesc(n-1);
			DeleteMapIndex = n
			local worldId = worldInfo.worldid;
			if GetLoadWorldListState(worldId) == 1 then
				AccountManager:abortLoadWorld();
			end
			if AccountManager:requestDeleteWorld(worldId) then				
				DelLoadWorldList(worldId);
			end
		end
	elseif MessageBoxFrame:GetClientString() == "删除好友" then
		local n = MessageBoxFrame:GetClientUserData(0);
		if AccountManager:requestBuddyAttentionDel(n) then
			ResetSlidingFrame();
			UpdateFriendInfo();			
		end
	elseif MessageBoxFrame:GetClientString() == "下载存档满" then
		IsNeedReset = true;
		LobbyFrame:Show();
		if ToSeeFriendFrame:IsShown() then
			ToSeeFriendFrame:Hide();
		end
		if LobbyFrameMoreGame:IsShown() then
			LobbyFrameMoreGame:Hide();
		end		
		LobbyFrameArchiveFrame:Show();
	elseif MessageBoxFrame:GetClientString() == "网络提示" then
		local n = MessageBoxFrame:GetClientUserData(0);
		if n > 0 then
			--调用上传分享存档接口
			IsNeedReset = false;
			UseNetType = 2;
			local worldInfo = AccountManager:getMyWorldList():getWorldDesc(n-1);
			if AccountManager:requestOpenOWorld(worldInfo.worldid) then
			end
		end
	elseif MessageBoxFrame:GetClientString() == "下载地图网络提示" then
		DownLoadWorld(2);
	elseif MessageBoxFrame:GetClientString() == "更多游戏中下载地图网络提示" then
		local owid = MessageBoxFrame:GetClientUserData(0);
		local version = MessageBoxFrame:GetClientUserData(1);
		local type = MessageBoxFrame:GetClientUserData(2);
		MoreGameDownLoadWorld(2, type, owid, version);
	elseif MessageBoxFrame:GetClientString() == "恢复下载地图网络提示" then
		local n = MessageBoxFrame:GetClientUserData(0);
		if n > 0 then
			UseNetType = 2;
			local worldInfo = AccountManager:getMyWorldList():getWorldDesc(n-1);
			SetLoadWorldListState(worldInfo.worldid, 1);
			AccountManager:requestLoadWorld(worldInfo.worldid);
		end
	elseif MessageBoxFrame:GetClientString() == "继续分享" then
		local n = MessageBoxFrame:GetClientUserData(0);
		if n > 0 then
			--调用上传分享存档接口
			UseNetType = 2;
			ContunueShare(n);
		end
	elseif MessageBoxFrame:GetClientString() == "取消关注" then
		local worldId = MessageBoxFrame:GetClientUserData(0);
		if worldId > 0 then
			AccountManager:removeAttentionIds(worldId);
			local name = LobbyFrameMoreGameAttentionBtnName:GetText();
			if string.find(name, "我的关注") then
				UpdateMoreGameShareInfo();			
			else
				UpdateAttentionWatchOw();	
			end
		end
	end

	MessageBoxFrame:Hide();
end

function MessageBoxFrame_OnHide()
	isOnclik = false;
	MessageBoxFrame:SetClientUserData(0, 0);
	MessageBoxFrame:SetClientUserData(1, 0);
	MessageBoxFrame:SetClientUserData(2, 0);
end

function MessageBoxFrameRightBtn_OnClick()
	if MessageBoxFrame:GetClientString() == "删除地图" then
	end
	MessageBoxFrame:Hide();
end

function MessageBoxFrameCenterBtn_OnClick()
	if MessageBoxFrame:GetClientString() == "创建地图上限" then
		MessageBoxFrame:Hide();
	end
end