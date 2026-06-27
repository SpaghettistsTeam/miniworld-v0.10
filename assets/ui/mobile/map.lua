
function MapFrame_OnLoad()
	this:setUpdateTime(0.05);
	this:RegisterEvent("GIE_MINIMAP_CHANGE");
end

function MapFrame_OnEvent()
	if arg1 == "GIE_MINIMAP_CHANGE" then
		if MapFrame:IsShown() then
			local ge = GameEventQue:getCurEvent();
			local mapData = ge.body.minimap;
			UpdateMapIcon(mapData);
		end
	end
end

function MapFrame_OnShow()
	local model 	= AccountManager:getRoleModel();
	local roleIcon 	= getglobal("MapFrameRoleIcon");
	roleIcon:SetTexture("ui/roleicons/"..model..".png");
end


local changeSpeed = 2;
local changeOffset = changeSpeed
local curOffset = 0;
function MapFrame_OnUpdate()
--[[
	curOffset = curOffset + changeOffset;
	if curOffset > 15 then
		curOffset = 15;
		changeOffset = -changeSpeed*0.5;
	elseif curOffset <= 0 then
		curOffset = 0;
		changeOffset = changeSpeed;
	end

	MapFrameRoleArrow:SetPoint("bottom", "MapFrameRoleBkg", "top", 0, -17+curOffset);
]]

	if MapFrameDeathUv:IsShown() then
		local size = MapFrameDeathUv:GetWidth();
		size = size - 5;
		if size <= 0 then
			size = 113;
		end
		MapFrameDeathUv:SetSize(size, size);
	end

end

function UpdateMapIcon(mapData)
	local roleBkg  	= getglobal("MapFrameRoleBkg");
	local boss 		= getglobal("MapFrameBoss");
	local birthplace	= getglobal("MapFrameBirthplace");
	local deathplace	= getglobal("MapFrameDeathplace");
	local deathUv		= getglobal("MapFrameDeathUv");
	local time 		= getglobal("MapFrameTime");
	local coord		= getglobal("MapFrameCoord");
	local height		= getglobal("MapFrameHeight");


	roleBkg:SetPoint("topleft", "$parent", "topleft", mapData.posx, mapData.posy);
	if mapData.bossx < 0 then
		boss:Hide();
	else
		boss:Show();
		boss:SetPoint("topleft", "$parent", "topleft", mapData.bossx, mapData.bossy);
	end
	
	birthplace:SetPoint("topleft", "$parent", "topleft", mapData.spawnx, mapData.spawny);

	if mapData.deadx < 0 then
		deathplace:Hide();
		deathUv:Hide();
	else
		deathplace:Show();
		deathplace:SetPoint("topleft", "$parent", "topleft", mapData.deadx, mapData.deady);
		deathUv:Show();
	end

	local hour = ClientCurGame:getGameTimeHour();
	time:SetText(hour..":"..ClientCurGame:getGameTimeMinute());

	local text = "("..CurMainPlayer:getBlockX().."，"..CurMainPlayer:getBlockZ()..")";
	coord:SetText(text);
	height:SetText(CurMainPlayer:getBlockY());
end

function MapFrameBackBtn_OnClick()
	ClientCurGame:enableMinimap(false);
	MapFrame:Hide();
	for i=1, #(t_UIName) do
		local frame = getglobal(t_UIName[i]);
		frame:Show();
	end
	CurMainPlayer:setUIHide(false);
end