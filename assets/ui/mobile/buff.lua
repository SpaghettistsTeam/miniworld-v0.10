
BUFF_MAX_NUM = 20;
function BuffFrame_OnLoad()
	this:setUpdateTime(0.05);
	for i=1, BUFF_MAX_NUM do
		local buff = getglobal("BuffFrameInfoBuff"..i);
		buff:SetPoint("topleft", "BuffFrameInfoPlane", "topleft", 0, (i-1)*70);
	end
end

function BuffFrameCloseBtn_OnClick()
	BuffFrame:Hide();
end

function BuffFrame_OnShow()
	HideAllFrame("BuffFrame");
end

function BuffFrame_OnHide()
	BuffFrameInfo:resetOffsetPos();
end

function BuffFrame_OnUpdate()
	local num = MainPlayerAttrib:getBuffNum();

	if num <= 5 then
		BuffFrameInfoPlane:SetSize(850, 325);
	else
		BuffFrameInfoPlane:SetSize(850, 325+(num-5)*70);
	end

	for i=1, BUFF_MAX_NUM do
		local frame = getglobal("BuffFrameInfoBuff"..i);
		if i <= num then
			frame:Show();
			local icon 		= getglobal("BuffFrameInfoBuff"..i.."Icon");
			local desc 		= getglobal("BuffFrameInfoBuff"..i.."Desc");
			local remainTime 	= getglobal("BuffFrameInfoBuff"..i.."RemainTime");

			local info = MainPlayerAttrib:getBuffInfo(i-1);

			icon:SetTexture("ui/bufficons/"..info.def.IconName..".png")
			local text = info.def.Name.."："..info.def.Desc;
			desc:SetText(text);

			local time = math.ceil( (info.def.EffectTicks - info.ticks)*0.05 );
			local timetext = math.floor(time/60)..":"..math.mod(time, 60);
			remainTime:SetText(timetext);

			if info.def.Type == 0 then			--有益
				desc:SetTextColor(125, 216, 26);
				remainTime:SetTextColor(125, 216, 26);
			elseif info.def.Type == 1 then			--不利
				desc:SetTextColor(229, 40, 1);	
				remainTime:SetTextColor(229, 40, 1);
			end
		else
			frame:Hide();
		end	
	end
end