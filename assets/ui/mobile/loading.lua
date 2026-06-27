
function LoadingFrame_OnLoad()
	this:RegisterEvent("GE_LOAD_PROGRESS");
	this:RegisterEvent("GE_LOAD_COMPLETE");
end

function LoadingFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();

	if this:IsShown() then
		if arg1 == "GE_LOAD_PROGRESS" then
			local value = ge.body.loadprogress.progress/100;
			local offsetX = value * 1100;
			LoadProgressBarSmoke:SetPoint("bottomright","LoadProgressBar","bottomleft", offsetX, 0);
			LoadProgressBarZombie:SetPoint("bottomleft","LoadProgressBarSmoke","bottomright", -60, 0);
			LoadProgressBarChicken:SetPoint("bottomleft","LoadProgressBarZombie","bottomright", 0, 0);
		end
		if arg1 == "GE_LOAD_COMPLETE" then	
		end
	end
end

function LoadingFrame_OnShow()
	ClientMgr:stopMusic();
	LoadProgressBarSmoke:SetUVAnimation(120, true);
	LoadProgressBarZombie:SetUVAnimation(100, true);
	LoadProgressBarChicken:SetUVAnimation(120, true);
	LoadProgressBarSmoke:Show();
	LoadProgressBarZombie:Show();
	LoadProgressBarChicken:Show();
end


--------------------------------------------------------LoadLoopFrame--------------------------------------------------
function LoadLoopFrame_OnLoad()
	this:setUpdateTime(0.05);
end

function LoadLoopFrame_OnUpdate()
	local angle = LoadLoopFrameTex:GetAngle();
	angle = angle + 10;

	if angle > 360 then
		angle = 0;
	end

	LoadLoopFrameTex:SetAngle(angle);
end