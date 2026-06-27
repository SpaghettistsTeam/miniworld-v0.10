

function EquipFrame_OnLoad()
	this:RegisterEvent("GE_BACKPACK_CHANGE");
end

function EquipFrame_OnEvent()
	local ge = GameEventQue:getCurEvent();
	local grid_index = ge.body.backpack.grid_index;

	if arg1 == "GE_BACKPACK_CHANGE" then
		if grid_index >= EQUIP_START_INDEX and grid_index<EQUIP_START_INDEX+1000 then
			BackpackGrids_UpdateOneGrid(grid_index);
		end
	end
end

EquipViewCurActor = nil
function EquipFrame_OnShow()
	local player = ClientCurGame:getMainPlayer();

	if EquipViewCurActor ~= player then
		EquipViewCurActor = player
		player:attachUIModelView(EquipActorView);
	end
end

function EquipFrame_OnHide()
	if EquipViewCurActor ~= nil then
		EquipViewCurActor:detachUIModelView();
		EquipViewCurActor = nil;
	end
end

function EquipFrameCloseBtn_OnClick()
	EquipFrame:Hide()
end

ROTATE_ACTOR_SPEED = 180.0
function EquipFrameLeftBtn_OnMouseDown()
	EquipActorView:setRotateSpeed(ROTATE_ACTOR_SPEED);
end

function EquipFrameLeftBtn_OnMouseUp()
	EquipActorView:setRotateSpeed(0);
end

function EquipFrameRightBtn_OnMouseDown()
	EquipActorView:setRotateSpeed(-ROTATE_ACTOR_SPEED);
end

function EquipFrameRightBtn_OnMouseUp()
	EquipActorView:setRotateSpeed(0);
end