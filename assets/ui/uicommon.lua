
VK_LBUTTON = 0x01
VK_RBUTTON = 0x02


function UpdateItemIconCount(iconbtn, numtext, durbar, grid_index)
	local itemid = ClientBackpack:getGridItem(grid_index);
	if itemid == 0 then
		iconbtn:SetTextureHuires(ClientMgr:getNullItemIcon());
		numtext:SetText("");
		durbar:Hide();
		return;
	end

	local u = 0;
	local v = 0;
	local width = 0;
	local height = 0;
	local r = 255;
	local g = 255;
	local b = 255;
	h, u, v, width, height, r, g, b = ClientMgr:getItemIcon(itemid, u, v, width, height, r, g, b);
	iconbtn:SetTextureHuires(h);
	iconbtn:SetTexUV(u, v, width, height);
	iconbtn:SetColor(r, g, b);

	count = ClientBackpack:getGridNum(grid_index);
	if count > 1 then
		numtext:SetText(count);
	else
		numtext:SetText("");
	end

	maxdur = ClientBackpack:getGridMaxDuration(grid_index);
	if maxdur > 0 then
		dur = ClientBackpack:getGridDuration(grid_index)
		if dur < 0 then dur = 0 end
		dur = dur/maxdur

		durbar:SetTexUV(143, 698, dur*60, 9)
		durbar:SetWidth(79*dur)

		if dur > 0.8 then durbar:SetColor(0, 255, 0) --绿色
		elseif dur > 0.6 then durbar:SetColor(0, 128, 0) --深绿色
		elseif dur > 0.4 then durbar:SetColor(128, 128, 0) --棕色
		elseif dur > 0.2 then durbar:SetColor(255, 255, 0) --橙色
		else durbar:SetColor(255, 0, 0) end --红色

		if dur == 1.0 then durbar:Hide()
		else durbar:Show() end
	else
		durbar:Hide()
	end
	
end

-- @Desc:设置滚动条的位置
-- @param: szScrollBarName	为要设置的滚动条
-- @param: nMaxViewLine		为要一页所能显示的最大行数
-- @param: nValidDataNum	为当前要显示的数据行数
function SetScrollBar( szScrollBarName, nMaxViewLine, nValidDataNum )
	local slider		= getglobal( szScrollBarName );
	local nNum			= nValidDataNum - nMaxViewLine;
	if nNum > 0  then
		slider:SetMaxValue( nNum );
		slider:Show();
	else
		slider:SetMaxValue( 1 );
		slider:Hide();
	end

	slider:SetMinValue( 0 );
	slider:SetValueStep( 1 );
	if slider:GetValue() > slider:GetMaxValue() then
		slider:SetValue( slider:GetMaxValue() );
	end

end
