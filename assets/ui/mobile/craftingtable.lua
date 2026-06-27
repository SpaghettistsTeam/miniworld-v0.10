NORMAL_PRODUCT_GRID_MAX = 100;			--3*3制作物列表栏
CRAFT_GRID_MAX = 10				--合成栏

function CraftingTableFrame_OnShow()
	HideAllFrame("CraftingTableFrame");
	CraftingTableFrameCommonBtn_OnClick();
	CraftingTableFrameCommonBtn:Checked();
end

function CraftingTableFrame_OnHide()
	ClearCragtingFrameAllStuffGrid();
	ClientCurGame:setOperateUI(false);
end

function CraftingTableFrameCloseBtn_OnMouseDown()
	local btnIcon = getglobal(this:GetName().."Icon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(43,43);
end

function CraftingTableFrameCloseBtn_OnMouseUp()
	local btnIcon = getglobal(this:GetName().."Icon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(55,56);
end

function CraftingTableFrameCloseBtn_OnClick()
	CraftingTableFrame:Hide();
end

function CraftingTableFrameCommonBtn_OnClick()
	ClearCragtingFrameAllStuffGrid();
	CraftingTableDisCheckAllBtn();
	local btnIcon = getglobal("CraftingTableFrameCommonBtnIcon");
	btnIcon:SetTexUV(919, 330, 50, 53);

	HideCraftingFrameAllItemBoxTexture();
	selectNormalProductId = 0;
	CraftingTableSetClientID();
	NormalProductBox:resetOffsetPos();
	CraftingFrame_UpdateAllGrid();
end

function CraftingTableFrameEquipBtn_OnClick()
	ClearCragtingFrameAllStuffGrid();
	CraftingTableDisCheckAllBtn();
	local btnIcon = getglobal("CraftingTableFrameEquipBtnIcon");
	btnIcon:SetTexUV(520, 675, 55, 55);

	HideCraftingFrameAllItemBoxTexture();
	selectNormalProductId = 0;
	CraftingTableSetClientID();
	NormalProductBox:resetOffsetPos();	
	CraftingFrame_UpdateAllGrid();
end

function CraftingTableFrameBuildBtn_OnClick()
	ClearCragtingFrameAllStuffGrid();
	CraftingTableDisCheckAllBtn();
	local btnIcon = getglobal("CraftingTableFrameBuildBtnIcon");
	btnIcon:SetTexUV(635, 673, 52, 61);

	HideCraftingFrameAllItemBoxTexture();
	selectNormalProductId = 0;
	CraftingTableSetClientID();
	NormalProductBox:resetOffsetPos();
	CraftingFrame_UpdateAllGrid();
end

function CraftingTableFrameMachineBtn_OnClick()
	ClearCragtingFrameAllStuffGrid();
	CraftingTableDisCheckAllBtn();
	local btnIcon = getglobal("CraftingTableFrameMachineBtnIcon");
	btnIcon:SetTexUV(931, 526, 63, 60);

	HideCraftingFrameAllItemBoxTexture();
	selectNormalProductId = 0;
	CraftingTableSetClientID();
	NormalProductBox:resetOffsetPos();
	CraftingFrame_UpdateAllGrid();
end

local t_craftingTableLeftBtn = {
	{ name = "CraftingTableFrameCommonBtn", x=865,y=330,w=50,h=53 },
	{ name = "CraftingTableFrameEquipBtn", x=461,y=675,w=55,h=55 },
	{ name = "CraftingTableFrameBuildBtn", x=579,y=673,w=52,h=61 },
	{ name = "CraftingTableFrameMachineBtn", x=866,y=526,w=63,h=60 },
}

function CraftingTableDisCheckAllBtn()
	for i=1, #(t_craftingTableLeftBtn) do
		local btn = getglobal(t_craftingTableLeftBtn[i].name);
		local btnIcon = getglobal(t_craftingTableLeftBtn[i].name.."Icon");
		btn:SetChecked(false);
		btnIcon:SetTexUV(t_craftingTableLeftBtn[i].x, t_craftingTableLeftBtn[i].y, t_craftingTableLeftBtn[i].w, t_craftingTableLeftBtn[i].h);
	end
end

function CraftingTableSetClientID()
	local name = this:GetName();
	local base_index = COMMON_PRODUCT_LIST_INDEX;
	if string.find(name,"Common") then
		base_index = COMMON_PRODUCT_LIST_INDEX;
	elseif string.find(name,"Equip") then
		base_index = EQUIP_PRODUCT_LIST_INDEX;
	elseif string.find(name,"Build") then
		base_index = BUILD_PRODUCT_LIST_INDEX;
	elseif string.find(name,"Machine") then
		base_index = MACHINE_PRODUCT_LIST_INDEX;
	end

	for i=1,NORMAL_PRODUCT_GRID_MAX do
		local itembtn = getglobal("NormalProductBoxItem"..i);
		itembtn:SetClientID(base_index+i);
	end
end
-------------------------------------------------CraftingFrame----------------------------------------------------------

local Making = false;
local BeginMake = false;

function CraftingFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");

	for i=1,20 do
		for j=1,5 do
			local itembtn = getglobal("NormalProductBoxItem"..((i-1)*5+j));
			itembtn:SetPoint("topleft", "NormalProductBoxPlane", "topleft", (j-1)*93, (i-1)*93);
		end
	end
end

function HideCraftingFrameAllItemBoxTexture()
	for i=1,NORMAL_PRODUCT_GRID_MAX do
		local boxTexture = getglobal("NormalProductBoxItem"..i.."ContentBoxTexture");
		boxTexture:Hide(); 
	end
end

function CraftingFrame_UpdateAllGrid(index)
	for i=1,NORMAL_PRODUCT_GRID_MAX do
		local btn 	= getglobal("NormalProductBoxItem"..i);	
		local icon 	= getglobal("NormalProductBoxItem"..i.."ContentIcon");
		local num 	= getglobal("NormalProductBoxItem"..i.."ContentCount");
		local durbar 	= getglobal("NormalProductBoxItem"..i.."ContentDuration");
		local lack	= getglobal("NormalProductBoxItem"..i.."ContentLack");
		local grid_index = btn:GetClientID() - 1;
		local id = ClientBackpack:getGridItem(grid_index);
		UpdateCratingItemIconCount(icon, num, durbar, grid_index, lack);
--[[		
		if ClientBackpack:getGridItem(grid_index) ~= 0 then
			if ClientBackpack:getGridEnough(grid_index) == 0 then
				icon:SetGray(true);
				lack:Show();
			else
				icon:SetGray(false);
				lack:Hide();
			end
		else
			lack:Hide();
		end
--]]
	end

	if Making and index == -1 then		-- index为-1的时候，表示制作要消耗的材料已经消耗了，这个时候更新面板
		local grid_index = CheckNormalProductId(selectNormalProductId)
		local enough = 0;
		if grid_index > 0 then		--制作物列表里还有这个物品
			local btnName = GetCurNormalProductIdGridName(grid_index);
			SetOnclikItemBoxTexture( btnName );
			enough = ClientBackpack:getGridEnough(grid_index);
		else				
			HideCraftingFrameAllItemBoxTexture();
			selectNormalProductId = 0;
		end
		ClientBackpack:updateCraftContainer(selectNormalProductId, CRAFT_START_INDEX, enough);

		UpdateCraftingFrameRight(grid_index);
		Making = false;
	end
end

function GetCurNormalProductIdGridName(index)
	for i=1,NORMAL_PRODUCT_GRID_MAX do
		local btn = getglobal("NormalProductBoxItem"..i);
		local grid_index = btn:GetClientID() - 1;
		if index == grid_index then
			return btn:GetName();
		end	
	end
	return "";
end

function CheckNormalProductId(productId)
	for i=1,NORMAL_PRODUCT_GRID_MAX do
		local btn = getglobal("NormalProductBoxItem"..i);
		local grid_index = btn:GetClientID() - 1;
		if ClientBackpack:getGridItem(grid_index) ~= 0 and ClientBackpack:getGridItem(grid_index) == productId then
			return grid_index;
		end	
	end
	return -1;
end

function UpdateCraftingFrameRight(grid_index)
	UpdateCraftingFrameAllStuffGrid();
	UpdateCraftingFrameTips(grid_index);
end

function ClearCragtingFrameAllStuffGrid()
	ClientBackpack:updateCraftContainer(0, CRAFT_START_INDEX, -1);
	UpdateCraftingFrameRight(-1);
end

function UpdateCraftingFrameAllStuffGrid()
	local icon 	= getglobal("CraftingTableFrameCraftingFrameMakeResultContentIcon");
	local num 	= getglobal("CraftingTableFrameCraftingFrameMakeResultContentCount");
	local durbar 	= getglobal("CraftingTableFrameCraftingFrameMakeResultContentDuration");
	local lack	= getglobal("CraftingTableFrameCraftingFrameMakeResultContentLack");
	local grid_index = CRAFT_START_INDEX + CRAFT_GRID_MAX - 1;
	local id = ClientBackpack:getGridItem(grid_index);
	UpdateCratingItemIconCount(icon, num, durbar, grid_index, lack);

	if id ~= 0 then
		if ClientBackpack:getGridEnough(grid_index) == 0 then
			CraftingTableFrameCraftingFrameMakeBtnNormal:SetGray(true);
		else
			CraftingTableFrameCraftingFrameMakeBtnNormal:SetGray(false);
		end
	end

	for i=1,CRAFT_GRID_MAX - 1 do
		icon 	= getglobal("CraftingTableFrameCraftingFrameStuffGrid"..i.."ContentIcon");
		num 	= getglobal("CraftingTableFrameCraftingFrameStuffGrid"..i.."ContentCount");
		durbar 	= getglobal("CraftingTableFrameCraftingFrameStuffGrid"..i.."ContentDuration");
		lack	= getglobal("CraftingTableFrameCraftingFrameStuffGrid"..i.."ContentLack");
		grid_index = CRAFT_START_INDEX + i - 1;
		id = ClientBackpack:getGridItem(grid_index);
			
		UpdateCratingItemIconCount(icon, num, durbar, grid_index, lack);
--[[
		if id ~= 0 then
			if ClientBackpack:getGridEnough(grid_index) == 0 then
				icon:SetGray(true);
				lack:Show();
			else
				icon:SetGray(false);
				lack:Hide();
			end
		else
			lack:Hide();
		end
]]
	end
end

function UpdateCraftingFrameTips(grid_index)
	if grid_index < 0 or ClientBackpack:getGridItem(grid_index) <= 0 then
		CraftingTableFrameCraftingFrameName:SetText("");
		CraftingTableFrameCraftingFrameItemDesc:Clear();
	else
		local name = ClientBackpack:getGridItemName(grid_index);
		local itemId 	= ClientBackpack:getGridItem(grid_index);
		local itemDef 	= DefMgr:getItemDef(itemId)
		if itemDef ~= nil then
			CraftingTableFrameCraftingFrameName:SetText(name..":");
			local pos = string.find(itemDef.Desc, "#");
			local text = itemDef.Desc;
			if pos ~= nil then		--把颜色替换掉
				local colorString = string.sub(itemDef.Desc, pos, pos+7);
				text = string.gsub(itemDef.Desc, colorString, "");
			end
			CraftingTableFrameCraftingFrameItemDesc:SetText(text, 118, 67, 0);
		end
	end
end

function CraftingFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();
	local index = ge.body.backpack.grid_index;

	if arg1 == "GE_BACKPACK_CHANGE" then
		ClientBackpack:updateProductContainer(COMMON_PRODUCT_LIST_INDEX);
		ClientBackpack:updateProductContainer(EQUIP_PRODUCT_LIST_INDEX);
		ClientBackpack:updateProductContainer(BUILD_PRODUCT_LIST_INDEX);
		ClientBackpack:updateProductContainer(MACHINE_PRODUCT_LIST_INDEX);
	
		if not CraftingTableFrameCraftingFrame:IsShown() then return; end

		local test = 1;
		CraftingFrame_UpdateAllGrid(index);		
	end
end

function CheckNormalProducIsLackItem()
	for i=1,CRAFT_GRID_MAX - 1 do
		local grid_index = CRAFT_START_INDEX + i - 1;
		if ClientBackpack:getGridEnough(grid_index) == 0 then
			local name = ClientBackpack:getGridItemName(grid_index)
			return true,name;
		end	
	end
	return false,"";
end

local CraftingTime = 0
local IsMakeLongPress = false;	--标记制作按钮为长按按钮状态
function CraftingFrameMakeBtn_MouseDownUpdate()
	if arg1-CraftingTime > 0.5 then
		CraftingTime = arg1;
		IsMakeLongPress = true;
		CraftingFrameMakeFunc();		
	end
end

function CraftingFrameMakeBtn_OnClick()
	CraftingTime = 0;
	if IsMakeLongPress then
		IsMakeLongPress = false;
		return;
	end
	CraftingFrameMakeFunc();
end

function CraftingFrameMakeFunc()
	if Making then return; end

	Making = true;
	local grid_index = CheckNormalProductId(selectNormalProductId);
	if grid_index < 0 then
	--	UpdateTipsFrame("请选择要制作的物品！", 0);
		ShowGameTips(DefMgr:getStringDef(35), 3);
		Making = false;
		return;
	end

	local result_index = CraftingTableFrameCraftingFrameMakeResult:GetClientID() - 1;
	if ClientBackpack:getGridItem(grid_index) > 0 then
		local isLack,itemName = CheckNormalProducIsLackItem();
		if isLack then
			local text = DefMgr:getStringDef(61)..itemName;
			ShowGameTips(text, 2);
			Making = false
			ClientMgr:playSound2D("sounds/ui/info/crafting_error.ogg", 500);
		else	
			ClientBackpack:doCrafting2Mobile(result_index,CRAFT_START_INDEX)				
			itemName = ClientBackpack:getGridItemName(result_index);
			itemNum = ClientBackpack:getGridNum(result_index);
			local text = DefMgr:getStringDef(62)..itemName.."×"..itemNum;
			ShowGameTips(text, 1);

			ClientMgr:playSound2D("sounds/ui/info/crafting_success.ogg", 500);
		end
	end
end
