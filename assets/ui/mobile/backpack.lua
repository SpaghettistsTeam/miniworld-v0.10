BACK_PACK_GRID_MAX = 40;		--背包栏
EQUIP_GRID_MAX = 5;			--装备栏
BACK_PACK_GRID_EQUIP_MAX = 40;		--装备面板的背包栏
MINI_PRODUCT_GRID_MAX = 100;		--简易制作物列表栏
MINICRAFT_GRID_MAX = 5;			--简易合成栏

function BackpackFrame_OnShow()
	HideAllFrame("BackpackFrame");
	BackpackFramePackBtn_OnClick();
	BackpackFramePackBtn:Checked();
end

function BackpackFrameCloseBtn_OnMouseDown()
	local btnIcon = getglobal("BackpackFrameCloseBtnIcon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(51,51);
end

function BackpackFrameCloseBtn_OnMouseUp()
	local btnIcon = getglobal("BackpackFrameCloseBtnIcon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(66,67);
end

function BackpackFrameCloseBtn_OnClick()		
	HidePackFrameAllItemBoxTexture();
	HideMakeFrameAllItemBoxTexture();
	selectBackpackGrid = -1;
	BackpackFrame:Hide();
end

function BackpackFrame_OnHide()
	MakeFrame_OnHide();
	RoleFrame_OnHide();
	PackFrame_OnHide();
	ClientCurGame:setOperateUI(false);
end

function BackpackFramePackBtn_OnClick()
	BackPackDisCheckAllBtn();
	local name = this:GetName();
	local btnIcon = getglobal("BackpackFramePackBtnIcon");
	btnIcon:SetTexUV(800, 261, 50, 57);

	BackpackFrameRoleFrame:Hide();
	BackpackFrameMakeFrame:Hide();
	BackpackFramePackFrame:Show();		
end

function BackpackFrameMakeBtn_OnClick()
	BackPackDisCheckAllBtn();
	local btnIcon = getglobal("BackpackFrameMakeBtnIcon");
	btnIcon:SetTexUV(912, 264, 50, 57);

	BackpackFrameRoleFrame:Hide();
	BackpackFramePackFrame:Hide();
	BackpackFrameMakeFrame:Show();
end

function BackpackFrameRoleBtn_OnClick()
	BackPackDisCheckAllBtn();
	local btnIcon = getglobal("BackpackFrameRoleBtnIcon");
	btnIcon:SetTexUV(802, 322, 55, 61);

	BackpackFramePackFrame:Hide();
	BackpackFrameMakeFrame:Hide();
	BackpackFrameRoleFrame:Show();
end

local t_backPackLeftBtn = {
	{ name = "BackpackFramePackBtn", x=738,y=261,w=50,h=57 },
	{ name = "BackpackFrameMakeBtn", x=859,y=264,w=50,h=57 },
	{ name = "BackpackFrameRoleBtn", x=735,y=323,w=55,h=61 },
}

function BackPackDisCheckAllBtn()
	for i=1, #(t_backPackLeftBtn) do
		local btn = getglobal(t_backPackLeftBtn[i].name);
		local btnIcon = getglobal(t_backPackLeftBtn[i].name.."Icon");
		btn:SetChecked(false);
		btnIcon:SetTexUV(t_backPackLeftBtn[i].x, t_backPackLeftBtn[i].y, t_backPackLeftBtn[i].w, t_backPackLeftBtn[i].h);
	end
end

-------------------------------------------------------PackFrame----------------------------------------------------------------------------
function PackFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");
	for i=1,BACK_PACK_GRID_MAX/10 do
		for j=1,10 do
			local n 	= (i-1)*10+j;
			local itembtn 	= getglobal("BackpackFramePackFrameItem"..n);
			itembtn:SetPoint("topleft", "BackpackFramePackFrame", "topleft", (j-1)*106+41, (i-1)*106+44);
			if n > 30 then
				local bkg = getglobal("BackpackFramePackFrameItem"..n.."BkgTexture");
				bkg:SetBlendAlpha(0.75);
			end
		end
	end
end

function PackFrame_OnShow()
	if ShortCut_SelectedIndex >= 0 then		--打开背包时，把选中的快捷栏工具隐藏
		local selbox = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentBoxTexture1");
		selbox:Hide()
		local uv = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentUVAnimationTex")
		uv:Hide();
	end
end

function PackFrameTidyBtn_OnClick()
	ClientBackpack:mergePack(BACKPACK_START_INDEX);
	ClientBackpack:sortPack(BACKPACK_START_INDEX);
	PackFrame_UpdateAllGrids();
end

function PackFrame_UpdateOneGrid(grid_index)
	ClientBackpack:getGridItem(grid_index);
	local n = grid_index+1;
	if grid_index >= BACKPACK_START_INDEX then
		n = n - BACKPACK_START_INDEX
	end

	if n <= 30 then
		local icon = getglobal("BackpackFramePackFrameItem"..n.."ContentIcon");
		local num = getglobal("BackpackFramePackFrameItem"..n.."ContentCount");
		local durbar = getglobal("BackpackFramePackFrameItem"..n.."ContentDuration");	

		UpdateItemIconCount(icon, num, durbar, grid_index);
	end
end

function PackFrame_UpdateAllGrids()
	for i=1, BACK_PACK_GRID_MAX do
		PackFrame_UpdateOneGrid(BACKPACK_START_INDEX+i-1)
	end
end

function PackFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();

	if arg1 == "GE_BACKPACK_CHANGE" then
		local grid_index = ge.body.backpack.grid_index;
		if grid_index >= BACKPACK_START_INDEX and grid_index < BACKPACK_START_INDEX+1000 then
			PackFrame_UpdateOneGrid(grid_index);
		elseif grid_index < 0 then
			PackFrame_UpdateAllGrids();
		end
	end
end

function HidePackFrameAllItemBoxTexture()
	for i=1,BACK_PACK_GRID_MAX do
		local boxTexture = getglobal("BackpackFramePackFrameItem"..i.."ContentBoxTexture");
		boxTexture:Hide(); 
	end
end

function PackFrame_OnHide()
	HidePackFrameAllItemBoxTexture();
	HideShortCutAllItemBoxTexture();
	selectBackpackGrid = -1;
	
	if ShortCut_SelectedIndex >= 0 then		--关闭背包时，把选中的快捷栏工具显示
		CurMainPlayer:setCurShortcut(ShortCut_SelectedIndex);		
		local selbox = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentBoxTexture1");
		selbox:Show()
--		local uv = getglobal("ToolShortcut"..(ShortCut_SelectedIndex+1).."ContentUVAnimationTex")
--		uv:SetUVAnimation(80, true);
--		uv:Show();
	end
end

function GetPackFrameFristNullGridIndex()	
	for i=1,MAX_SHORTCUT do
		local grid_index = i + SHORTCUT_START_INDEX - 1;
		local itemid = ClientBackpack:getGridItem(grid_index);
		if itemid == 0 then
			return grid_index;
		end
	end
	for i=1,BACK_PACK_GRID_MAX do
		local grid_index = i + BACKPACK_START_INDEX - 1;
		local itemid = ClientBackpack:getGridItem(grid_index);
		if itemid == 0 and i <= 30 then
			return grid_index;
		end
	end
	return -1;
end
-------------------------------------------------------RoleFrame----------------------------------------------------------------------------------
EquipViewCurActor = nil

function RoleFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");

	for i=1,5 do
		local equipGrid = getglobal("BackpackFrameRoleFrameEquipGrid" .. i);
		equipGrid:SetPoint("topleft", "BackpackFrameRoleFrame", "topleft", (i-1)*106+55, 48);
	end

	for i=1,8 do
		for j=1,5 do
			local equipItem = getglobal("EquipBoxItem"..((i-1)*5+j));
			equipItem:SetPoint("topleft", "EquipBoxPlane", "topleft", (j-1)*106, (i-1)*106);	
		end
	end
end

function RoleFrame_OnShow()
	local player = ClientCurGame:getMainPlayer();

	if EquipViewCurActor ~= player then
		local modelView = getglobal("BackpackFrameRoleFrameEquipActorView");
		EquipViewCurActor = player
		player:attachUIModelView(modelView);
		local name = AccountManager:getNickName();
		BackpackFrameRoleFramePlayerNick:SetText(name);
	end

	EquipBox:resetOffsetPos();
	InitEquipAllGrid();
	ClearRoleFrameAllItem();
	RoleFrame_UpdateAllGrids();
end

function ClearRoleFrameAllItem()
	for i=1,BACK_PACK_GRID_EQUIP_MAX do
		local equipItem = getglobal("EquipBoxItem" .. i);
		local icon = getglobal("EquipBoxItem"..i.."ContentIcon");
		local num = getglobal("EquipBoxItem"..i.."ContentCount");
		icon:SetTextureHuires(ClientMgr:getNullItemIcon());
		num:SetText("");
		equipItem:SetClientID(0)
	end
end

function ClearRoleFrameOneItem(btnIndex)
	local equipItem = getglobal("EquipBoxItem" .. btnIndex);
	local icon = getglobal("EquipBoxItem"..btnIndex.."ContentIcon");
	local num = getglobal("EquipBoxItem"..btnIndex.."ContentCount");
	icon:SetTextureHuires(ClientMgr:getNullItemIcon());
	num:SetText("");
	equipItem:SetClientID(0)
end

function RoleFrame_OnHide()
	if EquipViewCurActor ~= nil then
		EquipViewCurActor:detachUIModelView();
		EquipViewCurActor = nil;
	end
end

--初始化所有装备栏
function InitEquipAllGrid()
	for i=1, 5 do
		local grid_index = EQUIP_START_INDEX + i - 1;
		local iconbtn = getglobal("BackpackFrameRoleFrameEquipGrid"..i.."ContentIcon");
		local numtext = getglobal("BackpackFrameRoleFrameEquipGrid"..i.."ContentCount");
		local durbar = getglobal("BackpackFrameRoleFrameEquipGrid"..i.."ContentDuration");

		UpdateItemIconCount(iconbtn, numtext, durbar, grid_index);	
	end
end

--更新一个装备栏
function RoleFrameEquip_UpdateOneGrid(grid_index)
	local n = grid_index + 1 - EQUIP_START_INDEX;
	local name = "BackpackFrameRoleFrameEquipGrid"..n;
	local iconbtn = getglobal(name.."ContentIcon");

	local numtext = getglobal(name.."ContentCount");
	local durbar = getglobal(name.."ContentDuration");
	
	UpdateItemIconCount(iconbtn, numtext, durbar, grid_index);
end

function GetRoleFrameItemIndex(grid_index)
	local id = grid_index - BACKPACK_START_INDEX + 1;
	for i=1,BACK_PACK_GRID_EQUIP_MAX do									-- 物品替换，替换后的物品放在原来的格子上
		local equipItem = getglobal("EquipBoxItem" .. i);
		if equipItem:GetClientID() == id then
			return true,i;
		end
	end
	for i=1,BACK_PACK_GRID_EQUIP_MAX do									-- 找一个空的格子放这个物品
		local equipItem = getglobal("EquipBoxItem" .. i);
		if equipItem:GetClientID() < 1 then
			return false,i;
		end
	end
	return false,-1;
end

function RoleFrame_UpdateOneGrid(grid_index)
	local isExsit,n = GetRoleFrameItemIndex(grid_index);
	if n < 1 then return end

	local id = grid_index - BACKPACK_START_INDEX +1;

	local btn = getglobal("EquipBoxItem"..n);

	local icon = getglobal("EquipBoxItem"..n.."ContentIcon");
	local num = getglobal("EquipBoxItem"..n.."ContentCount");
	local durbar = getglobal("EquipBoxItem"..n.."ContentDuration");

	if not IsEquip(grid_index) then
		if isExsit then
			icon:SetTextureHuires(ClientMgr:getNullItemIcon());
			num:SetText("");
			btn:SetClientID(0);
			durbar:Hide();
			return;
		else
			return;
		end
	end

	btn:SetClientID(id);						--标识这个装备在背包栏中的Index;
	UpdateItemIconCount(icon, num, durbar, grid_index);
end

--从背包物品栏中筛选出所有的装备更新到装备面板的物品栏中
function RoleFrame_UpdateAllGrids()
	for i=1,BACK_PACK_GRID_MAX do
		local grid_index = i + BACKPACK_START_INDEX - 1;
		if IsEquip(grid_index) then
			RoleFrame_UpdateOneGrid(grid_index);		
		end
	end

	for i=1,MAX_SHORTCUT do
		local grid_index = i + SHORTCUT_START_INDEX - 1;
		if IsEquip(grid_index) then
			RoleFrame_UpdateOneGrid(grid_index);		
		end
	end
end

function RoleFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();

	if arg1 == "GE_BACKPACK_CHANGE" then
		local grid_index = ge.body.backpack.grid_index;

		if grid_index>=BACKPACK_START_INDEX and grid_index<BACKPACK_START_INDEX+1006 then
			RoleFrame_UpdateOneGrid(grid_index)
		end

		if grid_index >= EQUIP_START_INDEX and grid_index<EQUIP_START_INDEX+1000 then		--更新装备栏
			RoleFrameEquip_UpdateOneGrid(grid_index);
		end
	end
end

--[[
ROTATE_ACTOR_SPEED = 180.0
function RoleFrameLeftBtn_OnMouseDown()
	local modelView = getglobal("BackpackFrameRoleFrameEquipActorView");
	modelView:setRotateSpeed(ROTATE_ACTOR_SPEED);
end

function RoleFrameLeftBtn_OnMouseUp()
	local modelView = getglobal("BackpackFrameRoleFrameEquipActorView");
	modelView:setRotateSpeed(0);
end

function RoleFrameRightBtn_OnMouseDown()
	local modelView = getglobal("BackpackFrameRoleFrameEquipActorView");
	modelView:setRotateSpeed(-ROTATE_ACTOR_SPEED);
end

function RoleFrameRightBtn_OnMouseUp()
	local modelView = getglobal("BackpackFrameRoleFrameEquipActorView");
	modelView:setRotateSpeed(0);
end
--]]
-----------------------------------------------------------MakeFrame--------------------------------------------------------------------------------
local Making = false;
local IsMakeLongPress = false;	--标记制作按钮为长按按钮状态
function MakeFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");

	for i=1,20 do
		for j=1,5 do
			local item = getglobal("MiniProductBoxItem"..((i-1)*5+j));
			item:SetPoint("topleft", "MiniProductBoxPlane", "topleft", (j-1)*106, (i-1)*106);	
		end
	end
end

function MakeFrame_OnShow()
	selectProductId = 0
	MakeFrame_UpdateAllGrid();
end


function MakeFrame_UpdateAllGrid(index)
	for i=1,MINI_PRODUCT_GRID_MAX do	
		local icon 	= getglobal("MiniProductBoxItem"..i.."ContentIcon");
		local num 	= getglobal("MiniProductBoxItem"..i.."ContentCount");
		local durbar 	= getglobal("MiniProductBoxItem"..i.."ContentDuration");
		local lack 	= getglobal("MiniProductBoxItem"..i.."ContentLack");
		local grid_index = i + PRODUCT_LIST_TWO_INDEX - 1;
		local id = ClientBackpack:getGridItem(grid_index);
		UpdateCratingItemIconCount(icon, num, durbar, grid_index, lack);

	end
	if Making and index == -1 then		-- index为-1的时候，表示制作要消耗的材料已经消耗了，这个时候更新面板
		local grid_index = CheckProductId(selectProductId)
		local enough = 0;
		if grid_index > 0 then		--制作物列表里还有这个物品
			local btnName = GetCurProductIdGridName(grid_index);
			SetOnclikItemBoxTexture( btnName );
			enough = ClientBackpack:getGridEnough(grid_index);
		else				
			HideMakeFrameAllItemBoxTexture();
			selectProductId = 0;
		end
		ClientBackpack:updateCraftContainer(selectProductId, MINICRAFT_START_INDEX, enough);

		UpdateMakeFrameRight(grid_index);
		Making = false;
	end
end

function GetCurProductIdGridName(index)
	for i=1,MINI_PRODUCT_GRID_MAX do
		local grid_index = PRODUCT_LIST_TWO_INDEX + i - 1;
		if index == grid_index then
			local btn = getglobal("MiniProductBoxItem"..i);
			return btn:GetName();
		end	
	end
	return "";
end

function CheckProductId(productId)
	for i=1,MINI_PRODUCT_GRID_MAX do
		local grid_index = PRODUCT_LIST_TWO_INDEX + i - 1;
		if ClientBackpack:getGridItem(grid_index) ~= 0 and ClientBackpack:getGridItem(grid_index) == productId then
			return grid_index;
		end	
	end
	return -1;
end

function MakeFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();
	local index = ge.body.backpack.grid_index;

	if arg1 == "GE_BACKPACK_CHANGE" then
		ClientBackpack:updateProductContainer(PRODUCT_LIST_TWO_INDEX);	
		if not BackpackFrameMakeFrame:IsShown() then return; end

		MakeFrame_UpdateAllGrid(index);		
	end
end

function HideMakeFrameAllItemBoxTexture()
	for i=1,MINI_PRODUCT_GRID_MAX do
		local boxTexture = getglobal("MiniProductBoxItem"..i.."ContentBoxTexture");
		boxTexture:Hide(); 
	end
end

function UpdateMakeFrameAllStuffGrid()
	local icon 	= getglobal("BackpackFrameMakeFrameMakeResultContentIcon");
	local num 	= getglobal("BackpackFrameMakeFrameMakeResultContentCount");
	local durbar 	= getglobal("BackpackFrameMakeFrameMakeResultContentDuration");
	local lack 	= getglobal("BackpackFrameMakeFrameMakeResultContentLack");
	local grid_index = MINICRAFT_START_INDEX + MINICRAFT_GRID_MAX - 1;
	local id = ClientBackpack:getGridItem(grid_index);
	UpdateCratingItemIconCount(icon, num, durbar, grid_index, lack);

	if id ~= 0 then
		if ClientBackpack:getGridEnough(grid_index) == 0 then
			BackpackFrameMakeFrameMakeBtnNormal:SetGray(true);
		else
			BackpackFrameMakeFrameMakeBtnNormal:SetGray(false);
		end
	end

	for i=1,MINICRAFT_GRID_MAX - 1 do
		icon 	= getglobal("BackpackFrameMakeFrameStuffGrid"..i.."ContentIcon");
		num 	= getglobal("BackpackFrameMakeFrameStuffGrid"..i.."ContentCount");
		durbar 	= getglobal("BackpackFrameMakeFrameStuffGrid"..i.."ContentDuration");
		lack	= getglobal("BackpackFrameMakeFrameStuffGrid"..i.."ContentLack");
		grid_index = MINICRAFT_START_INDEX + i - 1;
		id = ClientBackpack:getGridItem(grid_index);			
		UpdateCratingItemIconCount(icon, num, durbar, grid_index, lack);
	end	
end

function UpdateProductTips(grid_index)	
	if grid_index < 0 or ClientBackpack:getGridItem(grid_index) <= 0 then
		BackpackFrameMakeFrameName:SetText("");
		BackpackFrameMakeFrameItemDesc:Clear();
	else
		local name 	= ClientBackpack:getGridItemName(grid_index);
		local itemId 	= ClientBackpack:getGridItem(grid_index);
		local itemDef 	= DefMgr:getItemDef(itemId)
		if itemDef ~= nil then
			BackpackFrameMakeFrameName:SetText(name..":");
			BackpackFrameMakeFrameItemDesc:SetText(itemDef.Desc, 118, 67, 0);
		end
	end	
end

function UpdateMakeFrameRight(grid_index)
	UpdateMakeFrameAllStuffGrid();
	UpdateProductTips(grid_index);
end

function MakeFrame_OnHide()
	HideMakeFrameAllItemBoxTexture();
	ClientBackpack:updateCraftContainer(0, MINICRAFT_START_INDEX, 1);		--关闭的时候传ID为零，清除craftContainer里的内容
	UpdateMakeFrameAllStuffGrid();
	BackpackFrameMakeFrameName:SetText("");
	BackpackFrameMakeFrameItemDesc:Clear();
end

function CheckIsLackItem()
	for i=1,MINICRAFT_GRID_MAX - 1 do
		local grid_index = MINICRAFT_START_INDEX + i - 1;
		if ClientBackpack:getGridEnough(grid_index) == 0 then
			local name = ClientBackpack:getGridItemName(grid_index)
			return true,name;
		end	
	end
	return false,"";
end

local frontTime = 0;
function PackFrameMakeBtn_OnMouseDownUpdate()		
	if arg1 - frontTime > 0.5 then  	--长按0.4秒制作一次
		frontTime = arg1;
		IsMakeLongPress = true;
		MakeProduct();
	end
end

function PackFrameMakeBtn_OnClick()
	frontTime = 0;
	if IsMakeLongPress then
		IsMakeLongPress = false;
		return;
	end
	MakeProduct()
end

function MakeProduct()
	if Makeing then return; end

	Making = true;
	local grid_index = CheckProductId(selectProductId);
	if grid_index < 0 then
	--	UpdateTipsFrame("请选择要制作的物品！", 0);
		ShowGameTips(DefMgr:getStringDef(35), 3);
		Making = false;
		return;
	end

	local result_index = BackpackFrameMakeFrameMakeResult:GetClientID() - 1;
	if ClientBackpack:getGridItem(grid_index) > 0 then
		local isLock,itemName = CheckIsLackItem();
		if isLock then
			local text = DefMgr:getStringDef(61)..itemName;
			ShowGameTips(text, 2);
			Making = false;
			ClientMgr:playSound2D("sounds/ui/info/crafting_error.ogg", 500);
		else	
			ClientBackpack:doCrafting2Mobile(result_index,MINICRAFT_START_INDEX)				
			itemName = ClientBackpack:getGridItemName(result_index);
			itemNum = ClientBackpack:getGridNum(result_index);
			local text = DefMgr:getStringDef(62)..itemName.."×"..itemNum;
			ShowGameTips(text, 1);

			ClientMgr:playSound2D("sounds/ui/info/crafting_success.ogg", 500);				
		end
	end
end

--------------------------------------------------------------------创造模式背包---------------------------------------------------------------------------------------------
local CREATE_BACKPACK_MAX = 120;
local CurSelectCreateType = 1;		--当前选择的创造模式的背包类型，
local t_createBackpackLabelInfo = {
					{ name="CreateBackpackFrameCommonBtn", normalState={x=768, y=450, h=55, w=60}, pushState={x=825, y=450, h=55, w=60}, },
					{ name="CreateBackpackFrameCropBtn", normalState={x=733, y=525, h=62, w=60}, pushState={x=801, y=525, h=62, w=60}, },
					{ name="CreateBackpackFrameMachineBtn", normalState={x=825, y=754, h=52, w=61}, pushState={x=879, y=754, h=52, w=61}, },
					{ name="CreateBackpackFrameMineralBtn", normalState={x=285, y=0, h=55, w=59}, pushState={x=348, y=0, h=55, w=59}, },
				}

function CreateBackpackFrame_OnLoad()
	for i=1, CREATE_BACKPACK_MAX/10 do
		for j=1, 10 do  
			local createItem = getglobal("CreateBoxItem"..((i-1)*10+j));
			createItem:SetPoint("topleft", "CreateBoxPlane", "topleft", (j-1)*106, (i-1)*106);
		end
	end
end

function CreateBackpackFrame_OnShow()
	CreateBackpackFrameCropBtn_OnClick();
	CreateBackpackFrameCropBtn:Checked();
	UpdateCreateItem();
end

function GetItemDefTable2CreateType()
	local t_itemDef = {};
	local n = DefMgr:getItemNum();

	for i=1, n do
		local itemDef = DefMgr:getItemDef(i-1);
		if itemDef ~= nil and itemDef.CreateType == CurSelectCreateType then 
			table.insert(t_itemDef, itemDef);
		end
	end

	if #(t_itemDef) > 1 then
		table.sort(t_itemDef,
			 function(a,b)
				if a.SortId == b.SortId then
					return a.ID < b.ID;
				else
			 		return a.SortId < b.SortId 
				end
			 end
			);
	end

	return t_itemDef;
end

function UpdateCreateItem()
	local t_itemDef = GetItemDefTable2CreateType();
	for i=1, CREATE_BACKPACK_MAX do
		local createItem = getglobal("CreateBoxItem"..i);
		if i <= #(t_itemDef) then
			createItem:Show();
			local itemIcon 	= getglobal("CreateBoxItem"..i.."ContentIcon");
			local u = 0;
			local v = 0;
			local width = 0;
			local height = 0;
			local r = 255;
			local g = 255;
			local b = 255;
			h, u, v, width, height, r, g, b = ClientMgr:getItemIcon(t_itemDef[i].ID, u, v, width, height, r, g, b);
			itemIcon:SetTextureHuires(h);
			itemIcon:SetTexUV(u, v, width, height);
			itemIcon:SetColor(r, g, b);
			createItem:SetClientID(t_itemDef[i].ID);			--记录下物品的ID
		else			
			createItem:Hide();
		end
	end

	local n = math.ceil(#(t_itemDef) / 10);
	CreateBoxPlane:SetSize(1079, n*106);

	if n > 4 then 
		CreateBox:SetSize(1076, 490);
		CreateBox:setSlidingY(true);
	else
		CreateBox:SetSize(1076, n*106);
		CreateBox:setSlidingY(false);
	end
end

function UpdateCreateBackpackLabelBtnState(btnName)
	CreateBox:resetOffsetPos();
	for i=1, #(t_createBackpackLabelInfo) do
		local info = t_createBackpackLabelInfo[i];
		local btn = getglobal(info.name);
		local btnIcon = getglobal(info.name.."Icon");		
		if info.name == btnName then
			btn:Disable();
			btnIcon:SetTexUV(info.pushState.x, info.pushState.y, info.pushState.h, info.pushState.w);
		else
			btn:Enable();
			btn:SetChecked(false);
			btnIcon:SetTexUV(info.normalState.x, info.normalState.y, info.normalState.h, info.normalState.w);
		end
	end
end

function HideCreateBoxItemBoxTexture()
	for i=1, CREATE_BACKPACK_MAX do 
		local boxTexture = getglobal("CreateBoxItem"..i.."ContentBoxTexture");
		boxTexture:Hide();
	end
	selectCreateItemId = -1;
end

function CreateBackpackFrame_OnHide()
end

function CreateBackpackFrameCloseBtn_OnMouseDown()
	local btnIcon = getglobal("CreateBackpackFrameCloseBtnIcon");
	btnIcon:SetTexUV(396,226,33,33);
	btnIcon:SetSize(51,51);
end

function CreateBackpackFrameCloseBtn_OnClick()
	local btnIcon = getglobal("CreateBackpackFrameCloseBtnIcon");
	btnIcon:SetTexUV(351,222,42,43);
	btnIcon:SetSize(66,67);	
	CreateBackpackFrame:Hide();
end

function CreateBackpackFrameCropBtn_OnClick()
	HideCreateBoxItemBoxTexture();
	UpdateCreateBackpackLabelBtnState("CreateBackpackFrameCropBtn");
	CurSelectCreateType = 1;
	UpdateCreateItem();
end

function CreateBackpackFrameMachineBtn_OnClick()
	HideCreateBoxItemBoxTexture();
	UpdateCreateBackpackLabelBtnState("CreateBackpackFrameMachineBtn");
	CurSelectCreateType = 2;
	UpdateCreateItem();
end

function CreateBackpackFrameCommonBtn_OnClick()
	HideCreateBoxItemBoxTexture();
	UpdateCreateBackpackLabelBtnState("CreateBackpackFrameCommonBtn");
	CurSelectCreateType = 3;
	UpdateCreateItem();
end

function CreateBackpackFrameMineralBtn_OnClick()
	HideCreateBoxItemBoxTexture();
	UpdateCreateBackpackLabelBtnState("CreateBackpackFrameMineralBtn");
	CurSelectCreateType = 4;
	UpdateCreateItem();
end

function IsShortcutNotHasItem(itemId)
	for i=1, MAX_SHORTCUT do
		local grid_index 	= SHORTCUT_START_INDEX + i - 1;
		local shortcutItemId	= ClientBackpack:getGridItem(grid_index);
		if itemId == shortcutItemId then
			CurMainPlayer:setCurShortcut(i-1);
			return true;
		end 
	end
	return false
end